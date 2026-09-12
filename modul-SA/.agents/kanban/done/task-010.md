---
id: task-010
title: "Tulis Tugas 2 dan rubrik Persistence/API"
status: done
priority: 80
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [assignment, assessment, tugas-2]
---

# Tulis Tugas 2 dan rubrik Persistence/API

## Goal
Membuat tugas kedua untuk SQLite, REST, serialization, error state, dan offline-first sederhana.

## Context
Tugas 2 berbobot 35%; dependency utama P04/P05. Harus dapat dinilai pada mock fallback.
## Scope
- **Included**:
- Buat `04-Penugasan/Tugas-02-Persistence-dan-API.md` dan `04-Penugasan/Rubrik-Tugas-02.md`.
- Sertakan demonstrasi restart, loading, empty, 4xx/5xx/network error, local action saat offline.
- Tulis dua jalur submission: endpoint dosen atau fixture/mock fallback.
- **Excluded**:
- Auth kompleks, sync conflict, background job.

## Acceptance Criteria
- [ ] Rubrik 100 mengukur local persistence, mapper/API, error UX, architecture/code quality, evidence/penjelasan.
- [ ] Tidak mewajibkan server pribadi/akun berbayar.
- [ ] Requirement mengacu starter P04/P05 dan materi.

## Verification Commands
```bash
test -f 04-Penugasan/Tugas-02-Persistence-dan-API.md && test -f 04-Penugasan/Rubrik-Tugas-02.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed Tugas 2 brief/rubric. Fixed P04+P05 target platform (Android-only), 5xx evidence for mock limitation, and fair AI scoring for students without AI. Final structure, 100-point rubric, starter references, fence balance, and diff checks passed.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi after P05 review/commit.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: wrote `04-Penugasan/Tugas-02-Persistence-dan-API.md` + `04-Penugasan/Rubrik-Tugas-02.md`; moved doing→review.

## Pi Handoff
- Changed:
  - `04-Penugasan/Tugas-02-Persistence-dan-API.md` (new) — brief Tugas 2: starting point (merge Tugas 1 + starter p04/p05), 6 grup requirement (persistence, serialization, REST, error UX, mode offline, arch/quality), non-goal, deliverable, aturan AI P4–P5, command verifikasi, rubrik bobot, deadline placeholder, tips, sumber.
  - `04-Penugasan/Rubrik-Tugas-02.md` (new) — 5 dimensi total 100: Local Persistence 25, Serialization & API 25, Error UX & offline 20, Architecture & code quality 15, Evidence & penjelasan 15. Gate ✔ bertanda; gate E1/E2/E3 memaksa A+B=0 bila gagal (sesuai Rubrik-Remedial §6).
- Tests: `test -f 04-Penugasan/Tugas-02-Persistence-dan-API.md && test -f 04-Penugasan/Rubrik-Tugas-02.md` → PASS. Bobot 25+25+20+15+15=100 terverifikasi. Semua 14 path referensi (materi P04/P05, starter, API-CONTRACT, .env.example, template, planning, standar) eksis. Secret scan bersih (hanya placeholder `your-server.example.com`, konsisten dgn API-CONTRACT.md).
- Decisions:
  - Rubrik 5 dimensi dipetakan persis ke acceptance criteria (local persistence / mapper-API / error UX / arch-code quality / evidence-penjelasan).
  - Mode mock = jalur default; semua gate dinilai tanpa server pribadi/akun berbayar. Endpoint dosen via `--dart-define` = jalur tambahan.
  - 5xx: diterima via flag demo-only `simulateServerError` (dokumentasi README) ATAU bukti `api_error_test.dart` mapping 503→ServerError (konsisten dgn batas starter P05 yang tidak menyimulasikan 5xx native).
  - Integrasi arsitektur: repository koordinator `OfflineFirstTaskRepository` (lokal source of truth + remote best-effort), indikator offline boolean sederhana — sync conflict & background job dikecualikan (Non-goal §4).
- Open: runtime Flutter/Dart SDK tidak tersedia di host — verifikasi build/test ditangguhkan ke mesin target (sama sbb task-008/009). Tugas 3 + Rubrik-Tugas-03 belum dibuat (task terpisah).
