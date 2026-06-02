import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  ShieldCheck, 
  WarningCircle, 
  Clock, 
  CalendarBlank, 
  User, 
  MapPin, 
  ArrowLeft,
  Stamp
} from '@phosphor-icons/react';
import { bookingService } from '../../bookings/services/bookingService';
import logoIPBSpace from '../../../assets/icons/logo.png';

export default function VerifyPermit() {
  const { token } = useParams();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [result, setResult] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    const verifyToken = async () => {
      try {
        setLoading(true);
        setError(null);
        const response = await bookingService.verifyBookingPermit(token);
        
        if (response.success && response.data) {
          setResult(response.data);
        } else {
          setError(response.message || 'Gagal memverifikasi permit digital.');
        }
      } catch (err) {
        console.error(err);
        const errMsg = err.response?.data?.detail || err.response?.data?.message || 'Tanda tangan digital tidak valid atau telah dimodifikasi.';
        setError(errMsg);
      } finally {
        setLoading(false);
      }
    };

    if (token) {
      verifyToken();
    } else {
      setError('Token permit tidak ditemukan.');
      setLoading(false);
    }
  }, [token]);

  // Handle formatted date/time if available
  const getFormattedDate = (dateStr) => {
    if (!dateStr) return '';
    try {
      const dateObj = new Date(dateStr);
      return dateObj.toLocaleDateString('id-ID', {
        weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
      });
    } catch {
      return dateStr;
    }
  };

  const getFormattedVerifiedTime = (verifiedAtStr) => {
    if (!verifiedAtStr) return '';
    try {
      const dateObj = new Date(verifiedAtStr);
      return dateObj.toLocaleString('id-ID', {
        dateStyle: 'medium',
        timeStyle: 'medium'
      });
    } catch {
      return verifiedAtStr;
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-surface to-surface-dim p-4">
        <div className="animate-spin rounded-full h-14 w-14 border-4 border-accent border-t-transparent shadow-lg mb-4"></div>
        <p className="text-primary-container font-black text-sm uppercase tracking-widest animate-pulse">
          Menganalisis Tanda Tangan Kriptografi...
        </p>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-surface via-surface-bright to-surface-dim flex items-center justify-center p-4 md:p-8 font-sans">
      <div className="w-full max-w-lg animate-fade-in">
        
        {/* Logo and brand header */}
        <div className="flex items-center justify-center gap-3 mb-8">
          <img src={logoIPBSpace} alt="IPB Space" className="h-12 w-12 object-contain drop-shadow" />
          <div>
            <h1 className="text-2xl font-black tracking-widest text-primary-container leading-none uppercase">IPB Space</h1>
            <span className="text-[10px] font-black text-accent tracking-widest leading-none block mt-1.5 uppercase">Sistem Validasi Kriptografis</span>
          </div>
        </div>

        {error ? (
          /* TAMPERED OR INVALID SCREEN */
          <div className="bg-white rounded-3xl shadow-2xl border border-red-100 overflow-hidden animate-scale-up">
            
            {/* Red Alert Banner */}
            <div className="bg-gradient-to-r from-red-500 to-red-600 p-8 text-center text-white space-y-4">
              <div className="inline-flex items-center justify-center h-20 w-20 rounded-full bg-white/10 border border-white/20 shadow-inner animate-bounce">
                <WarningCircle size={48} weight="fill" className="text-white" />
              </div>
              <div>
                <span className="bg-white/20 text-[10px] font-black tracking-widest uppercase px-3 py-1 rounded-full border border-white/10 inline-block">
                  Verification Failed
                </span>
                <h2 className="text-2xl font-black mt-2.5 tracking-tight leading-none">
                  PERMIT TIDAK VALID!
                </h2>
              </div>
            </div>

            {/* Error Message Details */}
            <div className="p-6 md:p-8 space-y-6 bg-red-50/30">
              <div className="bg-white border border-red-200 p-5 rounded-2xl shadow-ambient text-center space-y-2">
                <p className="text-xs font-black text-red-500 uppercase tracking-wider">Penyebab Kegagalan</p>
                <p className="text-sm font-extrabold text-gray-700 leading-relaxed">
                  {error}
                </p>
              </div>

              <div className="text-xs text-gray-400 font-semibold text-center leading-relaxed max-w-[320px] mx-auto">
                Tanda tangan digital ini tidak cocok dengan payload atau kunci publik instansi. Segera hubungi pengelola jika Anda merasa ini adalah kesalahan sistem.
              </div>

              <button
                onClick={() => navigate('/')}
                className="w-full flex items-center justify-center gap-2 py-4 bg-primary-container text-white font-black rounded-2xl shadow-md hover:bg-primary-container/95 transition-all text-xs uppercase tracking-widest cursor-pointer"
              >
                <ArrowLeft size={16} weight="bold" />
                Kembali ke Beranda
              </button>
            </div>

          </div>
        ) : (
          /* VERIFIED GENUINE SCREEN */
          <div className="bg-white rounded-3xl shadow-2xl border border-emerald-100 overflow-hidden animate-scale-up">
            
            {/* Green Successful Banner */}
            <div className="bg-gradient-to-r from-emerald-500 to-teal-600 p-8 text-center text-white space-y-4">
              <div className="inline-flex items-center justify-center h-20 w-20 rounded-full bg-white/15 border border-white/20 shadow-inner relative">
                {/* Micro animation glow */}
                <div className="absolute inset-0 rounded-full bg-emerald-400 opacity-20 animate-ping"></div>
                <ShieldCheck size={48} weight="fill" className="text-white relative z-10" />
              </div>
              <div>
                <span className="bg-white/20 text-[10px] font-black tracking-widest uppercase px-3 py-1 rounded-full border border-white/10 inline-block">
                  Verified Genuine
                </span>
                <h2 className="text-2xl font-black mt-2.5 tracking-tight leading-none">
                  PERMIT TERVERIFIKASI
                </h2>
              </div>
            </div>

            {/* Verified Details Card */}
            <div className="p-6 md:p-8 space-y-6">
              
              {/* Stamp of Integrity */}
              <div className="flex items-center gap-3 p-4 bg-emerald-50/50 border border-emerald-100 rounded-2xl">
                <Stamp size={28} weight="fill" className="text-emerald-600 shrink-0" />
                <div>
                  <p className="text-[10px] text-emerald-700 font-black uppercase tracking-wider leading-none">Cryptographic Integrity Seal</p>
                  <p className="text-[11px] text-emerald-600 font-semibold mt-1">
                    Ed25519 asymmetric signature verified successfully.
                  </p>
                </div>
              </div>

              {/* Data Grid */}
              <div className="space-y-4">
                
                {/* Booking Code and ID */}
                <div className="flex items-center justify-between border-b border-gray-100 pb-3">
                  <div>
                    <span className="text-[10px] font-black text-gray-400 uppercase tracking-wider block">ID Reservasi</span>
                    <span className="font-extrabold text-sm text-gray-700">
                      IS-{result?.details?.booking_id?.toString().padStart(4, '0')}
                    </span>
                  </div>
                  <div className="text-right">
                    <span className="text-[10px] font-black text-gray-400 uppercase tracking-wider block">Metode Tanda Tangan</span>
                    <span className="font-black text-xs text-accent uppercase tracking-widest">Ed25519 (RawHex)</span>
                  </div>
                </div>

                {/* Facility / Room */}
                <div className="flex gap-3">
                  <div className="bg-surface text-primary p-2.5 rounded-xl shrink-0 h-10 w-10 flex items-center justify-center">
                    <MapPin size={20} weight="fill" className="text-accent" />
                  </div>
                  <div>
                    <span className="text-[10px] font-black text-gray-400 uppercase tracking-wider block">Fasilitas / Gedung</span>
                    <span className="font-extrabold text-sm text-gray-800 leading-tight block mt-0.5">
                      {result?.details?.facility_name}
                    </span>
                  </div>
                </div>

                {/* User / Applicant */}
                <div className="flex gap-3">
                  <div className="bg-surface text-primary p-2.5 rounded-xl shrink-0 h-10 w-10 flex items-center justify-center">
                    <User size={20} weight="fill" className="text-accent" />
                  </div>
                  <div>
                    <span className="text-[10px] font-black text-gray-400 uppercase tracking-wider block">Nama Civitas Akademika</span>
                    <span className="font-extrabold text-sm text-gray-800 leading-tight block mt-0.5">
                      {result?.details?.user_fullname}
                    </span>
                  </div>
                </div>

                {/* Date */}
                <div className="flex gap-3">
                  <div className="bg-surface text-primary p-2.5 rounded-xl shrink-0 h-10 w-10 flex items-center justify-center">
                    <CalendarBlank size={20} weight="fill" className="text-accent" />
                  </div>
                  <div>
                    <span className="text-[10px] font-black text-gray-400 uppercase tracking-wider block">Tanggal Peminjaman</span>
                    <span className="font-extrabold text-sm text-gray-800 leading-tight block mt-0.5">
                      {getFormattedDate(result?.details?.date_of_booking)}
                    </span>
                  </div>
                </div>

                {/* Time Range */}
                <div className="flex gap-3">
                  <div className="bg-surface text-primary p-2.5 rounded-xl shrink-0 h-10 w-10 flex items-center justify-center">
                    <Clock size={20} weight="fill" className="text-accent" />
                  </div>
                  <div>
                    <span className="text-[10px] font-black text-gray-400 uppercase tracking-wider block">Waktu / Durasi Akses</span>
                    <span className="font-extrabold text-sm text-gray-800 leading-tight block mt-0.5">
                      {result?.details?.time_range} WIB
                    </span>
                  </div>
                </div>

                {/* Signee Authority & Verification Timestamp */}
                <div className="mt-4 pt-4 border-t border-gray-150 grid grid-cols-2 gap-4 text-xs font-semibold text-gray-500">
                  <div>
                    <span className="text-[9px] font-black text-gray-400 uppercase tracking-wider block">Penandatangan Dokumen</span>
                    <span className="font-extrabold text-gray-800 block mt-0.5">{result?.details?.validated_by || 'Sistem IPB Space'}</span>
                  </div>
                  <div className="text-right">
                    <span className="text-[9px] font-black text-gray-400 uppercase tracking-wider block">Waktu Verifikasi</span>
                    <span className="font-extrabold text-gray-800 block mt-0.5">{getFormattedVerifiedTime(result?.details?.verified_at)}</span>
                  </div>
                </div>

              </div>

              {/* Bottom buttons */}
              <div className="space-y-3 pt-4">
                <button
                  onClick={() => navigate('/')}
                  className="w-full flex items-center justify-center gap-2 py-4 bg-emerald-600 hover:bg-emerald-700 text-white font-black rounded-2xl shadow-md transition-all text-xs uppercase tracking-widest cursor-pointer"
                >
                  <ArrowLeft size={16} weight="bold" />
                  Kembali ke Beranda
                </button>
              </div>

            </div>

          </div>
        )}
      </div>
    </div>
  );
}
