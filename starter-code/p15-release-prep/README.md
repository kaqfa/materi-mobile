# P15 — Deployment & Distribution Strategies

> Pertemuan 15 • Sub-CPMK53.2 • Modul: [Deployment & Distribution](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/14-deployment-distribution)

Starter: fondasi rilis — versioning semantik di pubspec, logger aman produksi (`kReleaseMode`), `FlutterError.onError`, dan `RELEASE-CHECKLIST.md` lengkap.

## Cara mulai

```bash
flutter create --platforms=android,ios .
flutter pub get
flutter run
```

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Tombol pemicu error (TODO P15-1) — amati jalurnya di konsol via `AppLogger.error` | Log muncul dengan stack trace |
| 2 | Sambungkan `AppLogger.error` ke layanan pelaporan (TODO P15-2, opsional Crashlytics/Sentry) | Crash uji terlihat di dashboard |
| 3 | Build rilis lokal: `flutter build apk --release` (tanpa signing dulu) | APK terbangun; jalankan `flutter install` — banner debug hilang, log debug hilang |
| 4 | Kerjakan `RELEASE-CHECKLIST.md` untuk capstone-mu sendiri | Bukti per butir masuk CHANGELOG G4 |

## Catatan

- Perbedaan debug/profile/release: debug = assert+log penuh; profile = pengukuran; release = optimasi + strip log. Jangan pernah menilai performa dari build debug.
- `--obfuscate --split-debug-info`: simpan folder symbols — tanpa itu, stack trace crash produksi tak terbaca.
- Pertemuan ini bertepatan gate **G4 (Rilis)** — signed build + dokumentasi adalah inti gate.
