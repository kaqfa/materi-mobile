# Moodle — Bank Soal & Aktivitas PPB 20251

> **Status:** v1.1 (2026-09-14) — course Kulino (id=21) **sudah dibangun penuh secara otomatis**;
> lihat [Status deployment](#status-deployment-kulino) untuk yang sudah jadi vs langkah manual tersisa.
> **Untuk:** dosen/admin kelas.

## Isi direktori

| Berkas | Fungsi |
|---|---|
| `PROSEDUR-EDIT.md` | **Runbook edit konten course** (soal, intro, gate, section, starter) untuk revisi pasca-deployment. |
| `bank_soal.py` | **Sumber kebenaran teks soal** (140 soal = 14 pertemuan × 10). Kunci selalu opsi pertama; validator menjaga panjang kunci ≤ semua distraktor. |
| `build_moodle_xml.py` | Generator + validator. Output XML (di `build/`, tergitignore) & kunci dosen. |
| `pack_starters.py` | Zip tiap starter `../starter-code/pNN-*` → `build/starter-zips/starter-pNN-*.zip` untuk diunggah ke Moodle (bukan via link repo). |
| `build/Moodle-Question-Bank.xml` | Hasil build untuk di-import (dibangun ulang via script). |
| `build/starter-zips/` | Zip starter per pertemuan, siap unggah sebagai aktivitas **File** (dibangun ulang via script). |
| `Kunci-Jawaban.md` | **Dokumen dosen** — kunci + penjelasan per soal. Jangan diunggah ke ruang mahasiswa. |
| `activities/` | Daftar aktivitas Moodle per pertemuan (P01–P16), teks siap copas. |

## Kategori question bank

| Kategori Moodle | Soal | Dipakai untuk |
|---|---:|---|
| `PPB/P01` … `PPB/P07` | 10 × 7 | Quiz unlock minggu 1–7 |
| `PPB/P09` … `PPB/P15` | 10 × 7 | Quiz unlock minggu 9–15 |
| **Total** | **140** | P08 (UTS) & P16 (UAS) tidak ber-quiz |

Semua soal `multichoice`, satu jawaban benar, `shuffleanswers` aktif, `penalty` 0, bobot 1.
Setiap soal ber-tag: `ppb-20251`, kode pertemuan (`p01`…), dan tag topik kebab-case —
digenerate `build_moodle_xml.py`, dipakai memfilter soal di question bank.

## Build ulang

```bash
python3 build_moodle_xml.py
```

Zip starter siap unggah:

```bash
python3 pack_starters.py
```

Skrip memvalidasi sebelum menulis: tepat 10 soal/pertemuan, 4 opsi, satu kunci, opsi unik,
dan **panjang teks kunci ≤ setiap distraktor** (mencegah jawaban benar tertebak dari panjangnya).
Import ulang ke kategori yang sama = **menambah** soal baru, bukan menimpa; hapus soal lama dulu bila mengganti.

## Distribusi starter code (kebijakan)

- Starter **tidak dibagikan via URL repo/GitHub** — di-zip per pertemuan (`pack_starters.py`) dan diunggah ke section minggunya sebagai aktivitas **File**.
- Restrict access tiap file starter: **Grade ≥ 80% pada quiz pertemuan sebelumnya** — mahasiswa membuka starter P0N setelah lulus Quiz P0(N−1). Pengecualian: starter P01 terbuka sejak awal; starter P09 dibuka Quiz P07 (P08 = UTS, tanpa quiz).
- Zip berisi folder `pNN-<slug>/` (lib, pubspec, test, README), tanpa `.dart_tool`/`.flutter-plugins*`; `pubspec.lock` ikut agar dependensi deterministik.
- Rebuild zip setelah revisi starter, lalu hapus+unggah ulang file di Moodle (Moodle tidak menimpa berkas lama otomatis).

## Import ke Moodle

> ✅ **Sudah dikerjakan (2026-09-13/14)**: 140 soal versi ber-tag ter-import, kategori `PPB/P01`–`PPB/P15`
> terbentuk di bank course (10 soal/kategori), 14 quiz masing-masing menarik 10 soal dari kategorinya.
> Instruksi di bawah untuk re-import/semester berikutnya.

1. Course → **Question bank** → **Import** → format **Moodle XML format** → unggah `build/Moodle-Question-Bank.xml`.
2. Biarkan **"Get category from file"** tercentang → 14 kategori `PPB/PXX` terbentuk otomatis.
3. Cek ringkasan "140 questions imported".

## Menyusun quiz unlock per minggu

Mengikuti kebijakan `../penugasan/README.md` (quiz = syarat masuk gate, tanpa bobot nilai):

1. **Add an activity → Quiz**, nama: `Quiz P0N — <topik>` (lihat `activities/P0N-*.md`).
2. **Timing**: tanpa batas waktu. **Layout**: satu halaman disarankan.
3. **Grade**: *Attempts allowed* = **Unlimited**, *Grading method* = **Highest grade**, *Grade to pass* = **8** (dari 10).
4. **Question behaviour**: *Shuffle within questions* = Yes.
5. **Review options**: *Whether correct* + *General feedback* ditampilkan **hanya setelah attempt ditutup**; *Right answer* **tidak pernah** — mahasiswa belajar dari umpan balik tanpa menyalin kunci saat unlimited attempt.
6. **Edit quiz → Add → from question bank** → kategori `PPB/P0N` → tambahkan semua 10 soal (total nilai 10).

> ✅ 14 quiz sudah dibuat + config terverifikasi (task-009: 14/14 cocok).

## Mengaktifkan gerbang (restrict access)

Pada aktivitas **minggu berikutnya** (mis. materi P10 atau gate G2):

1. **Edit settings → Restrict access → Add restriction → Grade**.
2. Pilih quiz minggu sebelumnya, **must be ≥ 80** (%).
3. Klik ikon mata agar syarat terlihat (mahasiswa tahu apa yang membuka).

Rantai yang dituju: quiz P0N ≥ 80% membuka materi P(N+1); akumulasi quiz menjadi syarat masuk gate capstone (G1 P07, G2 P10, G3 P13, G4 P15) sesuai `../penugasan/README.md`.

> ✅ Rantai 13/13 terpasang & terverifikasi (starter P0N ← quiz P0(N−1) ≥80%, syarat visible/showc; P01 terbuka, P09 ← Quiz P07).

## Status deployment Kulino (2026-09-14)

Course `id=21`, audit penuh di `.kanban-evidence/task-009/` (matrix 69/69 aktivitas ada).

**Sudah dikerjakan otomatis:**

- [x] 16 section P01–P16 + summary per `activities/PXX-*.md`; duplikat/section kosong dibersihkan (17 section final)
- [x] Import 140 soal ber-tag (14 kategori `PPB/PXX`) — versi lama tanpa tag sudah dihapus dulu
- [x] 14 quiz P0N + config standar (unlimited/highest/pass 8/shuffle/no time limit/1 halaman)
- [x] Aktivitas non-quiz: 14 URL materi, 14 File starter zip, Choice, Feedback P16 (12 forum dihapus 2026-09-14 — keputusan dosen; activities PXX sudah disinkronkan)
- [x] Assignment: Tugas P02/P03/P04, gate G1–G4, UTS, UAS (brief penugasan terlampir)
- [x] Peer review P07 & P13 (format tiga butir) + attach form
- [x] Restrict access berantai 13/13 (quiz → starter minggu berikutnya)
- [x] Aktivitas semester lama di-hide; section minggu mendatang hidden (P01–P02 visible)

**Langkah manual tersisa (dosen):**

- [ ] Import/isi kalender — event deadline gate G1–G4, UTS, UAS ke kalender course (bisa dari kalender Kulino atau import `.ics`)
- [ ] Pengaturan gradebook — kategori & bobot sesuai `../penugasan/README.md`: Weekly 15%, Capstone 40%, Peer review 5%, UTS 15%, UAS 20%, AI portfolio 5% (quiz = 0, hanya syarat gate)
- [ ] Buka section tiap minggu berjalan (Eye icon) — saat ini P03+ hidden by design
- [ ] `git push` repo ini ke GitHub (manual oleh user)
- [ ] Bila starter code direvisi: rebuild zip (`python3 pack_starters.py`) lalu hapus+unggah ulang File starter terkait

## Catatan integritas

- Attempt tak terbatas disengaja (tujuan penguasaan); pengacakan opsi mengurangi hafalan posisi.
- Semester berikutnya: perbesar pool soal per kategori lalu pakai **Random question**, bukan 10 soal tetap.
- `Kunci-Jawaban.md` dan folder `solution-reference` di starter-code = dokumen dosen; jangan pernah ikut dipublikasikan di course.
