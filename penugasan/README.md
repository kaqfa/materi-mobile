# Penugasan — Pemrograman Mobile 20251

Sumber kebenaran penugasan mata kuliah. Brief lengkap + rubrik dibuat di sini, dipublikasikan & dikumpulkan via **Moodle**. Acuan capaian: `../RPS PPB - 20251.md`. Materi pendukung: `../modul-buku/`.

## Filosofi

1. **Tugas individu hanya di awal** (P02–P03): pastikan skill Dart/Flutter dasar tiap mahasiswa solid sebelum bebas memilih stack di capstone — mencegah free-rider terdeteksi terlambat.
2. **Setelah P04, capstone mengambil alih**: pekerjaan mingguan mahasiswa = capstone incremental. Graded gate tiap ~2 minggu (sesuai "Quality Gates" RPS), progres antar-gate dicek ringan lewat commit.
3. **Akuntabilitas mingguan lewat quiz kecil** (auto-grade Moodle, pola unlock quiz): memaksa belajar modul tanpa menambah beban penilaian manual.
4. **Stack bebas**: mahasiswa boleh pakai bahasa/framework/tools apa pun untuk capstone (rubrik menilai outcome, bukan stack). Modul (`modul-buku/`) tetap Flutter.
5. **Aturan AI mengikuti fase RPS**: P1–4 syntax/konsep · P5–8 debugging saja · P9–12 optimasi/arsitektur · P13–16 bebas + wajib interaction log.

## Struktur Direktori

```
penugasan/
├── README.md                 # dokumen ini — kalender + pemetaan bobot
├── individu/                 # tugas individu (2)
│   ├── P02_Dart-OOP-Challenge.md
│   └── P03_Flutter-Mini-App.md
├── capstone/
│   ├── README.md             # panduan umum: domain, tim, stack bebas, quality gates
│   ├── M0_Proposal.md        # P04
│   ├── M1_UI-Foundation.md   # P05–P06 (UI Design System + Custom Widgets)
│   ├── M2_Responsive.md      # P07
│   ├── M3_Backend.md         # P09
│   ├── M4_Offline-Sync.md    # P10
│   ├── M5_State-Arch.md      # P11
│   ├── M6_Testing-QA.md      # P12
│   ├── M7_Native-Features.md # P13
│   ├── M8_Release-Ready.md   # P14
│   └── M9_Deploy-Final.md    # P15
└── peer-review/
    └── README.md             # 3 siklus review + form
```

## Kalender Penugasan

| Periode | Artefak | Jenis | Graded? |
|---|---|---|---|
| P01 | Checklist environment + quiz diagnostik | individu | ❌ (gate masuk kelas) |
| **P02** | **Dart OOP Challenge** — model domain Dart: class, inheritance, mixin, null safety | individu | ✅ |
| **P03** | **Flutter Mini App** — app 3 screen: navigasi, StatefulWidget, setState | individu | ✅ |
| P04 | Capstone **M0**: proposal (domain, wireframe, user flow, struktur folder) + initial structure | tim | ✅ gate |
| P05–P06 | Capstone **M1**: UI foundation — design system, custom widget library | tim | progres |
| P07 | Capstone **M2**: responsive showcase (3 konfigurasi layar) | tim | ✅ gate |
| — | **UTS**: live coding 60' + demo StudyTracker + progress capstone | individu | ✅ 15% |
| P09 | Capstone **M3**: backend integration sprint — REST API + auth + error handling | tim | ✅ gate |
| P10 | Capstone **M4**: offline-first + sync + conflict resolution | tim | progres |
| P11 | Capstone **M5**: refactor state management (arsitektur scalable) | tim | ✅ gate |
| P12 | Capstone **M6**: test suite — unit + widget, coverage ≥70% | tim | ✅ gate |
| P13 | Capstone **M7**: native features ≥2 (kamera/lokasi/sensor) + permission handling | tim | ✅ gate |
| P14 | Capstone **M8**: profiling + optimasi + signed release build terdokumentasi | tim | ✅ gate |
| P15 | Capstone **M9**: deployment prep + dokumentasi teknis + demo script | tim | ✅ gate |
| — | **UAS**: presentasi 20' + technical demo + Q&A | tim+individu | ✅ 20% |
| tiap minggu | Quiz unlock modul (Moodle, ~10 soal, unlimited attempt) | individu | ✅ kumulatif |
| setelah M1, M3, M5 | Peer code review terstruktur (3 siklus) | individu | ✅ 5% |

Progress antar-gate: demo singkat/commit check di praktikum (tidak masuk nilai terpisah, tapi syarat ikut gate berikutnya).

## Pemetaan Bobot RPS

| Komponen RPS | Bobot | Realisasi di sini |
|---|---|---|
| Weekly Assignments | 15% | 2 tugas individu (2×5%) + quiz mingguan (5%) |
| Capstone Development | 40% | M0 (4%) + M1–M9 gates (proporsional, rincian di `capstone/README.md`) |
| Peer Code Review | 5% | 3 siklus (`peer-review/README.md`) |
| UTS | 15% | soal di `../Ujian/UTS/` |
| UAS | 20% | presentasi final + `../Ujian/UAS/` |
| AI Integration Portfolio | 5% | interaction log terkumpul dari tugas individu + capstone |

Pembagian internal (mis. 2×5% + 5%) = proposal awal, bisa disesuaikan sebelum P02.

## Relasi ke 8 Assignment Resmi RPS

| Assignment RPS | Estimasi | jatuh ke |
|---|---|---|
| Dart OOP Challenge (Sub-CPMK53.1) | 3×50' | `individu/P02` |
| Flutter Mini App (Sub-CPMK53.1) | 3×50' | `individu/P03` |
| UI Design System (Sub-CPMK92.1) | 3×50' | capstone M1 |
| Responsive Layout Showcase (Sub-CPMK92.1) | 3×50' | capstone M2 |
| Backend Integration Sprint (Sub-CPMK53.2) | 3×50' | capstone M3 |
| Release-Ready Build (Sub-CPMK53.2) | 3×50' | capstone M8 |
| Native Feature Integration (Sub-CPMK92.2) | 3×50' | capstone M7 |
| Quality Assurance Portfolio (Sub-CPMK92.2) | 3×50' | capstone M6 |

Semua assignment capstone direalisasikan sebagai milestone tim — estimasi 3×50' per anggota.

## Aturan Umum Capstone (ringkas)

- Tim 3–4 orang; domain salah satu dari: Local Business Solutions / EdTech / Health & Wellness (RPS).
- Topik capstone **berbeda** dari StudyTracker (modul) — capstone menilai transfer of learning.
- Stack bebas; keputusan teknologi didokumentasikan di proposal + dibenarkan saat gate.
- Setiap anggota wajib bisa menjelaskan bagian mana pun saat demo (pertanyaan acak).
- AI: ikuti fase RPS; setiap interaksi tercatat di interaction log (template: `modul-SA/01-Orientasi/Template-AI-Interaction-Log.md`).

## Status

- [x] Kalender + pemetaan bobot (dokumen ini)
- [ ] `capstone/README.md` — panduan umum + rincian bobot per milestone
- [ ] `individu/P02_Dart-OOP-Challenge.md` (brief + rubrik)
- [ ] `individu/P03_Flutter-Mini-App.md` (brief + rubrik)
- [ ] M0–M9 briefs (mulai dari M0, dibuat min. 2 minggu sebelum dipakai)
- [ ] `peer-review/README.md` — form review 3 siklus
- [ ] Quiz bank → `../moodle/` (generator, kategori `PPB/PXX`)
