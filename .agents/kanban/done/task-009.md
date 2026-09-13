---
id: task-009
title: "Verifikasi menyeluruh course + evidence pack"
status: done
priority: 85
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-14
tags: [moodle, qa]

depends: task-004, task-005, task-007, task-008
---
# Verifikasi menyeluruh course + evidence pack

## Goal
Course 21 fully aligned: 16 section, semua aktivitas rancangan ada, rantai restrict benar, tidak ada aktivitas lama visible, quiz config benar.

## Context
Task QA final: bandingkan realitas Kulino vs moodle/activities/*.md. Tergantung semua task lain selesai.

Baca WAJIB sebelum mulai: `.agents/kanban/WORKFLOW.md` (aturan keras no-DB-access, session Playwright, pitfall teknis terbukti).

## Scope
**Included**: Jalankan walkthrough read-only penuh (WS core_course_get_contents + halaman UI): matrix section×aktivitas vs moodle/activities/*.md; cek rantai restrict; cek quiz config; simpan evidence screenshot + JSON dump ke .kanban-evidence/task-009/.

**Excluded**: Perbaikan — laporkan gap, perbaikan jadi task follow-up.

## Acceptance Criteria
- [x] Matrix kecocokan 100% aktivitas rancangan (nama+jenis+section)
- [x] JSON dump struktur course tersimpan + screenshot tiap section
- [x] Laporan gap (bila ada) tertulis di task file

## Verification Commands
```bash
# Read-only WS (token ~/.kulino-admin/ws_token) — contoh:
curl -s https://kulino.dinus.ac.id/webservice/rest/server.php \
  -d wstoken=$(cat ~/.kulino-admin/ws_token) \
  -d wsfunction=core_course_get_contents -d courseid=21 -d moodlewsrestformat=json | python3 -m json.tool | head -80
# Screenshot evidence → .kanban-evidence/task-009/ (gitignored)
```

## Implementation Notes
- Playwright sync API; session cookie dari `~/.kulino-admin/session.txt`.
- Course id=21. qbank cmid=2180. Kategori soal PPB/PXX.
- Jangan pernah print token/cookie ke log.

## Hasil Verifikasi (ringkas)

Semua bukti di `.kanban-evidence/task-009/` (REPORT.md lengkap + matrix.json + dump JSON + 33 screenshot).

- **Matrix 69/69 aktivitas rancangan ADA** (nama+jenis+section cocok; 67 fully OK).
- **Rantai restrict 13/13 BENAR** — starter P0N ← quiz P0(N−1) ≥80% (P09 ← Quiz P07; P01 terbuka), semua showc=true. Mapping grade item terverifikasi via `core_grades_get_gradeitems`.
- **Quiz config 14/14 cocok**: unlimited attempts, highest, grade 10, pass 8.00, shuffle, no time limit, satu halaman, 10 slot soal, right answer never-shown.
- **URL materi 14/14 cocok**; **starter zip 14/14 nama cocok**.
- **Aktivitas lama: semua visible=0** ✅.

### Gap (perbaikan → task follow-up, task ini read-only)
1. **HIGH**: 144 section kosong "New section" (course_sections 29–160) visible=1 dan RENDER di halaman course — perlu bulk delete via UI.
2. **HIGH**: assign `Tugas P03` (cmid 16660) & `Capstone — Deklarasi Proyek` (cmid 16661) module visible=0 — saat section dibuka tetap tersembunyi; set visible=1 eksplisit.
3. **MED**: Question bank bersama "Question Bank Mobile" kosong; 140 soal hidup per-quiz local bank, kategori PPB/PXX tidak terbentuk — sejalan item pending WORKFLOW (re-import versi ber-tag).
4. **LOW**: legacy section 17–28 hidden (RPS dsb.) — opsional dibersihkan bersama gap 1.
5. **INFO**: idnumber course "A11.64605-20261" vs label RPS 20251 — konfirmasi dosen.

## Pi Handoff
- Changed: no repo files (QA read-only). Artifacts: `.kanban-evidence/task-009/` — REPORT.md, matrix.json, course21-contents.json, quizzes.json, gradeitems.json, section-00..16.png, course-full.png, gradebook-setup.png, quiz-edit-PXX.png ×14, question-banks.png/.txt, qbank-home.png/.txt, ui-walkthrough.json, ui-pass2.json, ui-pass3.json.
- Tests: WS read-only (core_course_get_contents, mod_quiz_get_quizzes_by_courses, core_grades_get_gradeitems) + Playwright UI walkthrough (17 section screenshot, 14 halaman quiz-edit, gradebook setup, form modedit untuk gradepass). Session valid, tanpa mutasi.
- Decisions: gap tidak diperbaiki di task ini (scope Excluded: laporkan saja); review options "later + right answer never" dianggap cocok maksud README (kunci tak tampil); privacy — response WS berisi data mahasiswa (gradereport_user) langsung dihapus, tidak disimpan.
- Open: 3 follow-up task (hapus section kosong bulk; unhide 2 assign; re-import 140 soal ber-tag ke bank bersama kategori PPB/PXX).

## Activity Log
- 2026-09-13 Prisa: created task.
- 2026-09-14 Pi: verifikasi penuh selesai — matrix 69/69 ada, restrict 13/13 benar, quiz config 14/14 cocok; 5 gap tercatat; evidence pack tersimpan. Pindah doing→review.
- 2026-09-13 Prisa: Tindak lanjut temuan — (1) 144 section kosong "New section" (efek samping task-006 timeout) + 12 legacy kosong dihapus via WS section_delete → 17 section final; (2) assign P03/P04 visible=0 → show via core_course_edit_module, verif visible=1; (3) temuan MED SALAH: bank course PPB/P01-P15 ×10 soal sehat, 14 quiz mereferensikan 10 soal/quiz dari kategori sesuai (bukan local duplikat) — audit DB read-only konfirmasi; (4) LOW legacy section sudah ikut dibersihkan. → done.
