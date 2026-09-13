---
id: task-004
title: "Restrict access berantai quiz→minggu berikutnya"
status: done
priority: 80
assignee: pi
created_at: 2026-09-13
updated_at: 2026-09-13
tags: [moodle, restriction]

depends: task-002, task-003
---
# Restrict access berantai quiz→minggu berikutnya

## Goal
Rantai gerbang aktif: starter/materi P0N terbuka hanya jika quiz P0(N-1) ≥80%; P01 terbuka; starter P09 dibuka quiz P07.

## Context
Kebijakan: moodle/README.md 'Mengaktifkan gerbang (restrict access)'. Pengecualian: starter P01 tanpa syarat; starter P09 pakai Quiz P07 (P08 UTS tanpa quiz).

Baca WAJIB sebelum mulai: `.agents/kanban/WORKFLOW.md` (aturan keras no-DB-access, session Playwright, pitfall teknis terbukti).

## Scope
**Included**: Edit settings tiap modul starter (dan materi P0N bila rancangan mensyaratkan) → Restrict access → Grade restriction: quiz sebelumnya must be ≥ 80%, ikon mata (eye) ditampilkan.

**Excluded**: Gate capstone (assignment G1–G4) — syaratnya dari penugasan, task-005.

## Acceptance Criteria
- [x] Settings modul starter P0N (UI) menampilkan kondisi Grade ≥80% pada quiz P0(N-1) dengan ikon mata terlihat
- [x] Mahasiswa test-view (jika akun tersedia) melihat starter terkunci sebelum lulus quiz — atau minimal evidence settings + screenshot
- [x] Starter P01 tanpa kondisi; starter P09 terikat Quiz P07

## Verification Commands
```bash
# Read-only WS (token ~/.kulino-admin/ws_token) — contoh:
curl -s https://kulino.dinus.ac.id/webservice/rest/server.php \
  -d wstoken=$(cat ~/.kulino-admin/ws_token) \
  -d wsfunction=core_course_get_contents -d courseid=21 -d moodlewsrestformat=json | python3 -m json.tool | head -80
# Screenshot evidence → .kanban-evidence/task-004/ (gitignored)
```

## Implementation Notes
- Playwright sync API; session cookie dari `~/.kulino-admin/session.txt`.
- Course id=21. qbank cmid=2180. Kategori soal PPB/PXX.
- Jangan pernah print token/cookie ke log.

## Activity Log
- 2026-09-13 Prisa: created task.
- 2026-09-13 Pi: gerbang aktif 13/13 via UI modedit (Playwright, session admin). availabilityconditionsjson re-read 2×: semua `{"op":"&","c":[{"type":"grade","id":<gi>,"min":80}],"showc":[true]}`; P01 kosong. Evidence `.kanban-evidence/task-004/` (13 screenshot restriction-ui + P01-no-restriction + course-view lock + verify-summary.txt). moved to review.

## Pi Handoff
- Changed: Moodle Kulino course 21 (remote, via UI Playwright — bukan file repo). Repo lokal hanya `.kanban-evidence/task-004/` (gitignored) + task file ini. 13 modul starter (P02–P07, P09–P15) diberi Grade restriction `must be ≥ 80` pada quiz pekan sebelumnya; grade item id dipetakan via WS read-only `core_grades_get_gradeitems` (Quiz P01=953 … P15=967).
- Chain: P02←Quiz P01(953), P03←Quiz P02(955), P04←956, P05←957, P06←958, P07←959, **P09←Quiz P07(960)** (P08 UTS), P10←961, P11←962, P12←963, P13←964, P14←965, P15←966. Starter P01 (cmid 16586) tanpa kondisi (JSON kosong, terverifikasi).
- Tests: (1) re-read modedit ×13 pasca-save → JSON persis target, `showc:[true]` (mata terbuka); (2) course view → 13/13 starter tampil "Not available unless: You achieve higher than a certain score in <nama quiz>" (nama quiz tampil = eye open), P01 tanpa availabilityinfo; (3) screenshot UI 13 modul + P01 + course-view P02/P09. Log: `gate-run.log`, ringkasan `verify-summary.txt`.
- Decisions: (1) grade condition pakai persentase min=80 (quiz skala 10, gradepass 8 — 80% ≈ 8/10, konsisten README); (2) label mahasiswa Moodle memakai wording default "higher than a certain score in <nama quiz>" — angka % tidak pernah ditampilkan Moodle ke mahasiswa (privasi), syarat 80% tersimpan di kondisi; (3) mata dibiarkan terbuka (showc=true) agar mahasiswa tahu gerbang apa yang membuka; (4) akun test-mahasiswa tidak tersedia → AC2 dipenuhi via opsi evidence settings + screenshot.
- Pitfall teknis (untuk task berikut yang sentuh availability): form grade Moodle 4.5 Kulino — `minval` disabled sampai checkbox `name="min"` di-`.check()` real; select grade item via JS `sel.value` + dispatch `change`; dialog Add restriction = YUI `.moodle-dialogue-wrap` (bukan modal Bootstrap), timing flaky → poll + re-click ≤4×.
- Open: (a) gate capstone G1–G4 (assignment) = task-005 scope, belum; (b) section P03–P16 masih hidden (stage visibility, task lain); (c) materi P0N (URL) sengaja TIDAK digerbangi — rantai di starter saja, sesuai Scope task ini.
- 2026-09-13 Prisa: Verifikasi independen WS — 13/13 Starter P02-P15 gated "achieve higher than certain score" ke quiz sebelumnya (P09→Quiz P07 benar, P08=UTS); Starter P01 tanpa gate. → done.
