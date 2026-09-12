# Panduan Import Moodle, Question Bank PPB Remidi

> **Status:** v1.0, 2026-08-10
> **Untuk:** dosen/admin kelas.
> **Berkas utama:** `Moodle-Question-Bank.xml` (105 soal, 8 kategori).
> **Generator:** `build_moodle_xml.py` (sumber kebenaran teks soal).

## 1. Isi bank soal

| Kategori Moodle | Soal | Dipakai untuk |
|---|---:|---|
| `PPB-Remidi/Diagnostik/Konsep` | 25 | Tes diagnostik konsep, P01 |
| `PPB-Remidi/Diagnostik/Praktik` | 20 | Tes diagnostik praktik, P01 |
| `PPB-Remidi/Unlock/P02` | 10 | Gate membuka materi P03 |
| `PPB-Remidi/Unlock/P03` | 10 | Gate membuka materi P04 |
| `PPB-Remidi/Unlock/P04` | 10 | Gate membuka materi P05 |
| `PPB-Remidi/Unlock/P05` | 10 | Gate membuka materi P06 |
| `PPB-Remidi/Unlock/P06` | 10 | Gate membuka materi P07 |
| `PPB-Remidi/Unlock/P07` | 10 | Gate membuka Proyek Akhir / Demo |
| **Total** | **105** | |

Semua soal bertipe `multichoice`, satu jawaban benar, `shuffleanswers` aktif, `penalty` 0, bobot 1 poin.

## 2. Langkah import

1. Masuk ke course → **Question bank** → **Import**.
2. Pilih format **Moodle XML format**.
3. Unggah `Moodle-Question-Bank.xml`.
4. Pada *General*, biarkan **"Get category from file"** tercentang agar 8 kategori terbentuk otomatis.
5. Klik **Import** → periksa ringkasan "105 questions imported".

> Kategori dibuat sebagai `$course$/PPB-Remidi/...`, artinya masuk ke bank soal **course ini**, bukan konteks sistem.

## 3. Menyusun kuis unlock (ulangi untuk P02-P07)

1. **Add an activity** → **Quiz**, beri nama mis. `Unlock P02, Widget & Navigasi`.
2. **Timing:** tanpa batas waktu (tujuannya penguasaan).
3. **Grade:**
   - *Attempts allowed*: **Unlimited**
   - *Grading method*: **Highest grade**
   - *Grade to pass*: **8** (dari 10)
4. **Question behaviour:** *Shuffle within questions* = Yes.
5. **Review options:** centang *Whether correct* dan *General feedback* **hanya** setelah attempt ditutup, agar mahasiswa belajar dari umpan balik tanpa langsung menyalin kunci.
6. **Edit quiz** → **Add** → **from question bank** → pilih kategori `Unlock/P0n` → tambahkan **semua 10 soal**. Total nilai 10.

## 4. Mengaktifkan gerbang (restrict access)

Pada aktivitas **materi P(n+1)** (mis. halaman/berkas Modul P03):

1. **Edit settings** → **Restrict access** → **Add restriction** → **Grade**.
2. Pilih `Unlock P02`, centang **must be ≥** dan isi **80** (%).
3. Klik ikon **mata** agar syarat tetap terlihat mahasiswa dalam keadaan terkunci (memberi tahu apa yang harus diselesaikan), atau sembunyikan bila ingin benar-benar tertutup.

Rantai gerbang yang dituju:

```
Diagnostik (P01, wajib dikerjakan)
  └─ Materi P02 ──[Unlock P02 ≥80%]──> Materi P03
                    └─[Unlock P03 ≥80%]──> Materi P04
                        └─[Unlock P04 ≥80%]──> Materi P05
                            └─[Unlock P05 ≥80%]──> Materi P06
                                └─[Unlock P06 ≥80%]──> Materi P07
                                    └─[Unlock P07 ≥80%]──> Proyek Akhir / Demo
```

**Gerbang P01 → P02 tidak memakai passing grade.** Tes diagnostik hanya *wajib dikerjakan* (gunakan restriction **Activity completion: must be marked complete**), karena fungsinya memetakan posisi awal, bukan menyaring.

## 5. Menyiapkan tes diagnostik

Buat dua kuis terpisah dari kategori `Diagnostik/Konsep` (25 soal, 30 menit) dan `Diagnostik/Praktik` (20 soal, 30 menit), dengan:

- *Attempts allowed*: **1**
- *Grade to pass*: kosongkan (tidak menentukan lulus)
- *Review options*: **jangan** tampilkan jawaban benar sebelum seluruh kelas selesai, agar peta diagnosis tidak terkontaminasi.

Hasil per kategori diekspor lewat **Quiz → Results → Grades** untuk mengisi pita Merah/Kuning/Hijau di `Kunci-Diagnostik.md`.

## 6. Memperbarui soal

Edit `build_moodle_xml.py` (bukan XML-nya langsung), lalu:

```bash
python3 build_moodle_xml.py
```

Skrip memvalidasi tiap soal punya **4 opsi** dan **tepat satu kunci**; bila tidak, proses berhenti dengan pesan kesalahan. Saat mengimpor ulang ke Moodle, import ke kategori yang sama akan **menambah** soal baru, bukan menimpa. Untuk mengganti, hapus soal lama di question bank lebih dulu (atau naikkan versi nama kategori).

## 7. Catatan integritas

- Kunci jawaban versi teks ada di `Bank-Soal-Unlock.md` (ditandai tebal) dan `Kunci-Diagnostik.md`. **Keduanya dokumen dosen**, jangan diunggah ke ruang mahasiswa.
- Attempt tak terbatas pada kuis unlock disengaja: tujuannya mahasiswa mengulang sampai paham. Pengacakan urutan opsi mengurangi hafalan posisi jawaban.
- Bila ingin memperkecil peluang saling menyalin, buat *question pool* lebih besar di semester berikutnya lalu gunakan **Random question** dari kategori, bukan menambahkan 10 soal tetap.
