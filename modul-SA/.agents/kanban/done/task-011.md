---
id: task-011
title: "Scaffold starter P06–P07 dan tulis materi/modul QA sampai release"
status: done
priority: 75
assignee: pi
created_at: 2026-08-08
updated_at: 2026-08-08
tags: [starter-code, material, module, testing, release]
---

# Scaffold starter P06–P07 dan tulis materi/modul QA sampai release

## Goal
Membuat baseline dan empat dokumen P06/P07 untuk device feature, test, analysis, APK, dan demo.

## Context
Scope P06 pilih image picker/camera dengan gallery fallback; P07 quality/release/live coding. Tidak perlu platform feature kompleks.
## Scope
- **Included**:
- Buat `06-Starter-Code/p06-testing-device/`, `p07-release/`, README, test skeleton, permission note, release checklist.
- Buat `02-Materi/P06-Device-Testing-QA.md`, `03-Modul-Kelas/Modul-P06-Device-Testing-QA.md`, `02-Materi/P07-Release-Live-Coding-Demo.md`, `03-Modul-Kelas/Modul-P07-Release-Live-Coding-Demo.md`.
- P06 wajib memuat 3 unit + 2 widget test target. P07 wajib memuat `flutter analyze`, `flutter test`, APK, `const`/rebuild basics, demo preparation.
- **Excluded**:
- Coverage target tinggi, Play Store publishing, iOS release.

## Acceptance Criteria
- [x] P06 memuat device unavailable/permission denied fallback.
- [x] P07 punya quality gate dan live modification rehearsal.
- [x] Starter P06/P07 tidak menyimpan signed key atau release secret.

## Verification Commands
```bash
test -d 06-Starter-Code/p06-testing-device && test -f 02-Materi/P07-Release-Live-Coding-Demo.md && test -f 03-Modul-Kelas/Modul-P06-Device-Testing-QA.md
```

## Implementation Notes
Root board dan artefak: `/home/kaqfa/Data-Kerja/personal-knowledge/01 Current - Projects/Completed/Kuliah - PPB 20251/Handout-SA`. Ikuti `../Standar Tutorial Koding PPB.md` dan `../Standar Pengembangan Materi PPB.md`. Jangan mengubah sumber reguler di parent folder.

## Activity Log
- 2026-08-08 Prisa: moved to done. Reviewed P06/P07 starters and four teaching docs. Fixed P06 nested enum/counter constructor/test references, undefined immutable annotations in P06/P07 models, and guided-lab timing (P06 15+20+20, P07 15+15+25). Structural audit, no-signing-file scan, and diff check passed.
- 2026-08-08 Prisa: moved to doing. Delegated to Pi after Tugas 2 review/commit.
- 2026-08-08 Prisa: created task from `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.
- 2026-08-08 Pi: scaffold P06/P07 + P06 materi/modul sudah ada dari task sebelumnya; tulis `02-Materi/P07-Release-Live-Coding-Demo.md` + `03-Modul-Kelas/Modul-P07-Release-Live-Coding-Demo.md`; perbaiki bug `copyWith` hilang di p07 `task.dart` (test gate gagal kompilasi tanpanya); verifikasi cmd PASS; pindah ke review.

## Pi Handoff
- **Changed:**
  - `06-Starter-Code/p07-release/lib/features/tasks/domain/task.dart` — tambah `Task.copyWith(...)` (sebelumnya test `Task immutability: copyWith` memanggil metode yang tak ada → gate `analyze`/`test` gagal kompilasi). Konsisten dengan model P06.
  - `02-Materi/P07-Release-Live-Coding-Demo.md` (BARU, ~30 KB) — materi/handout: 3 checkpoint (quality gate analyze+test+build; const/rebuild via PerfDemoScreen + Inspector; release APK + live modification rehearsal), prasyarat, setup, troubleshooting, self-assessment, challenge bertingkat, AI policy, resources. Memenuhi Standar Tutorial Koding (Progressive Checkpoint) + Standar Pengembangan Materi.
  - `03-Modul-Kelas/Modul-P07-Release-Live-Coding-Demo.md` (BARU, ~13 KB) — modul kelas 150 menit: 6 BAGIAN (overview/rundown, live coding demo, practice mandiri 40', challenge individual, Tugas 3 final, references & penutup paket).
- **Tests:** Host produksi tidak punya Flutter SDK → `analyze`/`test`/`build` tidak dijalankan di sini (lihat `06-Starter-Code/README.md`). Verifikasi statis: (a) verification cmd `test -d p06-testing-device && test -f P07-Release-Live-Coding-Demo.md && test -f Modul-P06-Device-Testing-QA.md` → PASS; (b) grep `copyWith` di p07 → kini ada di `task.dart` (definisi) + `task_model_test.dart` (pemanggil), kompilasi selaras; (c) secret scan `*.jks|keystore|key.properties|password|secret|api_key|PRIVATE KEY|google-services` di starter p06/p07 → no live secrets; `.gitignore` mengecualikan signing material. Runtime gate ditangguhkan sampai SDK tersedia.
- **Decisions:**
  - P06/P07 starter dir + P06 materi/modul sudah lengkap dari task sebelumnya — task-011 fokus melengkapi dua dokumen P07 yang belum ada + memperbaiki defect `copyWith` agar gate P07 sahih.
  - P07 di-scope-out Play Store upload (planning §2); demo cukup `flutter build apk --release` debug-sign/unsigned + install manual; tidak ada signing key di repo (AC3).
  - `Bank-Live-Coding.md`, `Rubrik-Demo-dan-Wawancara.md`, `Tugas-03-*`, `Rubrik-Tugas-03` dirujuk sebagai forward-reference (artefak produksi langkah 7; belum dibuat — di luar scope task-011). Path konsisten dengan tree planning §4.
- **Open:**
  - Verifikasi runtime `flutter analyze` + `flutter test` + `flutter build apk --release` di mesin dengan SDK (host ini tak punya Flutter).
  - Artefak P07 yang belum dibuat: `05-Assessment/Bank-Live-Coding.md`, `05-Assessment/Rubrik-Demo-dan-Wawancara.md`, `04-Penugasan/Tugas-03-QA-Release-dan-Demo.md`, `04-Penugasan/Rubrik-Tugas-03.md` (produksi langkah 7). Materi/modul P07 sudah merujuknya; perlu dibuat sebelum sesi P07 nyata.
