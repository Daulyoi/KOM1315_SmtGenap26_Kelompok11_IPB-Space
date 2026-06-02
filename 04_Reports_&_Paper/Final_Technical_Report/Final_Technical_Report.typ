#import "../../01_Proposal_&_Analisis/template.typ": project

#show: project.with(
  title: "FINAL TECHNICAL REPORT",
  subtitle: "Dokumen Kompilasi Implementasi Keamanan, Pengujian, dan Panduan Operasional",
  course: "Mata Kuliah Keamanan Informasi (KOM1315)",
  semester: "Semester Genap 2026",
  institution: "FAKULTAS MATEMATIKA DAN ILMU PENGETAHUAN ALAM\nIPB UNIVERSITY",
  department: "DEPARTEMEN ILMU KOMPUTER",
  authors: (
    (name: "Daffa Aulia Musyaffa Subyantoro", nim: "G6401231028"),
    (name: "Hakim Ilyas Azhar", nim: "G6401231077"),
    (name: "Kivi Adelio", nim: "G6401231047"),
  )
)

// --- DAFTAR ISI ---
#outline(indent: 1.5em, depth: 3)

= Ringkasan Proyek

== Latar Belakang
Proyek peminjaman fasilitas kampus di IPB University sebelumnya dihadapkan pada kendala birokrasi manual, tidak adanya transparansi ketersediaan ruangan secara dinamis, risiko terjadinya pemesanan ganda (_overlapping booking_), serta kerentanan keamanan informasi seperti pemalsuan tiket peminjaman dan penyangkalan keputusan persetujuan.

_IPB Space_ hadir sebagai solusi platform berbasis web terintegrasi yang menyajikan katalog fasilitas dan kalender jadwal pemakaian secara nyata. Dengan berfokus pada Keamanan Informasi, IPB Space menerapkan protokol keamanan berlapis, meliputi kontrol akses ketat menggunakan kerangka kerja _Authentication, Authorization, dan Accounting_ (AAA) serta penjaminan integritas transaksi peminjaman menggunakan tanda tangan digital kriptografi asimetris (_Digital Signature_).

== Tujuan Final Release
Rilis final teknis ini menyatukan seluruh komponen implementasi nyata sistem IPB Space, meliputi:
* Kompilasi seluruh arsitektur kode sumber backend, frontend, dan database relasional.
* Implementasi nyata dari kontrol keamanan AAA, penyimpanan kredensial aman, dan log transaksi.
* Penerbitan dan pemindaian tiket berbasis _Digital Signature_ RSA-SHA256 untuk memvalidasi _check-in_ civitas.
* Laporan hasil pengujian keamanan otomatis yang memverifikasi ketahanan sistem dari berbagai skenario serangan.
* Panduan instalasi, konfigurasi operasional, dan panduan pengguna lengkap per peran.

== Ruang Lingkup Implementasi
Sistem IPB Space rilis final mencakup empat cakupan terintegrasi:
* *FastAPI Backend*: Menyediakan REST API utama yang melayani otorisasi, penanganan transaksi sewa, pemeriksaan konflik jadwal, pembuatan log audit, serta pembubuhan tanda tangan digital tiket menggunakan kunci privat RSA.
* *React 19 Frontend (Vite)*: Antarmuka dinamis untuk Tamu, Civitas, Manager Fasilitas, dan Super Admin dengan integrasi otorisasi *LocalStorage*, penyegaran sesi otomatis (*Axios Interceptors*), serta generator QR Code tiket dan unduh gambar PNG.
* *PostgreSQL Database*: Skema penyimpanan relasional persisten terenkripsi untuk entitas pengguna, detail fasilitas, inventaris barang ekstra, detail transaksi, log audit, dan tanda tangan digital.
* *Docker Deployment Setup*: Containerization menggunakan docker-compose untuk database PostgreSQL dan backend FastAPI guna kemudahan replikasi operasional sistem.

= Struktur Implementasi

== Struktur Repositori
Struktur direktori repositori akhir disusun secara rapi guna menyelaraskan komponen kode sumber dengan artefak laporan akademis:

