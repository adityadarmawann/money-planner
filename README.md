# 📱 Student Plan

Aplikasi mobile Flutter untuk perencanaan keuangan mahasiswa — kelola e-wallet, transfer, paylater, dan budget dalam satu genggaman.

> Panduan ini ditujukan untuk **mahasiswa yang baru pertama kali menggunakan Flutter**. Ikuti setiap langkah secara berurutan dari awal sampai akhir.

---

## 📋 Daftar Isi

1. [Fitur Aplikasi](#-fitur-aplikasi)
2. [Tech Stack](#-tech-stack)
3. [Prasyarat](#-prasyarat)
4. [Langkah 1: Install Flutter SDK](#-langkah-1-install-flutter-sdk)
5. [Langkah 2: Install Android Studio & Emulator](#-langkah-2-install-android-studio--emulator)
6. [Langkah 3: Install Git](#-langkah-3-install-git)
7. [Langkah 4: Install VS Code + Extensions](#-langkah-4-install-vs-code--extensions)
8. [Langkah 5: Clone Project](#-langkah-5-clone-project)
9. [Langkah 6: Setup Supabase](#-langkah-6-setup-supabase)
10. [Langkah 7: Konfigurasi Environment](#-langkah-7-konfigurasi-environment)
11. [Langkah 8: Setup Google Sign-In (Opsional)](#-langkah-8-setup-google-sign-in-opsional)
12. [Langkah 9: Jalankan Aplikasi Development](#-langkah-9-jalankan-aplikasi-development)
13. [Langkah 10: Test di HP Android](#-langkah-10-test-di-hp-android)
14. [Langkah 11: Build APK Android](#-langkah-11-build-apk-android)
15. [Struktur Folder](#-struktur-folder)
16. [Database Schema](#-database-schema)
17. [Troubleshooting](#-troubleshooting)
18. [Ringkasan Urutan Lengkap](#-ringkasan-urutan-lengkap)
19. [Lisensi](#-lisensi)

---

## ✨ Fitur Aplikasi

| Fitur | Deskripsi |
|---|---|
| 🔐 Login & Register | Masuk dengan Email/Password atau Akun Google |
| 💳 E-Wallet | Top Up saldo, lihat saldo real-time |
| 🔄 Transfer | Transfer antar sesama pengguna Student Plan |
| 🏦 Transfer Bank | Transfer ke rekening BCA, BNI, BRI, Mandiri, dll |
| 📷 QRIS | Simulasi pembayaran QRIS |
| 💰 Paylater | Cairkan dana, kelola tagihan, bayar cicilan |
| 📊 Budget Planner | Buat anggaran mingguan, bulanan, atau kustom |
| 📜 Riwayat Transaksi | Lihat semua transaksi dengan filter tanggal & kategori |

---

## 🛠 Tech Stack

| Teknologi | Kegunaan |
|---|---|
| [Flutter](https://flutter.dev) | Framework UI Mobile (Android & iOS) |
| [Supabase](https://supabase.com) | Backend: Auth, Database PostgreSQL, Storage |
| [Provider](https://pub.dev/packages/provider) | State Management |
| [Google Sign-In](https://pub.dev/packages/google_sign_in) | Autentikasi dengan akun Google |
| [fl_chart](https://pub.dev/packages/fl_chart) | Grafik keuangan interaktif |
| [intl](https://pub.dev/packages/intl) | Format mata uang Rupiah (locale `id_ID`) |

---

## 📦 Prasyarat

Sebelum memulai, pastikan kamu sudah menginstall semua software berikut:

| Software | Versi Minimum | Link Download |
|---|---|---|
| Flutter SDK | 3.0.0 | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| Android Studio | 2023.x | [developer.android.com/studio](https://developer.android.com/studio) |
| Git | 2.x | [git-scm.com/downloads](https://git-scm.com/downloads) |
| VS Code | 1.80+ | [code.visualstudio.com](https://code.visualstudio.com) |
| Google Chrome | Terbaru | [google.com/chrome](https://www.google.com/chrome) |

---

## 🚀 Langkah 1: Install Flutter SDK

### Windows

1. Buka [flutter.dev/docs/get-started/install/windows](https://flutter.dev/docs/get-started/install/windows)
2. Download file `.zip` Flutter SDK terbaru
3. Ekstrak ke `C:\flutter` (jangan taruh di `C:\Program Files` karena butuh izin admin)
4. Tambahkan `C:\flutter\bin` ke **PATH** environment variable:
   - Buka **Start** → cari "Environment Variables"
   - Klik **Edit the system environment variables**
   - Klik **Environment Variables...**
   - Di bagian **User variables**, pilih `Path` → klik **Edit**
   - Klik **New** → ketik `C:\flutter\bin`
   - Klik **OK** di semua dialog
5. Buka Command Prompt baru dan verifikasi:
   ```bash
   flutter --version
   flutter doctor
   ```

### macOS

```bash
# Install menggunakan Homebrew
brew install --cask flutter

# Atau download manual dari flutter.dev lalu:
export PATH="$PATH:$HOME/flutter/bin"

# Verifikasi
flutter doctor
```

### Linux

```bash
# Install menggunakan Snap
sudo snap install flutter --classic

# Verifikasi
flutter doctor
```

> 💡 **`flutter doctor`** akan menampilkan daftar komponen yang sudah dan belum terinstall. Ikuti instruksinya sampai semua item menunjukkan tanda centang ✅.

---

## 📱 Langkah 2: Install Android Studio & Emulator

1. Download dan install [Android Studio](https://developer.android.com/studio)
2. Jalankan Android Studio → ikuti wizard setup awal
3. Buka **SDK Manager** (Menu: Tools → SDK Manager):
   - Di tab **SDK Platforms**: centang **Android 14.0 (API 34)**
   - Di tab **SDK Tools**: centang:
     - Android SDK Build-Tools
     - Android SDK Command-line Tools
     - Android Emulator
     - Android SDK Platform-Tools
   - Klik **Apply** → **OK**
4. Buat Virtual Device (Emulator):
   - Buka **Device Manager** (Menu: Tools → Device Manager)
   - Klik **Create Device**
   - Pilih **Pixel 7** → klik **Next**
   - Pilih system image **API 34 (Android 14)** → Download jika belum ada → klik **Next**
   - Klik **Finish**
5. Setujui lisensi Android:
   ```bash
   flutter doctor --android-licenses
   # Ketik 'y' lalu Enter untuk setiap pertanyaan
   ```
6. Jalankan `flutter doctor` lagi — pastikan Android toolchain sudah ✅

---

## 🌿 Langkah 3: Install Git

### Windows

1. Download installer dari [git-scm.com/download/win](https://git-scm.com/download/win)
2. Jalankan installer → pilih semua opsi default → klik **Next** sampai selesai
3. Verifikasi:
   ```bash
   git --version
   ```

### macOS

```bash
# Git biasanya sudah terinstall. Cek dengan:
git --version

# Jika belum ada, install via Homebrew:
brew install git
```

### Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install git
git --version
```

---

## 💻 Langkah 4: Install VS Code + Extensions

1. Download dan install [VS Code](https://code.visualstudio.com)
2. Buka VS Code → tekan `Ctrl+Shift+X` (Windows/Linux) atau `Cmd+Shift+X` (macOS) untuk membuka Extensions
3. Cari dan install extension berikut:
   - **Flutter** (oleh Dart Code) — wajib
   - **Dart** (oleh Dart Code) — wajib, biasanya terinstall otomatis bersama Flutter
4. Restart VS Code setelah install

---

## 📥 Langkah 5: Clone Project

Buka terminal (Command Prompt / Git Bash / Terminal) lalu jalankan:

```bash
# Clone repository
git clone https://github.com/adityadarmawann/money-planner.git

# Masuk ke folder project
cd money-planner

# Install semua package Flutter
flutter pub get
```

> 💡 Proses `flutter pub get` akan mengunduh semua library yang dibutuhkan. Tunggu sampai selesai.

---

## 🗄 Langkah 6: Setup Supabase

Supabase adalah backend yang menyediakan database, autentikasi, dan storage secara gratis.

1. **Buat akun** di [supabase.com](https://supabase.com) (bisa pakai akun GitHub atau email)
2. Klik **New Project**:
   - Organization: buat baru atau pilih yang ada
   - Name: `studentplan`
   - Database Password: buat password yang kuat (simpan!)
   - Region: **Southeast Asia (Singapore)** — paling dekat dengan Indonesia
   - Klik **Create new project** → tunggu ±2 menit
3. **Buat tabel database**:
   - Di sidebar kiri, klik **SQL Editor**
   - Klik **New query**
   - Buka file `supabase/schema.sql` dari folder project kamu
   - Copy seluruh isinya → paste di SQL Editor Supabase
   - Klik tombol **Run** (▶)
   - Pastikan muncul pesan "Success"
4. **Catat kredensial**:
   - Di sidebar kiri, klik **Settings** (ikon ⚙️) → **API**
   - Catat dua nilai ini:
     - **Project URL** — contoh: `https://abcdefgh.supabase.co`
     - **anon public** key — string panjang dimulai `eyJ...`
5. **Aktifkan Email Authentication**:
   - Di sidebar kiri, klik **Authentication** → **Providers**
   - Pastikan **Email** sudah dalam status **Enabled**

---

## ⚙️ Langkah 7: Konfigurasi Environment

1. Di folder project, salin file `.env.example` menjadi `.env`:
   ```bash
   # Windows (Command Prompt)
   copy .env.example .env

   # macOS / Linux
   cp .env.example .env
   ```
2. Buka file `.env` dengan VS Code atau teks editor lain:
   ```bash
   code .env
   ```
3. Isi dengan kredensial Supabase yang sudah dicatat tadi:
   ```env
   SUPABASE_URL=https://abcdefgh.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```
4. Simpan file `.env`

> ⚠️ **PENTING:** Jangan pernah commit file `.env` ke Git! File ini berisi kredensial rahasia. File `.env` sudah otomatis diabaikan oleh `.gitignore`.

---

## 🔑 Langkah 8: Setup Google Sign-In (Opsional)

Langkah ini opsional — aplikasi tetap bisa berjalan dengan login Email/Password tanpa Google Sign-In.

1. Buka [Google Cloud Console](https://console.cloud.google.com)
2. Buat project baru atau pilih project yang ada
3. Aktifkan **Google Sign-In API**: APIs & Services → Enable APIs → cari "Google Sign-In" → Enable
4. Buat **OAuth 2.0 Client ID**: APIs & Services → Credentials → Create Credentials → OAuth Client ID → Android
5. **Dapatkan SHA-1 fingerprint** dari komputer kamu:
   ```bash
   # Windows (pakai Git Bash)
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

   # macOS / Linux
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
   Salin nilai **SHA1** yang muncul
6. Masukkan SHA-1 ke Google Cloud Console → Credentials → pilih Client ID Android → isi SHA-1
7. **Aktifkan Google Provider di Supabase**:
   - Authentication → Providers → Google → Enable
   - Masukkan Client ID dan Client Secret dari Google Cloud Console
8. Download file **`google-services.json`** dari Google Cloud Console → letakkan di folder `android/app/`

---

## ▶️ Langkah 9: Jalankan Aplikasi Development

### Cek perangkat yang tersedia

```bash
flutter devices
```

Output contoh:
```
2 connected devices:
Pixel 7 (mobile)  • emulator-5554  • android-x64
Chrome (web)      • chrome         • web-javascript
```

### Jalankan di Emulator / HP

```bash
flutter run --dart-define-from-file=.env
```

Jika ada lebih dari satu device, pilih dengan flag `-d`:
```bash
flutter run --dart-define-from-file=.env -d emulator-5554
```

### Jalankan dari VS Code (F5)

1. Buka folder project di VS Code
2. File `.vscode/launch.json` sudah tersedia di project ini
3. Tekan **F5** atau klik menu **Run → Start Debugging**
4. Pilih konfigurasi **"Student Plan (Debug)"**

### Shortcut saat aplikasi berjalan

| Tombol | Aksi |
|---|---|
| `r` | Hot Reload — reload kode tanpa restart (state tetap) |
| `R` | Hot Restart — restart aplikasi (state reset) |
| `q` | Quit — hentikan aplikasi |
| `d` | Detach — biarkan app tetap berjalan di device |

---

## 📲 Langkah 10: Test di HP Android

### USB Debugging

1. Aktifkan **Developer Options** di HP:
   - Buka **Settings** → **About Phone**
   - Ketuk **Build Number** sebanyak **7 kali** sampai muncul "You are now a developer!"
2. Kembali ke **Settings** → **Developer Options** → aktifkan **USB Debugging**
3. Hubungkan HP ke PC dengan kabel USB
4. Di HP, izinkan koneksi USB debugging saat muncul dialog konfirmasi
5. Jalankan:
   ```bash
   flutter devices   # pastikan HP terdeteksi
   flutter run --dart-define-from-file=.env
   ```

### Wireless Debugging (Android 11+)

1. Aktifkan **Wireless Debugging** di Developer Options HP
2. Tap **Wireless Debugging** → **Pair device with pairing code**
3. Catat **IP address**, **port pairing**, dan **kode pairing**
4. Di PC, jalankan:
   ```bash
   # Pair dulu (gunakan IP, port, dan kode pairing dari HP)
   adb pair 192.168.1.xxx:PORT_PAIRING
   # Masukkan kode pairing saat diminta

   # Setelah paired, connect
   adb connect 192.168.1.xxx:PORT_WIRELESS
   ```
5. Jalankan aplikasi:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

> ⚠️ **Catatan Supabase Self-Hosted:** Jika kamu menjalankan Supabase di PC sendiri (bukan Supabase Cloud), gunakan **IP lokal PC** di file `.env`, bukan `localhost`:
> ```env
> SUPABASE_URL=http://192.168.1.100:54321
> ```
> Cari IP lokal PC: `ipconfig` (Windows) atau `ifconfig` (macOS/Linux)

---

## 📦 Langkah 11: Build APK Android

### ❓ APK vs EXE — Apa Bedanya?

Flutter menghasilkan file **berbeda** untuk setiap platform. **Untuk Android, outputnya adalah file `.apk`** — bukan `.exe`. File `.exe` hanya untuk Windows desktop.

| Platform | Output | Keterangan |
|---|---|---|
| Android | `.apk` / `.aab` | Install di HP Android |
| iOS | `.ipa` | Install di iPhone/iPad (butuh Mac) |
| Windows | `.exe` | Aplikasi desktop Windows |
| Web | Folder HTML/JS/CSS | Deploy ke web server |

### Perintah Build APK

Semua perintah build menggunakan `--dart-define-from-file=.env` agar kredensial Supabase ikut ter-embed.

```bash
# Build APK Debug (untuk testing, ukuran besar)
flutter build apk --debug --dart-define-from-file=.env

# Build APK Release (untuk distribusi, sudah dioptimasi)
flutter build apk --release --dart-define-from-file=.env

# Build APK Release per ABI (ukuran lebih kecil, direkomendasikan)
# Menghasilkan 3 file APK: arm64-v8a, armeabi-v7a, x86_64
flutter build apk --split-per-abi --release --dart-define-from-file=.env

# Build App Bundle (untuk upload ke Google Play Store)
flutter build appbundle --release --dart-define-from-file=.env
```

### Lokasi File Output

Setelah build selesai, file APK berada di:

```
# APK Debug
build/app/outputs/flutter-apk/app-debug.apk

# APK Release
build/app/outputs/flutter-apk/app-release.apk

# APK Split per ABI
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk

# App Bundle
build/app/outputs/bundle/release/app-release.aab
```

### Cara Install APK ke HP

**Cara 1: Lewat ADB (USB)**
```bash
# Pastikan HP terhubung via USB dengan USB Debugging aktif
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Cara 2: Transfer Manual**
1. Kirim file `.apk` ke HP via WhatsApp, Google Drive, atau Bluetooth
2. Di HP, buka file `.apk` dari notifikasi download atau File Manager
3. Jika muncul dialog **"Install unknown apps"** atau **"Unknown sources"**:
   - Tap **Settings**
   - Aktifkan izin untuk aplikasi yang kamu gunakan untuk membuka APK (mis. File Manager atau Chrome)
   - Kembali dan tap **Install**

> 💡 **Tips:** Untuk testing cepat antar teman, gunakan `--split-per-abi --release` dan kirim file `app-arm64-v8a-release.apk` — ukurannya paling kecil dan cocok untuk HP modern.

---

## 📂 Struktur Folder

```
money-planner/
├── .env.example                      # Template konfigurasi environment
├── .vscode/
│   └── launch.json                   # Konfigurasi run/debug VS Code
├── android/                          # Konfigurasi native Android
│   └── app/
│       └── google-services.json      # (Opsional) untuk Google Sign-In
├── ios/                              # Konfigurasi native iOS
├── supabase/
│   └── schema.sql                    # DDL lengkap semua tabel database
├── pubspec.yaml                      # Daftar dependencies Flutter
└── lib/
    ├── main.dart                     # Entry point + inisialisasi Supabase
    ├── app.dart                      # MaterialApp + konfigurasi routing
    ├── core/
    │   ├── constants/                # Konstanta warna, string, nama route
    │   ├── theme/                    # AppTheme (font Poppins, warna biru)
    │   ├── utils/                    # Helper: format Rupiah, tanggal, validator
    │   └── errors/                   # AppException dan error handling
    ├── data/
    │   ├── models/                   # 8 model data (User, Wallet, Transaction, dll)
    │   └── repositories/             # 6 repository untuk operasi CRUD ke Supabase
    ├── providers/                    # 6 Provider untuk state management
    └── presentation/
        ├── screens/                  # Semua layar/halaman aplikasi
        └── widgets/                  # Widget reusable (kartu, tombol, dll)
```

---

## 🗃 Database Schema

Berikut daftar tabel yang dibuat oleh `supabase/schema.sql`:

| Tabel | Deskripsi |
|---|---|
| `users` | Profil pengguna (nama, email, username, foto) |
| `wallets` | Saldo e-wallet setiap pengguna |
| `categories` | Kategori pemasukan & pengeluaran (default + kustom) |
| `transactions` | Seluruh riwayat transaksi (top up, transfer, dll) |
| `paylater_accounts` | Akun paylater (limit kredit Rp 1.000.000) |
| `paylater_bills` | Tagihan cicilan paylater |
| `budgets` | Anggaran keuangan per periode |
| `budget_items` | Item pemasukan/pengeluaran di dalam anggaran |

---

## 🔧 Troubleshooting

### ❌ `flutter: command not found`

Flutter belum ditambahkan ke PATH. Ikuti kembali [Langkah 1](#-langkah-1-install-flutter-sdk) dan pastikan `C:\flutter\bin` (Windows) atau direktori yang sesuai sudah ada di PATH. Tutup dan buka ulang terminal setelah mengubah PATH.

### ❌ `No connected devices`

- Pastikan emulator sudah dijalankan dari Android Studio (Device Manager → ▶)
- Atau pastikan HP terhubung dengan USB Debugging aktif
- Coba jalankan `adb devices` — jika kosong, cabut dan pasang ulang kabel USB
- Pastikan driver USB HP sudah terinstall (Windows)

### ❌ `Gradle build failed`

```bash
# Bersihkan cache build
cd android
./gradlew clean
cd ..

# Bersihkan cache Flutter
flutter clean
flutter pub get

# Coba build/run lagi
flutter run --dart-define-from-file=.env
```

### ❌ Aplikasi error "Konfigurasi belum lengkap"

- Pastikan file `.env` sudah dibuat (bukan hanya `.env.example`)
- Pastikan `SUPABASE_URL` dan `SUPABASE_ANON_KEY` sudah diisi dengan benar
- Pastikan selalu menjalankan dengan flag `--dart-define-from-file=.env`

### ❌ `SocketException: Connection refused`

- Periksa koneksi internet
- Jika menggunakan Supabase self-hosted: pastikan menggunakan IP lokal, bukan `localhost`
- Pastikan HP dan PC terhubung ke WiFi yang sama
- Coba ping IP PC dari HP untuk memastikan koneksi

### ❌ Google Sign-In gagal

- Pastikan file `google-services.json` sudah ada di `android/app/`
- Pastikan SHA-1 fingerprint sudah didaftarkan di Google Cloud Console
- Pastikan Google Provider sudah diaktifkan di Supabase Authentication

### ❌ APK tidak bisa diinstall di HP

- Aktifkan **"Install from unknown sources"** di pengaturan HP
- Pastikan file APK tidak corrupt (coba kirim ulang)
- Jika muncul "App not installed", hapus versi lama aplikasi dulu lalu install ulang
- Pastikan HP memiliki ruang penyimpanan yang cukup

---

## 📋 Ringkasan Urutan Lengkap

Berikut adalah 11 langkah yang harus dilakukan secara berurutan dari nol hingga aplikasi berjalan:

1. **Install Flutter SDK** dan tambahkan ke PATH
2. **Install Android Studio**, setup SDK API 34, buat emulator Pixel 7
3. **Install Git**
4. **Install VS Code** + extension Flutter & Dart
5. **Clone project** dan jalankan `flutter pub get`
6. **Buat project Supabase**, jalankan `schema.sql`, catat URL & Anon Key
7. **Buat file `.env`** dari `.env.example`, isi dengan kredensial Supabase
8. *(Opsional)* **Setup Google Sign-In** di Google Cloud Console & Supabase
9. **Jalankan aplikasi** dengan `flutter run --dart-define-from-file=.env`
10. **Test di HP Android** via USB Debugging atau Wireless Debugging
11. **Build APK** dengan `flutter build apk --release --dart-define-from-file=.env`

---

## 📄 Lisensi

MIT License — bebas digunakan, dimodifikasi, dan didistribusikan.

---

<div align="center">

Dibuat dengan ❤️ untuk mahasiswa Indonesia

</div>