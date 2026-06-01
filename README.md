# PBL Mata Kuliah Keamanan Informasi | IPB Space

> **Sistem Informasi Aman dengan Implementasi Kriptografi & Protokol AAA**
> 
> Proyek PBL (Project-Based Learning) untuk Mata Kuliah **Keamanan Informasi (KOM1315)** - Semester Genap 2026.
>
> Untuk melihat repository lengkap yang juga berisi frontend, kunjungi [Repository IPB Space](https://github.com/HusniAbdillah/ipb-space).


## Tech Stack

### Platform Inti
![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-4169E1?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white)

### Backend
![FastAPI](https://img.shields.io/badge/FastAPI-API-009688?logo=fastapi&logoColor=white)
![Uvicorn](https://img.shields.io/badge/Uvicorn-ASGI-1F2937?logo=uvicorn&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-2.0-D71F00?logo=sqlalchemy&logoColor=white)
![Alembic](https://img.shields.io/badge/Alembic-Migrations-111827?logo=alembic&logoColor=white)
![Pydantic](https://img.shields.io/badge/Pydantic-Validation-E92063?logo=pydantic&logoColor=white)
![Structlog](https://img.shields.io/badge/Structlog-Logging-334155)

## Fitur Utama

- Katalog fasilitas publik dan kalender untuk melihat ketersediaan ruangan.
- Alur pemesanan untuk civitas dengan pemilihan tanggal/waktu, unggah dokumen pendukung, dan pelacakan riwayat pemesanan.
- Penerbitan tiket digital untuk permintaan yang disetujui, termasuk dukungan kode QR untuk validasi operasional.
- Ruang kerja validasi untuk Admin Fasilitas yang menampilkan permintaan tertunda, konteks antrean, dan visibilitas konflik.
- Modul operasi fasilitas untuk manajemen ruangan, pemantauan jadwal, dan riwayat pemesanan yang telah diproses.
- Panel kontrol Super Admin untuk manajemen pengguna dan data master terpusat (fasilitas, barang, dan aset).
- Kontrol akses berbasis peran dan routing yang disesuaikan dengan peran antara tampilan tamu, civitas, admin fasilitas, dan super admin.
- Halaman audit dan log sistem untuk siklus hidup pemesanan dan pemantauan aktivitas operasional.

## Model Peran

| Peran | Tanggung Jawab Utama |
| :--- | :--- |
| Civitas | Menjelajah fasilitas, mengajukan permintaan pemesanan, melacak status, mengakses tiket, dan melakukan check-in dalam jendela waktu yang diperbolehkan. |
| Admin Fasilitas | Memvalidasi permintaan tertunda, mengelola operasi fasilitas, memantau jadwal, dan riwayat pemesanan. |
| Super Admin | Mengelola pengguna dan data master (fasilitas, barang, aset), serta memantau kalender global dan audit sistem. |

## Quick Start

### Prerequisites
- Python 3.10+
- PostgreSQL
- Git

### Setup

Clone repository dan ikuti panduan pengaturan. Pastikan Anda berada di direktori `03_Source_Code/backend`.

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```
Jika Anda memilih menggunakan Docker, gunakan `docker-compose.yml` yang tersedia.

```bash
cd backend
docker-compose up db -d
docker-compose up ipb-space-backend --build -d
```

---

## 👥 Profil Kelompok (Kelompok 11)

| Nama Anggota | NIM |
|---|---|
| Daffa Aulia Musyaffa Subyantoro | G6401231028 |
| Hakim Ilyas Azhar | G6401231077 |
| Kivi Adelio | G6401231047 |