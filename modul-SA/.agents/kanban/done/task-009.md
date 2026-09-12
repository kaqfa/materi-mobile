---
id: task-009
title: "Tulis materi dan modul kelas P05 REST API dan error handling"
status: done
priority: 80
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [material, module, p05, api]
---

# Tulis materi dan modul kelas P05 REST API dan error handling

## Goal
Menghasilkan paket REST API yang fokus GET/write, JSON mapper, status/error UI, serta fallback mock.

## Context
Endpoint nyata belum ditetapkan. Paket harus tuntas memakai fixture/mock; endpoint nyata hanya konfigurasi opsional saat pelaksanaan.

## Scope
- **Included**:
- Buat materi dan modul P05.
- Checkpoint: inspect API contract/Postman atau fixture; remote datasource+mapper; repository/provider error and retry manual.
- Masukkan 401/404/500/network error sebagai skenario eksplisit.
- **Excluded**:
- Supabase signup, JWT refresh, realtime sync, conflict resolution.

## Acceptance Criteria
- [ ] Tidak ada secret, akun, atau URL produksi tertulis.
- [ ] Semua checkpoint punya fallback mock path.
- [ ] Modul mengalokasikan waktu mengerjakan/submit Tugas 2.

## Verification Commands
```bash
test -f 02-Materi/P05-REST-API-Error-Handling.md && test -f 03-Modul-Kelas/Modul-P05-REST-API-Error-Handling.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Pi Handoff
- **Changed:**
  - `02-Materi/P05-REST-API-Error-Handling.md` (baru, 764 baris) — materi self-study: kontrak REST, `sealed ApiError` + `mapResponseToError`, `Task.toJson`/`fromJson`, mock/fixture fallback, wiring provider CRUD + state UI lengkap (loading/success/empty/401/404/500/network) + retry manual. 3 checkpoint (CP1 error type, CP2 mock path, CP3 provider CRUD) — tiap checkpoint punya blok "Fallback mock path" eksplisit.
  - `03-Modul-Kelas/Modul-P05-REST-API-Error-Handling.md` (baru, 274 baris) — panduan kelas 150 menit: rundown dengan **gate/alokasi Tugas 2** (blok 1 brief, praktik mulai, blok 6 kirim/kerja + tenggat sebelum P06), live demo, guided lab 3 checkpoint, praktik individual, challenge 3 level, catatan dosen.
- **Tests:** verification command `test -f 02-Materi/P05-REST-API-Error-Handling.md && test -f 03-Modul-Kelas/Modul-P05-REST-API-Error-Handling.md` → PASS. `git diff --check` clean (no whitespace). Acceptance scan: tidak ada host/URL produksi (hanya placeholder `your-server.example.com` + host dokumentasi publik); `API_TOKEN=***` adalah placeholder instruksi, bukan secret nyata. Semua 3 checkpoint punya blok fallback mock. Modul mengalokasikan waktu Tugas 2 di 4 blok.
- **Decisions:**
  - Mengikuti gaya/kedalaman P04 materi+modul (template terdekat; abstraksi `TaskRepository` sama).
  - Checkpoint times mengikuti `06-Starter-Code/p05-api/README.md` (CP1~25, CP2~20, CP3~40 menit self-study); di kelas CP1/CP2 jadi walkthrough ringkas (test sudah hijau sejak starter) dan CP3 jadi inti implementasi.
  - Tugas 2 **dibuka** di P05 (bukan dikumpul) — sesuai planning §6 (rilis setelah P5, tenggat sebelum P6). Alokasi: brief (blok 1), mulai kerja (praktik individual), detail (blok 5), kunci tenggat+submit (blok 6).
  - Mode live opsional via `--dart-define`; default mock/fixture cukup untuk seluruh acceptance (endpoint belum ditetapkan).
- **Open:**
  - Artefak `04-Penugasan/Tugas-02-Persistence-dan-API.md` + `Rubrik-Tugas-02.md` **belum ada** (di luar scope task-009). Modul/materi merujuk path tersebut + fallback ke spesifikasi di `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md` §6 bila belum lengkap.
  - Verifikasi runtime `flutter test/analyze` tidak dijalankan: host produksi tak punya Flutter SDK (lihat `06-Starter-Code/README.md`). Verifikasi ditangguhkan ke mesin target.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed P05 materials/modules against API contract and P05 starter. Fixed checkpoint timing to 10+10+35=55 minutes, mock capability claims for 401/500, and removed invalid pseudo-helper while restoring complete CRUD example. Static content gate and git diff check passed.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi for implementation.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: wrote P05 materi + modul (REST API + error handling, mock fallback, Tugas 2 allocation). AC1/AC2/AC3 + verification command PASS. Moved to review.
