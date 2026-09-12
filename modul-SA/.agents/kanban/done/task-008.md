---
id: task-008
title: "Tulis materi dan modul kelas P04 SQLite"
status: done
priority: 80
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [material, module, p04, sqlite]
---

# Tulis materi dan modul kelas P04 SQLite

## Goal
Menghasilkan paket SQLite/offline-first dasar untuk data Task yang persistent.

## Context
Gunakan tutorial P08 sebagai basis, dipersempit ke schema, CRUD, mapper, repository, restart persistence.
## Scope
- **Included**:
- Buat materi dan modul P04.
- Checkpoint: schema/database helper; datasource/repository; Provider load/save dan demo restart.
- Bahas migration secara konsep dan contoh kecil; tidak perlu advanced migration.
- **Excluded**:
- REST/API dan sync conflict.

## Acceptance Criteria
- [ ] Materi punya langkah verifikasi persistence sesudah restart.
- [ ] Modul punya live demo, practice, individual challenge, troubleshooting database path/map boolean/date.
- [ ] Mengacu starter P04.

## Verification Commands
```bash
test -f 02-Materi/P04-SQLite-Offline-First.md && test -f 03-Modul-Kelas/Modul-P04-SQLite-Offline-First.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed P04 material/module against starter and tests. Fixed P04/P05 provider import paths and P04 guided-lab timing. Verified schema ISO date, persistence-restart gate, three troubleshooting traps, and Tugas 1 gate.
- 2026-08-08 Prisa: moved to doing. Retry delegated after prior context-only exit.
- 2026-08-08 Prisa: moved back to todo. Pi exited during context reading; no P04 teaching artifacts were written.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi for implementation.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: wrote `02-Materi/P04-SQLite-Offline-First.md` (3 checkpoint: schema/database helper, mapper, datasource/repository/provider + restart persistence; konsep migration; troubleshooting path/boolean/date) and `03-Modul-Kelas/Modul-P04-SQLite-Offline-First.md` (rundown 150', live demo, praktik mandiri, challenge 3 level, gate Tugas 1). Moved to review.

## Pi Handoff
- **Changed:**
  - `02-Materi/P04-SQLite-Offline-First.md` (new, 731 baris)
  - `03-Modul-Kelas/Modul-P04-SQLite-Offline-First.md` (new, 256 baris)
  - `.pi-status/task-008.json` (in_progress -> completed)
- **Tests:** Verification commands lulus (`test -f` kedua file PASS). Runtime `flutter test/analyze` TIDAK dijalankan — host tanpa Flutter SDK (lihat `06-Starter-Code/p04-sqlite/README.md` bagian "Status verifikasi host"); ditangguhkan sampai SDK tersedia di mesin target kelas. Kode mapper/datasource/provider dalam materi diverifikasi manual terhadap starter `06-Starter-Code/p04-sqlite/` (skema `TaskSchema`, test expectation `task_mapper_test.dart`/`local_task_datasource_test.dart`, signature metode).
- **Decisions:**
  - Sumber kebenaran kode = starter P04 (bukan tutorial P08 outline). Perbedaan kunci: starter P04 simpan `due_date` sebagai **ISO-8601 string** (P08 memakai millis int). Materi konsisten dengan starter & test P04.
  - 3 checkpoint mengikuti README starter P04: (1) schema/database helper, (2) mapper, (3) datasource+repository+provider. Mapper dipisah sebelum datasource karena datasource bergantung mapper (README eksplisit: "Mapper dulu, baru datasource").
  - Konsep migration dibahas di akhir CP1 + bagian khusus (contoh `onUpgrade` v2 kecil) — sesuai scope "konsep + contoh kecil, bukan advanced".
  - Tiga jebakan (database path / boolean 0-1 vs string / date ISO vs millis) dijadikan troubleshooting wajib di materi DAN modul (sesuai acceptance criteria modul).
  - Tugas 1 = gate di blok 1 modul P04 (tenggat "sebelum P04" per `Runbook-Dosen.md`). Tugas 2 baru dibuka di P05, bukan hari ini — modul tidak membuka tugas baru.
- **Open / Risks:**
  - Host tanpa Flutter SDK: `flutter test`/`flutter analyze` belum dijalankan. Saat SDK tersedia, jalankan `flutter test` di `06-Starter-Code/p04-sqlite/` dan verifikasi snippet kode di materi match hasil hijau. Bila ada mismatch (mis. tipe `num` vs `int` dari driver sqflite tertentu), sesuaikan cast di materi CP2 (`as int` vs `(as num).toInt()`).
  - Tanggal ISO UTC vs local: materi menyarankan uji dengan `DateTime.utc(...)` (sesuai test starter). Saat integrasi P05 (JSON API), timezone mungkin perlu normalisasi terpisah.