#table(
  columns: (2fr, 4.5fr),
  inset: 8pt,
  align: (left, left),
  stroke: (x, y) => (left: none, right: none, top: 0.5pt + luma(120), bottom: 0.5pt + luma(120)),
  [*Folder Direktori*], [*Keterangan Artefak / Komponen*],
  [01_Proposal_&_Analisis/], [Proposal teknis proyek dan file cetak biru template.typ untuk standardisasi laporan.],
  [02_Design_Documents/], [Dokumen desain database (ERD), diagram alir data, diagram arsitektur keamanan, dan rencana uji.],
  [03_Source_Code/backend/], [Implementasi REST API utama server menggunakan Python, FastAPI, SQLAlchemy ORM, database PostgreSQL, dan modul kriptografi.],
  [03_Source_Code/frontend/], [Aplikasi antarmuka pengguna berbasis React 19, Vite, Tailwind CSS v3, Axios client, dan visualisasi QR Code.],
  [04_Reports_&_Paper/], [Final Technical Report (laporan akhir ini) dan naskah ilmiah (*Scientific Paper*).],
  [05_Testing/], [Script pengujian otomatis sisi backend menggunakan Pytest untuk memverifikasi fungsionalitas dan kontrol keamanan.],
)

== Komponen Backend
Backend IPB Space dikembangkan menggunakan FastAPI (Python) dengan pembagian struktur modul arsitektur yang bersih:
* `app/core/`: Menyimpan konfigurasi basis data (`database.py`), pengaturan variabel lingkungan (`config.py`), fungsi enkripsi/hashing (`security.py`), dan modul penandatanganan tiket digital asimetris (`security_sign.py`).
* `app/api/`: Berisi router endpoints API untuk autentikasi pengguna, manajemen fasilitas, transaksi booking, pengubahan status persetujuan, barang ekstra, dan log audit.
* `app/models/`: Definisi tabel database relasional berbasis SQLAlchemy ORM (`user.py`, `facility.py`, `booking.py`, `asset.py`, `items.py`, `extraItems.py`, `facilityAsset.py`).
* `app/schemas/`: Validasi DTO (*Data Transfer Object*) request dan response menggunakan Pydantic.
* `app/services/`: Logika bisnis inti sistem, termasuk pencarian konflik jadwal sewa secara otomatis.
* `app/repositories/`: Pola repositori untuk abstraksi query database.

== Komponen Frontend
Frontend IPB Space dibangun dengan React 19 dan Vite, memisahkan fitur berdasarkan modularitas domain:
* `src/context/`: Menyediakan `AuthContext.jsx` untuk menyimpan data sesi pengguna, *state* otorisasi, dan penanganan login/logout di LocalStorage.
* `src/features/auth/`: Komponen halaman login, registrasi civitas, dan layanan pemanggilan API autentikasi.
* `src/features/facilities/`: Katalog visual ruangan, detail ruang, manajemen ruangan, dan pencarian validasi.
* `src/features/bookings/`: Alur formulir pengajuan booking, pemilihan barang tambahan, kalender pemesanan, riwayat booking, dan workspace persetujuan Manager Fasilitas.
* `src/features/tickets/`: Tampilan tiket digital, modul QR Code generator, modul unduh gambar tiket PNG (`html-to-image`), dan workspace verifikator tiket.
* `src/lib/axios.js`: Konfigurasi Axios Client yang menyertakan header otorisasi Bearer JWT secara otomatis dan Axios interceptor untuk menangani refresh token.

= Implementasi Keamanan

== Authentication (Autentikasi)
Sistem keamanan autentikasi IPB Space mendukung tiga peran operasional (*Super Admin, Facility Manager, dan Civitas*). Kontrol keamanan mencakup:
* Hashing password satu arah menggunakan algoritma *Bcrypt* dengan penambahan *salt* dinamis sebelum disimpan di database.
* Penerbitan token akses JWT (*access_token*) berumur pendek dan token penyegar (*refresh_token*) berumur panjang saat pengguna sukses masuk (*LOGIN_SUCCESS*).
* Token JWT menggunakan algoritma penandatanganan simetris `HS256` dengan kunci `JWT_SECRET` yang sangat kuat yang dimuat secara aman dari environment variable.
* Validasi input request DTO login menggunakan *Pydantic* untuk mencegah serangan *SQL Injection* dan injeksi payload berbahaya.

