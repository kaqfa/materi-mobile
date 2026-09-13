# Penugasan — Pemrograman Mobile 20251

Sumber kebenaran penugasan mata kuliah. Brief lengkap + rubrik dibuat di sini, dipublikasikan & dikumpulkan via **Moodle**. Acuan capaian: `../RPS PPB - 20251.md`. Materi pendukung: `../modul-buku/`.

## Filosofi

1. **Tugas individu hanya di awal** (P02–P03): pastikan skill Dart/Flutter dasar tiap mahasiswa solid sebelum bebas memilih stack di capstone.
2. **Capstone individual, termasuk progresnya.** RPS tidak pernah menyebut tim; kolaborasi dipenuhi lewat peer review, bukan lewat pembagian kerja.
3. **Yang dinilai repo, bukan laporan tentang repo.** Tidak ada dokumen penyerahan terpisah. Empat gate berjarak tiga minggu, bentuk penyerahannya identik: tag + satu blok CHANGELOG + demo yang disampel.
4. **Akuntabilitas mingguan lewat quiz unlock** (auto-grade Moodle): syarat masuk gate, bukan komponen nilai tersendiri.
5. **Stack bebas**: mahasiswa boleh pakai bahasa/framework/tools apa pun untuk capstone (rubrik menilai outcome, bukan stack). Modul (`modul-buku/`) tetap Flutter.
6. **AI: deklarasi, bukan larangan.** Pembatasan fase hanya di P02–P03 (tugas individu, bisa diverifikasi langsung). Di capstone AI bebas dipakai tetapi wajib dideklarasikan, dan diverifikasi lewat demo — bukan lewat aturan yang tidak bisa ditegakkan. Lihat `capstone/README.md`.

## Struktur Direktori

```
penugasan/
├── README.md                 # dokumen ini — kalender + pemetaan bobot
├── individu/                 # tugas individu (2)
│   ├── P02_Dart-OOP-Challenge.md
│   └── P03_Flutter-Mini-App.md
├── capstone/
│   ├── README.md             # panduan umum: domain, gate, rubrik, aturan AI
│   ├── G1_Fondasi.md         # P07 — UI + responsif
│   ├── G2_Data.md            # P10 — REST + lokal + offline
│   ├── G3_Arsitektur-Kualitas.md  # P13 — state + test + fitur perangkat
│   └── G4_Rilis.md           # P15 — optimasi + signed build + dokumentasi
└── peer-review/
    └── README.md             # 2 siklus review (menempel G1 & G3) + form
```

## Kalender Penugasan

| Periode | Artefak | Jenis | Graded? |
|---|---|---|---|
| P01 | Checklist environment + quiz diagnostik | individu | ❌ (gate masuk kelas) |
| **P02** | **Dart OOP Challenge** — model domain Dart: class, inheritance, mixin, null safety | individu | ✅ |
| **P03** | **Flutter Mini App** — app 3 screen: navigasi, StatefulWidget, setState | individu | ✅ |
| P04 | Capstone: **Deklarasi Proyek** (1 halaman) | individu | ❌ syarat ikut G1 |
| **P07** | Capstone **G1 — Fondasi**: UI utuh, navigasi, 3 konfigurasi layar | individu | ✅ 8% |
| — | **UTS**: live coding 60' + demo StudyTracker + progres capstone | individu | ✅ 15% |
| **P10** | Capstone **G2 — Data**: REST API + penyimpanan lokal + offline | individu | ✅ 10% |
| **P13** | Capstone **G3 — Arsitektur & Kualitas**: state terpusat + test + ≥2 fitur perangkat | individu | ✅ 12% |
| **P15** | Capstone **G4 — Rilis**: profiling + signed build + dokumentasi | individu | ✅ 10% |
| — | **UAS**: presentasi 20' + technical demo + Q&A | individu | ✅ 20% |
| tiap minggu | Quiz unlock modul (Moodle, ~10 soal, unlimited attempt) | individu | ❌ syarat masuk gate |
| sebelum G1 & G3 | Peer code review terstruktur (2 siklus) | individu | ✅ 5% |

