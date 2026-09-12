# AGENTS.md

Panduan kerja untuk AI coding agent di repo materi perkuliahan **Pemrograman Mobile (Flutter) — 20251**. Baca file ini sebelum mengubah apa pun.

## 1. Peta Repo & Peran

| Path | Peran | Boleh diubah? |
|---|---|---|
| `RPS PPB - 20251.md` | **Sumber kebenaran kurikulum** (16 pertemuan, Sub-CPMK, penilaian, strategi AI) | ❌ Jangan ubah tanpa instruksi eksplisit user |
| `modul-flutter/` | Modul utama semester ini, Markdown/frontmatter untuk website Astro | ✅ Area kerja utama |
| `starter-code/` | Starter/sample code Flutter per pertemuan | ✅ |
| `penugasan/` | Brief assignment, rubrik, capstone | ✅ |
| `moodle/` | Question bank XML + generator script | ✅ |
| `Ujian/` | UTS/UAS (live coding, rubrik demo) | ✅ |
| `modul-buku/` | Referensi format frontmatter (buku OOP TS semester lalu) | ❌ Hanya baca, jadikan pola |
| `modul-SA/` | Referensi paket remedial (struktur penugasan, aset Moodle) | ❌ Hanya baca |
| `Standar Pengembangan Materi PPB.md` | Standar proses lama — **terlalu rumit, akan disederhanakan** | ⚠️ Jangan tambah kompleksitas |
| `Standar Tutorial Koding PPB.md` | Standar aktif untuk format tutorial | Baca sebelum menulis modul |

## 2. Sumber Kebenaran & Prioritas

Saat menulis/merevisi konten, urutan kepatuhan:

1. **RPS** — topik, Sub-CPMK, praktikum, dan batasan AI per pertemuan harus konsisten dengan RPS.
2. **Standar Tutorial Koding** (Progressive Checkpoint pattern).
3. **Standar Pengembangan Materi** — ambil prinsipnya saja (alignment RPS, kode teruji, kompleksitas progresif); abaikan pipeline outline→handout→modul 3-file yang berat. Sekarang **satu modul `.md` per pertemuan** menggantikan pipeline itu.
4. Konvensi di file ini.

Konflik antar dokumen? Ikuti yang lebih tinggi, lalu sebutkan konfliknya ke user.

## 3. Format Modul (Markdown + Frontmatter)

Konten ditulis sebagai **Markdown biasa + YAML frontmatter** (`.md`), tanpa sintaks MDX/JSX. Project web Astro berada di repo terpisah — saat publish, script publish me-rename `.md` → `.mdx` dan meng-copy ke project Astro. Ikuti skema frontmatter persis seperti `modul-buku/` (file-file tersebut sudah dikonversi ke `.md`, isi tidak berubah).

**`index.md` (buku/parent):**
```yaml
---
title: 'Pemrograman Mobile dengan Flutter'
description: '...'
author: 'Kaqfa'
coverImage: '/default-book-cover.png'
publishDate: 2025-09-xx
category: 'Programming'
difficulty: 'beginner'        # beginner | intermediate | advanced
tags: ['Flutter', 'Dart', ...]
accessLevel: 'free'
estimatedReadTime: <total menit>
chapters: <jumlah>
bookType: 'multi-chapter'
status: 'draft'               # draft | published
prerequisites: ['OOP', 'Struktur Data', 'Basis Data']
learningOutcomes: ['...']
chapterList:                  # urut, slug harus cocok dengan nama file
  - slug: '01-intro-dart-fundamentals'
    title: '...'
    estimatedReadTime: 45
    description: '...'
---
```

**Bab per pertemuan `NN-slug.md`:**
```yaml
---
parentBook: 'pemrograman-mobile-flutter'   # konsisten satu nilai
chapterNumber: N
chapterSlug: 'NN-slug'                      # = nama file tanpa .md
title: '...'
description: '...'
estimatedReadTime: 45
objectives: ['...']                         # 3–5, terukur, selaras Sub-CPMK
nextChapter: 'NN-slug-berikutnya' | null
prevChapter: '...' | null
status: 'draft'
accessLevel: 'free'
---
```

Di bawah frontmatter, buka dengan blok kutipan konteks (Mata Kuliah / Minggu / Bagian / Bahasa: Dart 3.x), lalu: Capaian Pembelajaran → Prasyarat → konten.

## 4. Standar Konten Tutorial (wajib)

