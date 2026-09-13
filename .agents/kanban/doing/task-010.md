---
id: task-010
title: "Update README moodle/ + commit"
status: doing
priority: 50
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-13
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
- [ ] git log menampilkan commit deskriptif
- [ ] git status bersih dari file bukti ber-sensitive (gitignore evidence)
- [ ] README updated mencerminkan status

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