Progres antar-gate tidak dinilai terpisah. Syarat masuk gate: ada commit di minimal tiga minggu berbeda sejak gate sebelumnya (dicek dari grafik contributor, bukan dari isi commit).

Demo lisan **disampel**: tiap gate sekitar sepertiga kelas dipanggil, diundi di tempat saat sesi dimulai. Semua harus siap setiap gate; setiap mahasiswa dipanggil minimal sekali sepanjang semester. Sisanya dinilai dari repo + CHANGELOG.

## Pemetaan Bobot RPS

| Komponen RPS | Bobot | Realisasi di sini |
|---|---|---|
| Weekly Assignments | 15% | 2 tugas individu (P02 + P03), masing-masing 7,5% |
| Capstone Development | 40% | G1 8% + G2 10% + G3 12% + G4 10% (rincian di `capstone/README.md`) |
| Peer Code Review | 5% | 2 siklus (`peer-review/README.md`) |
| UTS | 15% | soal di `../Ujian/UTS/` |
| UAS | 20% | presentasi final + `../Ujian/UAS/` |
| AI Integration Portfolio | 5% | butir "AI" di CHANGELOG tiap gate — tanpa dokumen tambahan |

Quiz mingguan tidak lagi memegang bobot; fungsinya (memaksa baca modul) tetap tercapai sebagai syarat masuk gate, tanpa 16 ritual bernilai.

## Relasi ke 8 Assignment Resmi RPS

| Assignment RPS | Estimasi | jatuh ke |
|---|---|---|
| Dart OOP Challenge (Sub-CPMK53.1) | 3×50' | `individu/P02` |
| Flutter Mini App (Sub-CPMK53.1) | 3×50' | `individu/P03` |
| UI Design System (Sub-CPMK92.1) | 3×50' | capstone G1 |
| Responsive Layout Showcase (Sub-CPMK92.1) | 3×50' | capstone G1 |
| Backend Integration Sprint (Sub-CPMK53.2) | 3×50' | capstone G2 |
| Native Feature Integration (Sub-CPMK92.2) | 3×50' | capstone G3 |
| Quality Assurance Portfolio (Sub-CPMK92.2) | 3×50' | capstone G3 |
| Release-Ready Build (Sub-CPMK53.2) | 3×50' | capstone G4 |

Delapan assignment RPS dipadatkan ke empat gate: G1 dan G3 masing-masing menampung dua assignment yang sejalan. Estimasi total tetap 3×50' per gate per mahasiswa.

## Aturan Umum Capstone (ringkas)

- **Individual**; domain salah satu dari: Local Business Solutions / EdTech / Health & Wellness (RPS).
- Topik capstone **berbeda** dari StudyTracker (modul) — capstone menilai transfer of learning.
- Stack bebas; keputusan teknologi dideklarasikan di P04 dan dibenarkan saat gate.
- Tidak bisa menjelaskan kode sendiri saat ditanya → dimensi Arsitektur dan Ketahanan nol, terlepas dari siapa yang menulisnya.
- AI bebas dipakai di capstone, wajib dideklarasikan di CHANGELOG. Pembatasan fase hanya berlaku di P02–P03.

Rincian lengkap: [`capstone/README.md`](capstone/README.md).

## Status

- [x] Kalender + pemetaan bobot (dokumen ini)
- [x] `capstone/README.md` — panduan umum, rubrik 4 dimensi, aturan AI
- [x] `capstone/G1_Fondasi.md`
- [ ] `individu/P02_Dart-OOP-Challenge.md` (brief + rubrik)
- [ ] `individu/P03_Flutter-Mini-App.md` (brief + rubrik)
- [ ] `capstone/G2`, `G3`, `G4` (dibuat min. 2 minggu sebelum dipakai)
- [ ] `peer-review/README.md` — form review 2 siklus
- [ ] Quiz bank → `../moodle/` (generator, kategori `PPB/PXX`)