== Authorization (Otorisasi)
Otorisasi membatasi hak akses pengguna berdasarkan peran (*Role-Based Access Control* / RBAC) yang terikat pada data JWT. Diimplementasikan di backend menggunakan FastAPI Dependency Injection:
* Civitas hanya diperbolehkan mengajukan booking, memilih barang ekstra, dan melihat tiket digital miliknya.
* Manager Fasilitas diperbolehkan mengelola data master ruangan miliknya, mengubah status booking (*APPROVED/REJECTED*), membubuhkan tanda tangan digital pada tiket yang disetujui, dan melakukan pemindaian check-in tiket civitas.
* Super Admin memiliki hak akses penuh (CRUD) untuk manajemen semua tipe pengguna, seluruh data master fasilitas, barang inventaris, serta meninjau log audit sistem global.

== Accounting dan Audit Log
Aspek *Accounting* (pencatatan aktivitas) diwujudkan melalui sistem logging terstruktur menggunakan pustaka *Structlog*. 
Setiap aktivitas kritis pengguna dicatat secara aman dalam format terstandardisasi ke dalam file log eksternal `app_logs.txt`. Data audit log mencakup:
* Identitas Pelaku (`user_id` / `email`).
* Waktu Kejadian (`timestamp` dengan format UTC).
* Alamat IP Asal (`ip_address`).
* Kategori Aktivitas (`event_type` seperti `LOGIN_SUCCESS`, `LOGIN_FAIL`, `BOOKING_CREATED`, `BOOKING_APPROVED`, `FACILITY_MUTATED`).
* Keterangan Detail (`details` seperti ID booking, kode ruangan, status).

== Digital Signature (Tanda Tangan Digital)
Untuk memastikan tiket digital yang diterbitkan IPB Space asli dan tidak dimanipulasi, sistem mengimplementasikan kriptografi asimetris **RSA-SHA256**:
* Server backend menyimpan sepasang kunci RSA (*RSA Private Key & RSA Public Key*).
* Ketika Manager Fasilitas menyetujui pemesanan, backend secara otomatis memformat data transaksi (ID booking, email pemohon, kode ruangan, tanggal) menjadi string JSON, membuat *hash* SHA-256 dari string tersebut, lalu mengenkripsinya dengan kunci privat RSA server untuk menghasilkan *Digital Signature*.
* Tanda tangan digital ini disimpan di database di kolom `digital_signature` dan dibungkus di dalam QR Code tiket.
* Saat check-in fisik di lokasi, petugas memindai QR Code tiket. Backend akan mendekripsi tanda tangan digital tersebut menggunakan kunci publik RSA server. Jika hasil dekripsi cocok dengan data transaksi, tiket dinyatakan **SAH** (menjamin integritas data dan anti-penyangkalan keputusan manager).

== Keamanan Database
* Basis data PostgreSQL diisolasi di dalam jaringan privat Docker dan hanya menerima koneksi internal dari backend FastAPI.
* Query ke database diimplementasikan menggunakan **SQLAlchemy ORM** dengan parameterization penuh, sehingga menutup celah serangan **SQL Injection**.
* Pengelolaan perubahan skema database dikontrol melalui migrasi terversi menggunakan **Alembic**.

= Alur Utama Aplikasi

== Registrasi & Login Multi-Peran
Civitas melakukan registrasi mandiri, sedangkan akun Manager Fasilitas dan Super Admin dibuat oleh Super Admin atau disiapkan lewat database seeder. Login divalidasi oleh backend, dan token JWT dikirim kembali ke frontend untuk disimpan di LocalStorage.

== Kalender Jadwal & Deteksi Konflik
Civitas meninjau ruangan yang tersedia pada halaman katalog. Sebelum pemesanan dapat dibuat, backend FastAPI menjalankan pemeriksaan tumpang tindih waktu untuk memastikan slot waktu yang dipilih kosong.

== Pengajuan Booking & Unggah Berkas
Civitas mengisi formulir, memilih barang ekstra, dan mengunggah dokumen peminjaman (PDF). Berkas diunggah secara aman dan jalur berkas disimpan di database.

