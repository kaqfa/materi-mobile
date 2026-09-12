---
id: task-012
title: "Tulis Tugas 3, bank live coding, dan QA paket lengkap"
status: done
priority: 75
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [assignment, assessment, qa, release]
---

# Tulis Tugas 3, bank live coding, dan QA paket lengkap

## Goal
Menyelesaikan assessment final dan menjalankan audit konsistensi seluruh paket.

## Context
Tugas 3 berbobot 30% serta final P07. Bank soal menilai pemahaman individual melalui perubahan kecil setara.
## Scope
- **Included**:
- Buat Tugas 3 dan rubriknya.
- Buat `05-Assessment/Bank-Live-Coding.md` dan `05-Assessment/Rubrik-Demo-dan-Wawancara.md`.
- Audit seluruh link/path/nama aplikasi, 7 materi, 7 modul, 3 tugas, starter directory, rubrik, AI policy.
- Tulis bukti QA di `00-Planning/QA-Checklist-Paket.md`.
- **Excluded**:
- Menjalankan build pada semua target bila toolchain belum tersedia; catat blocker, jangan memalsukan hasil.

## Acceptance Criteria
- [x] Bank memiliki minimal 10 variasi live modification dengan criteria dan kunci singkat.
- [x] Tiga tugas dan semua bobot total 100 serta konsisten terhadap rubrik utama.
- [x] QA checklist mencatat verified vs blocked dengan command nyata.

## Verification Commands
```bash
test -f 04-Penugasan/Tugas-03-QA-Release-dan-Demo.md && test -f 05-Assessment/Bank-Live-Coding.md && test -f 00-Planning/QA-Checklist-Paket.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed final assessment and full-package QA. Fixed device-permission requirement to match starter, fair no-AI scoring in demo rubric, and two live-coding answer keys (deterministic sorting/date boundary). Final artifact, rubric, bank, QA, fence, and diff audits passed.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi after P06/P07 review/commit.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: wrote Tugas-03 brief + Rubrik-Tugas-03, Bank-Live-Coding (12 variasi), Rubrik-Demo-dan-Wawancara, QA-Checklist-Paket (static verified / toolchain blocked). Moved to review.

## Pi Handoff
- **Changed:**
  - `04-Penugasan/Tugas-03-QA-Release-dan-Demo.md` (baru) — brief Tugas 3 (beban 30%, final P07): device feature, testing gate (≥3 unit + ≥2 widget), release APK, README final, demo + live mod.
  - `04-Penugasan/Rubrik-Tugas-03.md` (baru) — 5 dimensi total 100 (A20/B25/C25/D15/E15), gate ✔, bukti visual, no-secret.
  - `05-Assessment/Bank-Live-Coding.md` (baru) — 12 variasi setara (≥10) di 6 kategori (sorting/filter/search/tanggal/empty/mapper/immutability); tiap soal: prompt + 3–5 kriteria sukses + kunci singkat (🔒 dosen) + referensi materi + durasi/kesulitan.
  - `05-Assessment/Rubrik-Demo-dan-Wawancara.md` (baru) — demo 7–10' + live mod 20–25' + Q&A; 5 dimensi total 100 (A15/B20/C35/D15/E15); gate C2/C4/C6 membatalkan poin bila live mod gagal.
  - `00-Planning/QA-Checklist-Paket.md` (baru) — audit seluruh paket: verified vs blocked dengan command nyata.
- **Tests:**
  - Verification command task: `test -f Tugas-03 ... && test -f Bank-Live-Coding ... && test -f QA-Checklist ...` → **PASS**.
  - Static audit: 7 materi/7 modul/3 tugas/3 rubrik/starter p01–p07/assessment/AI policy → ✅ verified.
  - Bobot: beban 35+35+30=100; area RPS 30/25/20/25=100; Rubrik-03 & Demo total 100 → ✅ verified.
  - link-lint 4 artefak baru → no BROKEN.
  - bank soal = 12 (≥10).
  - no-secret: tidak ada signing material ter-lacak; `.gitignore` p07 cover 5 pattern.
  - **Blocked:** `flutter analyze`/`test`/`build apk` starter — toolchain Flutter/Dart tidak terpasang di mesin audit (tidak dipalsukan; eskalasi ke mesin target).
- **Decisions:**
  - Demo + live modification dinilai terpisah di `Rubrik-Demo-dan-Wawancara.md` (bukan di Rubrik-Tugas-03) agar tidak dobel-penilaian; keduanya berkontribusi ke Sub-CPMK 53.1 + 92.2 sesuai Peta §3/§6.
  - Release tidak mewajibkan Play Store/signing key (sesuai planning §2); debug-sign/unsigned + install manual cukup.
  - Kunci soal bank ditandai 🔒 dosen-only (mengikuti konvensi `Kunci-Diagnostik.md`); tidak dibagikan ke kanal mahasiswa.
  - Rubrik-03 dimensi: Device 20 / Testing 25 / Release&Tooling 25 (mencerminkan fokus Tugas 3 = 92.2 utama + 53.2 APK).
- **Open:**
  - Gate build/lint/test starter (`flutter analyze`/`test`/`build apk`) menunggu toolchain Flutter/Dart di mesin target — jalankan sebelum distribusi, catat hasil di `QA-Checklist-Paket.md` §7.
  - Dependency pin menunggu `flutter --version` mesin kelas (planning §11).
  - Minor non-blocking: 15 starter README belum menyebut nama anchor "Remedial Task Tracker" (tidak ada nama bertentangan, hanya ketiadaan) — tambah di siklus QA berikutnya.
