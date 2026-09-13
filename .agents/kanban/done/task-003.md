---
id: task-003
title: "Buat 14 quiz P0N + config standar + isi 10 soal"
status: done
priority: 85
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-13
tags: [moodle, quiz]

depends: task-001
---
# Buat 14 quiz P0N + config standar + isi 10 soal

## Goal
Quiz P01..P07, P09..P15 dibuat di section masing-masing: config standar (unlimited attempt, highest, grade to pass 8, shuffle) + 10 soal dari kategori PPB/P0N.

## Context
Kebijakan config di moodle/README.md section 'Menyusun quiz unlock per minggu'. Nama quiz + section ada di moodle/activities/PXX.md. Kategori soal PPB/PXX hasil task-001.

Baca WAJIB sebelum mulai: `.agents/kanban/WORKFLOW.md` (aturan keras no-DB-access, session Playwright, pitfall teknis terbukti).

## Scope
**Included**: Buat quiz via modedit.php + edit quiz page (add 10 soal dari bank kategori PPB/P0N). Config: attempts unlimited, grading method Highest, grade to pass 8.00 (dari 10), shuffle within questions Yes, review: Whether correct+General feedback only after attempt closed (quiz closed), layout 1 halaman, tanpa time limit.

**Excluded**: Restrict access berantai (task-004).

## Acceptance Criteria
- [x] mod_quiz_get_quizzes_by_courses (read-only) menunjukkan 14 quiz dengan nama benar
- [x] Halaman edit quiz tiap quiz menunjukkan 10 soal, total mark 10
- [x] Grade to pass = 8.00, attempts = unlimited, method = highest (spot-check 3 quiz via UI + screenshot)

## Verification Commands
```bash
# Read-only WS (token ~/.kulino-admin/ws_token) — contoh:
curl -s https://kulino.dinus.ac.id/webservice/rest/server.php \
  -d wstoken=$(cat ~/.kulino-admin/ws_token) \
  -d wsfunction=core_course_get_contents -d courseid=21 -d moodlewsrestformat=json | python3 -m json.tool | head -80
# Screenshot evidence → .kanban-evidence/task-003/ (gitignored)
```

## Implementation Notes
- Playwright sync API; session cookie dari `~/.kulino-admin/session.txt`.
- Course id=21. qbank cmid=2180. Kategori soal PPB/PXX.
- Jangan pernah print token/cookie ke log.

## Activity Log
- 2026-09-13 Prisa: created task.
- 2026-09-13 Pi: selesai — 14 quiz dibuat (cmid 16585, 16595–16612, section benar), masing-masing 10 soal dari kategori PPB/P0N, total mark 10.00. Config terverifikasi via WS + form read-back + screenshot. 1 quiz P01 duplikat (16593) tak sengaja dibuat saat batch pertama → dihapus via course/mod.php confirm.

## Pi Handoff
- Changed: (Moodle Kulino course 21 — bukan file repo)
  - 14 quiz baru: P01..P07, P09..P15 di section masing-masing (section number = pertemuan). Nama: `Quiz P0N — <topik>` sesuai `moodle/activities/P0N-*.md`.
  - Isi: 10 soal per quiz dari kategori `PPB/P0N` (qid ranges P01=767–776 … P15=897–906), total marks 10.00, semua mark default 1.
  - Config semua quiz (terverifikasi mod_quiz_get_quizzes_by_courses + re-read modedit form): attempts=0 (unlimited), grademethod=1 (Highest), grade=10.00, gradepass=8.00, shuffleanswers=1, questionsperpage=0 (satu halaman), timelimit=0, timeopen/timeclose=0 (tanpa jadwal/limit), visible=1.
  - Review options: `The attempt` during+immediately (dipaksa/parent), `Whether correct` + `General feedback` = immediately after the attempt (WS: reviewattempt=69632, reviewcorrectness=4096, reviewgeneralfeedback=4096); marks/specific feedback/right answer/overall feedback = 0 (tidak pernah).
- Tests:
  - WS read-only: 14 quiz, nama + section + sumgrades=10 + seluruh flag di atas → `ALL OK` (snapshot: `.kanban-evidence/task-003/ws-quizzes-final.json`).
  - Halaman edit quiz ×14: masing-masing tepat 10 baris soal prefix benar + `Total of marks 10.00` (`.kanban-evidence/task-003/edit-page-verify.json`).
  - Re-read form settings ×14: gradepass=8.00, attempts=0, grademethod=1, questionsperpage=0, shuffle=1, visible=1 → `ALL OK`.
  - Screenshot: `.kanban-evidence/task-003/` — settings+edit page P01/P07/P15, course section P01.
- Decisions:
  - Task text bilang review "after attempt closed (quiz closed)" — kolom "After quiz closes" Moodle DISABLED tanpa close date, dan close date bertentangan dengan desain self-paced gate (README moodle/ "setelah attempt ditutup"). Dipilih "Immediately after the attempt" = student lihat correctness+general feedback tepat setelah submit attempt, tak bisa lihat sebelum submit. `The attempt` (jawaban sendiri) ikut tampil during+immediately karena Moodle memaksa kolom during dan correctness butuh parent attempt — tidak membocorkan kunci (right answer tetap hidden).
  - Quiz dibuat via modedit UI form (Playwright, submitbutton2) karena POST murni ditolak validasi; soal ditambah via `mod/quiz/edit.php?cmid=X&addquestion=<qid>&sesskey=...` (GET) — terbukti idempotent utk soal yang sudah ada.
  - Pitfall untuk task-004: section param modedit = section NUMBER; checkbox dalam fieldset collapsed harus di-expand via anchor `a[data-bs-toggle="collapse"][href="#id_reviewoptionshdrcontainer"]` dan set via real `.check()` — event sintetis/programmatic-`checked` di-revert dependency manager.
  - Urutan modul dalam section = append di akhir; penyusunan urutan rapi mengikuti rancangan diserahkan task-002 (non-quiz activities masih berjalan paralel).
- Open:
  - task-002 (aktivitas non-quiz) masih in_progress oleh sesi Pi lain — urutan modul dalam section belum final.
  - Restrict access berantai quiz ≥80% = task-004 (excluded di sini).
  - `reviewmaxmarks` default Moodle (69888) dibiarkan — tidak dibahas spec; tidak membocorkan jawaban.
- 2026-09-13 Prisa: Verifikasi independen WS — 14/14 quiz review options benar (attempt+maxmarks+marks+correctness+generalfeedback=4096 IMMEDIATELY_AFTER; rightanswer/specificfeedback=0) via .fix_quiz_review_final.py retry round. Fix perlu centang attempt/maxmarks dulu (disabledIf chain mod_form.php:426-431). → done.