== Persetujuan & Penandatanganan Tiket
Manager Fasilitas meninjau peminjaman yang berstatus *PENDING* pada workspace admin. Jika disetujui, status diubah menjadi *APPROVED*, dan backend secara otomatis membubuhkan *Digital Signature* menggunakan kunci privat RSA, lalu menerbitkan tiket dengan kode QR.

== Validasi Check-In
Petugas memindai kode QR tiket civitas. Backend mendekripsi signature menggunakan kunci publik RSA. Jika tanda tangan valid, sistem mencatat waktu *check-in* civitas secara otomatis.

= Hasil Pengujian Keamanan

Pengujian keamanan otomatis dilakukan menggunakan kerangka kerja **Pytest** di direktori `05_Testing/`. Pengujian ini secara ketat memverifikasi ketahanan kontrol keamanan sistem IPB Space.

== Ringkasan Skenario Pengujian Keamanan
Berikut adalah draf file pengujian otomatis yang ada di repositori dan hasil verifikasinya:

#table(
  columns: (2fr, 1fr, 3.5fr),
  inset: 8pt,
  align: (left, center, left),
  stroke: (x, y) => (left: none, right: none, top: 0.5pt + luma(120), bottom: 0.5pt + luma(120)),
  [*Berkas Pengujian*], [*Status*], [*Deskripsi Kasus & Kontrol yang Diuji*],
  [test_jwt_authentication.py], [PASS], [Memverifikasi keabsahan JWT, masa berlaku token, penanganan token palsu/kedaluwarsa, dan pembatasan akses tanpa token.],
  [test_rbac.py], [PASS], [Menguji pemisahan hak akses per peran. Memastikan Civitas ditolak saat mengakses endpoint admin/manager, dan sebaliknya.],
  [test_password_security.py], [PASS], [Memverifikasi kekuatan hashing password dengan Bcrypt, mendeteksi kekuatan salt, dan menolak penyimpanan password plain-text.],
  [test_digital_signature.py], [PASS], [Menguji pembuatan tanda tangan digital RSA-SHA256, memverifikasi payload valid lolos, dan menolak tiket yang telah dimodifikasi (tampered).],
  [test_booking_security.py], [PASS], [Menguji pencegahan pemesanan ganda (overlapping booking), proteksi dokumen peminjaman, dan validasi input parameter.],
  [test_auth_flow.py], [PASS], [Menguji alur lengkap otorisasi login, token refresh via Axios interceptor simulator, dan proses penanganan logout log.],
)

== Keterbatasan Sistem yang Perlu Ditingkatkan
* *Kunci Enkripsi Statis*: Kunci privat/publik RSA saat ini masih disimpan sebagai file statis atau environment variable statis. Diperlukan integrasi dengan *Key Management Service* (KMS) seperti AWS KMS atau HashiCorp Vault untuk rotasi kunci berkala.
* *Enkripsi Dokumen*: File dokumen peminjaman PDF yang diunggah civitas disimpan apa adanya di server. Perlu dienkripsi di tingkat penyimpanan (encryption at-rest) agar tidak dapat dibaca langsung dari sistem file.

= Panduan Instalasi dan Operasional

== Prasyarat Sistem
* Python 3.10 atau lebih baru.
* Node.js 18 atau lebih baru dengan npm.
* PostgreSQL Database.
* Docker dan Docker-Compose (opsional untuk containerization).

== Menjalankan Backend (FastAPI)
1. Buka folder `03_Source_Code/backend/`.
2. Buat lingkungan virtual Python:
   ```bash
   python -m venv venv
   source venv/bin/activate # Pada Windows: venv\Scripts\activate
   ```
3. Instal seluruh pustaka dependensi backend:
   ```bash
   pip install -r requirements.txt
   ```
4. Konfigurasikan variabel lingkungan pada file `.env`.
5. Jalankan migrasi database menggunakan Alembic:
   ```bash
   alembic upgrade head
   ```
6. Jalankan pengisian data awal konsisten (seeder):
   ```bash
   python seed.py
   ```
7. Jalankan server pengembangan FastAPI:
   ```bash
   uvicorn app.main:app --reload
   ```

== Menjalankan Frontend (React/Vite)
1. Buka folder `03_Source_Code/frontend/`.
2. Instal pustaka dependensi frontend:
   ```bash
   npm install
   ```
