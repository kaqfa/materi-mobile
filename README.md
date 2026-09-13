# Materi-Mobile

Repositori pengembangan materi perkuliahan **Pemrograman Mobile (Perangkat Bergerak)** berbasis **Flutter** — semester 20251, 16 pertemuan, dengan capstone project sebagai tulang punggung penilaian.

> **Repo:** https://github.com/kaqfa/materi-mobile

---

## Arsitektur Pembelajaran

| Komponen | Platform | Isi |
|---|---|---|
| **Materi/modul utama** | Website **Astro** | Modul per pertemuan (Markdown + frontmatter, `.md`), buku multi-chapter, bisa dibaca mandiri |
| **Assignment, quiz, penilaian** | **Moodle** | Brief tugas, question bank (XML), rubrik, pengumpulan & grading |

Semua konten materi disusun **di repo ini** sebagai sumber kebenaran, lalu dipublikasikan ke platform masing-masing.

### Prinsip kurikulum

- **Standar pengajaran: Flutter + Dart.** Semua modul, contoh kode, dan praktikum memakai Flutter (reference app: **StudyTracker**).
- **Stack bebas untuk mahasiswa.** Dalam mengerjakan assignment dan proyek akhir, mahasiswa boleh memakai bahasa, framework, dan tools apa pun — rubrik menilai *outcome*, bukan stack.
- **Capstone incremental** sepanjang semester (mulai P04), domain: Local Business Solutions / EdTech / Health & Wellness.
- **Integrasi AI progresif**: batasan penggunaan AI menyesuaikan fase semester (lihat RPS).
- **Modul lama dipertahankan, direvisi bertahap.** Materi semester kemarin di `modul-buku/` sudah cukup baik — improve sedikit demi sedikit, bukan rewrite. Acuan capaian tetap **RPS 20251**: materi yang menyimpang dari RPS wajib direvisi.

---

## Struktur Repo

```
.
├── README.md                      # Dokumen ini
├── AGENTS.md                      # Panduan untuk AI coding agent
├── RPS PPB - 20251.md             # SUMBER KEBENARAN kurikulum (16 pertemuan, Sub-CPMK, penilaian)
├── Standar Pengembangan Materi PPB.md   # Standar proses (legacy — akan disederhanakan)
├── Standar Tutorial Koding PPB.md       # Standar format tutorial (Progressive Checkpoint)
│
├── modul-buku/                    # [AKTIF] MODUL UTAMA — buku "Pemrograman Mobile dengan Flutter" (14 bab, .md)
├── Ujian/                         # [AKTIF] UTS/UAS — soal live coding, rubrik demo
├── starter-code/                  # [AKTIF] Starter & sample code Flutter per pertemuan (14 project)
├── penugasan/                     # [AKTIF] Kalender penugasan + brief assignment, rubrik, capstone (publikasi via Moodle)
├── moodle/                        # [AKTIF] Generator bank soal (140 soal) + kunci dosen + aktivitas Moodle per pertemuan
│
└── modul-SA/                      # [REFERENSI] Paket remedial 7 pertemuan — acuan struktur penugasan & aset Moodle
```

`modul-buku/` berisi salinan konten dari project web Astro (repo terpisah). Repo ini = sumber kebenaran konten; perubahan di sini lalu disalin/sync ke project Astro.

---

## Pipeline Pengembangan Materi

```mermaid
graph LR
    A[RPS PPB - 20251.md] --> B[Outline singkat]
    B --> C[Buku .md - modul-buku/]
    C --> D[Starter code - starter-code/]
    C --> E[Brief tugas - penugasan/]
    E --> F[Quiz XML - moodle/]
    C --> G[Publish ke website Astro]
    F --> H[Import ke Moodle]
```

1. **RPS dulu.** Setiap bab harus nyambung ke pertemuan + Sub-CPMK di RPS. Bab buku **tidak 1:1 dengan pertemuan** — RPS tetap acuan ritme kelas; bab buku = materi belajar mandiri.
2. **Modul `.md`** di `modul-buku/` mengikuti skema frontmatter yang sudah ada dan standar tutorial **Progressive Checkpoint** (2–4 checkpoint per bab, setiap checkpoint bisa di-run).
3. **Aset penilaian** (brief tugas, rubrik, bank soal) dibuat di repo, dipublikasikan ke Moodle.
4. Detail aturan pengembangan: lihat `AGENTS.md` dan dua file standar.

---

## Isi Buku Utama (`modul-buku/`, 14 bab)

