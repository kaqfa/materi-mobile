# G1 — Fondasi

**Minggu**: P07 · **Bobot**: 8% · **Sub-CPMK**: 92.1 · **Estimasi**: 3 × 50 menit

Aturan umum, bentuk penyerahan, rubrik, dan aturan AI ada di [`README.md`](README.md). Dokumen ini hanya menyebut apa yang khas untuk gate ini.

## Target

Aplikasi Anda berdiri sebagai aplikasi: bisa dipasang, dibuka, dan satu alur utamanya bisa dijalankan dari awal sampai selesai tanpa mentok. Data boleh masih hidup di memori, belum perlu tersimpan setelah aplikasi ditutup.

Yang sudah harus ada:

- **Satu alur utama utuh.** Pilih alur paling inti dari aplikasi Anda (misalnya: buat pesanan, catat sesi belajar, tambah entri kesehatan) dan buat ia berjalan penuh. Lebih baik satu alur yang tuntas daripada lima layar yang semuanya setengah jadi.
- **Navigasi antar layar** yang konsisten, minimal tiga layar.
- **Tampilan terpisah dari data.** Widget tidak menyusun data langsung di dalam dirinya; ada tempat lain yang memegang daftar dan menyediakannya.
- **Bertahan di tiga konfigurasi layar**: ponsel potret, ponsel landscape, dan tablet atau jendela lebar. Tidak harus berubah bentuk, tapi tidak boleh rusak: tidak ada overflow, tidak ada teks terpotong, tidak ada tombol yang keluar layar.

Yang belum dituntut di gate ini: penyimpanan permanen, jaringan, autentikasi, test, fitur perangkat. Semuanya datang di gate berikutnya.

## Verifikasi Sendiri Sebelum Menyetor

Jalankan daftar ini, jangan diserahkan, cukup dipakai:

- [ ] Aplikasi dipasang dari nol dan langsung bisa dibuka tanpa langkah rahasia
- [ ] Alur utama dijalankan tiga kali berturut-turut tanpa crash
- [ ] Masukan kosong dan masukan aneh dicoba di setiap form, aplikasi tidak mati
- [ ] Diputar ke landscape di setiap layar, tidak ada yang meluap
- [ ] Dijalankan di emulator tablet atau jendela lebar, tidak ada teks yang terbentang selebar layar sampai sulit dibaca
- [ ] Skala teks sistem dinaikkan ke 150%, tata letak masih terbaca
- [ ] `CHANGELOG.md` sudah berisi blok `gate-1` dengan empat butir
- [ ] Tag `gate-1` sudah dibuat dan dikirim ke remote

Butir skala teks paling sering terlewat, dan paling sering jadi temuan saat demo.

## Peer Review (siklus 1)

Sebelum gate, Anda mereview satu mahasiswa lain yang ditentukan dosen. Kirim tiga hal saja:

1. Satu hal yang menurut Anda sudah bagus, sebutkan berkas dan barisnya
2. Satu hal yang akan menyusahkan pemiliknya dua minggu lagi, beserta alasannya
3. Satu pertanyaan yang Anda ingin ditanyakan ke penulisnya

Review dinilai dari ketajamannya, bukan panjangnya. "Kodenya bagus, lanjutkan" bernilai nol.

## Materi Pendukung

- Bab 3 — sistem widget, layout, navigasi dasar
- Bab 4 — struktur proyek dan pemisahan folder
- Bab 5 — Material 3, layout yang mengikuti ruang, skala teks
- Bab 6 — custom widget dan form

Bagi yang memakai stack selain Flutter: cari padanan konsepnya, bukan padanan API-nya. Empat dimensi rubrik tidak menyebut satu pun nama widget.
