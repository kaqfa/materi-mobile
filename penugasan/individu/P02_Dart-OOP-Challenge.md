# P02 — Dart OOP Challenge

**Minggu**: P02 · **Bobot**: 7,5% · **Sub-CPMK**: 53.1 · **Estimasi**: 3 × 50 menit · **Individual**

## Target

Membangun model domain sebuah aplikasi dalam Dart murni, tanpa Flutter. Tidak ada antarmuka, tidak ada layar. Yang diuji adalah apakah Anda bisa menerjemahkan aturan dunia nyata menjadi tipe data yang menolak keadaan mustahil.

Pilih satu domain kecil, bebas, misalnya: peminjaman buku, pemesanan makanan, jadwal latihan, penyewaan alat. Cukup satu domain, jangan seluruh aplikasi.

## Yang Diserahkan

Satu repo berisi:

- `lib/` — kelas-kelas domain Anda
- `bin/main.dart` — program konsol yang memperagakan setiap kemampuan model: membuat objek, mengubahnya, menampilkan hasilnya, dan memperlihatkan apa yang terjadi saat aturan dilanggar
- `README.md` — setengah halaman: domain apa, aturan apa yang Anda tegakkan, dan satu keputusan pemodelan yang sempat Anda ragukan

`dart analyze` harus bersih. Nol peringatan, bukan "peringatannya tidak apa-apa".

## Yang Harus Muncul di Kode

Enam hal, masing-masing harus punya alasan domain, bukan sekadar ditempel agar memenuhi daftar:

| Yang dituntut | Pertanyaan yang harus bisa Anda jawab |
|---|---|
| Minimal tiga kelas yang saling berelasi | kenapa ini tiga kelas, bukan satu kelas dengan banyak field? |
| Pewarisan **atau** komposisi | kenapa Anda memilih yang ini, bukan yang satunya? |
| Satu `mixin` | perilaku apa yang dipakai bersama oleh kelas yang tidak sekerabat? |
| `enum` untuk nilai terbatas | kenapa ini enum dan bukan `String`? |
| Null safety yang berarti | field mana yang boleh kosong, dan kenapa yang lain tidak boleh? |
| Satu `Exception` buatan sendiri | pelanggaran aturan apa yang pantas menghentikan program? |

Satu `mixin` yang dipasang hanya supaya ada mixin akan terbaca jelas dan mengurangi nilai. Lebih baik jujur menulis "domain saya tidak butuh mixin" di README dan menjelaskan kenapa, daripada memaksakannya.

## Rubrik

| Dimensi | Bobot | Memenuhi berarti |
|---|---|---|
| Ketepatan model | 40% | tipe data mencerminkan aturan domain; keadaan mustahil sulit dibuat |
| Kelengkapan teknis | 25% | enam butir di atas ada dan masing-masing punya alasan |
| Kebersihan | 20% | `dart analyze` bersih, penamaan jelas, tidak ada kode mati |
| Penjelasan | 15% | README menjelaskan keputusan, bukan mendaftar fitur |

## Aturan AI untuk Tugas Ini

**Dibatasi.** Tugas ini satu-satunya tempat di mata kuliah ini yang tujuannya membangun refleks membaca kode dari nol, dan ukurannya cukup kecil untuk diverifikasi langsung.

- Boleh: menanyakan sintaks Dart, meminta penjelasan konsep, menanyakan kenapa pesan error tertentu muncul.
- Tidak boleh: meminta AI menuliskan kelas domain Anda, lalu menyerahkannya.
- Verifikasi: di praktikum P03, Anda diminta mengubah satu bagian model Anda sendiri di tempat, dalam 10 menit, tanpa AI. Tidak bisa mengerjakannya berarti kode itu bukan milik Anda, apa pun yang tertulis di repo.

Aturan longgar dan deklaratif baru berlaku di capstone mulai P04. Lihat `../capstone/README.md`.

## Materi Pendukung

Bab 1 (dasar Dart, tipe, fungsi) dan bab 2 (OOP, enum, sealed class, null safety, exception).
