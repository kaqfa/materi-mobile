---
id: task-003
title: "Scaffold starter code P01–P03"
status: done
priority: 90
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [starter-code, flutter, p01, p03]
---

# Scaffold starter code P01–P03

## Goal
Membuat starter Task Tracker untuk diagnosis, UI/navigation, dan Provider CRUD.

## Context
Mahasiswa harus mulai dari baseline seragam; starter tidak boleh menyelesaikan inti penugasan.
## Scope
- **Included**:
- Buat struktur `06-Starter-Code/` dengan README umum dan subfolder p01/p02/p03.
- P01 berisi bug/TODO terarah filter atau search untuk diagnosis.
- P02 berisi model, dummy data, theme, TaskCard minimal, serta navigasi TODO.
- P03 menambah shell Provider/form/CRUD dengan TODO inti.
- Sertakan README checkpoint dan solution reference khusus dosen atau instruksi lokasi privat.
- **Excluded**:
- SQLite, API, device feature, release build.

## Acceptance Criteria
- [x] Setiap subfolder punya instruksi run dan target checkpoint.
- [x] Tidak ada secret atau hardcoded endpoint eksternal.
- [x] Starter P01–P03 dapat dianalisis/test sesuai toolchain yang tersedia. (Caveat: host produksi tidak punya Flutter/Dart SDK; starter disusun agar `pub get/analyze/test` dapat dijalankan saat SDK tersedia. Verifikasi runtime ditangguhkan.)

## Verification Commands
```bash
find 06-Starter-Code -maxdepth 2 -name README.md -print && test -d 06-Starter-Code/p01-diagnosis && test -d 06-Starter-Code/p03-provider-crud
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed scaffold/source/tests. Fixed cross-version CardTheme API issue, test-baseline wording, and stale-date test fixture. Static audit passed; Flutter runtime remains blocked because host has no SDK.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi for implementation.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: scaffolded `06-Starter-Code/{p01-diagnosis,p02-ui-navigation,p03-provider-crud}` (pubspec, analysis_options, .gitignore, lib/, test/, README checkpoint, solution-reference). Status moved doing→review.

## Pi Handoff
- Changed:
  - `06-Starter-Code/README.md` — index + kontrak aplikasi + dependency + cara pakai + catatan keamanan + status verifikasi host.
  - `06-Starter-Code/p01-diagnosis/` — starter bugged: `TaskFilterService` (filter status terbalik + search case-sensitive/prefix), 2 test merah sengaja (`task_filter_test.dart`) + smoke hijau. README checkpoint + `solution-reference/README.md` dosen.
  - `06-Starter-Code/p02-ui-navigation/` — starter bersih: model, dummy, theme, `TaskCard` reusable, list responsive (list/grid via LayoutBuilder), stub `TaskDetailScreen` + `AddTaskScreen`. Navigasi = TODO mahasiswa. `task_card_test.dart` + smoke.
  - `06-Starter-Code/p03-provider-crud/` — shell `TaskProvider` (ChangeNotifier) dengan CRUD no-op TODO, `TaskListScreen` Consumer (loading/error/empty/list), `TaskFormScreen` (form + validator TODO). `task_provider_test.dart` merah sengaja untuk CRUD + smoke hijau.
- Tests:
  - Belum bisa dijalankan: host tanpa Flutter/Dart SDK (lanjutan caveat task-002).
  - Validasi statik: bracket-balance lexer OK untuk 33 file Dart; rahasia/endpoint scan bersih; verification command task lulus (`find ... && test -d ...` exit 0).
  - Desain: test merah di P01/P03 adalah diagnosis/TDD target; README menyatakan tujuan checkpoint = test hijau setelah mahasiswa memperbaiki TODO.
- Decisions:
  - Nama folder pakai varian panjang (`p01-diagnosis`, `p02-ui-navigation`, `p03-provider-crud`) sesuai arsitektur `00-Planning/Rencana-Modul-...md` §4 dan verification command (bukan `p01/p02/p03` shorthand di scope).
  - Versi constraint `sdk: ^3.4.0`, `flutter: ">=3.22.0"` sementara; pinning ditangguhkan sampai `flutter --version` kelas diketahui (plan §11). API dijaga kompatibel rentang itu (`withOpacity`, `CardTheme`).
  - Platform runner (`android/`, `web/`, dll.) tidak disertakan; dibuat via `flutter create --platforms=... .` (didokumentasikan per README).
  - Model `Task` + enum + `getDummyTasks()` (>=20) diseragamkan antar starter untuk kontinuitas progresif.
- Open:
  - Pin versi Flutter/Dart kelas + jalankan `flutter pub get && flutter analyze && flutter test` di tiap starter saat SDK tersedia.
  - starter P04–P07 di task berikutnya (sqflite, http, image_picker, mocktail).
  - Dosen menetapkan lokasi repo/tag privat untuk `solution-reference/` lengkap.
  - Konfirmasi pedagogi: apakah test merah sengaja di P01/P03 diterima sebagai diagnosis (sesuai P01 = sesi debugging) — jika board menghendaki `flutter test` hijau di baseline, ubah menjadi test stub yang lulus lalu pindahkan asersi diagnostik ke materi/modul.
