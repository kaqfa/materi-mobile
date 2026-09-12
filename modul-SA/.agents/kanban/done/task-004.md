---
id: task-004
title: "Tulis materi dan modul kelas P01"
status: done
priority: 85
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [material, module, p01]
---

# Tulis materi dan modul kelas P01

## Goal
Menghasilkan handout dan modul pengajar untuk diagnosis, Dart, dan debugging.

## Context
Sesi P01 memulihkan model Task, collection, null safety, async/error, dan debugging terarah.
## Scope
- **Included**:
- Buat `02-Materi/P01-Diagnosis-Dart-Debugging.md` dan `03-Modul-Kelas/Modul-P01-Diagnosis-Dart-Debugging.md`.
- Materi 2–3 checkpoint: environment+diagnosis, model/collection, bug fixing.
- Modul memiliki rundown 150 menit, live demo, practice mandiri, challenge 3 level, exit ticket, notes dosen.
- **Excluded**:
- Membuat diagnosis artifact yang sudah ditangani task-002.

## Acceptance Criteria
- [ ] Header, prerequisites, goals, outcome, checkpoint validation, summary, troubleshooting tersedia.
- [ ] Seluruh instruksi merujuk starter P01 dengan path benar.
- [ ] Challenge individual dapat dinilai dengan lembar observasi.

## Verification Commands
```bash
test -f 02-Materi/P01-Diagnosis-Dart-Debugging.md && test -f 03-Modul-Kelas/Modul-P01-Diagnosis-Dart-Debugging.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed P01 handout/module; checkpoint, timing, references, assessment, and AI policy checks passed. Clarified intentional-red-test baseline and corrected editorial typo.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi for implementation.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: wrote `02-Materi/P01-Diagnosis-Dart-Debugging.md` (3 checkpoint: environment+diagnosis, model+koleksi, bug fixing R1–R4) and `03-Modul-Kelas/Modul-P01-Diagnosis-Dart-Debugging.md` (rundown 150', live demo, practice mandiri, challenge 3 level, exit ticket, notes dosen). Moved to review.

## Pi Handoff
- Changed:
  - `02-Materi/P01-Diagnosis-Dart-Debugging.md` (new) — materi self-study.
  - `03-Modul-Kelas/Modul-P01-Diagnosis-Dart-Debugging.md` (new) — modul kelas.
  - frontmatter + Activity Log task ini (status doing→review).
- Tests:
  - Verification command `test -f ... && test -f ...`: PASS (kedua file ada).
  - Acceptance grep: Tujuan/Prasyarat/Outcome/3 Checkpoint/Checkpoint Validation×3/Summary/Troubleshooting semua hadir.
  - Path merujuk starter `06-Starter-Code/p01-diagnosis/` (3× materi, 3× modul).
  - Challenge 3 level + 7 rujukan `Lembar-Observasi.md` (dapat dinilai via lembar observasi).
  - Rundown 150' + exit ticket + practice mandiri + live demo + notes dosen semua hadir.
  - Host tidak punya Flutter/Dart SDK → `flutter analyze/test/run` tidak dijalankan di sini (sesuai caveat task-002/003); verifikasi runtime ditangguhkan ke mesin kelas target. Snippet/petunjuk dalam materi sudah konsisten dengan starter (`sdk: ^3.4.0`, `flutter: ">=3.22.0"`).
- Decisions:
  - 3 checkpoint mengikuti scope task (environment+diagnosis / model+koleksi / bug fixing), sejajar dengan starter README (CP1 env+model, CP2 filter/search) tapi dipecah agar model+koleksi dapat gate terpisah.
  - Tidak membocorkan jawaban verbatim `task_filter.dart` di materi (petunjuk `toLowerCase().contains` + operator sesuai, bukan diff penuh); diagnosis spirit dijaga. Solusi lengkap tetap di `solution-reference/` (dosen).
  - PR P01 bersifat refleksi + penguatan; Tugas 1 belum dibuka (sesuai kadens: dibuka setelah P03).
- Open:
  - Flutter/Dart SDK versi kelas belum dipin di mesin target — catat di compatibility matrix saat diverifikasi.
  - Backend P5 & jalur submission = keputusan dosen (di luar task ini).
  - Verifikasi runtime `flutter test` pada starter bugged di mesin kelas perlu dikonfirmasi saat sesi.
