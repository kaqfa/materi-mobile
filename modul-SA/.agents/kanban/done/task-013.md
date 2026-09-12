---
id: task-013
title: "Buat proyek environment checker (smoke test semua library)"
status: done
priority: 90
assignee: pi
created_at: 2026-08-10
updated_at: 2026-08-10
tags: [starter-code, environment, smoke-test]
---

# Buat proyek environment checker (smoke test semua library)

## Goal

Membuat satu proyek Flutter sederhana di `06-Starter-Code/p00-env-check/` yang membuktikan semua library dan device feature yang dipakai sepanjang PPB Remidi (P01-P07) bisa jalan di mesin mahasiswa. Bukan aplikasi nyata; yang penting setiap dependency ter-import, ter-panggil, dan menampilkan hasil sukses/gagal di layar.

## Context

Sebelum P01, mahasiswa wajib memastikan laptop dan device mereka siap. Saat ini `Checklist-Environment.md` hanya perintah manual (`flutter doctor`, `pub get`, `analyze`, `test`). Proyek ini menjadi **bukti otomatis** bahwa toolchain + plugin native + device feature semua siap tempur.

## Scope

- **Included**:
  - Buat `06-Starter-Code/p00-env-check/` dengan `pubspec.yaml`, `analysis_options.yaml`, `README.md`.
  - Satu screen dengan checklist otomatis yang menjalankan smoke test tiap library.
  - Library yang diuji (minimal):
    - `provider` (ChangeNotifier + watch/read)
    - `sqflite` + `sqflite_common_ffi` (open DB, create table, insert, query)
    - `http` (GET ke endpoint publik placeholder, mis. `https://jsonplaceholder.typicode.com/todos/1`; tangani network error graceful)
    - `image_picker` (cek ketersediaan gallery + camera; tidak wajib ambil foto nyata, cukup panggil API dan tangani hasil/fallback)
    - `geolocator` atau `location` (cek permission + availability; tidak wajib GPS fix nyata)
    - `path` (getTemporaryPath, getApplicationDocumentsPath)
  - Setiap test menampilkan: nama library, status (OK/GAGAL/SKIP), pesan error bila gagal.
  - `flutter analyze` dan `flutter test` (minimal smoke widget test) harus hijau.
  - README menjelaskan cara run, interpretasi hasil, dan troubleshooting per library.
- **Excluded**:
  - Aplikasi CRUD nyata.
  - UI yang cantik; cukup list sederhana.
  - Test coverage tinggi.
  - Signing key, Play Store, release build.

## Acceptance Criteria

- [ ] Proyek `p00-env-check` bisa `flutter pub get` tanpa error (dependency ter-resolve).
- [ ] `flutter analyze` bersih.
- [ ] `flutter test` hijau (minimal widget smoke).
- [ ] Saat di-run, setiap library menampilkan status OK atau GAGAL dengan pesan.
- [ ] Tidak ada secret/token/credential di source.
- [ ] README menjelaskan: cara run, daftar library yang diuji, interpretasi hasil, troubleshooting.

## Verification Commands

```bash
test -d 06-Starter-Code/p00-env-check && test -f 06-Starter-Code/p00-env-check/pubspec.yaml && test -f 06-Starter-Code/p00-env-check/README.md
```

## Implementation Notes

Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-10 Prisa: moved to done. Reviewed env checker: sealed CheckResult, progressive provider, 6 library smoke tests, README troubleshooting. Cleaned em dash from new files. Static audit passed.
- 2026-08-10 Prisa: moved to doing. Delegated to Pi.

- 2026-08-10 Prisa: created task.

- 2026-08-10 Pi: selesai scaffold `06-Starter-Code/p00-env-check/` (pubspec + analysis_options + README + 16 file lib + widget smoke test). Pindah ke review.

## Pi Handoff
- Changed:
  - `06-Starter-Code/p00-env-check/pubspec.yaml` — dependency: provider, sqflite, sqflite_common_ffi(dev), http, image_picker, geolocator, path, path_provider.
  - `06-Starter-Code/p00-env-check/analysis_options.yaml` — seragam dengan starter lain (flutter_lints + const + avoid_print).
  - `06-Starter-Code/p00-env-check/README.md` — cara run, tabel 6 library, interpretasi OK/GAGAL/SKIP, troubleshooting per library, catatan keamanan.
  - `lib/`: app.dart, main.dart, core/{constants,theme}, features/env_check/{domain/check_result.dart (sealed Ok/Fail/Skip), presentation/{checks/* (6 smoke + all_checks + check_definition), providers/env_check_provider.dart (ChangeNotifier), screens/env_check_screen.dart}}.
  - `test/widget_test.dart` — render smoke (judul + Run button + 6 item pending), tidak menyentuh plugin native.
- Tests:
  - Verification command (test -d / test -f pubspec.yaml / test -f README.md): PASS.
  - `flutter pub get` / `flutter analyze` / `flutter test`: **belum dijalankan** — host tidak punya Flutter/Dart SDK (lihat README tiap starter + `06-Starter-Code/README.md`). Wajib dijalankan di mesin kelas. Sesuai caveat task-003/007/011.
- Decisions:
  - `sqflite` smoke memakai factory FFI + in-memory DB (portable Android/iOS/desktop/test) tanpa tulis file fisik; tidak mengganti `databaseFactory` global.
  - `image_picker` smoke non-interaktif → `CheckSkip` (registrasi plugin saja); uji ambil foto nyata ditangguhkan ke P06 sesuai scope task.
  - `geolocator` smoke non-interaktif: `isLocationServiceEnabled` + `checkPermission` (tidak minta dialog permission).
  - `path` + `path_provider` diuji bersama: tugas menyebut `path` untuk getTemporaryPath/getApplicationDocumentsPath padahal itu `path_provider`; README menjelaskan bedanya.
  - Check berjalan berurutan via `runAll()`; tiap item re-broadcast ke UI agar progres live.
  - Tidak ada secret/token; endpoint HTTP hanya placeholder publik `jsonplaceholder.typicode.com`.
- Open:
  - Pin versi Flutter/Dart kelas saat sudah diketahui (lihat `06-Starter-Code/README.md` § Versi).
  - Permission manifest `ACCESS_FINE/COARSE_LOCATION` perlu ditambah mahasiswa saat run device (lihat README troubleshooting).
  - Resolusi versi `geolocator ^12.0.0` belum diverifikasi via pub get (no SDK on host); jika gagal, naik/turunkan caret.
