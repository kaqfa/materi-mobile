# p07-release, Release, Quality Gate & Live Coding Demo

> **Pertemuan 7**, fokus: quality gate (`flutter analyze` + `flutter test`), release APK, `const`/rebuild basics, demo preparation.
> **Role starter:** shell release-ready minimal. Strict `const` lint aktif; smoke test hijau; tidak menyimpan signing key/secret apa pun. P07 menutup paket remidi + demo individual (Proyek Akhir).

## Prasyarat

- Selesai P06 (device feature + testing). P07 tidak menambah fitur baru; ia **membuktikan kualitas** seluruh capaian P01-P06 + merilis APK + menjelaskan kode.
- `flutter doctor` bersih; perangkat/emulator Android untuk uji APK.

## Instruksi run

```bash
flutter create --platforms=android. # di dalam folder ini
flutter pub get # provider ^6.1.2
flutter analyze # strict const -> harus bersih
flutter test # smoke + unit -> hijau
flutter build apk --release # hasil: build/app/outputs/flutter-apk/app-release.apk
```

> **Lihat `RELEASE-CHECKLIST.md`** untuk langkah rilis lengkap (termasuk obfuscation, ukuran APK, uji install). **Jangan commit signing key**, `.gitignore` sudah mengecualikan `*.jks`, `key.properties`, dll.

## Quality gate (wajib lulus sebelum demo)

```bash
# 1. Analisis statis: harus "No issues found!"
flutter analyze

# 2. Seluruh test: harus "All tests passed!"
flutter test

# 3. Build release: APK terbentuk tanpa error
flutter build apk --release
```

> Bila `analyze` melaporkan warning: perbaiki **atau** jelaskan di README (sesuai planning §6 Assignment 1). Jangan ditelan diam-diam.

## `const` & rebuild basics

- `lib/features/perf/perf_demo_screen.dart` mendemokan subtree `const` yang **tidak rebuild** saat `setState` di parent. Pakai Flutter Inspector (VS Code / Android Studio) untuk melihat highlight widget yang rebuild.
- `analysis_options.yaml` mengaktifkan `prefer_const_constructors` + `prefer_const_literals_to_create_immutables` agar lint menangkap pelanggaran otomatis.
- Aturan: widget immutable tanpa argumen dinamis -> `const`. Pisahkan state lokal ke `StatefulWidget` kecil agar rebuild terbatas pada yang membaca state itu.

## Demo preparation (Proyek Akhir)

1. **App walkthrough (2-3 menit):** jalankan APK rilis di perangkat; tunjukkan CRUD (P03), persistensi (P04), API/mock + error state (P05), device attachment (P06).
2. **Code walkthrough (3-4 menit):** jelaskan satu jalur end-to-end (mis. `TaskProvider -> TaskRepository -> datasource`), `sealed ApiError` (P05), `sealed AttachmentResult` (P06), `TaskFilterService` (P06).
3. **Live modification (20-25 menit):** dosen menarik soal dari `05-Assessment/Bank-Live-Coding.md` (sorting/filter baru, validasi tanggal, empty state khusus, mapper JSON). Selesaikan live + jelaskan. **Tidak dapat digantikan source code.**
4. **Q&A:** konsep `const`/rebuild, kenapa `sealed` aman, kenapa error dari HTTP status bukan body.

## Struktur penting

```text
lib/
├── main.dart # runApp(TaskTrackerApp())
├── app.dart # MaterialApp + home + FAB -> PerfDemoScreen
├── core/{constants,theme}/
└── features/
 ├── perf/perf_demo_screen.dart # const/rebuild demo
 └── tasks/
 ├── domain/task.dart # immutable, const-friendly
 └── presentation/screens/task_list_screen.dart # const-heavy
test/
├── domain/task_model_test.dart # unit smoke (gate)
└── widget/smoke_test.dart # widget smoke (gate)
```

## Yang TIDAK boleh dilakukan

- Menyimpan signing key, keystore, `key.properties`, token, atau `.env` berisi rahasia nyata di repo.
- Meng-hardcode endpoint/akun produksi.
- Menonaktifkan `flutter analyze` / skip test agar "hijau".
- Mengganti source reguler di parent folder.

## Catatan keamanan

- `.gitignore` mengecualikan `*.jks`, `*.keystore`, `key.properties`, `google-services.json`, `GoogleService-Info.plist`, `*.p12`, `*.pem`, `.env`, `secrets.json`.
- Starter **tidak** menyimpan signed key atau release secret apa pun (acceptance criteria P07).
- Signing APK di luar scope wajib (planning §2 kecualikan Play Store upload). Demo cukup `flutter build apk --release` (debug-sign atau unsigned) + install manual.

## Status verifikasi host

Host produksi tidak punya Flutter SDK. `analyze/test/build` belum dijalankan di sini; verifikasi runtime ditangguhkan sampai SDK tersedia (lihat `../README.md`).
