# AGENTS.md

Panduan kerja untuk AI coding agent di repo materi perkuliahan **Pemrograman Mobile (Flutter) — 20251**. Baca file ini sebelum mengubah apa pun.

## 1. Peta Repo & Peran

| Path | Peran | Boleh diubah? |
|---|---|---|
| `RPS PPB - 20251.md` | **Sumber kebenaran kurikulum** (16 pertemuan, Sub-CPMK, penilaian, strategi AI) | ❌ Jangan ubah tanpa instruksi eksplisit user |
| `modul-buku/` | **Modul utama** — buku "Pemrograman Mobile dengan Flutter" (14 bab, `.md`), salinan konten dari project web Astro (repo terpisah) | ✅ Area kerja utama |
| `starter-code/` | [RENCANA] Starter/sample code Flutter per pertemuan | ✅ (belum ada, buat baru) |
| `penugasan/` | Kalender penugasan + pemetaan bobot RPS (`README.md`); brief individu/capstone/peer-review menyusul | ✅ |
| `moodle/` | [RENCANA] Question bank XML + generator script | ✅ (belum ada, buat baru) |
| `Ujian/` | UTS/UAS (live coding, rubrik demo) | ✅ |
| `modul-SA/` | Referensi paket remedial (struktur penugasan, aset Moodle) | ❌ Hanya baca |
| `Standar Pengembangan Materi PPB.md` | Standar proses lama — **terlalu rumit, akan disederhanakan** | ⚠️ Jangan tambah kompleksitas |
| `Standar Tutorial Koding PPB.md` | Standar aktif untuk format tutorial | Baca sebelum menulis modul |

## 2. Kebijakan Revisi Modul

Materi semester kemarin di `modul-buku/` **sudah cukup baik** — jangan rewrite. Perbaikan bersifat **inkremental** (perbaikan kecil per bab), dengan dua aturan:

1. **RPS 20251 = acuan capaian.** Bila isi bab menyimpang dari RPS (topik hilang, urutan beda, penekanan beda), bab tersebut perlu direvisi agar selaras.
2. **Bab buku ≠ pertemuan 1:1.** Buku = materi belajar mandiri (14 bab); ritme kelas, praktikum, dan penilaian ikut RPS (16 pertemuan). Jangan paksa 1 bab = 1 pertemuan.

Daftar gap modul vs RPS saat ini ada di `README.md` (section "Gap modul vs RPS") — kerjakan dari sana.

## 3. Sumber Kebenaran & Prioritas

Saat menulis/merevisi konten, urutan kepatuhan:

1. **RPS** — topik, Sub-CPMK, praktikum, dan batasan AI per pertemuan harus konsisten dengan RPS.
2. **Standar Tutorial Koding** (Progressive Checkpoint pattern).
3. **Standar Pengembangan Materi** — ambil prinsipnya saja (alignment RPS, kode teruji, kompleksitas progresif); abaikan pipeline outline→handout→modul 3-file yang berat. Buku multi-bab di `modul-buku/` menggantikan pipeline itu.
4. Konvensi di file ini.

Konflik antar dokumen? Ikuti yang lebih tinggi, lalu sebutkan konfliknya ke user.

## 4. Format Modul (Markdown + Frontmatter)

Konten ditulis sebagai **Markdown biasa + YAML frontmatter** (`.md`), tanpa sintaks MDX/JSX. Project web Astro berada di repo terpisah — repo ini sumber kebenaran konten; saat publish, script publish me-rename `.md` → `.mdx` dan meng-copy ke project Astro.

Skema mengikuti yang sudah ada di `modul-buku/` (buku aktif). Contoh nilai nyata:

**`index.md` (buku/parent):**
```yaml
---
title: 'Pemrograman Mobile dengan Flutter'
description: '...'
author: 'Kaqfa'
coverImage: '/flutter-book-cover.png'
publishDate: 2024-09-18
updateDate: 2026-09-03            # update saat revisi bab
category: 'Programming'
difficulty: 'intermediate'
tags: ['flutter', 'dart', 'mobile', 'programming']
accessLevel: 'free'
estimatedReadTime: 10
chapters: 14
bookType: 'multi-chapter'
status: 'published'
prerequisites: ['...']
learningOutcomes: ['...']
---
```

**Bab `NN-slug.md`:**
```yaml
---
title: '...'
description: '...'
author: 'Kaqfa'
publishDate: 2024-09-18
category: 'Programming'
difficulty: 'beginner'
tags: ['flutter', 'dart', ...]
accessLevel: 'free'
estimatedReadTime: 25
status: 'published'
chapterNumber: N
chapterSlug: 'NN-slug'           # = nama file tanpa .md
parentBook: 'pemrograman-flutter'  # konsisten satu nilai
objectives: ['...']              # 3–5, terukur, selaras Sub-CPMK
nextChapter: 'NN-slug-berikutnya' | null
prevChapter: '...' | null
---
```

Saat merevisi bab: update `updateDate` (index) bila perubahan signifikan, jaga `nextChapter`/`prevChapter` tetap valid.

## 5. Standar Konten Tutorial (wajib)

