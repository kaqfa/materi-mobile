---
id: task-005
title: "Tulis materi dan modul kelas P02–P03"
status: done
priority: 85
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [material, module, p02, p03]
---

# Tulis materi dan modul kelas P02–P03

## Goal
Menghasilkan paket widget/navigation lalu form/Provider CRUD yang membangun Tugas 1.

## Context
P02 dan P03 harus tersambung progressive dari starter P02 menuju P03; gunakan Material 3 dan response state.
## Scope
- **Included**:
- Buat empat file materi/modul untuk P02 dan P03.
- P02: widget tree, reusable TaskCard, layout, navigation, responsive dasar.
- P03: form validation, controller lifecycle, Provider, CRUD, loading/error/empty state.
- Tambahkan challenge bertingkat dan troubleshooting untuk overflow, dispose controller, `notifyListeners`, context misuse.
- **Excluded**:
- Tugas 1 final dan starter code P04+.

## Acceptance Criteria
- [x] Masing-masing materi mempunyai maksimal 3 checkpoint <60 menit.
- [x] Modul P03 menyisakan waktu untuk memulai Tugas 1.
- [x] Path starter dan acceptance tiap checkpoint selaras.

## Verification Commands
```bash
test -f 02-Materi/P02-Widget-Layout-Navigation.md && test -f 03-Modul-Kelas/Modul-P03-Form-CRUD-Provider.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed all P02/P03 materials/modules. Fixed guided-lab timing, P02 two-column grid contract/source alignment, status examples, scope/challenge conflict, and rotation instruction. Final static audit passed.
- 2026-08-08 Prisa: moved to doing. Retry delegated to Pi after previous context-only exit.
- 2026-08-08 Prisa: moved back to todo. Pi exited during context reading; no teaching artifacts were written.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi for implementation.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: wrote 4 artefacts (P02 materi+modul, P03 materi+modul). Verified paths, checkpoint counts, troubleshooting topics, challenge levels. Moved to review.

## Pi Handoff
- Changed:
  - `02-Materi/P02-Widget-Layout-Navigation.md` (new) — 3 checkpoint (20/35/15 min), widget tree/TaskCard/navigation/responsive, troubleshooting overflow + context-misuse(mounted), challenge 3 level.
  - `03-Modul-Kelas/Modul-P02-Widget-Layout-Navigation.md` (new) — rundown 150 min, live demo, guided lab, praktik+observasi, challenge, exit ticket, catatan dosen.
  - `02-Materi/P03-Form-CRUD-Provider.md` (new) — 3 checkpoint (20/40/15 min), Provider wiring/CRUD/form validation, troubleshooting dispose controller + notifyListeners + context misuse, challenge 3 level, Tugas 1 kickoff.
  - `03-Modul-Kelas/Modul-P03-Form-CRUD-Provider.md` (new) — rundown 150 min dengan BAGIAN 5 khusus pembukaan Tugas 1 (menyisakan waktu memulai), demo, guided lab, observasi, challenge, catatan dosen.
- Tests:
  - Verification command `test -f 02-Materi/P02-Widget-Layout-Navigation.md && test -f 03-Modul-Kelas/Modul-P03-Form-CRUD-Provider.md` → PASS.
  - Grep: kedua materi masing-masing tepat 3 checkpoint, max 40 min (<60). Semua 4 file punya challenge Level 1/2/3. Topic troubleshooting terdistribusi sesuai relevansi (overflow→P02, dispose/notifyListeners/context-misuse→P03).
  - Runtime test (`flutter pub get/analyze/test`) TIDAK dijalankan: host tidak punya Flutter SDK (lihat `06-Starter-Code/README.md` "Status verifikasi host"). Materi hanya dokumen; tidak mengubah kode starter.
- Decisions:
  - Format & gaya mengikuti P01 (materi/modul yang sudah ada) + `Standar Tutorial Koding PPB.md` (Progressive Checkpoint Pattern), bukan template generik `Standar Pengembangan Materi PPB.md`.
  - P02 modul: blok 5 = challenge reveal + exit (tugas belum dibuka, konsisten P01). P03 modul: blok 5 dialokasikan untuk **pembukaan Tugas 1** (memenuhi acceptance "menyisakan waktu memulai Tugas 1").
  - Tidak mengubah kode starter `06-Starter-Code/p0X-*/` maupun sumber reguler parent folder — hanya menulis dokumen ajar. Semua path merujuk file starter aktual (task_card.dart, task_list_screen.dart, task_detail_screen.dart, add_task_screen.dart untuk P02; task_provider.dart, task_form_screen.dart, task_list_screen.dart untuk P03).
  - Acceptance criteria 3/3 dicentang.
- Open:
  - Validasi runtime materi (jalankan starter, ikuti checkpoint di mesin Flutter) ditangguhkan sampai SDK tersedia — bukti verifikasi host sudah dicatat di tiap README starter.
  - `04-Penugasan/Tugas-01-Task-Tracker-Core.md` + `Rubrik-Tugas-01.md` + `Template-Submission-README.md` dirujuk P03; dosen pastikan ketiganya sudah ada sebelum blok 5 kelas (bila belum ada, task produksi tugas terpisah).
