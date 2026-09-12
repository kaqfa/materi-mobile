---
id: task-001
title: "Bangun fondasi paket dan instrumen asesmen"
status: done
priority: 95
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [planning, assessment, foundation]
reviewed_at: 2026-08-08
---

# Bangun fondasi paket dan instrumen asesmen

## Goal
Materialkan pedoman mahasiswa/dosen, peta capaian, rubrik utama, checklist environment, policy AI, dan template AI log.

## Context
Plan kanonik menentukan struktur dan kontrak pembelajaran. Ini prerequisite semua artefak lain.
## Scope
- **Included**:
- Buat `00-Planning/Peta-Capaian-dan-Assessment.md`, `00-Planning/Rubrik-Remedial.md`, `01-Orientasi/Panduan-Mahasiswa.md`, `01-Orientasi/Checklist-Environment.md`, `01-Orientasi/Template-AI-Interaction-Log.md`, dan `00-Planning/Runbook-Dosen.md`.
- Peta mencantumkan alignment Sub-CPMK dan bobot 30/25/20/25.
- Rubrik memberi indikator observable untuk tiga tugas dan demo.
- **Excluded**:
- Menulis materi pertemuan, starter Flutter, atau tugas lengkap.

## Acceptance Criteria
- [ ] Semua file ada dan saling konsisten pada nama aplikasi, 7 sesi, dan 3 tugas.
- [ ] Checklist menjalankan `flutter doctor`, `flutter pub get`, `flutter analyze`, `flutter test`, emulator/device.
- [ ] Policy AI mencantumkan log dan verifikasi pemahaman.

## Verification Commands
```bash
test -f 00-Planning/Peta-Capaian-dan-Assessment.md && test -f 00-Planning/Rubrik-Remedial.md && test -f 01-Orientasi/Checklist-Environment.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed six artifacts; structure/content checks and `git diff --check` passed. Corrected three editorial typos.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi for implementation.
- 2026-08-08 Pi: built all 6 foundation artifacts; ran verification command (PASS); moved to review.

## Pi Handoff
- **Changed:**
  - `00-Planning/Peta-Capaian-dan-Assessment.md` (baru) — kontrak konstan, alignment RPS bobot 30/25/20/25, peta 7 sesi, peta 3 tugas, matriks rekonsiliasi tugas→area RPS, quality gate, verifikasi pemahaman.
  - `00-Planning/Rubrik-Remedial.md` (baru) — skala 0–4, indikator observable Tugas 1/2/3 + demo, gate, konversi nilai + aturan remidi-maks.
  - `00-Planning/Runbook-Dosen.md` (baru) — sebelum-P01, format 150', rundown P01–P07, kadens tugas, quality gate, penegakan AI, backend/mock fallback, live modification, keputusan dosen.
  - `01-Orientasi/Panduan-Mahasiswa.md` (baru) — tujuan, kompetensi wajib, 7 sesi, 3 tugas, policy AI bertingkat, alur kerja mingguan, definisi selesai.
  - `01-Orientasi/Checklist-Environment.md` (baru) — instalasi, `flutter doctor`, `flutter pub get`, `flutter analyze`, `flutter test`, emulator/device, device-feature Tugas 3, troubleshooting, sign-off.
  - `01-Orientasi/Template-AI-Interaction-Log.md` (baru) — template per-interaksi (purpose/prompt/ringkasan/dipilih/ditolak) + **Verifikasi pemahaman WAJIB** + refleksi + checklist kepatuhan.
- **Tests:** verification command `test -f ...` → PASS (3 core files); semua 6 file ada; nama aplikasi `Remedial Task Tracker` + 7 sesi + 3 tugas konsisten lintas 6 file; checklist mencakup 4 command `flutter` + emulator/device; AI policy mencantumkan log + verifikasi pemahaman.
- **Decisions:**
  - Bobot final nilai = empat area RPS 30/25/20/25; label 35/35/30 tugas = beban/luas lingkup, bukan bobot final — direkonsiliasi via matriks tugas→area.
  - Rubrik skor mentah 0–100; konversi remidi-maksimum delegasi ke prodi/dosen (sesuai rencana §11).
  - Backend P5 default = mock/fixture bila tanpa server stabil.
  - Artefak (diagnosis, starter code, materi/modul, bank live coding) sengaja tidak dibuat di task ini — milik task kanban lain (task-002 dst).
- **Open:**
  - Flutter/Dart version kelas belum di-pin (tunggu verifikasi mesin target) — placeholder di Checklist + Runbook.
  - Endpoint P5/mock fixture konkret akan dibuat saat task starter/data-layer.
  - Kebijakan nilai remidi-maks prodi belum final.
