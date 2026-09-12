---
id: task-006
title: "Tulis Tugas 1 dan rubrik Core Task Tracker"
status: done
priority: 85
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [assignment, assessment, tugas-1]
---

# Tulis Tugas 1 dan rubrik Core Task Tracker

## Goal
Membuat penugasan pertama yang mengukur Dart, UI, navigation, Provider, CRUD, search/filter, dan responsiveness.

## Context
Tugas 1 berbobot 35% dan harus mampu membedakan mahasiswa yang memahami kode dari copy-paste.
## Scope
- **Included**:
- Buat `04-Penugasan/Tugas-01-Task-Tracker-Core.md` dan `04-Penugasan/Rubrik-Tugas-01.md`.
- Buat `04-Penugasan/Template-Submission-README.md` bila belum ada.
- Cantumkan requirement, non-goal, deliverable, aturan AI, command verifikasi, deadline placeholder, rubric 100.
- **Excluded**:
- SQLite/API/device/test/release sebagai requirement wajib Tugas 1.

## Acceptance Criteria
- [ ] Rubrik mengukur functionality, state/data flow, UI/responsive, code quality, penjelasan/AI log.
- [ ] Ada bukti screenshot portrait+landscape dan video singkat.
- [ ] Requirement Tugas 1 konsisten dengan P01–P03.

## Verification Commands
```bash
test -f 04-Penugasan/Tugas-01-Task-Tracker-Core.md && test -f 04-Penugasan/Rubrik-Tugas-01.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed brief, rubric, and README template. Verified five assessment dimensions, visual/video gates, P01-P03 scope, and T1 non-goals. Clarified fair scoring for students who did not use AI.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi for implementation.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: wrote Tugas 1 brief, rubrik 100, submission template. Moved to review.

## Pi Handoff
- Changed:
  - `04-Penugasan/Tugas-01-Task-Tracker-Core.md` (NEW) — brief: goal, starting point (starter P03), 7-area requirement, non-goal, deliverable, AI policy P1–P3, verification commands, 100-pt rubrik ref, deadline placeholder, tips, references.
  - `04-Penugasan/Rubrik-Tugas-01.md` (NEW) — 5 dimensi total 100: A Fungsionalitas (25), B State & data flow (25), C UI & responsive (20), D Kualitas kode & tooling (15), E Penjelasan & AI log (15). Skala 0–4, indikator gate ✔, lembar skor, red flags, konversi area RPS.
  - `04-Penugasan/Template-Submission-README.md` (NEW) — template reusable Tugas 1/2/3: ringkasan, cara run, checklist fitur per tugas, arsitektur, bukti analyze/test, bukti visual (screenshot portrait+landscape + video), AI log, known limitation, pre-submit checklist.
- Tests: verification command `test -f 04-Penugasan/Tugas-01-Task-Tracker-Core.md && test -f 04-Penugasan/Rubrik-Tugas-01.md` PASS. Tidak ada test runner (artefak dokumen). Konsistensi silang diperiksa manual vs P01–P03 starter, Peta-Capaian, Rubrik-Remedial, Runbook-Dosen, Template-AI-Interaction-Log.
- Decisions:
  - Rubrik dibagi 5 dimensi sesuai permintaan AC (functionality, state/data flow, UI/responsive, code quality, explanation/AI log), bukan 9 baris datar Rubrik-Remedial; semua 9 indikator Rubrik-Remedial §2 terpetakan ke dimensi A–E.
  - Tugas 1 menambah syarat wajib baru vs starter P03: validasi due date tidak lampau (mode add) + filter priority — konsisten dengan challenge Level 2/3 P03 dan Rubrik-Remedial.
  - Bukti visual (screenshot portrait+landscape + video 3–5 menit) dibuat gate untuk dimensi C2/C3, langsung memenuhi AC "bukti screenshot portrait+landscape dan video singkat".
  - Non-goal eksplisit: SQLite/API/device/test/release dilarang jadi requirement Tugas 1 (sesuai scope task).
  - Deadline dibiarkan placeholder `[diisi dosen]` sesuai status planning (§11 keputusan terbuka).
- Open:
  - Versi Flutter/Dart belum dipin (keputusan dosen §11); brief memakai constraint starter `sdk ^3.4.0 / flutter >=3.22.0`.
  - Format submission final (ZIP vs repo) menunggu keputusan dosen.
  - Starter P03 sudah ada; bila starter berubah, brief/rubrik perlu recheck alignment (model Task, AppStrings).
