# Slide Kuliah PPB 20251

Slide presentasi per pertemuan, diturunkan dari `modul-buku/`. Ditulis dengan
[Marp](https://marp.app) — Markdown + CSS, satu sumber untuk HTML, PDF, dan PPTX.

## Kenapa Marp

Sumber materi sudah Markdown, jadi potongan kode Dart dari modul bisa dipindah
apa adanya dan tetap dapat syntax highlighting. Filenya teks, sehingga `git diff`
tetap berguna saat slide direvisi mengikuti revisi bab.

## Menjalankan

```bash
./build.sh              # semua deck -> build/*.pdf
./build.sh P03 html     # satu deck -> HTML (dipakai saat mengajar)
./build.sh all pptx     # kalau perlu setoran PPTX
./build.sh P03 png      # render tiap slide jadi PNG, untuk memeriksa overflow
```

Preview sambil menulis: `npx @marp-team/marp-cli@latest -s .` lalu buka
`http://localhost:8080`. Bila memakai ekstensi Marp di VS Code, theme sudah
didaftarkan lewat `.vscode/settings.json` — tanpa itu preview jatuh ke theme
default: logo hilang dan footer muncul di slide judul. Blok ```mermaid hanya
ter-render lewat `build.sh`/server di atas, bukan di preview VS Code.

Tidak ada `npm install`; `npx` mengambil marp-cli saat dipakai. Chrome/Chromium
diperlukan untuk output PDF, PPTX, dan PNG.

## Isi direktori

| Path | Keterangan |
|---|---|
| `PNN-*.md` | Satu deck per pertemuan RPS |
| `themes/ppb.css` | Theme: kanvas 4:3, tipografi, warna, layout dua kolom, blok kode |
| `marp.config.js` | Mendaftarkan theme + membuat blok ```mermaid ter-render sebagai diagram |
| `assets/logo-udinus.png` | Logo institusi; dipasang lewat theme, tidak perlu ditulis di deck |
| `vendor/mermaid.min.js` | Mermaid di-vendor agar render tetap jalan tanpa internet |
| `build/` | Hasil render, tidak di-commit |

## Keputusan tampilan

- **Kanvas 4:3 (1024×768)** mengikuti proyektor lab yang masih versi lama.
- **Blok kode light mode**, bukan dark. Di proyektor lama, teks gelap di atas latar terang jauh lebih kontras daripada sebaliknya.
- **Logo Udinus** dipasang dari theme: kecil di pojok kanan bawah slide isi, besar di pojok kanan atas slide judul. Jangan turunkan di bawah ~50px — lingkaran teks pada logo jadi tak terbaca.
- **Nama pengajar** ditulis di slide judul lewat `<div class="pengajar">`.

## Konvensi penulisan deck

Satu deck = satu pertemuan RPS (bukan satu bab buku) — lihat pemetaan RPS ↔ bab
di `../README.md`.

Kerangkanya:

1. Slide judul (`_class: title`) — nomor pertemuan, Sub-CPMK, bacaan, starter code
2. Tujuan pembelajaran
3. Peta perjalanan (diagram mermaid)
4. Isi, dipecah per segmen dengan pembatas `_class: section-break`
5. Praktikum hari ini
6. Bekerja dengan AI di materi ini
7. Ringkasan
8. Penutup — pertemuan berikutnya + bacaan

**Slide ini dense dan itu disengaja.** Fungsinya ganda: memandu saat mengajar,
dan jadi referensi belajar setelah kelas. Konsekuensinya satu aturan:
*tiap slide kode wajib punya minimal satu kalimat "kenapa"*, bukan kode telanjang.

### Class yang tersedia

| Class | Kegunaan |
|---|---|
| `title` | Slide judul deck |
| `section-break` | Pembatas antar segmen |
| `split` | Dua kolom 1:1 — kode kiri, anotasi kanan |
| `split split-wide` | Dua kolom 3:2, untuk kode yang lebih lebar |
| `code-dense` | Turunkan ukuran font kode; untuk blok >25 baris |

Dipakai lewat komentar per-slide: `<!-- _class: split split-wide -->`.

Kotak penanda: `<div class="note">` (catatan), `<div class="warn">` (jebakan /
anti-pattern), `<div class="ok">` (poin kunci). Beri baris kosong sebelum dan
sesudah isinya agar Markdown di dalamnya tetap diproses.

### Batas muat

Kanvas 1024×768. Kode ≤28 baris pada slide biasa, ≤34 baris dengan `code-dense`;
lebih dari itu pecah jadi dua slide. Lebar baris kode ≤90 karakter, dan ≤48
karakter untuk kolom di `split`. Setelah menulis deck, jalankan
`./build.sh PNN png` dan periksa hasilnya — Marp memotong diam-diam, tidak
memberi peringatan.

## Status

| Pertemuan | Deck | Status |
|---|---|---|
| P01 — Introduction to Mobile Development & Dart Fundamentals | `P01-dart-fundamentals.md` | ✅ 39 slide |
| P02 — Dart Programming Deep Dive | `P02-dart-deep-dive.md` | ✅ 42 slide |
| P03 — Flutter Fundamentals & Widget System | `P03-flutter-fundamentals.md` | ✅ 41 slide |
| P04 — Build System & Project Structure | `P04-build-system-project-structure.md` | ✅ 38 slide |
| P05 — UI Design & Material Design Implementation | `P05-material-design.md` | ✅ 39 slide |
| P06 — Advanced UI & Custom Widgets | `P06-custom-widgets.md` | ✅ 38 slide |
| P07 — Responsive Design & Adaptive Layouts | `P07-responsive-design.md` | ✅ 38 slide |
| P09 — API Integration & HTTP Operations | `P09-rest-api.md` | ✅ 41 slide |
| P10 — Real-time Features & Advanced API Integration | `P10-offline-sync.md` | ✅ 38 slide |
| P11 — Advanced State Management | `P11-state-management.md` | ✅ 37 slide |
| P12 — Testing & Quality Assurance | `P12-testing.md` | ✅ 37 slide |
| P13 — Platform Features & Device Integration | `P13-platform-features.md` | ✅ 37 slide |
| P14 — Performance Optimization & Production Prep | `P14-performance.md` | ✅ 43 slide |
| P15 — Deployment & Distribution Strategies | `P15-deployment.md` | ✅ 39 slide |

P08 (UTS) dan P16 (UAS) tidak punya deck — bahan ujian ada di `../Ujian/`.
