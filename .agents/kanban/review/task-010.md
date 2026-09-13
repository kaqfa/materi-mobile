---
id: task-010
title: "Update README moodle/ + commit"
status: review
priority: 50
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-14
tags: [docs, git]

depends: task-009
---
# Update README moodle/ + commit

## Goal
Dokumentasi repo mencerminkan realitas Kulino: checklist dosen di moodle/README.md & activities/README.md dicoret yang sudah dikerjakan otomatis, catat manual steps tersisa (mis. import kalender, pengaturan gradebook).

## Context
Task penutup setelah QA lulus.

Baca WAJIB sebelum mulai: `.agents/kanban/WORKFLOW.md` (aturan keras no-DB-access, session Playwright, pitfall teknis terbukti).

## Scope
**Included**: Update README.md (status import/quiz/restrict), activities/README.md checklist; commit semua perubahan repo (scripts kulino_client.py, probe_lib.py, generator tags) TANPA file secret/token/bukti berisi data mahasiswa.

**Excluded**: Push (manual oleh user).

## Acceptance Criteria
- [x] git log menampilkan commit deskriptif
- [x] git status bersih dari file bukti ber-sensitive (gitignore evidence)
- [x] README updated mencerminkan status

## Verification Commands
```bash
# Read-only WS (token ~/.kulino-admin/ws_token) — contoh:
curl -s https://kulino.dinus.ac.id/webservice/rest/server.php \
  -d wstoken=$(cat ~/.kulino-admin/ws_token) \
  -d wsfunction=core_course_get_contents -d courseid=21 -d moodlewsrestformat=json | python3 -m json.tool | head -80
# Screenshot evidence → .kanban-evidence/task-010/ (gitignored)
```

## Implementation Notes
- Playwright sync API; session cookie dari `~/.kulino-admin/session.txt`.
- Course id=21. qbank cmid=2180. Kategori soal PPB/PXX.
- Jangan pernah print token/cookie ke log.

## Activity Log
- 2026-09-13 Prisa: created task.
- 2026-09-14 Pi: README moodle/ + activities/README update (checklist dicoret, manual steps dicatat); commit 3x (tooling, moodle, board); gitignore skrip sekali-pakai; evidence `.kanban-evidence/task-010/`. Pindah doing→review.

## Pi Handoff
- Changed:
  - `moodle/README.md` — status v1.1, section "Status deployment Kulino": daftar otomatis selesai + manual steps tersisa (kalender, gradebook, buka section mingguan, push, re-upload starter); review options quiz diralat sesuai realitas (*Right answer* never); catat tag soal.
  - `moodle/activities/README.md` — checklist dosen 1–6 dicoret ✅ + blok "Tersisa manual".
  - Commits: `ef544bf` (kulino_client.py, probe_lib.py, .gitignore), `2fab643` (build_moodle_xml.py tags + P07/P13 peer review format + README×2), `1fec67f` (.agents/ board + WORKFLOW).
  - `.gitignore` — tambah pola skrip sekali-pakai (`/.tmp_*`, `/.stage*`, `/.fix_*`, dll) supaya `git status` bersih; bukti/screenshot tetap di `.kanban-evidence/` (ignored).
- Tests: `git status --porcelain` kosong (clean); scan secret (32-hex token / literal sesskey/cookie/password) di file ter-commit → 0 temuan; semua kredensial dibaca runtime dari `~/.kulino-admin/*` (tidak ada di repo).
- Decisions: skrip sekali-pakai dotfile di-gitignore (bukan di-commit) karena tidak dinamai scope & berisiko noise; hanya `kulino_client.py` + `probe_lib.py` (reusable, dinamai scope) yang di-commit. `.moodle_plan.json` di-gitignore — turunan `activities/*.md`. Push tidak dilakukan (Excluded, manual user).
- Open: langkah manual dosen tercatat di README (kalender, gradebook bobot, buka section mingguan); push GitHub oleh user.
