import os
from pydantic_settings import BaseSettings
from dotenv import load_dotenv

load_dotenv()

# Cache generated keys in module scope so they stay identical across restarts/requests
_cached_priv = None
_cached_pub = None

def _get_fallback_key(key_type: str) -> str:
    global _cached_priv, _cached_pub
    if not _cached_priv or not _cached_pub:
        from cryptography.hazmat.primitives.asymmetric import ed25519
        priv = ed25519.Ed25519PrivateKey.generate()
        pub = priv.public_key()
        _cached_priv = priv.private_bytes_raw().hex()
        _cached_pub = pub.public_bytes_raw().hex()
    
    return _cached_priv if key_type == "private" else _cached_pub

class Settings(BaseSettings):
    BASE_URL: str = os.getenv("BASE_URL", "http://localhost:8000")
    RESEND_API_KEY: str = os.getenv("RESEND_API_KEY", "")
    MAIL_FROM: str = os.getenv("MAIL_FROM", "onboarding@resend.dev")
    MAIL_FROM_NAME: str = os.getenv("MAIL_FROM_NAME", "IPB Space")
    CORS_ORIGINS: str = os.getenv("CORS_ORIGINS", "")
    
    # Cryptographic keys for signing permits
    SIGNING_PRIVATE_KEY: str = os.getenv("SIGNING_PRIVATE_KEY") or _get_fallback_key("private")
    SIGNING_PUBLIC_KEY: str = os.getenv("SIGNING_PUBLIC_KEY") or _get_fallback_key("public")

settings = Settings()


