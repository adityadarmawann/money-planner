# Student Plan

Aplikasi mobile Flutter untuk perencanaan keuangan mahasiswa dengan fitur e-wallet, transfer, paylater, dan budget planner.

## Tech Stack

- **Flutter** (Dart) — Mobile App
- **Supabase** — Backend (Auth, Database, Storage)
- **Provider** — State Management
- **Google Sign-In** — Autentikasi Google

## Fitur

- ✅ Login & Register (Email + Google)
- ✅ E-Wallet (Top Up, Saldo)
- ✅ Transfer Antar Pengguna
- ✅ Transfer ke Bank (BCA, BNI, BRI, Mandiri, dll)
- ✅ Pembayaran QRIS (Simulasi)
- ✅ Paylater (Cairkan Dana, Tagihan, Pembayaran)
- ✅ Financial Planner (Budget Mingguan/Bulanan/Kustom)
- ✅ Riwayat Transaksi dengan Filter
- ✅ Profil Pengguna (Edit Profil)

## Setup

### 1. Prasyarat

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Akun [Supabase](https://supabase.com)
- Akun Google Cloud (untuk Google Sign-In)

### 2. Clone & Install Dependencies

```bash
git clone <repo-url>
cd money-planner
flutter pub get
```

### 3. Setup Supabase

1. Buat project baru di [Supabase Dashboard](https://app.supabase.com)
2. Buka **SQL Editor** di Supabase
3. Jalankan script dari file `supabase/schema.sql`
4. Catat **Project URL** dan **Anon Key** dari Settings > API

### 4. Konfigurasi App

#### Opsi A: Menggunakan file .env (Direkomendasikan)

1. Salin file `.env.example` menjadi `.env`:
   ```bash
   cp .env.example .env
   ```

2. Edit file `.env` dan isi dengan kredensial Supabase kamu:
   ```
   SUPABASE_URL=https://xxxxx.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...
   ```

3. Jalankan aplikasi:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

#### Opsi B: Menggunakan --dart-define langsung

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...
```

> ⚠️ **Penting:** Jangan pernah commit file `.env` ke repository. File ini sudah ditambahkan ke `.gitignore`.

### 5. Setup Google Sign-In (Opsional)

1. Buat project di [Google Cloud Console](https://console.cloud.google.com)
2. Aktifkan Google Sign-In API
3. Buat OAuth 2.0 Client ID untuk Android dan iOS
4. Tambahkan SHA-1 fingerprint (Android) di Google Console
5. Di Supabase: Authentication > Providers > Google → masukkan Client ID & Secret

#### Android Setup

Edit `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdk 21
    }
}
```

Tambahkan `google-services.json` ke folder `android/app/`.

#### iOS Setup

Tambahkan `GoogleService-Info.plist` ke folder `ios/Runner/`.
Tambahkan URL scheme di `ios/Runner/Info.plist`.

### 6. Jalankan Aplikasi

```bash
flutter run --dart-define-from-file=.env
```

### 7. Menjalankan di Localhost (WiFi yang Sama)

Jika menggunakan Supabase **self-hosted** di PC dan ingin test di HP:

1. Cari IP address PC kamu:
   ```bash
   # Windows
   ipconfig
   # Mac/Linux
   ifconfig
   ```

2. Gunakan IP lokal (bukan `localhost`) di file `.env`:
   ```
   SUPABASE_URL=http://192.168.1.100:54321
   ```
   > ⚠️ HTTP hanya aman untuk development lokal. Gunakan HTTPS di production.

3. Pastikan HP dan PC terhubung ke **WiFi yang sama**

4. Jalankan:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

> 💡 Jika menggunakan Supabase Cloud, gunakan URL `https://xxxxx.supabase.co` — tidak perlu setting khusus untuk WiFi.

## Struktur Folder

```
lib/
├── main.dart                         # Entry point + Supabase init
├── app.dart                          # MaterialApp + routing
├── core/
│   ├── constants/                    # Warna, string, routes
│   ├── theme/                        # AppTheme (Poppins, biru muda)
│   ├── utils/                        # Format Rupiah, tanggal, validator
│   └── errors/                       # AppException
├── data/
│   ├── models/                       # 8 model data
│   └── repositories/                 # 6 repository (Supabase CRUD)
├── providers/                        # 6 provider (state management)
└── presentation/
    ├── screens/                      # Semua layar aplikasi
    └── widgets/                      # Widget yang dapat digunakan ulang
```

## Database Schema

Lihat file `supabase/schema.sql` untuk DDL lengkap.

Tabel utama:
- `users` — Profil pengguna
- `wallets` — Saldo e-wallet
- `transactions` — Riwayat transaksi
- `paylater_accounts` — Akun paylater (limit Rp 1.000.000)
- `paylater_bills` — Tagihan paylater
- `budgets` — Anggaran keuangan
- `budget_items` — Item anggaran per kategori
- `categories` — Kategori pemasukan/pengeluaran

## Format Mata Uang

Semua nilai ditampilkan dalam format Rupiah Indonesia:
- `Rp 1.000.000` (titik sebagai separator ribuan)
- Menggunakan package `intl` dengan locale `id_ID`

## Lisensi

MIT