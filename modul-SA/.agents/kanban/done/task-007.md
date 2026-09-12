---
id: task-007
title: "Scaffold starter code P04–P05 untuk SQLite dan REST"
status: done
priority: 80
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [starter-code, flutter, sqlite, api]
---

# Scaffold starter code P04–P05 untuk SQLite dan REST

## Goal
Membuat starter data layer berjenjang untuk persistence lokal dan integrasi REST.

## Context
Sesi P04/P05 memakai arsitektur local datasource/repository/remote datasource agar konsep tidak bercampur di UI.
## Scope
- **Included**:
- Buat `06-Starter-Code/p04-sqlite/` dan `p05-api/` beserta README per checkpoint.
- P04 menyediakan schema Task SQLite dan TODO mapper/repository/Provider wiring.
- P05 menyediakan API client interface, fixtures/mock response, error type, `--dart-define` config example.
- Buat `06-Starter-Code/API-CONTRACT.md` dan `.env.example` tanpa secret.
- **Excluded**:
- Mengunci endpoint produksi, credential nyata, automatic sync queue.

## Acceptance Criteria
- [x] P04 dapat didemokan tanpa internet.
- [x] P05 punya mock/fixture fallback sehingga bisa diuji tanpa server eksternal.
- [x] Tidak ada key/token di source atau dokumentasi.

## Verification Commands
```bash
test -d 06-Starter-Code/p04-sqlite && test -d 06-Starter-Code/p05-api && test -f 06-Starter-Code/API-CONTRACT.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Pi Handoff
- **Changed:**
  - `06-Starter-Code/p04-sqlite/` (baru, 16 file dart + config + README + solution-reference): arsitektur `TaskDatabase` (skema tabel `tasks`) → `LocalTaskDatasource` (CRUD TODO) → `TaskMapper` (fromRow/toRow TODO) → `LocalTaskRepository` (upsert, lengkap) → `TaskProvider` (loadTasks lengkap, CRUD TODO) → UI list/form dengan badge SQLite + empty/error/loading. Test: `task_mapper_test.dart` (merah TODO), `local_task_datasource_test.dart` (merah TODO, pakai `sqflite_common_ffi`), `widget_test.dart` (smoke hijau). Pubspec: `sqflite`, `path`, `provider` + dev `sqflite_common_ffi`.
  - `06-Starter-Code/p05-api/` (baru, 20 file dart + config + README + solution-reference): `ApiConfig` (`--dart-define` API_BASE_URL/API_TOKEN, `useMock` default true) → `ApiError` sealed (Network/Server/Client/NotFound/Parse + `mapResponseToError`) → `TaskApiClient` abstract → `HttpTaskApiClient` (package:http, timeout, mapping status→error) → `MockTaskApiClient` (fixture fallback in-memory + `simulateNetworkError`) → `RemoteTaskDatasource` → `RemoteTaskRepository` (upsert) → `TaskProvider` (loadTasks lengkap, CRUD TODO). Domain `task.dart` tambah `toJson/fromJson` sesuai kontrak. UI list/form dengan badge MOCK/LIVE + RefreshIndicator + state error cloud_off. Test: `api_error_test.dart` (hijau), `mock_task_api_client_test.dart` (hijau, fixture + simulasi error), `widget_test.dart` (hijau, mode mock tampil tanpa server).
  - `06-Starter-Code/API-CONTRACT.md` (baru): endpoint, bentuk JSON (single/list + `data`), tabel field, mapping status→ApiError, kebijakan konfigurasi & keamanan, lokasi fixture.
  - `06-Starter-Code/.env.example` (baru): placeholder `API_BASE_URL=`/`API_TOKEN=` kosong + catatan Flutter baca via `--dart-define`.
  - `06-Starter-Code/README.md` (update): cakupan task-007, struktur folder, dependency table P01–P05, verifikasi loop termasuk p04/p05, catatan keamanan & status verifikasi host.
- **Tests:** Host tidak punya Flutter/Dart SDK → `flutter pub get/analyze/test` ditangguhkan ke mesin kelas (sama seperti task-003). Yang dijalankan: (1) verification command task → PASS; (2) secret scan (URL/token/Bearer) → bersih, `.env.example` value kosong; (3) brace/paren/round balance 36 file dart → 0 issue; (4) `git diff --check` → bersih; (5) audit marker `TODO(student)` 14 titik terarah (mapper 2, datasource 5, provider P04 4, provider P05 4) + test merah P04 (6 test), hijau P05 (3 file). Yang menunggu SDK: resolve versi `sqflite`/`http`/`sqflite_common_ffi`, `flutter analyze` 0 warning, `flutter test` merah/hijau sesuai desain.
- **Decisions:**
  - Memakai arsitektur 3-layer (datasource→repository→provider) konsisten dengan planning §7; abstraksi `TaskRepository` sama antar P04 (local) & P05 (remote) agar P06 bisa digabung offline+sync.
  - P04 memisahkan `TaskMapper` (baris↔model) dari `LocalTaskDatasource` (query) → dua checkpoint jelas; `LocalTaskRepository.save` upsert non-TODO agar mahasiswa fokus mapper+datasource+provider.
  - P05 tidak pakai `mocktail`; `MockTaskApiClient` ganda sebagai test double + fixture fallback → capaian teruji tanpa dependensi mocking (di luar scope wajib).
  - Serialisasi eksplisit: P04 lewat mapper (kolom SQLite), P05 lewat `Task.toJson/fromJson` (kontrak REST) — dua pendekatan setara sesuai planning §6.
  - Default `API_BASE_URL` kosong → otomatis mock; tidak ada hardcode host/token.
  - Menghapus import tidak terpakai di file TODO (datasource/mapper/app.dart) + var `theme` tak terpakai demi `flutter analyze` bersih; menambah catatan import yang perlu ditambahkan saat implementasi.
- **Open:**
  - Pin versi Flutter/Dart + dependency setelah `flutter --version` mesin kelas diketahui (planning §11).
  - Jalankan `flutter pub get && flutter analyze && flutter test` pada p04-sqlite & p05-api di mesin target; perbaiki warning const-hint bila ada.
  - Konfirmasi endpoint/auth P05 dari dosen; bila tersedia, uji mode `--dart-define=API_BASE_URL=...` end-to-end.
  - Pertemuan P04/P05: materi/modul (`02-Materi/P0x-...md`, `03-Modul-Kelas/`) belum diproduksi (task terpisah) — starter ini jadi rujukan saat produksi materi.
  - Pertimbangan cross-platform: `sqflite` tidak jalan di web → demo P04 target Android/desktop; sudah didokumentasikan.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed P04/P05 data layers, API contract, mock fallback, and configuration. Fixed API token table, P04 web instruction, PATCH documentation, and async Future assertions. Static gate passed; target-machine Flutter runtime remains pending.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi for implementation.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: scaffolded p04-sqlite + p05-api + API-CONTRACT.md + .env.example; updated 06-Starter-Code/README.md. Static checks (verification cmd, secret scan, brace balance, git diff --check) PASS; runtime pub/analyze/test ditangguhkan (no SDK). Moved doing → review.
