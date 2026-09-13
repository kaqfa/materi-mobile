# P01 — Introduction to Mobile Development & Dart Fundamentals

> Pertemuan 1 • Sub-CPMK53.1 • Modul: [Dart Fundamentals](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/01-dart-fundamentals)

Starter: aplikasi Flutter pertama bernama **StudyTracker** — cukup untuk memahami struktur project, `pubspec.yaml`, dan widget tree dasar.

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
```

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Jalankan project & kenali struktur folder (`lib/`, `test/`, `pubspec.yaml`) | Aplikasi terbuka di emulator/device, teks sambutan tampil |
| 2 | Pindahkan judul `'StudyTracker'` ke variabel `appTitle`, pakai di AppBar & Text | Aplikasi tetap jalan; `flutter analyze` 0 issue |
| 3 | Isi `onPressed` FAB dengan `SnackBar` | Tap FAB → snackbar muncul |
| 4 | Tambah `Text` kedua (nama MK & semester) di bawah Card | Teks baru tampil rapi tanpa overflow |

## Catatan

- `pubspec.yaml` = manifest project: nama, dependensi, aset. Belum ada dependensi eksternal di P01.
- Hot reload (`r` di terminal `flutter run`) vs hot restart (`R`): coba ubah teks, rasakan bedanya.
- Kalau `flutter doctor` ada isu merah, selesaikan dulu — ini syarat environment check P01.
