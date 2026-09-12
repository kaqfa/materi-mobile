---
id: task-002
title: "Buat tes diagnosis konsep dan praktik"
status: done
priority: 90
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [assessment, diagnostic, p01]
---

# Buat tes diagnosis konsep dan praktik

## Goal
Menyediakan pretest untuk pemetaan kemampuan sebelum sesi pertama.

## Context
Diagnosis harus menguji konsep dan kemampuan mengubah kode, bukan hafalan saja. Referensi UTS filter/search dan RPS.
## Scope
- **Included**:
- Buat `01-Orientasi/Tes-Diagnostik-Konsep.md`, `01-Orientasi/Tes-Diagnostik-Praktik.md`, `05-Assessment/Kunci-Diagnostik.md`, `05-Assessment/Lembar-Observasi.md`.
- Praktik memakai perubahan filter/search Task Tracker yang dapat selesai 30–45 menit.
- Kunci membagi hasil ke Merah/Kuning/Hijau dan action dosen.
- **Excluded**:
- Starter Flutter produksi penuh atau materi P02–P07.

## Acceptance Criteria
- [x] Tes konsep memuat Dart, widget/state, async/error, data/API/testing.
- [x] Tes praktik punya requirement, batasan, rubrik 100, expected behavior, dan langkah verifikasi.
- [x] Kunci tidak dibagikan ke mahasiswa.

## Verification Commands
```bash
test -f 01-Orientasi/Tes-Diagnostik-Konsep.md && test -f 01-Orientasi/Tes-Diagnostik-Praktik.md && test -f 05-Assessment/Kunci-Diagnostik.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed all four diagnosis artifacts; content/requirement checks passed. Corrected enum sort, async-order, constructor-key, and editorial defects. Host Dart SDK unavailable; runtime test deferred to starter-code task.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi for implementation.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: produced 4 artefak diagnosis (konsep, praktik, kunci, observasi); moved to review.

## Pi Handoff
- Changed:
  - `01-Orientasi/Tes-Diagnostik-Konsep.md` (baru) — 25 soal lintas 5 area (Dart, widget/state, async/error, data/API, testing); campuran MCQ + trace + perbaikan kode; anti-AI.
  - `01-Orientasi/Tes-Diagnostik-Praktik.md` (baru) — perbaikan filter+search Task Tracker bugged, 30–45 menit; memuat setup, gejala bug, requirement R1–R4, batasan, rubrik 100, expected behavior, dan langkah verifikasi.
  - `05-Assessment/Kunci-Diagnostik.md` (baru, DOSEN-ONLY) — kunci konsep, rubrik praktik, pita Merah/Kuning/Hijau per area + keseluruhan, action dosen per pita, variasi setara.
  - `05-Assessment/Lembar-Observasi.md` (baru) — sheet observasi blok praktik individual + rekap kelas; reusable lintas sesi.
- Tests:
  - Verification command task lulus: `test -f` ketiga file konsep/praktik/kunci = PASS.
  - Lembar observasi terverifikasi ada.
  - Cakupan 5 area konsep + 6 baris rubrik praktik + expected behavior + langkah verifikasi lengkap (grep konfirmasi).
- Decisions:
  - Praktik distel ke 30–45 menit: hanya filter + search (variasi ringan dari UTS UJIAN_01/02), tanpa sort/toggle/counter yang ada di UTS penuh.
  - Model `Task` mengikuti kontrak starter (enum `TaskStatus{pending,overdue,completed}`, `TaskPriority`, `isCompleted`, `dueDate`) agar konsisten dengan UTS dan Rencana-Modul.
  - Pita Merah/Kuning/Hijau didefinisikan per area DAN keseluruhan supaya action dosen presisi (bukan satu label kasar).
  - Kunci eksplisit ditandai tidak untuk mahasiswa + petunjuk penyimpanan repo privat.
  - Pelanggaran AI/contek tidak membatalkan keikutsertaan; menurunkan pita satu tingkat + bimbingan policy.
- Open:
  - Penyesuaian kunci 1.2/4.3/5.2 bila starter P01 memakai enum/field berbeda (dicatat di Kunci bagian 7).
  - Validasi starter P01 bugged belum ada (di luar scope task-002; starter code tugas kanban terpisah).
  - Kebijakan nilai maksimum remidi (konversi final) tetap input dosen/prodi sesuai Rubrik-Remedial bagian 6.
