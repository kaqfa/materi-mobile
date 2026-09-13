---
id: task-001
title: "Hapus & re-import bank soal versi ber-tag"
status: done
priority: 80
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-13
tags: [moodle, question-bank]
---
# Hapus & re-import bank soal versi ber-tag

## Goal
Bank soal di Kulino berisi persis 140 soal dari XML terbaru (ber-tags), kategori PPB/P01..P15 rapi.

## Context
Import pertama (tanpa tags) sudah masuk 140 soal di 14 kategori PPB/*. XML baru `moodle/build/Moodle-Question-Bank.xml` (rebuild 2026-09-13) kini menyertakan 3 tag/soal (kode pekan, topik, ppb-20251). Quiz belum dibuat → aman hapus soal lama.

Baca WAJIB sebelum mulai: `.agents/kanban/WORKFLOW.md` (aturan keras no-DB-access, session Playwright, pitfall teknis terbukti).

## Scope
**Included**: Hapus SEMUA soal lama via UI bulk delete (kategori PPB & subnya; lihat WORKFLOW selector). Re-import XML baru via form import (format=xml, catfromfile=1, contextfromfile=1, matchgrades=nearest).

**Excluded**: Jangan buat quiz. Jangan ubah struktur kategori selain yang otomatis dari XML.

## Acceptance Criteria
- [x] Halaman Questions per kategori PPB/PXX menunjukkan tepat 10 soal
- [x] Sample soal (via UI detail question) menampilkan tags p01/p02/... + topik + ppb-20251
- [x] Total 140 soal di 14 kategori; tidak ada kategori default berisi duplikat
- [x] Screenshot evidence per kategori

## Verification Commands
```bash
# Read-only WS (token ~/.kulino-admin/ws_token) — contoh:
curl -s https://kulino.dinus.ac.id/webservice/rest/server.php \
  -d wstoken=$(cat ~/.kulino-admin/ws_token) \
  -d wsfunction=core_course_get_contents -d courseid=21 -d moodlewsrestformat=json | python3 -m json.tool | head -80
# Screenshot evidence → .kanban-evidence/task-001/ (gitignored)
```

## Implementation Notes
- Playwright sync API; session cookie dari `~/.kulino-admin/session.txt`.
- Course id=21. qbank cmid=2180. Kategori soal PPB/PXX.
- Jangan pernah print token/cookie ke log.

## Activity Log
- 2026-09-13 Prisa: created task.
- 2026-09-13 Prisa: Pi re-import selesai (timeout di fase evidence, pekerjaan inti done). Verifikasi independen: 14×10 soal, tags benar (qid 767), default kosong. → done.
