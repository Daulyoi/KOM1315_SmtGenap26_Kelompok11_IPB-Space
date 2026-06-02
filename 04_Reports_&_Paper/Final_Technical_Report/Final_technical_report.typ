#let project(
  title: "",
  subtitle: "",
  course: "",
  semester: "",
  institution: "",
  department: "",
  authors: (),
  body
) = {
  // Page setup
  set page(
    paper: "a4",
    margin: (x: 2.5cm, top: 3cm, bottom: 2.5cm),
    header: context {
      if here().page() > 1 {
        align(right, text(8pt, fill: luma(120), style: "italic")[#title | IPB SPACE])
      }
    },
    footer: context {
      if here().page() > 1 {
        let page_number = counter(page).get().first()
        let total_pages = counter(page).final().first()
        align(center, text(9pt, fill: luma(100))[Halaman #page_number dari #total_pages])
      }
    }
  )

  // Text setup
  set text(
    font: "Times New Roman",
    size: 11pt,
    lang: "id"
  )

  // Paragraph setup
  set par(justify: true, leading: 0.65em)

  // Heading setup
  show heading: set text(fill: black)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(1cm)
    align(center, text(14pt, weight: "bold")[#it.body])
    v(0.5cm)
  }
  show heading.where(level: 2): it => {
    v(0.5cm)
    text(12pt, weight: "bold")[#it.body]
    v(0.2cm)
  }
  show heading.where(level: 3): it => {
    v(0.3cm)
    text(11pt, weight: "bold", style: "italic")[#it.body]
    v(0.1cm)
  }

  // Halaman Sampul (Cover Page)
  align(center)[
    #v(2cm)
    #text(18pt, weight: "bold", fill: black)[#title]
    
    #v(0.5cm)
    #text(16pt, weight: "bold")[IPB SPACE]
    
    #v(0.3cm)
    #text(12pt, style: "italic", fill: luma(80))[#subtitle]
    
    #v(1.5cm)
    #rect(width: 80%, height: 0.5mm, fill: luma(80))
    
    #v(1.5cm)
    #text(11pt)[
      *#course*\
      #semester
    ]
    
    #v(2.5cm)
    #text(11pt)[*Disusun oleh (Kelompok 11):*]
    #v(0.2cm)
    #table(
      columns: (auto, auto),
      align: (left, center),
      column-gutter: 1cm,
      stroke: none,
      ..authors.map(author => (author.name, author.nim)).flatten()
    )
    
    #v(3cm)
    #text(12pt, weight: "bold")[#department]\
    #text(11pt, weight: "bold")[
      #institution\
      2026
    ]
  ]

  pagebreak()
  body
}

#let codebox(title: "", body) = {
  block(
    width: 100%,
    stroke: 0.5pt + luma(180),
    radius: 4pt,
    fill: luma(250),
    inset: (x: 10pt, y: 8pt),
    [
      #set text(font: "Courier New", size: 10pt)
      #if title != "" [
        #text(weight: "bold", fill: rgb("#1d4ed8"))[#title]
        #v(1pt)
      ]
      #body
    ]
  )
}

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
- Kompilasi seluruh arsitektur kode sumber backend, frontend, dan database relasional.
- Implementasi nyata dari kontrol keamanan AAA, penyimpanan kredensial aman, dan log transaksi.
- Penerbitan dan pemindaian tiket berbasis _Digital Signature_ Ed25519 untuk memvalidasi _check-in_ civitas.
- Laporan hasil pengujian keamanan otomatis yang memverifikasi ketahanan sistem dari berbagai skenario serangan.
- Panduan instalasi, konfigurasi operasional, dan panduan pengguna lengkap per peran.

== Ruang Lingkup Implementasi
Sistem IPB Space rilis final mencakup empat cakupan terintegrasi:
- FastAPI Backend: Menyediakan REST API utama yang melayani otorisasi, penanganan transaksi sewa, pemeriksaan konflik jadwal, pembuatan log audit, serta pembubuhan tanda tangan digital tiket menggunakan kunci privat RSA.
- React 19 Frontend (Vite): Antarmuka dinamis untuk Tamu, Civitas, Manager Fasilitas, dan Super Admin dengan integrasi otorisasi LocalStorage, penyegaran sesi otomatis (Axios Interceptors), serta generator QR Code tiket dan unduh gambar PNG.
- PostgreSQL Database: Skema penyimpanan relasional persisten terenkripsi untuk entitas pengguna, detail fasilitas, inventaris barang ekstra, detail transaksi, log audit, dan tanda tangan digital.
- Docker Deployment Setup: Containerization menggunakan docker-compose untuk database PostgreSQL dan backend FastAPI guna kemudahan replikasi operasional sistem.

= Struktur Implementasi

== Struktur Repositori
Struktur direktori repositori akhir disusun secara rapi guna menyelaraskan komponen kode sumber dengan artefak laporan akademis:

#table(
  columns: (2fr, 4.5fr),
  inset: 8pt,
  align: (left, left),
  stroke: (x, y) => (left: none, right: none, top: 0.5pt + luma(120), bottom: 0.5pt + luma(120)),
  [*Folder Direktori*], [*Keterangan Artefak / Komponen*],
  [#text("01_Proposal_&_Analisis")], [Proposal teknis proyek dan file cetak biru template.typ untuk standardisasi laporan.],
  [#text("02_Design_Documents")], [Dokumen desain database (ERD), diagram alir data, diagram arsitektur keamanan, dan rencana uji.],
  [#text("03_Source_Code/backend")], [Implementasi REST API utama server menggunakan Python, FastAPI, SQLAlchemy ORM, database PostgreSQL, dan modul kriptografi.],
  [#text("03_Source_Code/frontend")], [Aplikasi antarmuka pengguna berbasis React 19, Vite, Tailwind CSS v3, Axios client, dan visualisasi QR Code.],
  [#text("04_Reports_&_Paper")], [Final Technical Report (laporan akhir ini) dan naskah ilmiah (Scientific Paper).],
)

== Komponen Backend
Backend IPB Space dikembangkan menggunakan FastAPI (Python) dengan pembagian struktur modul arsitektur yang bersih:
-  `app/core/`: Menyimpan konfigurasi basis data (`database.py`), pengaturan variabel lingkungan (`config.py`), fungsi enkripsi/hashing (`security.py`), dan modul penandatanganan tiket digital asimetris (`security_sign.py`).
-  `app/routers/`: Berisi router endpoints API untuk autentikasi pengguna, manajemen fasilitas, transaksi booking, pengubahan status persetujuan, barang ekstra, dan log audit.
-  `app/api/`: Menyimpan konfigurasi dependency injection (seperti `dependencies.py`) untuk kebutuhan FastAPI router.
-  `app/models/`: Definisi tabel database relasional berbasis SQLAlchemy ORM (`user.py`, `facility.py`, `booking.py`, `asset.py`, `items.py`, `extraItems.py`, `facilityAsset.py`).
-  `app/schemas/`: Validasi DTO (Data Transfer Object) request dan response menggunakan Pydantic.
-  `app/services/`: Logika bisnis inti sistem, termasuk pencarian konflik jadwal sewa secara otomatis.
-  `app/repositories/`: Pola repositori untuk abstraksi query database.

== Komponen Frontend
Frontend IPB Space dibangun dengan React 19 dan Vite, memisahkan fitur berdasarkan modularitas domain:
- `src/context/`: Menyediakan `AuthContext.jsx` untuk menyimpan data sesi pengguna, state otorisasi, dan penanganan login/logout di LocalStorage.
- `src/features/auth/`: Komponen halaman login, registrasi civitas, dan layanan pemanggilan API autentikasi.
- `src/features/facilities/`: Katalog visual ruangan, detail ruang, manajemen ruangan, dan pencarian validasi.
- `src/features/bookings/`: Alur formulir pengajuan booking, pemilihan barang tambahan, kalender pemesanan, riwayat booking, dan workspace persetujuan Manager Fasilitas.
- `src/features/tickets/`: Tampilan tiket digital, modul QR Code generator, modul unduh gambar tiket PNG (`html-to-image`), dan workspace verifikator tiket.
- `src/lib/axios.js`: Konfigurasi Axios Client yang menyertakan header otorisasi Bearer JWT secara otomatis dan Axios interceptor untuk menangani refresh token.

= Implementasi Keamanan

== Authentication (Autentikasi)
Sistem keamanan autentikasi IPB Space mendukung tiga peran operasional (Super Admin, Facility Manager, dan Civitas). Kontrol keamanan mencakup:
- Hashing password satu arah menggunakan algoritma Bcrypt dengan penambahan salt dinamis sebelum disimpan di database.
- Penerbitan token akses JWT (access_token) berumur pendek dan token penyegar (refresh_token) berumur panjang saat pengguna sukses masuk (LOGIN_SUCCESS).
- Token JWT menggunakan algoritma penandatanganan simetris `HS256` dengan kunci `SECRET_KEY` yang sangat kuat yang dimuat secara aman dari environment variable.
- Validasi input request DTO login menggunakan Pydantic untuk mencegah serangan SQL Injection dan injeksi payload berbahaya.

== Authorization (Otorisasi)
Otorisasi membatasi hak akses pengguna berdasarkan peran (Role-Based Access Control / RBAC) yang terikat pada data JWT. Diimplementasikan di backend menggunakan FastAPI Dependency Injection:
- Civitas hanya diperbolehkan mengajukan booking, memilih barang ekstra, dan melihat tiket digital miliknya.
- Manager Fasilitas diperbolehkan mengelola data master ruangan miliknya, mengubah status booking (APPROVED/REJECTED), membubuhkan tanda tangan digital pada tiket yang disetujui, dan melakukan pemindaian check-in tiket civitas.
- Super Admin memiliki hak akses penuh (CRUD) untuk manajemen semua tipe pengguna, seluruh data master fasilitas, barang inventaris, serta meninjau log audit sistem global.

== Accounting dan Audit Log
Aspek Accounting (pencatatan aktivitas) diwujudkan melalui sistem logging terstruktur menggunakan pustaka Structlog. 
Setiap aktivitas kritis pengguna dicatat secara aman dalam format terstandardisasi ke dalam file log eksternal `app_logs.txt`. Data audit log mencakup:
- Identitas Pelaku (`user_id` / `email`).
- Waktu Kejadian (`timestamp` dengan format UTC).
- Alamat IP Asal (`ip_address`).
- Kategori Aktivitas (`event_type` seperti `LOGIN_SUCCESS`, `LOGIN_FAIL`, `BOOKING_CREATED`, `BOOKING_APPROVED`, `FACILITY_MUTATED`).
- Keterangan Detail (`details` seperti ID booking, kode ruangan, status).

== Digital Signature (Tanda Tangan Digital)
Untuk memastikan tiket digital yang diterbitkan IPB Space asli dan tidak dimanipulasi, sistem mengimplementasikan kriptografi asimetris Ed25519:
- Server backend menyimpan sepasang kunci Ed25519 (Ed25519 Private Key & Ed25519 Public Key).
- Ketika Manager Fasilitas menyetujui pemesanan, backend secara otomatis memformat data transaksi (ID booking, email pemohon, kode ruangan, tanggal) menjadi string JSON, lalu menandatanganinya dengan kunci privat Ed25519 server untuk menghasilkan Digital Signature dalam format token Base64.
- Tanda tangan digital ini disimpan di database di kolom `digital_signature` dan dibungkus di dalam QR Code tiket.
- Saat check-in fisik di lokasi, petugas memindai QR Code tiket. Backend akan memverifikasi keabsahan tanda tangan digital tersebut menggunakan kunci publik Ed25519 server. Jika tanda tangan valid dan tidak mengalami manipulasi, tiket dinyatakan SAH (menjamin integritas data dan anti-penyangkalan keputusan manager).

== Keamanan Database
- Basis data PostgreSQL diisolasi di dalam jaringan privat Docker dan hanya menerima koneksi internal dari backend FastAPI.
- Query ke database diimplementasikan menggunakan SQLAlchemy ORM dengan parameterization penuh, sehingga menutup celah serangan SQL Injection.
- Pengelolaan perubahan skema database dikontrol melalui migrasi terversi menggunakan Alembic.

= Alur Utama Aplikasi

== Registrasi & Login Multi-Peran
Civitas melakukan registrasi mandiri, sedangkan akun Manager Fasilitas dan Super Admin dibuat oleh Super Admin atau disiapkan lewat database seeder. Login divalidasi oleh backend, dan token JWT dikirim kembali ke frontend untuk disimpan di LocalStorage.

== Kalender Jadwal & Deteksi Konflik
Civitas meninjau ruangan yang tersedia pada halaman katalog. Sebelum pemesanan dapat dibuat, backend FastAPI menjalankan pemeriksaan tumpang tindih waktu untuk memastikan slot waktu yang dipilih kosong.

== Pengajuan Booking & Unggah Berkas
Civitas mengisi formulir, memilih barang ekstra, dan mengunggah dokumen peminjaman (PDF). Berkas diunggah secara aman dan jalur berkas disimpan di database.

== Persetujuan & Penandatanganan Tiket
Manager Fasilitas meninjau peminjaman yang berstatus PENDING pada dashboard admin. Jika disetujui, status diubah menjadi APPROVED, dan backend secara otomatis membubuhkan Digital Signature menggunakan kunci privat Ed25519, lalu menerbitkan tiket dengan kode QR.

== Validasi Check-In
Petugas memindai kode QR tiket civitas. Backend memverifikasi signature menggunakan kunci publik Ed25519. Jika tanda tangan valid, sistem mencatat waktu check-in civitas secara otomatis.

= Keterbatasan Sistem dan Rekomendasi Peningkatan
- Kunci Enkripsi Statis: Kunci privat/publik Ed25519 saat ini masih disimpan sebagai environment variable statis. Diperlukan integrasi dengan Key Management Service (KMS) seperti AWS KMS atau HashiCorp Vault untuk rotasi kunci berkala.
- Enkripsi Dokumen: File dokumen peminjaman PDF yang diunggah civitas disimpan apa adanya di server. Perlu dienkripsi di tingkat penyimpanan (encryption at-rest) agar tidak dapat dibaca langsung dari sistem file.

= Panduan Instalasi dan Operasional

== Prasyarat Sistem
- Python 3.10 atau lebih baru.
- Node.js 18 atau lebih baru dengan npm.
- PostgreSQL Database.
- Docker dan Docker-Compose (opsional untuk containerization).

== Menjalankan Backend dengan Docker Container (Direkomendasikan)
Jika Anda ingin mendeposisi sistem secara otomatis menggunakan Docker:

#codebox(title: "docker_run.sh")[
  ```bash
  cd 03_Source_Code/backend
  docker-compose up db -d
  docker-compose up ipb-space-backend --build -d
  ```
]

Perintah ini akan secara otomatis menyalakan container PostgreSQL dan container server FastAPI secara terisolasi.

== Menjalankan Backend secara Lokal
Berikut adalah skrip instruksi untuk mempersiapkan dan menjalankan backend FastAPI secara lokal:

#codebox(title: "setup_backend.sh")[
  ```bash
  # 1. Masuk ke direktori backend
  cd 03_Source_Code/backend/

  # 2. Buat lingkungan virtual Python & aktifkan
  python -m venv venv
  source venv/bin/activate # Pada Windows: venv\Scripts\activate

  # 3. Instal dependensi library
  pip install -r requirements.txt

  # 4. Konfigurasikan variabel lingkungan (.env)

  # 5. Jalankan migrasi database relasional
  alembic upgrade head

  # 6. Jalankan seeder data awal
  python seed.py

  # 7. Jalankan server pengembangan FastAPI
  uvicorn app.main:app --reload
  ```
]

== Menjalankan Frontend (React/Vite)
Berikut adalah skrip instruksi untuk mempersiapkan dan menjalankan frontend React (Vite) secara lokal:

#codebox(title: "setup_frontend.sh")[
  ```bash
  # 1. Masuk ke direktori frontend
  cd 03_Source_Code/frontend/

  # 2. Instal seluruh dependensi package
  npm install

  # 3. Konfigurasikan file .env (arahkan VITE_API_URL ke backend)

  # 4. Jalankan server pengembangan React/Vite
  npm run dev
  ```
]

== Konfigurasi Variabel Environment Backend Penting
Beberapa variabel Environment kritis yang harus dikonfigurasi pada file `.env` sistem meliputi:

#table(
  columns: (auto, auto),
  inset: 8pt,
  align: (left, left),
  stroke: (x, y) => (left: none, right: none, top: 0.5pt + luma(120), bottom: 0.5pt + luma(120)),
  [*Variabel Environment*], [*Fungsi Keamanan & Operasional*],
  [DATABASE_URL], [String koneksi ke database PostgreSQL utama.],
  [POSTGRES_USER], [Username otentikasi basis data PostgreSQL.],
  [POSTGRES_PASSWORD], [Kata sandi otentikasi basis data PostgreSQL.],
  [POSTGRES_DB], [Nama database utama untuk sistem IPB Space.],
  [SECRET_KEY], [Kunci rahasia berkekuatan tinggi untuk menandatangani token JWT.],
  [ALGORITHM], [Algoritma penandatanganan JWT (disarankan HS256).],
  [ACCESS_TOKEN_EXPIRE_MINUTES], [Masa berlaku token akses JWT dalam menit (default 30).],
  [BOOKING_DOCUMENT_VENDOR], [Penyedia penyimpanan berkas dokumen peminjaman (local atau appwrite).],
  [APPWRITE_ENDPOINT], [Endpoint API layanan Appwrite Cloud (jika menggunakan vendor appwrite).],
  [APPWRITE_PROJECT_ID], [ID proyek Appwrite untuk penyimpanan berkas.],
  [APPWRITE_API_KEY], [Kredensial API key untuk akses Appwrite storage bucket.],
  [APPWRITE_BUCKET_ID], [ID bucket penyimpanan file dokumen di Appwrite.],
  [RESEND_API_KEY], [Kredensial API key Resend untuk pengiriman email notifikasi transaksi.],
  [MAIL_FROM], [Alamat email pengirim notifikasi email.],
  [MAIL_FROM_NAME], [Nama pengirim notifikasi email (misalnya IPB Space).],
  [HARDCODE_MAIL_RECIPIENT], [Alamat email tujuan pengujian notifikasi di lingkungan pengembangan.],
  [SIGNING_PRIVATE_KEY], [Kunci privat asimetris Ed25519 heksadesimal untuk digital signature tiket.],
  [SIGNING_PUBLIC_KEY], [Kunci publik asimetris Ed25519 heksadesimal untuk verifikasi check-in tiket.],
)

= Panduan Pengguna

== Peran Civitas
- *Pemesanan Ruangan*: Masuk ke aplikasi, jelajahi katalog ruangan, pilih tanggal dan slot waktu kosong di kalender, tentukan jumlah peserta, pilih barang ekstra, unggah PDF dokumen pendukung, lalu ajukan.
- *Tiket Digital*: Buka halaman "Tiket Saya", pilih peminjaman yang disetujui, sistem akan memvisualisasikan Tiket Digital beserta QR Code. Civitas dapat mengunduh tiket dalam format gambar PNG untuk diperlihatkan saat check-in fisik di lokasi.

== Peran Manager Fasilitas
- *Persetujuan Booking*: Masuk ke workspace admin, tinjau peminjaman berstatus PENDING, periksa berkas pendukung PDF yang diunggah civitas. Klik Approve untuk menyetujui, yang mana backend secara otomatis akan menandatangani secara digital dan menerbitkan QR Code tiket.
- *Verifikasi Check-In*: Petugas menggunakan kamera perangkat pada halaman "Ticket Validator" untuk memindai QR Code tiket fisik/ponsel milik civitas akademika. Jika tanda tangan valid, sistem mencatat status check-in civitas secara sah.

== Peran Super Admin
- *Manajemen Pengguna*: CRUD akun Civitas, Manager Fasilitas, dan Super Admin lainnya serta menetapkan otorisasi peran.
- *Manajemen Data Master*: Mengelola daftar seluruh ruangan kampus, daftar barang ekstra inventaris, serta melakukan inspeksi log audit aktivitas sistem.

= Kesimpulan

Sistem IPB Space telah berhasil dikembangkan dari fase desain menjadi sistem aplikasi web relasional yang andal dengan fungsionalitas peminjaman ruangan yang aman. Rilis final teknis ini membuktikan bahwa kerangka kerja keamanan AAA (Authentication, Authorization, Accounting) berbasis JWT dan hashing Bcrypt, perlindungan database PostgreSQL dari SQL Injection, serta jaminan integritas non-repudiation menggunakan Ed25519 Digital Signature pada QR Code tiket telah berhasil diintegrasikan ke dalam alur utama transaksi.

Sistem dirancang untuk handal dalam menangani skenario serangan manipulasi data, bypassing hak akses, maupun tabrakan jadwal ganda (overlapping booking) melalui mekanisme pertahanan digital signature dan kontrol akses peran. Dengan laporan kompilasi implementasi teknis akhir ini, IPB Space siap digunakan secara aman untuk civitas akademika IPB University.
