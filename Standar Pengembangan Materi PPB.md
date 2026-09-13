# Standar Pengembangan Materi PPB

Satu halaman. Versi sebelumnya memerinci pipeline tiga berkas (outline → handout → modul kelas) yang tidak lagi dipakai: buku multi-bab di `modul-buku/` menggantikannya, dan aset penilaian pindah ke `penugasan/` serta `moodle/`. Prinsip yang tetap berlaku dirangkum di sini; formatnya hidup di `Standar Tutorial Koding PPB.md`.

## Lima Prinsip

**1. RPS lebih dulu.** Setiap bab menyebut pertemuan dan Sub-CPMK yang ditopangnya. Bab tidak dipetakan satu-satu ke pertemuan, tetapi tidak boleh ada Sub-CPMK yang tidak punya bab pendamping. Peta pemetaannya ada di `README.md`.

**2. Satu aplikasi acuan, tumbuh terus.** Semua bab implementasi memakai StudyTracker yang sama dan melanjutkan kode bab sebelumnya. Bab yang memperkenalkan contoh baru tanpa alasan memaksa pembaca membangun konteks dari nol, dan itu biaya yang jarang sepadan.

**3. Kode yang bisa dijalankan, bukan potongan.** Contoh lengkap sampai bisa disalin dan berjalan, lolos `flutter analyze`, null safety aktif. Setiap checkpoint berakhir pada keadaan aplikasi yang bisa dijalankan.

**4. Jelaskan kenapa, bukan hanya bagaimana.** Langkah tanpa alasan menghasilkan pembaca yang bisa mengulang dan tidak bisa memutuskan. Setiap keputusan teknis yang tidak sepele menyebutkan apa yang ditolak dan kenapa.

**5. Batas ditulis, bukan didiamkan.** Topik yang sengaja tidak dibahas dinyatakan terbuka beserta alasannya, dalam bagian "Batas Bab Ini". Pembaca berhak tahu apa yang belum ia pelajari.

## Alur Kerja Revisi

Materi lama sudah cukup baik. Perbaikan bersifat inkremental, bukan penulisan ulang.

1. Periksa bab terhadap RPS dan terhadap daftar di `AUDIT-Gap-Modul-vs-RPS.md`.
2. Tulis perubahan sekecil mungkin yang menutup selisihnya.
3. Perbarui frontmatter bila cakupan bab berubah: `objectives`, `description`, `estimatedReadTime`.
4. Jaga rantai `nextChapter` dan `prevChapter` tetap utuh; perbarui `updateDate` di `index.md` untuk perubahan yang berarti.
5. Bila bab itu menopang gate penilaian, periksa apakah brief di `penugasan/` masih cocok.

## Selesai Berarti

- Frontmatter valid dan sesuai skema di `AGENTS.md`
- Setiap checkpoint bisa dijalankan dan punya daftar periksa
- Ringkasan dan referensi ada
- Blok "Bekerja dengan AI di Bab Ini" ada, dan tidak menyebut nomor minggu
- Contoh kode lolos `flutter analyze`
- Pemetaan ke Sub-CPMK jelas

## Rujukan

| Kebutuhan | Berkas |
|---|---|
| Capaian, pertemuan, penilaian | `RPS PPB - 20251.md` |
| Format tutorial dan pola checkpoint | `Standar Tutorial Koding PPB.md` |
| Skema frontmatter dan konvensi repo | `AGENTS.md` |
| Peta RPS ↔ bab | `README.md` |
| Riwayat temuan dan keputusan revisi | `AUDIT-Gap-Modul-vs-RPS.md` |
| Brief tugas, rubrik, aturan AI | `penugasan/` |
