---
id: task-005
title: "Buat assignment P02, P03, P04 (tugas individu + deklarasi)"
status: done
priority: 70
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-13

tags: [moodle, assignment]

depends: task-002
---
# Buat assignment P02, P03, P04 (tugas individu + deklarasi)

## Goal
3 assignment tugas individu/deklarasi dibuat sesuai brief penugasan: Tugas P02 (Dart OOP, 7.5%), Tugas P03 (Flutter Mini App, 7.5%), Capstone — Deklarasi Proyek (tanpa nilai, syarat G1).

## Context
Brief lengkap: penugasan/individu/ (P02-P03) + penugasan/capstone/ (deklarasi G1). Lampirkan file brief PDF/MD ke assignment bila tersedia; jika tidak, deskripsi ringkas + link.

Baca WAJIB sebelum mulai: `.agents/kanban/WORKFLOW.md` (aturan keras no-DB-access, session Playwright, pitfall teknis terbukti).

## Scope
**Included**: Buat assign di section P02/P03/P04 via modedit.php. Grade sesuai bobot (100 skala lokal — nilai akhir direkap dosen). Due date ikut kalender penugasan/README.md. Submission types: file (zip project) + statement AI-declaration field.

**Excluded**: Gate G1–G4 assignment (task-006), peer review (task-007).

## Acceptance Criteria
- [x] mod_assign_get_assignments (read-only) menunjukkan 3 assignment dengan nama/section benar
- [x] Form assignment: submission file aktif, due date sesuai kalender
- [x] Deskripsi berisi ringkasan brief + link ke dokumen penugasan

## Verification Commands
```bash
# Read-only WS (token ~/.kulino-admin/ws_token) — contoh:
curl -s https://kulino.dinus.ac.id/webservice/rest/server.php \
  -d wstoken=$(cat ~/.kulino-admin/ws_token) \
  -d wsfunction=core_course_get_contents -d courseid=21 -d moodlewsrestformat=json | python3 -m json.tool | head -80
# Screenshot evidence → .kanban-evidence/task-005/ (gitignored)
```

## Implementation Notes
- Playwright sync API; session cookie dari `~/.kulino-admin/session.txt`.
- Course id=21. qbank cmid=2180. Kategori soal PPB/PXX.
- Jangan pernah print token/cookie ke log.

## Activity Log
- 2026-09-13 Prisa: created task.
- 2026-09-13 Pi: 3 assignment dibuat via Playwright modedit UI (raw POST assign kena bug Moodle `assign::save_editor_draft_files(): null returned`); brief .md dilampirkan sebagai intro attachment via repository_ajax upload; verifikasi WS read-only + screenshot; moved to review.

## Pi Handoff
- Changed: tidak ada file repo konten yang diubah. Perubahan hanya di Moodle course 21 (lihat bawah) + `.kanban-evidence/task-005/` (evidence) + `.pi-status/task-005.json`. Tidak ada commit.
- Moodle changes (course 21):
  - `Tugas P02 — Dart OOP Challenge` (cmid 16659, section 2, sebelum Quiz P02) — grade 100 point, due 2026-09-18 23:59 WIB, file submission (1 file, 10 MB) + onlinetext aktif, brief `P02_Dart-OOP-Challenge.md` terlampir.
  - `Tugas P03 — Flutter Mini App` (cmid 16660, section 3, sebelum Quiz P03) — grade 100 point, due 2026-09-25 23:59 WIB, submission sama, brief `P03_Flutter-Mini-App.md` terlampir.
  - `Capstone — Deklarasi Proyek` (cmid 16661, section 4, sebelum Quiz P04) — grade type none (tanpa nilai, syarat G1), due 2026-10-02 23:59 WIB, submission sama, brief `capstone/README.md` terlampir.
- Tests: `mod_assign_get_assignments` read-only → 3 assignment, section+nama+due+grade+submission config OK (`.kanban-evidence/task-005/ws-assignments.json`); view page 3 assignment → attachment tampil + due date tampil; screenshot `assign-p02/p03/p04.png`, `course-section-p02.png`.
- Decisions:
  - Due date = akhir minggu kalender kuliah (course start 2026-09-05, minggu Sab–Jum): P02=18 Sep, P03=25 Sep, P04=2 Okt 2026 23:59 — `penugasan/README.md` tidak memuat tanggal absolut, pakai minggu.
  - Raw form POST `modedit.php` untuk assign GAGAL (bug server Moodle `assign::save_editor_draft_files(): Return value must be of type string, null returned`, HTTP 404) — creation via Playwright UI seperti quiz task-003; pola ini simpan sebagai pitfall baru WORKFLOW.
  - P04 grade `none` bukan 0 poin, sesuai "tanpa nilai"; kolom teks submission dipakai sbg field deklarasi/pernyataan AI (P02/P03: pernyataan tulis sendiri; P04: link repo Git).
  - Brief dilampirkan sbg file attachment intro (bukan link eksternal — dokumen penugasan hanya ada di repo, belum ada URL publik); deskripsi memuat ringkasan + link materi pendukung classroom.
  - Kegagalan pertama P04: required gradingduedate default masa depan vs due date → fix: pastikan `cutoffdate`/`gradingduedate` disabled saat fill.
- Open: brief penugasan belum punya URL publik (opsional: publish di classroom.fahrifirdaus.my.id lalu update link di deskripsi); comments submission plugin dibiarkan default aktif (tidak berdampak pada acceptance).
- 2026-09-13 Prisa: Verifikasi independen WS — 3 assignment (cm 16659-16661) di section 2/3/4, due date 18/25 Sep & 2 Okt sesuai ritme mingguan. → done.
