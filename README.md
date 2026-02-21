# 💰 StudentPlan — Financial Planner untuk Mahasiswa

> Panduan setup lengkap dari nol sampai build APK Android — untuk mahasiswa yang baru pertama kali pakai Flutter.

---

## 📋 Daftar Isi

**Informasi Umum**
- [Fitur Aplikasi](#-fitur-aplikasi)
- [Tech Stack](#-tech-stack)
- [Prasyarat Software](#-prasyarat-software)

**11 Langkah Setup (dari nol sampai APK)**
1. [Install Flutter SDK](#langkah-1--install-flutter-sdk)
2. [Install Android Studio & Emulator](#langkah-2--install-android-studio--emulator)
3. [Install Git](#langkah-3--install-git)
4. [Install VS Code & Extensions](#langkah-4--install-vs-code--extensions)
5. [Clone Project](#langkah-5--clone-project)
6. [Setup Supabase](#langkah-6--setup-supabase)
7. [Konfigurasi Environment](#langkah-7--konfigurasi-environment)
8. [Google Sign-In (Opsional)](#langkah-8--google-sign-in-opsional)
9. [Jalankan App (Development)](#langkah-9--jalankan-app-development)
10. [Test di HP Android](#langkah-10--test-di-hp-android)
11. [Build APK Android](#langkah-11--build-apk-android)

**Referensi**
- [Struktur Folder](#-struktur-folder)
- [Database Schema](#-database-schema)
- [Troubleshooting](#-troubleshooting)
- [Ringkasan 11 Langkah](#-ringkasan-11-langkah)
- [Lisensi](#-lisensi)

---

## ✨ Fitur Aplikasi

| Fitur | Deskripsi |
|---|---|
| 🔐 Login & Register | Autentikasi via Email/Password dan Google Sign-In |
| 💳 E-Wallet | Top up saldo, lihat saldo real-time |
| 🔄 Transfer Antar Pengguna | Kirim uang ke sesama pengguna StudentPlan |
| 🏦 Transfer ke Bank | Transfer ke BCA, BNI, BRI, Mandiri, dan lainnya |
| 📷 Pembayaran QRIS | Simulasi pembayaran via QR Code |
| 💸 Paylater | Cairkan dana, kelola tagihan, dan bayar cicilan |
| 📊 Financial Planner | Buat anggaran mingguan, bulanan, atau kustom |
| 📜 Riwayat Transaksi | Lihat dan filter semua riwayat transaksi |
| 👤 Profil Pengguna | Edit profil, foto, dan informasi akun |

---

## 🛠 Tech Stack

| Teknologi | Kegunaan | Versi |
|---|---|---|
| [Flutter](https://flutter.dev) | Framework UI Mobile (Android & iOS) | >= 3.0.0 |
| [Dart](https://dart.dev) | Bahasa Pemrograman | >= 3.0.0 |
| [Supabase](https://supabase.com) | Backend (Auth, Database, Storage) | ^2.3.0 |
| [Provider](https://pub.dev/packages/provider) | State Management | ^6.1.1 |
| [Google Sign-In](https://pub.dev/packages/google_sign_in) | Autentikasi Google | ^6.2.1 |
| [FL Chart](https://pub.dev/packages/fl_chart) | Grafik & Visualisasi Data | ^0.66.0 |
| [Intl](https://pub.dev/packages/intl) | Format Rupiah (id_ID) | ^0.19.0 |

---

## 📦 Prasyarat Software

Pastikan semua software berikut sudah terinstall sebelum memulai:

| Software | Versi Minimum | Link Download |
|---|---|---|
| Flutter SDK | 3.0.0 | [flutter.dev/docs/get-started/install](https://docs.flutter.dev/get-started/install) |
| Android Studio | 2022.3+ (Giraffe) | [developer.android.com/studio](https://developer.android.com/studio) |
| Git | 2.x | [git-scm.com/downloads](https://git-scm.com/downloads) |
| VS Code | 1.80+ | [code.visualstudio.com](https://code.visualstudio.com) |

---

## Langkah 1 — Install Flutter SDK

### Windows

1. Buka [flutter.dev/docs/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)
2. Download file `.zip` Flutter SDK terbaru
3. Ekstrak ke folder yang **tidak memerlukan admin** (contoh: `C:\src\flutter`)  
   ⚠️ Jangan ekstrak ke `C:\Program Files\` karena butuh hak admin
4. Tambahkan Flutter ke PATH:
   - Cari **"Edit the system environment variables"** di Start Menu
   - Klik **Environment Variables** → pilih `Path` → klik **Edit**
   - Klik **New** → masukkan path ke folder `flutter\bin` (contoh: `C:\src\flutter\bin`)
   - Klik OK sampai semua jendela tertutup
5. Buka **Command Prompt** baru dan verifikasi:
   ```cmd
   flutter --version
   ```

### macOS

1. Download Flutter SDK dari [flutter.dev/docs/get-started/install/macos](https://docs.flutter.dev/get-started/install/macos)
2. Ekstrak dan pindahkan ke direktori yang sesuai:
   ```bash
   cd ~/development
   unzip ~/Downloads/flutter_macos_*.zip
   ```
3. Tambahkan Flutter ke PATH (tambahkan ke `~/.zshrc` atau `~/.bash_profile`):
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
4. Reload shell dan verifikasi:
   ```bash
   source ~/.zshrc
   flutter --version
   ```

### Linux

1. Download Flutter SDK dari [flutter.dev/docs/get-started/install/linux](https://docs.flutter.dev/get-started/install/linux)
2. Ekstrak dan tambahkan ke PATH:
   ```bash
   cd ~
   tar xf ~/Downloads/flutter_linux_*.tar.xz
   echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   flutter --version
   ```

### Verifikasi dengan Flutter Doctor

Setelah install, jalankan perintah ini untuk mengecek apakah semua dependensi sudah lengkap:

```bash
flutter doctor
```

Contoh output yang diharapkan:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio (version 2022.x)
[✓] VS Code (version 1.xx.x)
[✓] Connected device (1 available)
```

> 💡 Tanda `[!]` atau `[✗]` berarti ada yang perlu diperbaiki. Ikuti instruksi yang muncul.

---

## Langkah 2 — Install Android Studio & Emulator

### 2.1 Install Android Studio

1. Download dari [developer.android.com/studio](https://developer.android.com/studio)
2. Jalankan installer dan ikuti petunjuknya (next → next → install)
3. Saat pertama kali dibuka, Android Studio akan men-download komponen tambahan secara otomatis. Tunggu hingga selesai.

### 2.2 Install Android SDK (API 34)

1. Buka Android Studio
2. Pergi ke **SDK Manager**:
   - Windows/Linux: **Tools → SDK Manager**
   - macOS: **Android Studio → Settings → Appearance & Behavior → System Settings → Android SDK**
3. Di tab **SDK Platforms**, centang **Android 14.0 (API Level 34)**
4. Di tab **SDK Tools**, pastikan ini tercentang:
   - ✅ Android SDK Build-Tools
   - ✅ Android Emulator
   - ✅ Android SDK Platform-Tools
5. Klik **Apply** → **OK** untuk mengunduh

### 2.3 Buat Virtual Device (Emulator)

1. Di Android Studio, buka **Device Manager** (ikon HP di toolbar kanan)
2. Klik **Create Device**
3. Pilih perangkat: **Pixel 6** (atau perangkat lain yang tersedia) → klik **Next**
4. Pilih System Image: **API 34** (jika belum ada, klik **Download** dulu) → klik **Next**
5. Beri nama emulator (atau biarkan default) → klik **Finish**
6. Klik ▶️ untuk menjalankan emulator dan pastikan bisa menyala

### 2.4 Setujui Android Licenses

Jalankan perintah berikut di terminal dan ketik `y` untuk setiap pertanyaan:

```bash
flutter doctor --android-licenses
```

Setelah selesai, jalankan `flutter doctor` lagi — pastikan Android toolchain sudah `[✓]`.

---

## Langkah 3 — Install Git

Git digunakan untuk men-download (clone) kode project.

### Windows

1. Download dari [git-scm.com/downloads](https://git-scm.com/downloads)
2. Jalankan installer. Pada bagian **"Adjusting your PATH environment"**, pilih opsi **"Git from the command line and also from 3rd-party software"**
3. Sisanya biarkan default → klik Install
4. Verifikasi:
   ```cmd
   git --version
   ```

### macOS

Git biasanya sudah ada di macOS. Verifikasi dengan:
```bash
git --version
```
Jika belum ada, jalankan `xcode-select --install` untuk menginstall Command Line Tools.

### Linux (Ubuntu/Debian)

```bash
sudo apt update && sudo apt install git -y
git --version
```

---

## Langkah 4 — Install VS Code & Extensions

VS Code adalah editor kode yang direkomendasikan untuk Flutter.

### 4.1 Install VS Code

Download dan install dari [code.visualstudio.com](https://code.visualstudio.com).

### 4.2 Install Extensions Flutter

1. Buka VS Code
2. Tekan `Ctrl+Shift+X` (Windows/Linux) atau `Cmd+Shift+X` (macOS) untuk membuka panel Extensions
3. Cari dan install extension berikut satu per satu:

| Extension | Publisher | Kegunaan |
|---|---|---|
| **Flutter** | Dart Code | Dukungan Flutter (wajib) |
| **Dart** | Dart Code | Dukungan bahasa Dart (wajib, otomatis terinstall bersama Flutter) |
| **Pubspec Assist** | Jeroen Meijer | Mudah tambah package ke pubspec.yaml |
| **Error Lens** | Alexander | Tampilkan error langsung di baris kode |
| **GitLens** | GitKraken | Fitur Git yang lebih lengkap |

> 💡 Setelah install extension Flutter, VS Code akan otomatis mendeteksi Flutter SDK kamu.

---

## Langkah 5 — Clone Project

### 5.1 Clone Repository

Buka terminal (Command Prompt / Terminal / VS Code Terminal) dan jalankan:

```bash
git clone https://github.com/adityadarmawann/money-planner.git
cd money-planner
```

### 5.2 Buka di VS Code

```bash
code .
```

Atau buka VS Code terlebih dahulu, lalu **File → Open Folder** dan pilih folder `money-planner`.

### 5.3 Install Semua Package (Dependencies)

Di terminal, pastikan kamu berada di dalam folder project, lalu jalankan:

```bash
flutter pub get
```

Perintah ini akan men-download semua package/library yang dibutuhkan aplikasi (terdaftar di `pubspec.yaml`). Tunggu hingga selesai.

---

## Langkah 6 — Setup Supabase

Supabase adalah backend yang digunakan aplikasi ini untuk database dan autentikasi.

### 6.1 Buat Akun Supabase

1. Buka [supabase.com](https://supabase.com) dan klik **Start your project**
2. Daftar menggunakan akun GitHub atau email
3. Setelah login, klik **New project**

### 6.2 Buat Project Baru

1. Pilih **Organization** (atau buat baru)
2. Isi:
   - **Project name**: `studentplan` (atau nama apapun)
   - **Database Password**: buat password yang kuat dan **simpan baik-baik**
   - **Region**: pilih yang terdekat (contoh: `Southeast Asia (Singapore)`)
3. Klik **Create new project** dan tunggu beberapa menit hingga project siap

### 6.3 Jalankan Database Schema

1. Di dashboard Supabase, klik menu **SQL Editor** di sidebar kiri
2. Klik **New query**
3. Buka file `supabase/schema.sql` di project kamu, salin **seluruh** isinya
4. Paste ke SQL Editor Supabase
5. Klik tombol **Run** (atau tekan `Ctrl+Enter`)
6. Pastikan tidak ada error merah — semua tabel berhasil dibuat

### 6.4 Catat URL dan Anon Key

1. Di dashboard Supabase, pergi ke **Settings → API** (di sidebar kiri)
2. Catat dua nilai berikut:
   - **Project URL**: contoh `https://abcdefghij.supabase.co`
   - **anon (public) key**: string panjang yang dimulai dengan `eyJ...`

> ⚠️ **Jangan bagikan** `anon key` ke publik atau upload ke GitHub. Key ini akan kita simpan di file `.env` yang sudah ada di `.gitignore`.

---

## Langkah 7 — Konfigurasi Environment

### 7.1 Salin File .env

Di terminal dalam folder project, jalankan:

```bash
# Windows (Command Prompt)
copy .env.example .env

# macOS / Linux
cp .env.example .env
```

### 7.2 Edit File .env

Buka file `.env` yang baru dibuat (terlihat di VS Code) dan isi dengan URL dan Key dari Langkah 6.4:

```env
SUPABASE_URL=https://abcdefghij.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

Ganti nilai di atas dengan URL dan Key milikmu.

> ⚠️ **Penting:** File `.env` sudah ada di `.gitignore` sehingga **tidak akan ter-upload ke GitHub**. Ini adalah cara aman menyimpan kredensial.

---

## Langkah 8 — Google Sign-In (Opsional)

Langkah ini hanya perlu dilakukan jika kamu ingin mengaktifkan fitur login dengan Google. Jika ingin skip, login email biasa sudah cukup untuk menjalankan aplikasi.

### 8.1 Setup Google Cloud Console

1. Buka [console.cloud.google.com](https://console.cloud.google.com)
2. Buat project baru atau pilih project yang sudah ada
3. Di menu samping, pergi ke **APIs & Services → Credentials**
4. Klik **Create Credentials → OAuth 2.0 Client ID**
5. Pilih **Application type: Android**
6. Masukkan **Package name**: `com.example.student_plan` (sesuai `android/app/build.gradle`)
7. Masukkan **SHA-1 fingerprint** (dapatkan dengan perintah di bawah):
   ```bash
   # Windows
   keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

   # macOS / Linux
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
8. Salin SHA-1 yang muncul → paste ke Google Console → klik **Create**
9. Download file `google-services.json` dan letakkan di folder `android/app/`

### 8.2 Setup di Supabase

1. Di dashboard Supabase, pergi ke **Authentication → Providers**
2. Klik **Google** dan aktifkan toggle
3. Masukkan **Client ID** dan **Client Secret** dari Google Console
4. Klik **Save**

---

## Langkah 9 — Jalankan App (Development)

### 9.1 Pastikan Emulator atau HP Terhubung

Jalankan perintah ini untuk melihat perangkat yang tersedia:

```bash
flutter devices
```

Contoh output:
```
Found 2 connected devices:
  sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64 • Android 14 (API 34)
  Chrome (web)                  • chrome       • web-javascript
```

### 9.2 Jalankan Aplikasi

```bash
flutter run --dart-define-from-file=.env
```

> 💡 Flag `--dart-define-from-file=.env` diperlukan agar aplikasi bisa membaca `SUPABASE_URL` dan `SUPABASE_ANON_KEY` dari file `.env` yang kamu buat.

Jika ada beberapa perangkat yang terdeteksi, Flutter akan menanyakan perangkat mana yang ingin digunakan. Pilih dengan mengetik nomornya.

### 9.3 Hot Reload & Hot Restart

Saat aplikasi berjalan di terminal:

| Perintah | Fungsi |
|---|---|
| Tekan `r` | **Hot Reload** — perbarui UI tanpa restart (state tetap) |
| Tekan `R` | **Hot Restart** — restart penuh aplikasi (state hilang) |
| Tekan `q` | Keluar dan hentikan aplikasi |

> 💡 Di VS Code, kamu juga bisa klik ikon ⚡ (Hot Reload) atau 🔄 (Hot Restart) di toolbar debug atas.

---

## Langkah 10 — Test di HP Android

### Opsi A: USB Debugging (Kabel)

1. Di HP Android kamu, buka **Pengaturan → Tentang ponsel**
2. Ketuk **Nomor build** sebanyak **7 kali** hingga muncul notifikasi "Kamu sekarang adalah developer"
3. Kembali ke **Pengaturan → Sistem → Opsi pengembang** (atau **Pengaturan → Opsi pengembang**)
4. Aktifkan **USB Debugging**
5. Hubungkan HP ke PC/laptop dengan kabel USB
6. Di HP akan muncul popup **"Izinkan USB Debugging?"** → klik **OK / Izinkan**
7. Di terminal, jalankan `flutter devices` dan pastikan HP terdeteksi
8. Jalankan aplikasi:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

### Opsi B: Wireless Debugging (Tanpa Kabel)

> Membutuhkan HP dengan Android 11 atau lebih baru, dan HP + PC harus terhubung ke **WiFi yang sama**.

1. Aktifkan **Opsi Pengembang** dan **USB Debugging** (seperti langkah di atas)
2. Di **Opsi pengembang**, aktifkan **Wireless debugging**
3. Ketuk **Wireless debugging** → ketuk **Pair device with pairing code**
4. Akan muncul **IP address & port** serta **Pairing code** di HP
5. Di terminal PC, jalankan:
   ```bash
   adb pair <IP>:<PORT>
   ```
   Contoh: `adb pair 192.168.1.5:37893`
6. Masukkan **Pairing code** yang muncul di HP
7. Setelah paired, hubungkan untuk debugging:
   ```bash
   adb connect <IP>:<PORT_DEBUG>
   ```
   (Port debug berbeda dari port pairing — lihat di layar Wireless debugging HP)
8. Jalankan `flutter devices` untuk memastikan HP terdeteksi, lalu:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

---

## Langkah 11 — Build APK Android

### ❓ Apa itu APK?

> **PENTING untuk dipahami:** Flutter adalah framework untuk membuat aplikasi **mobile** (Android & iOS). Hasil build Flutter untuk Android adalah file **`.apk`** (Android Package) — **BUKAN `.exe`** seperti program Windows.

Perbandingan format output per platform:

| Platform Target | Perintah Build | Format Output | Cara Install |
|---|---|---|---|
| **Android** (HP/tablet) | `flutter build apk` | `.apk` / `.aab` | Install di HP Android |
| **iOS** (iPhone/iPad) | `flutter build ios` | `.ipa` | Butuh Mac + Xcode |
| **Windows** (PC) | `flutter build windows` | `.exe` | Install di Windows |
| **Web** | `flutter build web` | folder HTML/JS/CSS | Deploy ke web server |
| **macOS** | `flutter build macos` | `.app` | Install di macOS |

> 💡 Untuk project ini, kita fokus ke **APK Android** yang bisa langsung diinstall di HP.

---

### 11.1 Build APK Debug

APK Debug digunakan untuk testing. Ukuran lebih besar, performa lebih lambat, tapi mudah di-debug.

```bash
flutter build apk --debug --dart-define-from-file=.env
```

📁 Output: `build/app/outputs/flutter-apk/app-debug.apk`

---

### 11.2 Build APK Release

APK Release adalah versi final yang siap dibagikan. Sudah teroptimasi dan lebih kecil.

```bash
flutter build apk --release --dart-define-from-file=.env
```

📁 Output: `build/app/outputs/flutter-apk/app-release.apk`

---

### 11.3 Build APK Split Per ABI (Direkomendasikan)

Perintah ini menghasilkan **3 APK terpisah** yang masing-masing dioptimalkan untuk arsitektur prosesor yang berbeda. Ukuran file lebih kecil dari APK universal.

```bash
flutter build apk --split-per-abi --release --dart-define-from-file=.env
```

📁 Output (3 file):
```
build/app/outputs/flutter-apk/
├── app-armeabi-v7a-release.apk   ← HP Android lama (32-bit)
├── app-arm64-v8a-release.apk     ← HP Android modern (64-bit) ← paling umum
└── app-x86_64-release.apk        ← Emulator x86
```

> 💡 Untuk HP Android modern (2017 ke atas), gunakan `app-arm64-v8a-release.apk`.

---

### 11.4 Build App Bundle (.aab) untuk Google Play Store

Jika ingin upload ke Google Play Store, gunakan format App Bundle:

```bash
flutter build appbundle --release --dart-define-from-file=.env
```

📁 Output: `build/app/outputs/bundle/release/app-release.aab`

---

### 11.5 Cara Install APK ke HP

#### Cara A: Via ADB (Kabel USB)

Hubungkan HP ke PC dengan USB Debugging aktif, lalu:

```bash
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

#### Cara B: Transfer Manual

1. Salin file `.apk` ke HP (via USB, WhatsApp, Google Drive, atau email)
2. Di HP, buka file `.apk` dari File Manager
3. Jika muncul peringatan **"Install dari sumber tidak dikenal"**, pergi ke **Pengaturan → Keamanan** dan aktifkan **Izinkan instalasi dari sumber tidak dikenal** untuk aplikasi yang kamu gunakan (File Manager atau browser)
4. Ketuk **Install**

---

## 📁 Struktur Folder

```
money-planner/
├── .env.example                      # Template konfigurasi environment
├── .vscode/
│   └── launch.json                   # Konfigurasi debug/release VS Code
├── android/                          # Konfigurasi native Android
├── ios/                              # Konfigurasi native iOS
├── supabase/
│   └── schema.sql                    # Script SQL untuk buat semua tabel
├── pubspec.yaml                      # Daftar dependencies/package
└── lib/
    ├── main.dart                     # Entry point + inisialisasi Supabase
    ├── app.dart                      # MaterialApp + routing
    ├── core/
    │   ├── constants/                # Warna, string konstanta, nama routes
    │   ├── theme/                    # AppTheme (font Poppins, warna biru muda)
    │   ├── utils/                    # Helper: format Rupiah, tanggal, validator
    │   └── errors/                   # Kelas AppException
    ├── data/
    │   ├── models/                   # 8 model data (User, Wallet, Transaction, dll)
    │   └── repositories/             # 6 repository untuk operasi CRUD ke Supabase
    ├── providers/                    # 6 provider untuk state management (Provider)
    └── presentation/
        ├── screens/                  # Semua layar/halaman aplikasi
        └── widgets/                  # Widget yang dapat digunakan ulang
```

---

## 🗄 Database Schema

Semua tabel dibuat otomatis saat kamu menjalankan `supabase/schema.sql` (Langkah 6).

| Tabel | Deskripsi | Kolom Utama |
|---|---|---|
| `users` | Profil pengguna | `id`, `email`, `username`, `full_name`, `phone`, `avatar_url` |
| `wallets` | Saldo e-wallet per pengguna | `user_id`, `balance`, `currency` |
| `transactions` | Riwayat semua transaksi | `type`, `amount`, `fee`, `status`, `ref_code`, `sender_id`, `receiver_id` |
| `paylater_accounts` | Akun paylater | `credit_limit` (Rp 1.000.000), `used_limit`, `interest_rate` |
| `paylater_bills` | Tagihan cicilan paylater | `principal_amount`, `interest_amount`, `total_due`, `due_date`, `status` |
| `budgets` | Anggaran keuangan | `name`, `period_type` (weekly/monthly/custom), `start_date`, `end_date` |
| `budget_items` | Item anggaran per kategori | `budget_id`, `category_id`, `planned_amount`, `actual_amount` |
| `categories` | Kategori transaksi | `name`, `icon`, `color`, `type` (income/expense) |

> Lihat file `supabase/schema.sql` untuk DDL lengkap beserta constraint dan trigger-nya.

---

## 🔧 Troubleshooting

### ❌ `flutter: command not found`
**Solusi:** Flutter belum ditambahkan ke PATH. Ulangi [Langkah 1](#langkah-1--install-flutter-sdk) dan pastikan path ke folder `flutter/bin` sudah benar.

---

### ❌ `Android toolchain - No issues found` tidak muncul di `flutter doctor`
**Solusi:**
1. Pastikan Android Studio sudah terinstall
2. Jalankan `flutter doctor --android-licenses` dan ketik `y` untuk semua pertanyaan
3. Cek apakah `ANDROID_HOME` atau `ANDROID_SDK_ROOT` sudah di-set di environment variables

---

### ❌ `MissingPluginException` saat run
**Solusi:** Jalankan `flutter clean && flutter pub get`, lalu coba jalankan kembali.

---

### ❌ Emulator sangat lambat
**Solusi:**
- Aktifkan **Hardware Acceleration** (HAXM di Intel / WHPX di Windows) di BIOS dan Android Studio
- Pilih system image **x86_64** untuk emulator yang lebih cepat
- Atau gunakan HP fisik (jauh lebih cepat dari emulator)

---

### ❌ Error `SUPABASE_URL` tidak ditemukan saat build/run
**Solusi:** Pastikan kamu selalu menyertakan flag `--dart-define-from-file=.env` saat menjalankan atau build:
```bash
flutter run --dart-define-from-file=.env
flutter build apk --dart-define-from-file=.env
```

---

### ❌ `Unsupported class file major version` atau error Gradle
**Solusi:** Pastikan JDK yang terinstall kompatibel. Android Studio biasanya sudah membundel JDK. Coba jalankan dari Android Studio langsung atau set `JAVA_HOME` ke JDK bawaan Android Studio.

---

### ❌ APK tidak bisa diinstall di HP ("App not installed")
**Solusi:**
- Pastikan **USB Debugging** aktif saat install via ADB
- Jika install manual, aktifkan **"Izinkan sumber tidak dikenal"** di pengaturan HP
- Coba uninstall versi lama aplikasi terlebih dahulu jika pernah install sebelumnya

---

## ✅ Ringkasan 11 Langkah

| # | Langkah | Perintah Utama |
|---|---|---|
| 1 | Install Flutter SDK | `flutter doctor` |
| 2 | Install Android Studio & Emulator | `flutter doctor --android-licenses` |
| 3 | Install Git | `git --version` |
| 4 | Install VS Code & Extensions | — |
| 5 | Clone Project | `git clone ... && flutter pub get` |
| 6 | Setup Supabase | Jalankan `schema.sql` di SQL Editor |
| 7 | Konfigurasi Environment | `cp .env.example .env` → edit `.env` |
| 8 | Google Sign-In (Opsional) | Setup di Google Console & Supabase |
| 9 | Jalankan App (Development) | `flutter run --dart-define-from-file=.env` |
| 10 | Test di HP Android | USB/Wireless Debugging |
| 11 | Build APK Android | `flutter build apk --release --dart-define-from-file=.env` |

---

## 📄 Lisensi

MIT — Bebas digunakan dan dimodifikasi untuk keperluan pembelajaran.