3. Siapkan file konfigurasi `.env` dengan mengarahkan `VITE_API_URL` ke alamat server backend FastAPI.
4. Jalankan aplikasi frontend di server pengembangan lokal:
   ```bash
   npm run dev
   ```

== Menjalankan dengan Docker Container
Jika Anda ingin mendeposisi sistem secara otomatis menggunakan Docker:
```bash
cd 03_Source_Code/backend
docker-compose up --build -d
```
Perintah ini akan secara otomatis menyalakan container PostgreSQL dan container server FastAPI secara terisolasi.

== Konfigurasi Variabel Lingkungan Penting
Beberapa variabel lingkungan kritis yang harus dikonfigurasi pada file `.env` sistem meliputi:

#table(
  columns: (2.5fr, 4fr),
  inset: 8pt,
  align: (left, left),
  stroke: (x, y) => (left: none, right: none, top: 0.5pt + luma(120), bottom: 0.5pt + luma(120)),
  [*Variabel Lingkungan*], [*Fungsi Keamanan & Operasional*],
  [DATABASE_URL], [String koneksi ke database PostgreSQL utama.],
  [JWT_SECRET], [Kunci rahasia berkekuatan tinggi untuk menandatangani token JWT.],
  [JWT_ALGORITHM], [Algoritma penandatanganan JWT (disarankan HS256).],
  [RSA_PRIVATE_KEY_PATH], [Jalur lokasi penyimpanan berkas kunci privat RSA untuk digital signature.],
  [RSA_PUBLIC_KEY_PATH], [Jalur lokasi penyimpanan berkas kunci publik RSA untuk verifikasi check-in.],
  [RESEND_API_KEY], [Kredensial API notifikasi email transaksi untuk civitas akademika.],
)

= Panduan Pengguna

== Peran Civitas
* *Pemesanan Ruangan*: Masuk ke aplikasi, jelajahi katalog ruangan, pilih tanggal dan slot waktu kosong di kalender, tentukan jumlah peserta, pilih barang ekstra, unggah PDF dokumen pendukung, lalu ajukan.
* *Tiket Digital*: Buka halaman "Tiket Saya", pilih peminjaman yang disetujui, sistem akan memvisualisasikan Tiket Digital beserta QR Code. Civitas dapat mengunduh tiket dalam format gambar PNG untuk diperlihatkan saat check-in fisik di lokasi.

== Peran Manager Fasilitas
* *Persetujuan Booking*: Masuk ke workspace admin, tinjau peminjaman berstatus *PENDING*, periksa berkas pendukung PDF yang diunggah civitas. Klik *Approve* untuk menyetujui, yang mana backend secara otomatis akan menandatangani secara digital dan menerbitkan QR Code tiket.
* *Verifikasi Check-In*: Petugas menggunakan kamera perangkat pada halaman "Ticket Validator" untuk memindai QR Code tiket fisik/ponsel milik civitas akademika. Jika tanda tangan valid, sistem mencatat status check-in civitas secara sah.

== Peran Super Admin
* *Manajemen Pengguna*: CRUD akun Civitas, Manager Fasilitas, dan Super Admin lainnya serta menetapkan otorisasi peran.
* *Manajemen Data Master*: Mengelola daftar seluruh ruangan kampus, daftar barang ekstra inventaris, serta melakukan inspeksi log audit aktivitas sistem.

= Kesimpulan

Sistem **IPB Space** telah berhasil dikembangkan dari fase desain menjadi sistem aplikasi web relasional yang andal dengan fungsionalitas peminjaman ruangan yang aman. Rilis final teknis ini membuktikan bahwa kerangka kerja keamanan AAA (Authentication, Authorization, Accounting) berbasis JWT dan hashing Bcrypt, perlindungan database PostgreSQL dari SQL Injection, serta jaminan integritas non-repudiation menggunakan **RSA-SHA256 Digital Signature** pada QR Code tiket telah berhasil diintegrasikan ke dalam alur utama transaksi.

Melalui pengujian keamanan otomatis terstruktur, sistem terbukti handal dalam menangani skenario serangan manipulasi data, bypassing hak akses, maupun tabrakan jadwal ganda (*overlapping booking*). Dengan laporan kompilasi implementasi teknis akhir ini, IPB Space siap digunakan secara aman untuk civitas akademika IPB University.
