import base64
import json
import structlog
from datetime import datetime, timezone
from cryptography.hazmat.primitives.asymmetric import ed25519
from cryptography.exceptions import InvalidSignature

logger = structlog.get_logger()

class CryptographicSigner:
    @staticmethod
    def generate_key_pair():
        """
        Generates a new Ed25519 key pair.
        Returns a tuple of (private_key_hex, public_key_hex).
        """
        private_key = ed25519.Ed25519PrivateKey.generate()
        public_key = private_key.public_key()
        
        private_bytes = private_key.private_bytes_raw()
        public_bytes = public_key.public_bytes_raw()
        
        return private_bytes.hex(), public_bytes.hex()

    def __init__(self, private_key_hex: str = None, public_key_hex: str = None):
        self.private_key = None
        self.public_key = None
        
        if private_key_hex:
            try:
                self.private_key = ed25519.Ed25519PrivateKey.from_private_bytes(
                    bytes.fromhex(private_key_hex)
                )
                self.public_key = self.private_key.public_key()
            except Exception as e:
                logger.error("failed_to_initialize_private_key", error=str(e))
                raise ValueError("Invalid private key hex format.") from e
        elif public_key_hex:
            try:
                self.public_key = ed25519.Ed25519PublicKey.from_public_bytes(
                    bytes.fromhex(public_key_hex)
                )
            except Exception as e:
                logger.error("failed_to_initialize_public_key", error=str(e))
                raise ValueError("Invalid public key hex format.") from e

    def sign_payload(self, payload: dict) -> str:
        """
        Serializes a JSON payload, signs it using the private key,
        and returns a URL-safe Base64 encoded token in the format:
        Base64Url(payload) . Base64Url(signature)
        """
        if not self.private_key:
            raise ValueError("Private key is required for signing operations.")
            
        if "iat" not in payload:
            payload["iat"] = int(datetime.now(timezone.utc).timestamp())
            
        # Serialize with sorted keys to ensure deterministic representation
        serialized_payload = json.dumps(payload, sort_keys=True).encode('utf-8')
        signature = self.private_key.sign(serialized_payload)
        
        # Structure: Base64UrlEncodedPayload.Base64UrlEncodedSignature
        encoded_payload = base64.urlsafe_b64encode(serialized_payload).decode('utf-8').rstrip('=')
        encoded_signature = base64.urlsafe_b64encode(signature).decode('utf-8').rstrip('=')
        
        return f"{encoded_payload}.{encoded_signature}"

    def verify_token(self, token: str) -> dict:
        """
        Decodes the token, verifies the cryptographic signature,
        and returns the original payload if authentic.
        Raises ValueError if verification fails.
        """
        if not self.public_key:
            raise ValueError("Public key is required for verification operations.")
            
        try:
            parts = token.split('.')
            if len(parts) != 2:
                raise ValueError("Invalid token structure (expected payload.signature).")
                
            encoded_payload, encoded_signature = parts[0], parts[1]
            
            # Pad Base64 strings if necessary
            payload_padded = encoded_payload + "=" * ((4 - len(encoded_payload) % 4) % 4)
            signature_padded = encoded_signature + "=" * ((4 - len(encoded_signature) % 4) % 4)
            
            payload_bytes = base64.urlsafe_b64decode(payload_padded.encode('utf-8'))
            signature_bytes = base64.urlsafe_b64decode(signature_padded.encode('utf-8'))
            
            # Cryptographically verify the signature of the payload
            self.public_key.verify(signature_bytes, payload_bytes)
            
            # Load and return verified data
            return json.loads(payload_bytes.decode('utf-8'))
        except InvalidSignature as e:
            logger.warning("invalid_token_signature_verification_failed")
            raise ValueError("Cryptographic verification failed: Tampered or invalid signature.") from e
        except Exception as e:
            logger.error("token_verification_error", error=str(e))
            raise ValueError(f"Failed to verify permit token: {str(e)}") from e
