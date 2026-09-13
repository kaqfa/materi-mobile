# G4 — Rilis

**Minggu**: P15 · **Bobot**: 10% · **Sub-CPMK**: 53.2 · **Estimasi**: 3 × 50 menit

Aturan umum, bentuk penyerahan, rubrik, dan aturan AI ada di [`README.md`](README.md).

## Target

Aplikasi berpindah dari "jalan di laptop saya" menjadi berkas yang bisa dipasang orang lain.

Yang sudah harus ada:

- **Build rilis yang tertandatangani**, dengan keystore Anda sendiri. Keystore dan kata sandinya **tidak** masuk repo.
- **Bukti profiling.** Temukan satu masalah performa nyata dengan alat profil, perbaiki, dan tunjukkan angka sebelum dan sesudahnya. Satu temuan yang diperbaiki dengan bukti lebih bernilai daripada daftar panjang optimasi tanpa pengukuran. Kalau setelah diukur ternyata aplikasi Anda memang sudah cepat, katakan begitu dan tunjukkan pengukurannya — itu jawaban yang sah.
- **Bersih untuk produksi**: tidak ada log debug yang bocor, tidak ada kunci di dalam berkas rilis, tidak ada layar atau menu percobaan yang tertinggal.
- **README yang utuh**, satu sampai dua halaman: apa aplikasinya, cara menjalankannya dari nol, gambaran arsitekturnya, dan keterbatasan yang Anda sadari. Bagian keterbatasan wajib diisi dan dinilai.
- **Refleksi AI**, satu paragraf: sepanjang semester, di mana AI benar-benar mempercepat Anda, dan di mana ia justru menyesatkan.

## Verifikasi Sendiri Sebelum Menyetor

- [ ] Berkas rilis dipasang di perangkat yang belum pernah memasang aplikasi ini, dan berjalan
- [ ] Repo diklon ke direktori baru, diikuti README dari nol, aplikasi berhasil dijalankan
- [ ] `git log` dan seluruh isi repo diperiksa, tidak ada keystore, kata sandi, atau kunci API
- [ ] Aplikasi dijalankan tanpa koneksi ke alat pengembangan, tidak ada yang macet menunggu
- [ ] Angka sebelum dan sesudah profiling tercatat di CHANGELOG
- [ ] Tag `gate-4` dibuat, blok CHANGELOG lengkap, video terunggah

Butir kedua paling sering gagal: README hampir selalu melewatkan satu langkah yang penulisnya sudah lakukan berbulan-bulan lalu dan lupa pernah melakukannya.

## Hubungan dengan UAS

G4 adalah keadaan akhir aplikasi. UAS menilai kemampuan Anda mempresentasikan dan mempertahankannya. Tidak ada pengembangan fitur baru yang dituntut di antara keduanya — pakai sisa waktunya untuk menyiapkan presentasi dan menutup keterbatasan yang Anda tulis sendiri di README.

## Materi Pendukung

Bab 13 (profiling, cakupan rebuild, optimasi) dan bab 14 (build rilis, penandatanganan, checklist rilis, privasi).
