---
id: task-002
title: "Buat aktivitas non-quiz P01–P16 (URL, File starter, Forum, Choice)"
status: done
priority: 80
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-13
tags: [moodle, activities]

depends: task-001
---
# Buat aktivitas non-quiz P01–P16 (URL, File starter, Forum, Choice)

## Goal
Semua aktivitas non-quiz per rancangan tampil di section masing-masing: 14 URL materi, 14 File starter zip, forum/choice sesuai file PXX.

## Context
Rincian lengkap per section ada di moodle/activities/P01..P16.md (nama, jenis, URL, nama file zip). Zip starter di moodle/build/starter-zips/.

Baca WAJIB sebelum mulai: `.agents/kanban/WORKFLOW.md` (aturan keras no-DB-access, session Playwright, pitfall teknis terbukti).

## Scope
**Included**: Buat modul via UI (Add activity) atau modedit.php POST: 14 URL materi classroom, 14 File (upload zip starter), forum error-wall/perkenalan P01, forum P02–P06/P09–P15 sesuai rancangan, Choice P01 (checklist env), Choice P08/P16 (slot tanya jawab), Feedback P16 (survei). Urutan tampil dalam section mengikuti file PXX.

**Excluded**: Quiz & assignment (task lain). Jangan ubah section/summary.

## Acceptance Criteria
- [x] core_course_get_contents (read-only WS) menunjukkan modul sesuai daftar per section
- [x] File starter dapat diunduh (cek link resource ada, filename benar)
- [x] Tidak ada modul duplikat

## Verification Commands
```bash
# Read-only WS (token ~/.kulino-admin/ws_token) — contoh:
curl -s https://kulino.dinus.ac.id/webservice/rest/server.php \
  -d wstoken=$(cat ~/.kulino-admin/ws_token) \
  -d wsfunction=core_course_get_contents -d courseid=21 -d moodlewsrestformat=json | python3 -m json.tool | head -80
# Screenshot evidence → .kanban-evidence/task-002/ (gitignored)
```

## Implementation Notes
- Playwright sync API; session cookie dari `~/.kulino-admin/session.txt`.
- Course id=21. qbank cmid=2180. Kategori soal PPB/PXX.
- Jangan pernah print token/cookie ke log.

## Activity Log
- 2026-09-13 Prisa: created task.
- 2026-09-13 Pi: 44 modul dibuat via modedit.php POST (14 URL, 14 resource+upload zip via repository_ajax repo_id=5, 12 forum, 3 choice, 1 feedback + 3 item survei). Reorder via UI move-modal (P01 forum→after Choice, P01 quiz→after Starter, P15 quiz→after Starter). Verifikasi: missing=0 duplicate=0 filename_bad=0 exturl_bad=0, 14/14 zip terunduh (PK+size). Evidence: `.kanban-evidence/task-002/`. → review.

## Pi Handoff
- Changed: Moodle course 21 (remote, via UI/POST — bukan file repo). Repo lokal hanya `.kanban-evidence/task-002/` (gitignored) + task file ini. Modul: URL materi 14 (cmid 16571–16584 selang-seling), Starter resource 14 (zip asli dari `moodle/build/starter-zips/`, filename terjaga), forum 12 (cmid 16614–16625 selang-seling), Choice P01=16626 (4 opsi checklist, multiple answer, publish after answer), Choice P08=16627 & P16=16628 (Slot 1–5, publish always), Feedback P16=16629 (anonymous, 3 pertanyaan textarea).
- Tests: verifikasi read-only WS + scraping — `.kanban-evidence/task-002/ws-verify.txt` (missing=0 duplicate=0 filename_bad=0), `url-verify.txt` (14/14 external URL benar), download check 14/14 zip (header PK + size match + token appended di webservice/pluginfile URL). Screenshot: course-p01.png, choice-p01-checklist.png, feedback-p16-items.png, section-p05.png.
- Decisions: (1) urutan dalam section disesuaikan file PXX — 3 move dilakukan termasuk 2 quiz milik task-003 (posisi saja, config/soal tak disentuh); (2) Choice slot P08/P16 pakai label generik "Slot 1–5" (limit form 5 opsi); (3) Feedback dibuat anonymous + multiple_submit; (4) restrict access starter (syarat quiz lulus) SENGASA dilewati — itu scope task-004; (5) intro semua modul ringkas dari deskripsi file PXX, HTML-escaped.
- Open: (a) dosen perlu mengisi jadwal riil pada Choice slot P08/P16 (label generik); (b) task-003 diperingatkan posisi quiz — 2 sudah saya rapikan, sisanya urut; (c) task-004 wiring restrict access quiz→starter; (d) section P03–P16 masih hidden (sesuai WORKFLOW stage) — bukan scope task ini.
- 2026-09-13 Prisa: Verifikasi independen via WS — 14/14 pekan punya URL materi + starter; total 80 modul di P01–P15; modul lama tertinggal (scope task-008). → done.
