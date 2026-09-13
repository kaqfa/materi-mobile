# P13 — Platform Features & Device Integration

> Pertemuan 13 • Sub-CPMK92.2 • Modul: [Platform Features & Device Integration](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/12-platform-features-device)

Starter: foto progres tugas (kamera/galeri, kompresi `maxWidth`+`imageQuality`) + lokasi GPS dengan penanganan izin bertingkat.

## Cara mulai

```bash
flutter create --platforms=android,ios .
flutter pub get
flutter run
```

**Wajib: deklarasi izin** (folder platform dibuat oleh `flutter create`):

- `android/app/src/main/AndroidManifest.xml` — di dalam `<manifest>`:
  ```xml
  <uses-permission android:name="android.permission.CAMERA"/>
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
  ```
- `ios/Runner/Info.plist`:
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Foto progres tugas belajar</string>
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>Mencatat lokasi sesi belajar</string>
  ```

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Foto dari kamera & galeri; perhatikan ukuran file sebelum/sesudah kompresi | Preview tampil; ukuran file turun (lihat via `file.lengthSync()`) |
| 2 | Tangani `deniedForever` (TODO P13-2) dengan pesan arahkan-ke-pengaturan | Tolak permanen di pengaturan → snackbar menyebut pengaturan |
| 3 | Uji mati GPS + tolak izin + kabulkan izin — tiga jalur error/sukses | Tiap jalur memberi pesan yang tepat, app tidak crash |
| 4 | Simpan metadata sesi (path foto + lat/long) ke `Map` lokal, tampilkan riwayat | Riwayat sesi tampil dengan lokasi |

## Catatan

- Perilaku platform beda: izin kamera Android vs `Info.plist` iOS — selalu uji di device/emulator, bukan hanya di kode.
- `pickImage` mengembalikan null ketika user membatalkan — itu bukan error; jangan perlakukan seperti error.
- Upload foto ke Supabase Storage (dari modul bab 12) bisa jadi lanjutan capstone G3.
