---
id: task-008
title: "Hide aktivitas lama & rapikan course page"
status: done
priority: 70
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-13
tags: [moodle, cleanup]

depends: task-002
---
# Hide aktivitas lama & rapikan course page

## Goal
Semua aktivitas semester lama di-hide (bukan hapus): UTS A11.4702/4708, Testing Todo-List, FoodieQuest, Capstone Submission, Presentasi Project, URL materi lama di General, forum Announcements ganda, dsb.

## Context
Keputusan user 2026-09-13: hide saja, jadi referensi kalimat assignment. Daftar modul per section via read-only WS core_course_get_contents.

Baca WAJIB sebelum mulai: `.agents/kanban/WORKFLOW.md` (aturan keras no-DB-access, session Playwright, pitfall teknis terbukti).

## Scope
**Included**: Hide modul lama (Eye icon off) di section General & P01–P16 bila bukan bagian rancangan baru. Qbank module (cm 942/2180) — pastikan hanya satu aktif bila perlu.

**Excluded**: Hapus modul apapun. Gerakkan section.

## Acceptance Criteria
- [x] Course view (dosen) tidak menampilkan aktivitas lama sebagai available
- [x] Screenshots course page P01–P16 setelah cleanup

## Verification Commands
```bash
# Read-only WS (token ~/.kulino-admin/ws_token) — contoh:
curl -s https://kulino.dinus.ac.id/webservice/rest/server.php \
  -d wstoken=$(cat ~/.kulino-admin/ws_token) \
  -d wsfunction=core_course_get_contents -d courseid=21 -d moodlewsrestformat=json | python3 -m json.tool | head -80
# Screenshot evidence → .kanban-evidence/task-008/ (gitignored)
```

## Implementation Notes
- Playwright sync API; session cookie dari `~/.kulino-admin/session.txt`.
- Course id=21. qbank cmid=2180. Kategori soal PPB/PXX.
- Jangan pernah print token/cookie ke log.

## Activity Log
- 2026-09-13 Prisa: created task.
- 2026-09-13 Pi: hidden 22 modul lama via `course/mod.php?hide=` (Playwright, session admin): General — cm 948 (URL Overview), 2128/2130/2131 + 7813/7814/7815/7816 (label template placeholder), 7812 (forum Announcements duplikat; cm 944 = forum news asli dipertahankan); P01 — cm 2132/7817/7819/7821 (subsection kosong) + 7824 (label panduan template); P02 — cm 2140–2143 + 7825–7828 (subsection template "Topik 1 / Minggu 1"). Qbank: cm 942 tetap hidden, cm 2180 satu-satunya aktif ✓. Modul lama P03–P16/UTS/UAS sudah visible=0 sejak awal — tidak diubah. Verifikasi: re-read WS core_course_get_contents → semua target visible=0, semua modul baru (cm 16571–16629) visible=1. Evidence: `.kanban-evidence/task-008/` (course-full.png + P01.png…P16.png).
- 2026-09-13 Pi: moved to review.

## Pi Handoff
- Changed: 22 modul course 21 di-hide (Eye off), tanpa hapus/gerak — General (9), P01 (5), P02 (8). Daftar cmid di Activity Log.
- Tests: WS re-read `core_course_get_contents` → target visible=0 ✓, modul baru 16571–16629 visible=1 ✓, tidak ada modul baru ikut tersembunyi ✓. Screenshots dosen view tersimpan (course-full + P01–P16).
- Decisions: cm 944 dipertahankan sebagai Announcements aktif (forum news original course), duplikat cm 7812 di-hide. Kedua blok label template (2xxx & 7xxx) di-hide semua karena isi placeholder `[silakan isi disini]`. Label cm 950 'CPL Prodi' + qbank cm 2180 tetap tampil. Subsection P01/P02 di-hide karena section anak (21430–21441) kosong.
- Open: Child section 21430–21441 masih ada (kosong, tak tampil karena parent hidden) — bila mau benar-benar bersih bisa dihapus di task terpisah (out of scope: task ini no-delete).
- 2026-09-13 Prisa: Verifikasi independen WS — 0 aktivitas lama visible (filter nama: UTS/Todo-List/FoodieQuest/GMeet/RPS/RTM/Topik 1/dll). → done.
