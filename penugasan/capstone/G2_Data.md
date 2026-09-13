# G2 — Data

**Minggu**: P10 · **Bobot**: 10% · **Sub-CPMK**: 53.2 · **Estimasi**: 3 × 50 menit

Aturan umum, bentuk penyerahan, rubrik, dan aturan AI ada di [`README.md`](README.md).

## Target

Aplikasi Anda berhenti menjadi demo dan mulai menyimpan data sungguhan. Dua kemampuan baru: data hidup di server, dan aplikasi tetap berguna saat jaringan mati.

Yang sudah harus ada:

- **Data dari server lewat REST.** Minimal satu entitas dengan operasi baca, tulis, dan hapus. Backend bebas — Supabase, Firebase, backend buatan sendiri, atau layanan lain — asalkan diakses lewat HTTP, bukan lewat SDK yang menyembunyikan requestnya. Poin latihannya justru pada request itu.
- **Autentikasi**, minimal daftar dan masuk, dengan token yang tersimpan aman dan tidak hilang saat aplikasi dibuka ulang.
- **Penyimpanan lokal** yang bertahan setelah aplikasi ditutup.
- **Tetap berfungsi saat offline.** Standar minimumnya: data yang sudah pernah dimuat masih bisa dibaca tanpa jaringan, dan perubahan yang dibuat saat offline tidak lenyap begitu saja. Sinkronisasi dua arah penuh tidak dituntut di gate ini.
- **Kegagalan dibedakan.** Tidak ada jaringan, sesi kedaluwarsa, dan data ditolak server adalah tiga hal berbeda dan harus terlihat berbeda oleh pengguna. Satu `catch` yang menampilkan "terjadi kesalahan" untuk semuanya dinilai sebagai belum memenuhi.

## Verifikasi Sendiri Sebelum Menyetor

- [ ] Kunci API atau rahasia lain tidak ada di dalam repo, tidak juga di riwayat commit
- [ ] Aplikasi ditutup lalu dibuka lagi, pengguna masih dalam keadaan masuk
- [ ] Mode pesawat dinyalakan, aplikasi dibuka, data lama masih terbaca
- [ ] Mode pesawat menyala, satu perubahan dibuat, jaringan dinyalakan lagi, perubahan tidak hilang
- [ ] Token dirusak sengaja, aplikasi memberi tahu bahwa sesi berakhir, bukan "terjadi kesalahan"
- [ ] Server dimatikan atau URL disalahkan, aplikasi tidak crash
- [ ] Tag `gate-2` dibuat, blok CHANGELOG lengkap, video terunggah

Untuk video G2: perlihatkan mode pesawat dinyalakan sambil aplikasi berjalan. Itu satu adegan yang membuktikan paling banyak.

## Materi Pendukung

Bab 8 (penyimpanan lokal), bab 9 (REST, autentikasi, penanganan error), bab 10 (offline-first, antrean perubahan).

Catatan untuk yang memakai Supabase: modul memakainya lewat REST biasa, bukan lewat SDK, karena yang dilatih adalah keterampilan yang tetap berguna saat Anda pindah ke backend perusahaan yang tidak punya SDK semewah itu.