Inti `Standar Tutorial Koding PPB.md`:

- **Progressive Checkpoint**: 2–4 checkpoint per bab. Setiap checkpoint **harus bisa di-run** dan punya validation checklist + estimasi waktu (15–60 menit).
- **Continuity**: satu aplikasi reference (**StudyTracker/Task Tracker**) dibangun bertahap antar bab. Checkpoint 2+ diawali recap ("Already have") + apa yang baru ("Will add"). Tidak menulis ulang kode bab sebelumnya.
- **Struktur bab**: header (Prerequisites, Final Outcome, Learning Goals) → checkpoints → Summary (What You Built, Key Concepts, Next Session Preview) → Troubleshooting.
- **Kode**: lengkap bisa dicopy, fokus jelaskan *why* bukan hanya *how*, nama variabel jelas.
- Error-First Learning & Generate-Analyze-Improve boleh dipakai sesuai kolom "AI Integration" RPS per pertemuan.

Catatan: bab-bab lama mungkin belum mengikuti pola checkpoint penuh — saat revisi bab, condongkan ke pola ini secara bertahap, jangan rewrite sekali jalan.

## 6. Flutter & Dart

- Standar pengajaran: **Flutter stable + Dart 3, null safety aktif**. Contoh kode harus lolos `flutter analyze`.
- Reference app: **StudyTracker** (task/study tracker) — dipakai dari bab 3 sampai 14. Backend contoh: **Supabase** via REST (`http`/`dio`), local DB: `sqflite` + `shared_preferences`, state: `setState` → Provider (BLoC/Riverpod hanya pembanding, sesuai RPS P11).
- Baseline versi & catatan deployment mengikuti section "Baseline Versi" di `modul-buku/index.md`.
- Struktur project contoh: `lib/models|services|screens|widgets|utils`.
- **Mahasiswa boleh pakai stack apa pun** untuk tugas/capstone. Modul tetap mengajarkan Flutter; brief tugas & rubrik jangan melarang stack lain — nilai outcome (fungsionalitas, arsitektur, kualitas), bukan pilihan teknologi.

## 7. Aset Moodle

- Assignment/quiz/exam **tidak ditaruh di modul** — buat di `penugasan/` (brief + rubrik, format Markdown) dan `moodle/` (bank soal).
- Bank soal: format **Moodle XML**, tipe `multichoice`, satu jawaban benar, kategori mengikuti pola `PPB/...` (lihat `modul-SA/05-Assessment/Panduan-Import-Moodle.md`).
- Kalau bank soal besar: buat generator script (Python/Node) sebagai sumber teks soal, XML adalah hasil build — jangan edit XML langsung.
- Setiap quiz *unlock* di Moodle: attempts unlimited, grading highest.

## 8. Integrasi AI dalam Materi (dari RPS)

Materi harus mencerminkan fase AI per periode:

| Minggu | Kebijakan AI di materi/tugas |
|---|---|
| 1–4 | AI untuk syntax & konsep; mahasiswa wajib pahami setiap saran AI |
| 5–8 | AI hanya debugging; core logic manual |
| 9–12 | AI untuk optimasi & arsitektur; desain tetap manual dulu |
| 13–16 | AI bebas + dokumentasi wajib (interaction log) |

Sertakan blok "AI Integration" di brief tugas bila relevan.

## 9. Konvensi Umum

- **Bahasa**: konten Bahasa Indonesia; istilah teknis & kode dalam bahasa aslinya. Balas chat memakai bahasa user.
- **Penamaan**: file bab `NN-slug.md` kebab-case (tanpa sintaks MDX di konten); berkas penilaian prefiks `P0X_`; direktori kebab-case atau PascalCase mengikuti yang sudah ada di folder terkait.
- **Git**: commit kecil, pesan deskriptif (boleh Bahasa Indonesia). Jangan commit `.DS_Store`, `node_modules/`, hasil build (sudah di `.gitignore`).
- **Done definition modul**: frontmatter valid, checkpoint semua bisa di-run, checklist ada, summary + troubleshooting ada, contoh kode lolos analyze, mapping Sub-CPMK jelas, dan (bila ada tugas) brief di `penugasan/` + quiz di `moodle/` sudah dibuat.

## 10. Todo Repo

- [ ] Audit gap modul vs RPS (daftar di README) — responsive/adaptive, Supabase, realtime, BLoC/Riverpod, blok AI per bab
- [ ] Commit hasil konversi `.mdx` → `.md` + dokumen repo
- [ ] Sederhanakan `Standar Pengembangan Materi PPB.md` jadi satu halaman ringkas
- [ ] Setup `starter-code/` (template StudyTracker per bab)
- [x] Kalender penugasan + pemetaan bobot RPS (`penugasan/README.md`)
- [ ] Brief `penugasan/capstone/README.md` (panduan umum + bobot per milestone)
- [ ] Brief tugas individu P02 + P03 (rubrik)
- [ ] Brief milestone capstone M0 (proposal) — prioritas, dipakai P04
- [ ] Generator bank soal `moodle/`
- [ ] Siapkan soal UTS di `Ujian/UTS/`
