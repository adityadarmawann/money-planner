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

Buka `lib/main.dart` dan ganti:

```dart
const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

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
flutter run
```

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