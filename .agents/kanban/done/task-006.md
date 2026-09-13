---
id: task-006
title: "Buat assignment gate G1–G4 + UTS/UAS"
status: done
priority: 80
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-13
tags: [moodle, assignment]

depends: task-002
---
# Buat assignment gate G1–G4 + UTS/UAS

## Goal
Assignment gate capstone G1 (P07, 8%), G2 (P10, 10%), G3 (P13, 12%), G4 (P15, 10%), UTS live coding (P08, 15%), UAS presentasi final (P16, 20%).

## Context
Brief: penugasan/capstone/G1..G4 + Ujian/UTS + penugasan (P16 brief UAS).

Baca WAJIB sebelum mulai: `.agents/kanban/WORKFLOW.md` (aturan keras no-DB-access, session Playwright, pitfall teknis terbukti).

## Scope
**Included**: Buat 6 assignment via modedit.php di section sesuai. Submission file + video link (G3 video demo, UAS video). Deskripsi ringkas + link brief.

**Excluded**: Peer review assignment.

## Acceptance Criteria
- [x] 6 assignment tampil di section P07/P10/P13/P15/P08/P16 (verifikasi read-only WS)
- [x] Submission settings sesuai (file untuk gate, file+online text utk link video)

## Verification Commands
```bash
# Read-only WS (token ~/.kulino-admin/ws_token) — contoh:
curl -s https://kulino.dinus.ac.id/webservice/rest/server.php \
  -d wstoken=$(cat ~/.kulino-admin/ws_token) \
  -d wsfunction=core_course_get_contents -d courseid=21 -d moodlewsrestformat=json | python3 -m json.tool | head -80
# Screenshot evidence → .kanban-evidence/task-006/ (gitignored)
```

## Implementation Notes
- Playwright sync API; session cookie dari `~/.kulino-admin/session.txt`.
- Course id=21. qbank cmid=2180. Kategori soal PPB/PXX.
- Jangan pernah print token/cookie ke log.

## Activity Log
- 2026-09-13 Prisa: created task.
- 2026-09-13 Pi: 6 assignment dibuat via modedit.php form UI (Playwright): Gate G1 — Fondasi (cm 16716, section 7/P07), UTS — Live Coding & Demo (cm 16717, section 8/UTS), Gate G2 — Data (cm 16718, section 10/P10), Gate G3 — Arsitektur & Kualitas (cm 16719, section 13/P13), Gate G4 — Rilis (cm 16720, section 15/P15), UAS — Video Presentasi Final (cm 16721, section 16/UAS). Semua grade 100 point, file submission 1 berkas/10 MB, onlinetext aktif untuk UTS/G3/UAS, due Jumat 23.59 sesuai ritme minggu (G1=23 Okt, UTS=31 Okt, G2=13 Nov, G3=4 Des, G4=18 Des, UAS=24 Des 2026), visible=1 (section tetap hidden per ritme). Brief .md dilampirkan di intro attachment (G1–G4 + capstone/README utk UAS; UTS tanpa lampiran — rubrik dibagikan saat sesi). Verifikasi read-only: `core_course_get_contents` (posisi & visible) + `mod_assign_get_assignments` (submission config, due, attachments) + screenshot. Evidence: `.kanban-evidence/task-006/`. moved to review.

## Pi Handoff
- Changed: tidak ada file konten repo yang diubah. Perubahan hanya di Moodle course 21 + `.kanban-evidence/task-006/` (evidence) + `.pi-status/task-006.json` + pitfall baru di `.agents/kanban/WORKFLOW.md`. Script kerja sengaja disimpan: `.tmp_t006_create.py` (create), `.tmp_t006_fix.py` (attach+visible), `.tmp_t006_shots.py` (evidence); probe dihapus.
- Moodle changes (course 21): 6 assignment baru (cmid 16716–16721, lihat Activity Log). Posisi via `beforemod` → gate selalu di antara Starter dan Quiz/masih sebelum Choice/Feedback.
- Tests: WS read-only `mod_assign_get_assignments` → 6/6 nama+section+due+grade+submission config benar (`ws-assignments.json`, `verify-config.txt`); `core_course_get_contents` → 6/6 visible=1 di section benar (`ws-contents.json`, `verify-visible.txt`); view page dosen → deskripsi + tenggat + lampiran tampil, screenshot `assign-*.png`.
- Decisions:
  - Root cause kegagalan percobaan pertama (raw POST & UI POST): param `section` di `modedit.php` = NOMOR section, bukan id (957→7) — pemakaian id → `invalidrecordunknown` "Can't find data record in database". Simpan sebagai pitfall WORKFLOW.
  - Upload lampiran intro: `repository/repository_ajax.php action=upload` field file = `repo_upload_file` (bukan `content`); itemid dari input `introattachments`.
  - Module baru di section hidden otomatis `visible=0` → fix pass set visible=1 eksplisit (section tetap hidden sesuai ritme unlock Prisa).
  - Due date: akhir pekan kalender kuliah (Sab–Jum, mulai 2026-09-05) — lanjut konvensi task-005; UTS = Sab 31 Okt (24 jam setelah akhir pekan UTS), UAS = Kam 24 Des (H-1 sesi kelas minggu 16).
  - Submission plugin comments dinonaktifkan; cutoff & grading due dimatikan (hindari pitfall validasi gradingduedate task-005).
  - UTS tanpa lampiran brief: 5 varian soal di `Ujian/UTS/` rahasia sampai sesi — "lampirkan sesuai sesi" tidak bisa sekarang.
- Open: rubrik UTS live coding belum punya file publik (dibagikan saat sesi); brief capstone belum ada URL publik (opsional publish classroom, sama seperti open item task-005); peer review assignment (bagian 5%, G1 & G3) = task-007.
- 2026-09-13 Prisa: Verifikasi independen WS — 6/6 assignment gate (cm 16716-16721) di sec 7/8/10/13/15/16, due berjenjang 23 Okt-24 Des, grade 100. Attempt pertama TIMEOUT, rerun sukses. → done.