Inti `Standar Tutorial Koding PPB.md`:

- **Progressive Checkpoint**: 2–4 checkpoint per pertemuan. Setiap checkpoint **harus bisa di-run** dan punya validation checklist + estimasi waktu (15–60 menit).
- **Continuity**: satu aplikasi reference (**StudyTracker**) dibangun bertahap antar pertemuan. Checkpoint 2+ diawali recap ("Already have") + apa yang baru ("Will add"). Tidak menulis ulang kode pertemuan sebelumnya.
- **Struktur pertemuan**: header (Prerequisites, Final Outcome, Learning Goals) → checkpoints → Summary (What You Built, Key Concepts, Next Session Preview) → Troubleshooting.
- **Kode**: lengkap bisa dicopy, fokus jelaskan *why* bukan hanya *how*, nama variabel jelas.
- Error-First Learning & Generate-Analyze-Improve boleh dipakai sesuai kolom "AI Integration" RPS per pertemuan.

## 5. Flutter & Dart

- Standar pengajaran: **Flutter stable + Dart 3, null safety aktif**. Contoh kode harus lolos `flutter analyze`.
- Reference app: **StudyTracker** (assignment tracker) — dipakai dari P01 sampai P15. Backend contoh: **Supabase** via REST (`http`/`dio`), local DB: `sqflite` + `shared_preferences`, state: `setState` → Provider → BLoC/Riverpod (sesuai RPS).
- Struktur project contoh: `lib/models|services|screens|widgets|utils`.
- **Mahasiswa boleh pakai stack apa pun** untuk tugas/capstone. Modul tetap mengajarkan Flutter; brief tugas & rubrik jangan melarang stack lain — nilai outcome (fungsionalitas, arsitektur, kualitas), bukan pilihan teknologi.

## 6. Aset Moodle

- Assignment/quiz/exam **tidak ditaruh di modul** — buat di `penugasan/` (brief + rubrik, format Markdown) dan `moodle/` (bank soal).
- Bank soal: format **Moodle XML**, tipe `multichoice`, satu jawaban benar, kategori mengikuti pola `PPB/...` (lihat `modul-SA/05-Assessment/Panduan-Import-Moodle.md`).
- Kalau bank soal besar: buat generator script (Python/Node) sebagai sumber teks soal, XML adalah hasil build — jangan edit XML langsung.
- Setiap quiz *unlock* di Moodle: attempts unlimited, grading highest.

## 7. Integrasi AI dalam Materi (dari RPS)

Materi harus mencerminkan fase AI per periode:

| Minggu | Kebijakan AI di materi/tugas |
|---|---|
| 1–4 | AI untuk syntax & konsep; mahasiswa wajib pahami setiap saran AI |
| 5–8 | AI hanya debugging; core logic manual |
| 9–12 | AI untuk optimasi & arsitektur; desain tetap manual dulu |
| 13–16 | AI bebas + dokumentasi wajib (interaction log) |

Sertakan blok "AI Integration" di brief tugas bila relevan.

## 8. Konvensi Umum

- **Bahasa**: konten Bahasa Indonesia; istilah teknis & kode dalam bahasa aslinya. Balas chat memakai bahasa user.
- **Penamaan**: file modul `NN-slug.md` kebab-case (tanpa sintaks MDX di konten); berkas penilaian prefiks `P0X_`; direktori kebab-case atau PascalCase mengikuti yang sudah ada di folder terkait.
- **Git**: commit kecil, pesan deskriptif (boleh Bahasa Indonesia). Jangan commit `.DS_Store`, `node_modules/`, hasil build (sudah di `.gitignore`).
- **Done definition modul**: frontmatter valid, checkpoint semua bisa di-run, checklist ada, summary + troubleshooting ada, contoh kode lolos analyze, mapping Sub-CPMK jelas, dan (bila ada tugas) brief di `penugasan/` + quiz di `moodle/` sudah dibuat.

## 9. Todo Repo

- [ ] Inisialisasi `modul-flutter/index.md` + `01-intro-dart-fundamentals.md`
- [ ] Sederhanakan `Standar Pengembangan Materi PPB.md` jadi satu halaman ringkas
- [ ] Setup `starter-code/` P01 (template StudyTracker)
- [ ] Buat struktur `penugasan/` (8 assignment RPS + capstone milestones)
- [ ] Generator bank soal `moodle/`
- [ ] Siapkan soal UTS di `Ujian/UTS/`
