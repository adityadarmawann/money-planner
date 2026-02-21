# Student Plan — Panduan Lengkap Setup & Build

Aplikasi mobile Flutter untuk perencanaan keuangan mahasiswa dengan fitur e-wallet, transfer, paylater, dan budget planner.

> 📖 **Panduan ini ditujukan untuk mahasiswa yang baru pertama kali coding Flutter.** Ikuti langkah demi langkah dari awal sampai akhir — kamu pasti bisa!

---

## Daftar Isi

1. [Fitur Aplikasi](#fitur-aplikasi)
2. [Tech Stack](#tech-stack)
3. [Prasyarat — Apa Saja yang Harus Diinstall](#prasyarat--apa-saja-yang-harus-diinstall)
4. [Langkah 1: Install Flutter SDK](#langkah-1-install-flutter-sdk)
5. [Langkah 2: Install Android Studio & Emulator](#langkah-2-install-android-studio--emulator)
6. [Langkah 3: Install Git](#langkah-3-install-git)
7. [Langkah 4: Install VS Code](#langkah-4-install-vs-code)
8. [Langkah 5: Clone Project & Install Dependencies](#langkah-5-clone-project--install-dependencies)
9. [Langkah 6: Setup Supabase Backend & Database](#langkah-6-setup-supabase-backend--database)
10. [Langkah 7: Konfigurasi Environment](#langkah-7-konfigurasi-environment)
11. [Langkah 8: Setup Google Sign-In (Opsional)](#langkah-8-setup-google-sign-in-opsional)
12. [Langkah 9: Jalankan Aplikasi Development](#langkah-9-jalankan-aplikasi-development)
13. [Langkah 10: Test di HP Android via WiFi](#langkah-10-test-di-hp-android-via-wifi)
14. [Langkah 11: Build APK / File Instalasi Android](#langkah-11-build-apk--file-instalasi-android)
15. [Struktur Folder](#struktur-folder)
16. [Database Schema](#database-schema)
17. [Troubleshooting](#troubleshooting)
18. [Ringkasan Urutan Lengkap](#ringkasan-urutan-lengkap)
19. [Lisensi](#lisensi)

---

## Fitur Aplikasi

| No | Fitur | Deskripsi |
|----|-------|-----------|
| 1 | Login & Register | Autentikasi via Email/Password atau Google |
| 2 | E-Wallet | Saldo digital, top up dana |
| 3 | Transfer Antar Pengguna | Kirim uang ke sesama pengguna aplikasi |
| 4 | Transfer ke Bank | Transfer ke BCA, BNI, BRI, Mandiri, dll |
| 5 | Pembayaran QRIS | Simulasi pembayaran via QRIS |
| 6 | Paylater | Cairkan dana pinjaman, kelola tagihan & pembayaran |
| 7 | Financial Planner | Budget mingguan, bulanan, atau kustom |
| 8 | Riwayat Transaksi | Lihat semua transaksi dengan filter tanggal & kategori |
| 9 | Profil Pengguna | Edit nama, foto profil, dan informasi akun |

---

## Tech Stack

| Komponen | Teknologi | Keterangan |
|----------|-----------|------------|
| Mobile App | Flutter (Dart) | Framework UI cross-platform |
| Backend | Supabase | Auth, Database PostgreSQL, Storage |
| State Management | Provider | Manajemen state aplikasi |
| Autentikasi Google | Google Sign-In | Login dengan akun Google |
| Format Mata Uang | intl (id_ID) | Format Rupiah: Rp 1.000.000 |

---

## Prasyarat — Apa Saja yang Harus Diinstall

Sebelum mulai, pastikan kamu menginstall semua tools berikut:

| Tool | Versi Minimum | Fungsi | Link Download |
|------|--------------|--------|---------------|
| Flutter SDK | 3.0.0+ | Framework utama | https://flutter.dev/docs/get-started/install |
| Android Studio | Electric Eel+ | Emulator & Android SDK | https://developer.android.com/studio |
| Git | 2.30+ | Clone repository | https://git-scm.com/downloads |
| VS Code | 1.70+ | Code editor (opsional, tapi direkomendasikan) | https://code.visualstudio.com |
| Chrome | Latest | Debug di web (opsional) | https://www.google.com/chrome |

---

## Langkah 1: Install Flutter SDK

### Windows

1. Buka https://flutter.dev/docs/get-started/install/windows
2. Download file ZIP Flutter SDK (misal: `flutter_windows_3.x.x-stable.zip`)
3. Ekstrak ke folder, misalnya `C:\flutter`
4. Tambahkan `C:\flutter\bin` ke **PATH** environment variable:
   - Buka **Start** → cari **"Environment Variables"**
   - Klik **"Edit the system environment variables"**
   - Klik **"Environment Variables"**
   - Di bagian **"User variables"**, pilih `Path` → klik **Edit**
   - Klik **New** → ketik `C:\flutter\bin`
   - Klik OK semua dialog

### macOS

```bash
# Install via Homebrew (direkomendasikan)
brew install --cask flutter

# Atau download manual dari https://flutter.dev/docs/get-started/install/macos
# Ekstrak dan tambahkan ke PATH di ~/.zshrc atau ~/.bash_profile:
export PATH="$HOME/flutter/bin:$PATH"
```

### Linux

```bash
# Download dan ekstrak Flutter SDK
cd ~
tar xf flutter_linux_3.x.x-stable.tar.xz

# Tambahkan ke PATH di ~/.bashrc atau ~/.zshrc:
export PATH="$HOME/flutter/bin:$PATH"
source ~/.bashrc
```

### Verifikasi Instalasi Flutter

Buka terminal baru dan jalankan:

```bash
flutter doctor
```

Contoh output yang diharapkan:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio (version Electric Eel)
[✓] VS Code (version 1.x.x)
[✓] Connected device (1 available)
```

> ⚠️ **Jika ada tanda `[!]` atau `[✗]`**, baca pesannya dan ikuti instruksi yang diberikan untuk memperbaikinya sebelum lanjut ke langkah berikutnya.

---

## Langkah 2: Install Android Studio & Emulator

### Install Android Studio

1. Buka https://developer.android.com/studio
2. Download installer untuk OS kamu (Windows `.exe`, macOS `.dmg`, Linux `.tar.gz`)
3. Jalankan installer dan ikuti wizard instalasi
4. Buka Android Studio setelah selesai

### Setup Android SDK

1. Buka Android Studio → klik **"More Actions"** → **"SDK Manager"**
2. Di tab **"SDK Platforms"**, centang **Android 12.0 (API 31)** atau yang lebih baru
3. Di tab **"SDK Tools"**, pastikan centang:
   - ✅ Android SDK Build-Tools
   - ✅ Android SDK Command-line Tools
   - ✅ Android Emulator
   - ✅ Android SDK Platform-Tools
4. Klik **Apply** dan tunggu download selesai

### Buat Emulator Android (AVD)

1. Di Android Studio → **"More Actions"** → **"Virtual Device Manager"**
2. Klik **"Create Device"**
3. Pilih perangkat, misal **Pixel 6** → klik **Next**
4. Pilih system image (misal **API 33, x86_64**) → klik **Download** jika belum ada → klik **Next**
5. Klik **Finish**
6. Klik tombol ▶️ untuk menjalankan emulator

### Accept Android Licenses

Jalankan perintah ini di terminal dan ketik `y` untuk semua pertanyaan:

```bash
flutter doctor --android-licenses
```

---

## Langkah 3: Install Git

### Windows

1. Buka https://git-scm.com/download/win
2. Download installer `.exe` dan jalankan
3. Ikuti wizard dengan pengaturan default
4. Verifikasi: buka **Git Bash** dan ketik `git --version`

### macOS

```bash
# Via Homebrew
brew install git

# Atau gunakan Xcode Command Line Tools (sudah include git)
xcode-select --install
```

### Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install git
```

### Verifikasi Git

```bash
git --version
# Output: git version 2.x.x
```

---

## Langkah 4: Install VS Code

### Install VS Code

1. Buka https://code.visualstudio.com
2. Download untuk OS kamu dan install
3. Buka VS Code

### Install Extensions Flutter & Dart

1. Di VS Code, tekan `Ctrl+Shift+X` (Windows/Linux) atau `Cmd+Shift+X` (macOS) untuk membuka Extensions
2. Cari dan install:
   - **Flutter** (by Dart Code) — wajib
   - **Dart** (by Dart Code) — wajib, biasanya otomatis terinstall bersama Flutter
3. Setelah install, restart VS Code

> 💡 Dengan extensions ini, kamu bisa menekan **F5** untuk menjalankan aplikasi langsung dari VS Code (lihat [Langkah 9](#langkah-9-jalankan-aplikasi-development)).

---

## Langkah 5: Clone Project & Install Dependencies

### Clone Repository

```bash
git clone https://github.com/adityadarmawann/money-planner.git
cd money-planner
```

### Install Dependencies Flutter

```bash
flutter pub get
```

Perintah ini akan mengunduh semua package yang dibutuhkan aplikasi (tercantum di `pubspec.yaml`).

### Analisis Kode (Opsional tapi Direkomendasikan)

```bash
flutter analyze
```

Perintah ini memeriksa apakah ada error atau warning di kode. Jika tidak ada masalah, output akan menampilkan:

```
No issues found!
```

---

## Langkah 6: Setup Supabase Backend & Database

Aplikasi ini menggunakan **Supabase** sebagai backend (database, autentikasi, storage). Kamu perlu membuat project Supabase sendiri.

### Buat Akun Supabase

1. Buka https://supabase.com dan klik **"Start your project"**
2. Daftar dengan GitHub atau email
3. Verifikasi email jika diminta

### Buat Project Supabase

1. Di dashboard Supabase, klik **"New project"**
2. Isi:
   - **Name**: `money-planner` (atau nama lain yang kamu suka)
   - **Database Password**: buat password yang kuat (simpan, nanti dibutuhkan)
   - **Region**: pilih yang terdekat, misal `Southeast Asia (Singapore)`
3. Klik **"Create new project"** dan tunggu sekitar 1-2 menit

### Jalankan Schema Database

1. Di project Supabase, klik **"SQL Editor"** di menu kiri
2. Klik **"New query"**
3. Buka file `supabase/schema.sql` di project ini
4. Salin seluruh isi file tersebut dan tempel di SQL Editor Supabase
5. Klik **"Run"** (atau tekan `Ctrl+Enter`)
6. Pastikan muncul pesan sukses, bukan error

### Catat URL & Anon Key

1. Di dashboard Supabase, klik **"Settings"** (ikon ⚙️) di menu kiri
2. Klik **"API"**
3. Catat dua nilai ini (kamu akan butuhkan di Langkah 7):
   - **Project URL**: `https://xxxxxxxxxx.supabase.co`
   - **anon public key**: `eyJhbGciOiJIUzI1NiIs...` (string panjang)

### Aktifkan Email Auth

1. Di dashboard Supabase, klik **"Authentication"** di menu kiri
2. Klik **"Providers"**
3. Pastikan **"Email"** sudah aktif (toggle hijau)
4. Untuk development, kamu bisa aktifkan **"Confirm email"** → nonaktifkan (agar tidak perlu verifikasi email saat testing)

---

## Langkah 7: Konfigurasi Environment

### Buat File .env

```bash
cp .env.example .env
```

### Edit File .env

Buka file `.env` dengan VS Code atau text editor, lalu isi dengan nilai yang kamu catat dari Supabase:

```env
SUPABASE_URL=https://xxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

Ganti `xxxxxxxxxx` dengan URL project Supabase kamu yang sebenarnya.

> ⚠️ **PENTING:** Jangan pernah commit file `.env` ke repository! File ini berisi kredensial rahasia. File `.env` sudah ditambahkan ke `.gitignore` sehingga tidak akan tercommit secara tidak sengaja.

---

## Langkah 8: Setup Google Sign-In (Opsional)

> Langkah ini **opsional**. Jika kamu hanya ingin login dengan email/password, kamu bisa skip langkah ini.

### Buat Project di Google Cloud Console

1. Buka https://console.cloud.google.com
2. Klik **"Select a project"** → **"New Project"**
3. Beri nama project → klik **"Create"**

### Aktifkan Google Sign-In API

1. Di menu kiri, pilih **"APIs & Services"** → **"Library"**
2. Cari **"Google Sign-In API"** atau **"Identity"**
3. Klik **"Enable"**

### Dapatkan SHA-1 Fingerprint (Android)

Jalankan perintah ini di terminal:

```bash
# Windows (menggunakan keytool dari Java/Android Studio)
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Catat nilai **SHA1** yang muncul (format: `XX:XX:XX:...`).

### Buat OAuth Client ID

1. Di Google Cloud Console → **"APIs & Services"** → **"Credentials"**
2. Klik **"+ Create Credentials"** → **"OAuth client ID"**
3. Untuk Android:
   - Application type: **Android**
   - Package name: `com.example.money_planner`
   - SHA-1: tempel nilai SHA-1 yang sudah kamu catat
4. Untuk Web (dibutuhkan Supabase):
   - Application type: **Web application**
   - Catat **Client ID** dan **Client Secret**

### Tambahkan google-services.json

1. Di Google Cloud Console → **"Project Overview"** atau kembali ke **Firebase Console** (https://console.firebase.google.com) jika menggunakan Firebase
2. Download `google-services.json`
3. Taruh di folder `android/app/`

### Konfigurasi Supabase untuk Google

1. Di dashboard Supabase → **"Authentication"** → **"Providers"**
2. Klik **"Google"** → aktifkan toggle
3. Isi **Client ID** dan **Client Secret** dari Google Cloud Console
4. Klik **"Save"**

---

## Langkah 9: Jalankan Aplikasi Development

### Cek Perangkat yang Tersedia

```bash
flutter devices
```

Contoh output:

```
3 connected devices:

sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x86_64
Chrome (web)                  • chrome        • web-javascript
```

### Jalankan via Terminal

```bash
flutter run --dart-define-from-file=.env
```

Jika ada lebih dari satu perangkat, kamu akan diminta memilih. Ketik nomor perangkat yang diinginkan.

### Jalankan via VS Code (tekan F5)

File `.vscode/launch.json` sudah disediakan di repository ini. Cukup:

1. Buka project di VS Code
2. Pastikan emulator atau HP sudah terhubung
3. Tekan **F5** atau klik menu **Run** → **"Start Debugging"**
4. Pilih konfigurasi **"Student Plan (Debug)"**

### Hot Reload & Hot Restart

Saat aplikasi sedang berjalan di terminal:

| Perintah | Fungsi |
|----------|--------|
| `r` | **Hot Reload** — perbarui UI tanpa restart (cepat, state tidak hilang) |
| `R` | **Hot Restart** — restart aplikasi (state direset) |
| `q` | Keluar dari flutter run |

Di VS Code, tombol Hot Reload tersedia di toolbar debug (ikon petir ⚡).

---

## Langkah 10: Test di HP Android via WiFi

### Aktifkan USB Debugging di HP

1. Di HP Android, buka **Pengaturan** → **Tentang Ponsel**
2. Ketuk **"Nomor Build"** sebanyak **7 kali** hingga muncul notifikasi "Kamu sekarang seorang developer"
3. Kembali ke **Pengaturan** → **Opsi Developer**
4. Aktifkan **"USB Debugging"**

### Hubungkan via USB (Cara Biasa)

1. Hubungkan HP ke PC dengan kabel USB
2. Di HP, pilih **"File Transfer"** atau **"MTP"** saat muncul dialog
3. Izinkan USB Debugging saat ada dialog konfirmasi
4. Cek apakah HP terdeteksi:
   ```bash
   adb devices
   # Harus muncul: List of devices attached → XXXXXXXX device
   ```
5. Jalankan:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

### Wireless Debugging (Android 11+, tanpa kabel)

1. Di HP: **Pengaturan** → **Opsi Developer** → aktifkan **"Wireless Debugging"**
2. Ketuk **"Wireless Debugging"** → ketuk **"Pair device with pairing code"**
3. Catat **IP address:port** dan **Pairing code** yang muncul
4. Di terminal PC:
   ```bash
   adb pair <IP>:<PORT>
   # Ketik pairing code saat diminta
   ```
5. Setelah berhasil pair, hubungkan:
   ```bash
   adb connect <IP>:<PORT_CONNECT>
   ```
6. Verifikasi:
   ```bash
   adb devices
   # Harus muncul: <IP>:<PORT> device
   ```
7. Jalankan aplikasi:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

### Catatan Supabase Self-Hosted & IP Lokal

Jika kamu menggunakan Supabase **self-hosted** (bukan Supabase Cloud) dan ingin test di HP via WiFi:

1. Cari IP address PC kamu:
   ```bash
   # Windows
   ipconfig
   # macOS/Linux
   ifconfig
   ```
2. Gunakan IP lokal di `.env` (bukan `localhost`):
   ```env
   SUPABASE_URL=http://192.168.1.100:54321
   ```
3. Pastikan HP dan PC terhubung ke **WiFi yang sama**

> 💡 Jika menggunakan **Supabase Cloud** (`https://xxxxx.supabase.co`), tidak perlu setting khusus — langsung bisa diakses dari HP manapun selama ada koneksi internet.

---

## Langkah 11: Build APK / File Instalasi Android

### ⚠️ PENTING: Flutter Menghasilkan .apk, Bukan .exe!

Banyak yang bingung soal ini. Berikut penjelasannya:

| Platform | File Output | Ekstensi | Keterangan |
|----------|-------------|----------|------------|
| Android | APK / App Bundle | `.apk` / `.aab` | Untuk install di HP Android |
| iOS | IPA | `.ipa` | Untuk install di iPhone/iPad |
| Windows Desktop | EXE | `.exe` | Untuk install di PC Windows |
| Web | HTML/JS/CSS | — | Dibuka di browser |

> **File `.apk` digunakan untuk Android.** File `.exe` hanya dihasilkan jika kamu build untuk **Windows Desktop** — bukan untuk HP Android.

### Build APK Debug (untuk testing)

```bash
flutter build apk --debug --dart-define-from-file=.env
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Build APK Release (untuk distribusi)

```bash
flutter build apk --release --dart-define-from-file=.env
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build APK Split per Arsitektur (ukuran lebih kecil)

```bash
flutter build apk --split-per-abi --release --dart-define-from-file=.env
```

Output:

```
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk   → HP lama 32-bit
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk     → HP modern 64-bit (paling umum)
build/app/outputs/flutter-apk/app-x86_64-release.apk        → Emulator
```

> 💡 Gunakan `app-arm64-v8a-release.apk` untuk HP Android modern (2018 ke atas).

### Build App Bundle (untuk Google Play Store)

```bash
flutter build appbundle --release --dart-define-from-file=.env
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Cara Install APK ke HP

#### Via ADB (sambil HP terhubung ke PC)

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### Via Transfer Manual (tanpa kabel setelah build)

1. Copy file `.apk` dari `build/app/outputs/flutter-apk/`
2. Kirim ke HP via **WhatsApp**, **Email**, **Google Drive**, atau **kabel USB**
3. Di HP, buka file `.apk` dari File Manager
4. Jika muncul dialog **"Install from unknown sources"**:
   - Ketuk **"Settings"**
   - Aktifkan **"Allow from this source"**
   - Kembali dan ketuk **Install**
5. Tunggu proses instalasi selesai
6. Aplikasi siap digunakan! 🎉

---

## Struktur Folder

```
money-planner/
├── .env.example                      # Template konfigurasi environment
├── .vscode/
│   └── launch.json                   # Konfigurasi run/debug VS Code (F5)
├── android/                          # Konfigurasi Android native
├── ios/                              # Konfigurasi iOS native
├── supabase/
│   └── schema.sql                    # Script DDL database Supabase
├── pubspec.yaml                      # Dependensi & konfigurasi project Flutter
└── lib/
    ├── main.dart                     # Entry point + inisialisasi Supabase
    ├── app.dart                      # MaterialApp + routing
    ├── core/
    │   ├── config/
    │   │   └── env_config.dart       # Baca variabel dari .env
    │   ├── constants/
    │   │   ├── app_colors.dart       # Palet warna aplikasi
    │   │   ├── app_routes.dart       # Nama-nama route navigasi
    │   │   └── app_strings.dart      # String konstan
    │   ├── theme/
    │   │   └── app_theme.dart        # AppTheme (font Poppins, biru muda)
    │   ├── utils/
    │   │   ├── currency_formatter.dart  # Format Rupiah (Rp 1.000.000)
    │   │   ├── date_formatter.dart      # Format tanggal Indonesia
    │   │   └── validators.dart          # Validasi form input
    │   └── errors/
    │       └── app_exception.dart    # Custom exception handler
    ├── data/
    │   ├── models/                   # 8 model data (mapping tabel database)
    │   │   ├── user_model.dart
    │   │   ├── wallet_model.dart
    │   │   ├── transaction_model.dart
    │   │   ├── paylater_account_model.dart
    │   │   ├── paylater_bill_model.dart
    │   │   ├── budget_model.dart
    │   │   ├── budget_item_model.dart
    │   │   └── category_model.dart
    │   └── repositories/            # 6 repository (operasi CRUD ke Supabase)
    │       ├── auth_repository.dart
    │       ├── user_repository.dart
    │       ├── wallet_repository.dart
    │       ├── transaction_repository.dart
    │       ├── budget_repository.dart
    │       └── paylater_repository.dart
    ├── providers/                    # 6 provider (manajemen state dengan Provider)
    │   ├── auth_provider.dart
    │   ├── user_provider.dart
    │   ├── wallet_provider.dart
    │   ├── transaction_provider.dart
    │   ├── budget_provider.dart
    │   └── paylater_provider.dart
    └── presentation/
        ├── screens/                  # Semua layar aplikasi
        │   ├── auth/                 # Login, Register, Splash, Onboarding
        │   ├── home/                 # Home & Main screen (bottom nav)
        │   ├── wallet/               # Wallet & Top Up
        │   ├── transfer/             # Transfer, Konfirmasi, Sukses
        │   ├── paylater/             # Paylater, Apply, Tagihan
        │   ├── budget/               # Budget list, Create, Detail
        │   ├── history/              # Riwayat & Detail transaksi
        │   └── profile/              # Profil & Edit profil
        └── widgets/                  # Widget yang dapat digunakan ulang
            ├── common/               # Button, Card, Loading, Snackbar, TextField
            ├── home/                 # BalanceCard, QuickActionGrid
            ├── budget/               # BudgetChart, BudgetProgressBar
            └── transaction/          # TransactionTile
```

---

## Database Schema

Lihat file `supabase/schema.sql` untuk DDL lengkap.

| Tabel | Keterangan |
|-------|------------|
| `users` | Profil pengguna (nama, email, foto) |
| `wallets` | Saldo e-wallet per pengguna |
| `transactions` | Riwayat semua transaksi |
| `paylater_accounts` | Akun paylater (limit Rp 1.000.000) |
| `paylater_bills` | Tagihan paylater yang harus dibayar |
| `budgets` | Anggaran keuangan (mingguan/bulanan/kustom) |
| `budget_items` | Item anggaran per kategori dalam satu budget |
| `categories` | Kategori pemasukan & pengeluaran |

---

## Troubleshooting

### `flutter: command not found`

**Penyebab:** Flutter belum ditambahkan ke PATH.

**Solusi:**
- Pastikan PATH sudah dikonfigurasi (lihat [Langkah 1](#langkah-1-install-flutter-sdk))
- Buka terminal baru setelah mengubah PATH
- Verifikasi dengan: `echo $PATH | grep flutter`

---

### `No devices found` saat `flutter run`

**Penyebab:** Tidak ada perangkat terhubung atau emulator tidak berjalan.

**Solusi:**
1. Jalankan emulator Android dari Android Studio (AVD Manager)
2. Atau hubungkan HP Android dengan USB Debugging aktif
3. Cek dengan: `flutter devices`
4. Cek dengan: `adb devices`

---

### `Gradle build failed`

**Penyebab:** Masalah konfigurasi Android SDK atau versi Gradle.

**Solusi:**
```bash
# Bersihkan build cache
flutter clean
flutter pub get

# Pastikan Java tersedia
java -version

# Jalankan ulang
flutter run --dart-define-from-file=.env
```

---

### `SUPABASE_URL or SUPABASE_ANON_KEY not configured`

**Penyebab:** File `.env` belum dibuat atau variabel belum diisi.

**Solusi:**
1. Pastikan file `.env` ada di root project (bukan `.env.example`)
2. Pastikan isi `.env` benar (tidak ada spasi, tidak ada tanda kutip ekstra)
3. Jalankan dengan flag `--dart-define-from-file=.env`

---

### `SocketException: Connection refused` atau `Network unreachable`

**Penyebab:** URL Supabase salah, atau menggunakan `localhost` saat test di HP.

**Solusi:**
- Pastikan URL di `.env` benar dan dapat diakses
- Jika self-hosted, gunakan IP lokal (bukan `localhost`) — lihat [Langkah 10](#langkah-10-test-di-hp-android-via-wifi)
- Jika Supabase Cloud, pastikan ada koneksi internet

---

### Google Sign-In Error

**Penyebab:** SHA-1 fingerprint tidak sesuai, atau `google-services.json` tidak ada.

**Solusi:**
1. Pastikan `google-services.json` ada di `android/app/`
2. Pastikan SHA-1 di Google Console cocok dengan SHA-1 debug keystore kamu
3. Pastikan Client ID & Secret di Supabase sudah diisi dengan benar

---

### APK tidak bisa diinstall di HP

**Penyebab:** "Install from unknown sources" belum diizinkan, atau APK corrupt.

**Solusi:**
1. Aktifkan "Install from unknown sources" di Pengaturan HP:
   - Android 8+: **Pengaturan** → **Apps** → cari app File Manager → **Install unknown apps** → izinkan
2. Coba build ulang APK dengan `flutter build apk --release --dart-define-from-file=.env`
3. Pastikan transfer file APK tidak corrupt (bandingkan ukuran file)

---

## Ringkasan Urutan Lengkap

1. **Install Flutter SDK** (tambahkan ke PATH, verifikasi dengan `flutter doctor`)
2. **Install Android Studio & Emulator** (setup SDK, buat AVD, accept licenses)
3. **Install Git** (verifikasi dengan `git --version`)
4. **Install VS Code** (install extensions Flutter & Dart)
5. **Clone project & install dependencies** (`git clone`, `cd`, `flutter pub get`, `flutter analyze`)
6. **Setup Supabase** (buat akun, buat project, jalankan `schema.sql`, catat URL & Anon Key, aktifkan Email Auth)
7. **Konfigurasi environment** (`cp .env.example .env`, isi URL & Anon Key)
8. **Setup Google Sign-In** (opsional — Google Cloud Console, SHA-1, Supabase provider, `google-services.json`)
9. **Jalankan aplikasi** (`flutter run --dart-define-from-file=.env` atau tekan F5 di VS Code)
10. **Test di HP Android** (aktifkan USB Debugging, hubungkan HP, atau pakai Wireless Debugging)
11. **Build APK** (`flutter build apk --release --dart-define-from-file=.env`, install via `adb install` atau transfer manual)

---

## Lisensi

MIT