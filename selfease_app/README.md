# SelfEase - Aplikasi Kesehatan Mental

SelfEase adalah aplikasi kesehatan mental yang membantu pengguna mengelola stres dan kecemasan melalui berbagai fitur seperti meditasi, jurnal harian, dan latihan pernapasan.

## Fitur Utama

- 🧘‍♀️ **Meditasi**: Berbagai jenis meditasi dengan panduan suara
- 📝 **Jurnal Harian**: Catat perasaan dan refleksi harian
- 🫁 **Latihan Pernapasan**: Teknik pernapasan 4-7-8 dan lainnya
- 📊 **Statistik**: Pantau perkembangan kesehatan mental
- 🔔 **Pengingat**: Notifikasi untuk meditasi dan jurnal
- 📱 **Mode Offline**: Akses fitur tanpa internet

## Teknologi

- Flutter 3.0+
- Firebase (Authentication, Firestore, Analytics)
- Provider untuk state management
- Local Notifications
- Just Audio untuk meditasi
- FL Chart untuk visualisasi data

## Persyaratan Sistem

- Flutter SDK: 3.0.0 atau lebih tinggi
- Dart SDK: 2.17.0 atau lebih tinggi
- Android Studio / VS Code
- Android SDK
- iOS SDK (untuk pengembangan iOS)

## Instalasi

1. Clone repositori:
   ```bash
   git clone https://github.com/username/selfease_app.git
   ```

2. Masuk ke direktori proyek:
   ```bash
   cd selfease_app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Konfigurasi Firebase:
   - Buat proyek di Firebase Console
   - Download google-services.json
   - Tempatkan di android/app/

5. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## Struktur Proyek

```
lib/
├── config/
│   └── theme.dart
├── models/
│   ├── user_model.dart
│   ├── exercise_model.dart
│   └── ...
├── screens/
│   ├── welcome_screen.dart
│   ├── home_screen.dart
│   └── ...
├── services/
│   ├── auth_service.dart
│   └── database_service.dart
├── widgets/
│   └── exit_dialog.dart
└── main.dart
```

## Panduan Kontribusi

1. Fork repositori
2. Buat branch fitur (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## Rilis

### Versi 1.0.0
- Fitur dasar meditasi
- Jurnal harian
- Latihan pernapasan
- Statistik dasar
- Notifikasi

### Versi 1.1.0 (Akan Datang)
- Komunitas pengguna
- Berbagi progress
- Tema tambahan
- Konten premium

## Lisensi

Dilindungi oleh hak cipta © 2023 SelfEase. Seluruh hak cipta.

## Kontak

Email: support@selfease.com
Website: https://selfease.com

## FAQ

**T: Apakah aplikasi ini gratis?**
J: Ya, aplikasi ini gratis dengan fitur dasar. Fitur premium akan tersedia di masa mendatang.

**T: Apakah data saya aman?**
J: Ya, kami menggunakan enkripsi end-to-end dan mematuhi standar keamanan data.

**T: Bagaimana cara memulai meditasi?**
J: Setelah login, pilih menu Meditasi dan ikuti panduan audio yang tersedia.
