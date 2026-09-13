---
id: task-007
title: "Buat peer review P07 & P13 + attach brief penugasan"
status: done
priority: 60
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-14
tags: [moodle, assignment]

depends: task-006
---
# Buat peer review P07 & P13 + attach brief penugasan

## Goal
2 assignment peer review (siklus 1 di P07, siklus 2 di P13, masing bagian 5%) + semua brief penugasan terlampir ke assignment terkait.

## Context
Brief: penugasan/peer-review/. Peer review di Moodle bisa berupa assignment dengan submission + rubrik sederhana (Workshop terlalu berat utk setup otomatis awal — konsisten dgn rancangan file activities PXX yang menyebut 'Assignment').

Baca WAJIB sebelum mulai: `.agents/kanban/WORKFLOW.md` (aturan keras no-DB-access, session Playwright, pitfall teknis terbukti).

## Scope
**Included**: Buat 2 assignment peer review. Upload file brief (md/pdf dari penugasan/) sebagai attachment/Description file pada assignment P02, P03, P04(deklarasi), G1-G4, peer review.

**Excluded**: Mengubah tipe assignment lain.

## Acceptance Criteria
- [x] 2 assignment peer review tampil di P07 & P13
- [x] Assignment utama menampilkan attachment brief (file terlihat di halaman assignment)

## Verification Commands
```bash
# Read-only WS (token ~/.kulino-admin/ws_token) — contoh:
curl -s https://kulino.dinus.ac.id/webservice/rest/server.php \
  -d wstoken=$(cat ~/.kulino-admin/ws_token) \
  -d wsfunction=core_course_get_contents -d courseid=21 -d moodlewsrestformat=json | python3 -m json.tool | head -80
# Screenshot evidence → .kanban-evidence/task-007/ (gitignored)
```

## Implementation Notes
- Playwright sync API; session cookie dari `~/.kulino-admin/session.txt`.
- Course id=21. qbank cmid=2180. Kategori soal PPB/PXX.
- Jangan pernah print token/cookie ke log.

## Activity Log
- 2026-09-13 Prisa: created task.
- 2026-09-14 Pi: buat "Peer Review — Siklus 1" (cmid 16724, section P07, sebelum Quiz P07) & "Peer Review — Siklus 2" (cmid 16725, section P13, sebelum Quiz P13) via modedit UI Playwright; brief `penugasan/peer-review/README.md` di-upload ke introattachments masing-masing; visible 0→1 via update form. Verifikasi WS (mod_assign_get_assignments) + screenshot.

## Pi Handoff
- Changed: hanya artefak di server Moodle (course id=21) + evidence `.kanban-evidence/task-007/`. Nol perubahan file repo source.
  - `Peer Review — Siklus 1` — assign cmid **16724**, section P07, posisi antara Gate G1 dan Quiz P07. Due 2026-10-16 23:59 (sepekan sebelum G1 10-23). Grade 100 pt, submission file(1,10MB)+onlinetext, attach `README.md` (brief peer-review), visible=1.
  - `Peer Review — Siklus 2` — assign cmid **16725**, section P13, posisi antara Gate G3 dan Quiz P13. Due 2026-11-27 23:59 (sepekan sebelum G3 12-04). Konfigurasi sama, visible=1.
- Attach brief utama: dicek via WS `mod_assign_get_assignments` — P02 16659 `P02_Dart-OOP-Challenge.md`, P03 16660 `P03_Flutter-Mini-App.md`, P04 16661 `README.md` (capstone/README.md), G1 16716 `G1_Fondasi.md`, G2 16718 `G2_Data.md`, G3 16719 `G3_Arsitektur-Kualitas.md`, G4 16720 `G4_Rilis.md` — **semua sudah ter-attach sejak task-005/006**, tidak diubah. UTS 16717 tanpa lampiran (out of scope).
- Tests: verifikasi read-only WS re-read (contents + assignments) → `verify-pr.txt`, `ws-contents-after.json`; screenshot `assign-pr1.png`/`assign-pr2.png` (halaman assignment menampilkan brief README.md), `update-16724.png`/`update-16725.png`, `course-p07.png`/`course-p13.png`. Semua di `.kanban-evidence/task-007/`.
- Decisions:
  - Deskripsi assignment mengikuti `moodle/activities/P07|P13.md` (source of truth konten per WORKFLOW.md): isi = 3 hal baik · 2 masalah konkret · 1 saran prioritas; butir detail penilaian dirujuk ke lampiran README.md.
  - Due date: siklus 1 = sepekan sebelum due G1; siklus 2 = sepekan sebelum due G3 (kalender penugasan tidak mencantumkan tanggal eksplisit).
  - Module baru di section hidden auto `visible=0` (pitfall WORKFLOW) → sudah di-set `visible=1` via update form; section P07/P13 sendiri tetap hidden sampai dibuka dosen (sesuai staging task-004).
- Open:
  - **Konflik konten**: `penugasan/peer-review/README.md` menjabarkan bentuk review "tiga butir" (1 hal bagus, 1 hal yang akan menyusahkan, 1 pertanyaan), sedangkan `moodle/activities/P07|P13.md` menulis "3 hal baik, 2 masalah konkret, 1 saran prioritas". Moodle memakai redaksi activities + merujuk lampiran; mahasiswa akan melihat dua format. Perlu Prisa pilih satu & selaraskan activities file vs brief.
  - Nama file lampiran peer review = `README.md` (nama generik di halaman assignment) — konsisten dengan attach UAS/P04, tapi kurang deskriptif; opsional rename file jadi `Peer-Review-README.md` bila mengganggu.
  - Pasangan review ("ditentukan dosen") belum punya wadah (forum/announcement) — di luar scope task ini.
- 2026-09-13 Prisa: Verifikasi independen WS — cm16724 (P07) + cm16725 (P13) visible, due 16 Okt/27 Nov, brief attached. Konflik redaksi diselesaikan: format tiga-butir (brief kanonik menang); activities P07/P13 dipatch + intro Moodle disinkronkan (cm16724 awalnya intro kosong — diisi via editor iframe + submit button asli). → done.
