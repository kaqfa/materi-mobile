# G3 — Arsitektur & Kualitas

**Minggu**: P13 · **Bobot**: 12% · **Sub-CPMK**: 92.2 · **Estimasi**: 3 × 50 menit

Aturan umum, bentuk penyerahan, rubrik, dan aturan AI ada di [`README.md`](README.md). Ini gate dengan bobot terbesar.

## Target

Aplikasi yang sudah berfungsi dirapikan supaya bisa tumbuh, dibuktikan bisa dipercaya, dan menyentuh perangkat.

Yang sudah harus ada:

- **State terpusat.** State aplikasi tidak lagi tersebar di banyak `setState`; ada satu tempat yang memegangnya dan memberitahu tampilan saat berubah. Pustaka apa pun boleh; yang dinilai adalah konsistensinya, bukan mereknya.
- **Keputusan arsitektur yang bisa dipertahankan.** Butir "Keputusan" di CHANGELOG gate ini wajib membahas pilihan pengelolaan state Anda: apa yang dipilih, apa yang ditolak, dan apa yang akan berubah kalau aplikasi ini tumbuh sepuluh kali lipat.
- **Test yang benar-benar dijalankan.** Minimal enam test yang lulus dan pernah gagal saat kode dirusak sengaja. Bagi sekitar dua pertiga untuk logika (aturan domain, penyaringan, validasi) dan sepertiga untuk tampilan. **Cakupan tidak dinilai angkanya** — enam test bermakna lebih bernilai daripada lima puluh test yang hanya memanggil getter.
- **Minimal dua fitur perangkat** yang benar-benar dipakai alur aplikasi, bukan tombol demo terpisah: kamera, galeri, lokasi, sensor, berkas, atau notifikasi. Masing-masing menangani izin ditolak dan perangkat tidak mendukung, tanpa crash.

## Verifikasi Sendiri Sebelum Menyetor

- [ ] `setState` yang tersisa hanya untuk state milik satu widget (animasi, buka-tutup, fokus)
- [ ] Satu baris logika dirusak sengaja, ada test yang gagal karenanya; kemudian dikembalikan
- [ ] Test dijalankan dari nol di direktori bersih dan lulus semua
- [ ] Izin ditolak lalu fitur perangkat dicoba, aplikasi memberi tahu dengan jelas dan tetap hidup
- [ ] Izin diberikan lalu dicabut dari pengaturan sistem, aplikasi dibuka lagi, tidak crash
- [ ] Peer review siklus 2 sudah dikirim
- [ ] Tag `gate-3` dibuat, blok CHANGELOG lengkap dengan pembahasan arsitektur, video terunggah

Butir kedua adalah inti gate ini. Test yang tidak pernah terbukti bisa gagal belum diketahui menguji apa pun.

## Tambahan pada Butir AI

Mulai gate ini, blok AI di CHANGELOG memuat satu hal lagi: **satu saran AI yang Anda tolak**, beserta alasan kenapa saran itu keliru untuk konteks aplikasi Anda. Sebutkan sarannya, keberatan Anda, dan apa yang Anda kerjakan sebagai gantinya.

Menemukan bahan untuk butir ini tidak sulit. Yang sulit adalah menyadari saat sedang terjadi — dan itulah yang sedang dilatih.

## Materi Pendukung

Bab 7 dan bagian "Arah Setelah Provider" (pengelolaan state dan pembandingnya), bab 11 (pengujian), bab 12 (fitur perangkat dan izin), bab 13 bagian pemilihan cakupan rebuild.