| Bab | Judul | Status |
|---|---|---|
| 01 | Dart Fundamentals | ✅ published |
| 02 | Dart Deep Dive | ✅ |
| 03 | Flutter Fundamentals | ✅ |
| 04 | Build System & Project Structure | ✅ |
| 05 | Material Design Implementation | ✅ |
| 06 | Advanced UI & Custom Widgets | ✅ |
| 07 | State Management & SharedPreferences | ✅ |
| 08 | Local Storage & Databases | ✅ |
| 09 | REST API Integration | ✅ |
| 10 | Offline-First & SQLite | ✅ |
| 11 | Testing & Quality Assurance | ✅ |
| 12 | Platform Features & Device Integration | ✅ |
| 13 | Performance Optimization | ✅ |
| 14 | Deployment & Distribution | ✅ |

Semua bab berstatus `published` di frontmatter. Revisi berjalan inkremental (perbaikan kecil per bab).

### Pemetaan RPS ↔ Bab

Bab buku tidak 1:1 dengan pertemuan; sejak P11 penomorannya bergeser satu langkah. Tabel ini acuannya.

| Pertemuan RPS | Topik | Bab | Status |
|---|---|---|---|
| P01–P06 | Dart, widget, build system, Material 3, custom widget | 01–06 | ✅ |
| P07 | Responsive & adaptive layout | 05 (Checkpoint 2–3) | ✅ |
| P09 | API integration (Supabase via REST) | 09 | ✅ |
| P10 | Real-time & advanced API | 10 | ✅ |
| P11 | Advanced state management | 07 (bagian "Arah Setelah Provider") | ✅ |
| P12 | Testing & QA | 11 | ✅ |
| P13 | Platform features | 12 | ✅ |
| P14 | Performance optimization | 13 | ✅ |
| P15 | Deployment | 14 | ✅ |

Semua gap hasil audit sudah ditutup; riwayat temuan dan alasan tiap keputusan tersimpan di [`AUDIT-Gap-Modul-vs-RPS.md`](AUDIT-Gap-Modul-vs-RPS.md). Blok **"Bekerja dengan AI di Bab Ini"** kini ada di keempat belas bab.

Yang masih terbuka di repo: penyederhanaan `Standar Pengembangan Materi PPB.md`.

## Starter Code & Bank Soal

- **`starter-code/`** — 14 project Flutter (P01–P07, P09–P15), tanpa folder platform (mahasiswa menjalankan `flutter create .` sekali; pola `modul-SA/06-Starter-Code`). Semua lolos `flutter pub get` + `flutter analyze` (0 issue), baseline Flutter 3.38 / lints ^4. Sebagian test sengaja merah (p02, p12) sebagai bahan TDD.
- **`moodle/`** — generator `build_moodle_xml.py` + sumber `bank_soal.py`: 140 soal praktis (10 × 14 pertemuan, kategori `PPB/P01`…`PPB/P15`), potongan kode di soal/jawaban, kunci divalidasi tidak lebih panjang dari distraktor. Output: XML (build, tergitignore) + `Kunci-Jawaban.md` (dosen) + `activities/` (narasi & aktivitas Moodle per pertemuan, siap copas).

## Penilaian

Capstone **individual** sepanjang semester, empat gate berjarak tiga minggu (P07, P10, P13, P15). Bentuk penyerahan tiap gate identik: tag di repo, satu blok `CHANGELOG.md`, dan video demo lima menit. Tidak ada laporan terpisah.

Aturan AI: pembatasan hanya di tugas individu P02–P03; di capstone AI bebas dipakai tetapi wajib dideklarasikan, dan diverifikasi lewat demo. Rincian di [`penugasan/`](penugasan/README.md).

## Konvensi

- **Bahasa**: konten Indonesia, istilah teknis Inggris dibiarkan (widget, state, dsb.).
- **Penamaan berkas**: bab buku `NN-slug.md` (kebab-case, `NN` = nomor bab); aset penilaian pakai prefiks `P0X_`. Saat publish ke web Astro, script publish me-rename ke `.mdx`.
- **Contoh kode Flutter**: harus lolos `flutter analyze`, null safety aktif.
- **Git**: commit kecil dengan pesan deskriptif; hasil build, `node_modules/`, `.DS_Store` tidak di-commit (lihat `.gitignore`).

## referensi cepat

- RPS lengkap (Sub-CPMK, breakdown nilai, strategi AI): `RPS PPB - 20251.md`
- Format tutorial: `Standar Tutorial Koding PPB.md`
- Contoh modul jadi: `modul-buku/01-dart-fundamentals.md`
- Contoh alur Moodle: `modul-SA/05-Assessment/Panduan-Import-Moodle.md`
