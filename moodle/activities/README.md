# Aktivitas Moodle per Pertemuan — PPB 20251

Siap copas. Tiap file = satu pertemuan: summary section + daftar aktivitas dengan teks pendek.

## Peta file

| Minggu | File | Fokus | Penilaian |
|---|---|---|---|
| P01 | [P01-intro-mobile.md](P01-intro-mobile.md) | Setup + paradigma mobile | Checklist env (tanpa nilai) |
| P02 | [P02-dart-deep-dive.md](P02-dart-deep-dive.md) | Dart OOP + async | Tugas P02 (7,5%) |
| P03 | [P03-flutter-fundamentals.md](P03-flutter-fundamentals.md) | Widget + navigasi | Tugas P03 (7,5%) |
| P04 | [P04-project-structure.md](P04-project-structure.md) | Build system + capstone start | Deklarasi (syarat G1) |
| P05 | [P05-material-design.md](P05-material-design.md) | Material Design + form | — |
| P06 | [P06-custom-widgets.md](P06-custom-widgets.md) | Custom widget + animasi | — |
| P07 | [P07-responsive-gate1.md](P07-responsive-gate1.md) | Responsif + gate | G1 (8%) + peer review 1 |
| P08 | [P08-uts.md](P08-uts.md) | UTS live coding + demo | UTS (15%) |
| P09 | [P09-rest-api.md](P09-rest-api.md) | REST API + Supabase | — |
| P10 | [P10-offline-gate2.md](P10-offline-gate2.md) | Offline-first + gate | G2 (10%) |
| P11 | [P11-state-management.md](P11-state-management.md) | Provider + state | — |
| P12 | [P12-testing.md](P12-testing.md) | Testing + TDD | — |
| P13 | [P13-platform-gate3.md](P13-platform-gate3.md) | Fitur perangkat + gate | G3 (12%) + peer review 2 |
| P14 | [P14-performance.md](P14-performance.md) | Profiling + optimasi | — |
| P15 | [P15-deployment-gate4.md](P15-deployment-gate4.md) | Rilis + gate | G4 (10%) |
| P16 | [P16-uas.md](P16-uas.md) | UAS presentasi final | UAS (20%) |

## Konvensi

- Satu section Moodle per minggu; summary dari tiap file.
- Materi: link ke web kelas `https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/<slug>`.
- Starter: **File zip** hasil `python3 ../pack_starters.py`, bukan URL GitHub. Restrict: quiz pertemuan sebelumnya ≥80% (P01 terbuka; P09 dibuka Quiz P07).
- Quiz: bank `../build/Moodle-Question-Bank.xml`, kategori `PPB/P0N`, 10 soal, config standar (lihat `../README.md`).
- Assignment hanya di minggu beraudit; brief lengkap di `../../penugasan/` dilampirkan ke assignment.

## Checklist dosen awal semester

Status per 2026-09-14 — pengerjaan otomatis sudah selesai (audit: `.kanban-evidence/task-009/`, matrix 69/69):

1. ~~Import bank soal (140 soal, 14 kategori).~~ ✅ done — 140 soal ber-tag, kategori `PPB/P01`–`PPB/P15`
2. ~~Jalankan `python3 ../pack_starters.py`; unggah zip per section + set restrict.~~ ✅ done — 14 zip terunggah, restrict 13/13 terpasang
3. ~~Buat 16 section, tempel summary + aktivitas per file.~~ ✅ done — 17 section final (incl. General), aktivitas sesuai file PXX
4. ~~Set quiz config + restrict berantai.~~ ✅ done — 14/14 config standar terverifikasi
5. ~~Lampirkan brief penugasan ke assignment terkait.~~ ✅ done — P02/P03/P04, G1–G4, UTS/UAS, peer review P07/P13
6. ~~Sembunyikan section minggu mendatang sampai minggu berjalan.~~ ✅ done — P01–P02 visible, sisanya hidden

**Tersisa manual (di luar otomasi):**

- [ ] Import/isi kalender course — deadline gate G1–G4, UTS, UAS
- [ ] Gradebook: kategori + bobot nilai (lihat `../../penugasan/README.md`; quiz 0%)
- [ ] Buka section tiap minggu berjalan
- [ ] Push repo (manual user)
