# Lembar Observasi, PPB Remidi 7 Pertemuan

> **Status:** v1.0, 2026-08-08
> **Aplikasi jangkar:Remedial Task Tracker**
> **Untuk:** dosen/asisten mengisi **selama** blok praktik individual (40') tiap sesi, mulai P01.
> **Sumber:** `../00-Planning/Runbook-Dosen.md`, `Kunci-Diagnostik.md`, `../01-Orientasi/Tes-Diagnostik-Praktik.md`.
> **Tujuan:** menangkap bukti observable untuk diagnosis, rubrik tugas, dan action dosen, bukan menilai niat.

## 0. Cara pakai

1. Cetak/salin **satu tabel mahasiswa** per sesi per mahasiswa (boleh digital di spreadsheet).
2. Isi saat mengamati, bukan dari ingatan di akhir. Tandai bukti konkret (kutipan/persiapan) pada kolom "Catatan".
3. Skor 0-4 mengikuti `Rubrik-Remedial.md` bagian 1: 0 = tidak ada/tidak jujur, 1 = kurang, 2 = cukup, 3 = baik, 4 = sangat baik.
4. Pada P01, gunakan pita Merah/Kuning/Hijau dari `Kunci-Diagnostik.md` bagian 4.
5. Tutup sesi dengan **satu** rekomendasi tindak lanjut per mahasiswa.

> Hormati kejujuran. Observasi adalah alat bantu belajar; tanda kebiasaan buruk (mencontek, tempel AI tanpa analisis) dicatat agar dapat dibenahi, bukan untuk menghakimi.

## 1. Data sesi

- Nama mahasiswa: ____________________ NIM/NPM: ____________________
- Sesi: - [ ] P01 - [ ] P02 - [ ] P03 - [ ] P04 - [ ] P05 - [ ] P06 - [ ] P07
- Tanggal: ____________________ Pengamat: ____________________
- Blok yang diamati: - [ ] Retrieval (10') - [ ] Konsep+demo (20') - [ ] Guided lab (55') - [ ] **Praktik individual (40')** - [ ] Demo+exit ticket (15')

## 2. Indikator diagnostik (fokus P01, reusable sesi lain)

Tandai dengan Y/T dan skor 0-4. Catat bukti konkret.

| # | Indikator observable | Y/T | Skor 0-4 | Bukti / Catatan |
|---|---|:---:|:---:|---|
| D1 | Membaca error/lint sebelum bertanya (cek `flutter analyze`, console) | | | |
| D2 | Membuktikan perbaikan dengan data uji (≥8 tugas, uji manual 1-7) | | | |
| D3 | Memahami alur state lokal (filter aktif, query, controller) | | | |
| D4 | Membedakan bug sumber data vs filter vs render | | | |
| D5 | Mengelola lifecycle widget (controller di-`dispose`, `mounted` check) | | | |
| D6 | Menjelaskan "mengapa" kode kerjanya (bukan hanya "jalan") | | | |
| D7 | Tidak tempel AI tanpa analisis; bila pakai AI, ada catatan/analisis | | | |
| D8 | Tidak lanjut dengan broken state; memvalidasi tiap langkah | | | |

## 3. Pencapaian kompetensi sesi (rubrik terkait)

Sebut indikator dari `Rubrik-Remedial.md` yang relevan sesi itu.

| Kompetensi sesi ini | Status (/◐/) | Bukti |
|---|:---:|---|
| _(P01)_ Environment valid, model `Task` dipahami | | |
| _(P01)_ Memperbaiki filter/search sesuai R1-R4 | | |
| _(P02 dst.)_ _sesuaikan dengan capaian sesi_ | | |

## 4. Sikap dan metode kerja

| Aspek | Catatan |
|---|---|
| Cara bertanya (spesifik vs "gak jalan") | |
| Ketekunan (lanjut setelah buntu / cepat menyerah) | |
| Pemakaai AI/dokumentasi (sesuai policy sesi?) | |
| Kerja sama (minta bantu anchor/teman dengan benar) | |
| Manajemen waktu (progress vs 40') | |

## 5. Exit ticket mahasiswa (direkam dosen)

- Konsep yang **belum jelas** (dari exit ticket): ____________________
- Satu hal yang **sudah jelas** sekarang: ____________________
- Screenshot/log yang dikumpulkan: ____________________

## 6. Penilaian pita (P01) dan tindak lanjut

- Pita konsep: Dart ____ Widget/state ____ Async/error ____ Data/API ____ Testing ____
- Pita praktik (filter/search): - [ ] Merah Merah - [ ] Kuning Kuning - [ ] Hijau Hijau
- Pita gabungan: - [ ] Merah - [ ] Kuning - [ ] Hijau

### Tindak lanjut (pilih per `Kunci-Diagnostik.md` bagian 6)
- [ ] Pasangkan dengan *anchor* hijau
- [ ] Wajib ulang checkpoint pertama sesi berikutnya
- [ ] Micro-quiz retrieval awal sesi berikut (area: ______)
- [ ] Tunda mulai Assignment 1 sampai P02 checkpoint-1 lulus
- [ ] Bimbingan AI policy
- [ ] Lanjut normal

**Rekomendasi satu kalimat:** ________________________________________

## 7. Sign-off

- Pengamat: ____________________ Tanda tangan: ____________________
- Mahasiswa (diberi tahu hasil, **bukan** kunci): ____________________
- Tanggal: ____________________

---

## Lampiran: rekap kelas (per sesi)

Salin satu baris per mahasiswa. Memudahkan melihat pola kelas untuk retrieval quiz sesi berikut.

| Nama | Pita konsep terlemah | Pita praktik | Anchor? | Tindak lanjut utama |
|---|---|---|:---:|---|
| | | | - [ ] | |
| | | | - [ ] | |
| | | | - [ ] | |
| | | | - [ ] | |
