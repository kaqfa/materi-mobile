# Panduan Mahasiswa, PPB Remidi 7 Pertemuan

> **Status:** v1.0, 2026-08-08
> **Aplikasi jangkar:Remedial Task Tracker**
> **Baca juga:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `Checklist-Environment.md`, `Template-AI-Interaction-Log.md`

## 1. Apa itu paket remidi ini

Paket remidi **bukan ringkasan 14 pertemuan reguler**. Paket ini berbentuk klinik praktik terukur selama **7 pertemuan**, memulihkan kompetensi inti Flutter melalui **satu aplikasi jangkar: Remedial Task Tracker**. Kamu sudah pernah mengikuti PPB, tetapi nilaimu belum memenuhi standar. Di sini kamu harus membuktikan kemampuan individual untuk **membaca, memperbaiki, membuat, menguji, dan menjelaskan** kode.

Nilai aplikasi saja tidak cukup. Di final kamu wajib menjelaskan kodemu sendiri dan menyelesaikan perubahan kecil secara langsung (live modification).

## 2. Yang harus kamu kuasai

1. **Dart**: model, constructor, enum, null safety, collection, `async`/`await`, `try`/`catch`, JSON.
2. **Flutter**: widget tree, `StatelessWidget`/`StatefulWidget`, layout, navigasi, form validation, responsive dasar.
3. **State**: `ChangeNotifier` + Provider; loading, error, empty state; CRUD reaktif.
4. **Data**: SQLite sebagai local source of truth; repository/data source; REST CRUD + error handling.
5. **Kualitas**: unit test, widget test, permission + satu fitur device, `flutter analyze`, release APK, penjelasan kode.

Di luar scope wajib: BLoC/Riverpod, WebSocket, push notification, iOS build, Play Store upload, dan sebagainya. Kamu boleh menambah fitur setelah semua gate wajib lulus; fitur tambahan tidak menggantikan fitur wajib.

## 3. Tujuh sesi singkat

Setiap sesi 150 menit (3 × 50). Rasio praktik minimal 65%.

| Sesi | Fokus | Kamu harus bisa … |
|---|---|---|
| P01 | Diagnosis, Dart, debugging | menyiapkan environment, membuat model `Task`, memperbaiki filter/search rusak |
| P02 | Widget, layout, navigation | membuat task list + detail/add, `TaskCard` reusable, responsive |
| P03 | Form, CRUD, Provider | membuat validator, `TaskProvider`, CRUD + state (loading/error/empty) |
| P04 | SQLite, offline-first *(opsional di tugas)* | membuat schema + repository lokal; data bertahan setelah restart |
| P05 | REST API, robustness | memanggil HTTP/JSON; menangani network/error state; retry manual |
| P06 | Device, testing, QA | permission + image picker; menulis unit & widget test yang lulus |
| P07 | Release, live coding, demo | release APK; menjelaskan kode; menyelesaikan live modification |

Format tiap sesi tetap: 10' retrieval/review -> 20' konsep+demo -> 55' guided lab -> 40' praktik individual -> 15' demo + exit ticket + PR.

## 4. Dua assignment + satu proyek akhir

| Tugas | Judul | Batas lingkup | Beban | Dibuka | Tenggat |
|---|---|---|---:|---|---|
| Assignment 1 | Task Tracker Core | sampai testing | 30% | setelah P03 | sebelum P04 |
| Assignment 2 | Serialization dan API | sampai testing | 30% | setelah P05 | sebelum P06 |
| Proyek Akhir | QA, Release, dan Demo | release + demo | 40% | setelah P06 | final P07 |

Detail lingkup dan rubrik ada di `../00-Planning/Peta-Capaian-dan-Assessment.md` dan `../00-Planning/Rubrik-Remedial.md`. Bobot final nilai mengikuti empat area RPS (30/25/20/25), bukan langsung beban tugas.

**Assignment berhenti di testing.** Kamu cukup memastikan `flutter analyze` bersih dan `flutter test` hijau. Build release APK, demo individual, dan live modification **hanya ada di Proyek Akhir**.

**SQLite opsional.** Persistence lokal diajarkan di P04 dan boleh kamu pakai (jalur B), tapi **bukan syarat**. Kamu boleh memakai penyimpanan in-memory (jalur A) dan tetap mendapat nilai penuh. Jalur B bernilai bonus. Pilih satu di Assignment 2, tulis alasannya di README.

### Bukti yang harus dikumpulkan per tugas
- Source code (ZIP/repo).
- **Narasi Pemanfaatan AI** (Assignment: 800-1200 kata; Proyek Akhir: 1000-1500 kata).
- **Screenshot** sebagai bukti visual fungsional.
- `README` (cara run, arsitektur, jalur lokal, fitur, known limitation, bukti test).
- **AI Interaction Log** bila memakai AI (template: `Template-AI-Interaction-Log.md`).
- Proyek Akhir: tambahan **release APK** + **demo tatap muka** di sesi final.

> Penjelasan kodemu disampaikan lewat **narasi tertulis**, dan untuk Proyek Akhir juga lewat **demo tatap muka** di sesi final.

### Apa itu Narasi Pemanfaatan AI

Karangan tertulis (bahasa Indonesia) yang menjelaskan bagaimana kamu memanfaatkan AI untuk menyelesaikan tugas. Struktur lengkap ada di `../04-Penugasan/Template-Submission-README.md` §7 dan brief tiap tugas §5.1. Inti yang dinilai:

1. **Strategi** memakai AI, termasuk contoh prompt konkret milikmu.
2. **Keputusan menerima dan menolak** saran AI beserta alasan teknisnya. Minimal satu penolakan, ini bukti terkuat bahwa kamu paham.
3. **Cara verifikasi** bahwa kode benar (`analyze`/`test`/uji manual) + buktinya.
4. **Penjelasan satu alur kode end-to-end** dengan kata-katamu sendiri.

Narasi yang berisi kalimat umum ("AI sangat membantu saya belajar Flutter") tanpa menyebut file, class, atau keputusan nyata di proyekmu **dinilai rendah**. Tulis sambil mengerjakan, jangan dari ingatan semalam sebelum tenggat.

> **Tidak memakai AI sama sekali?** Narasi tetap wajib, tapi lebih pendek (500-800 kata; Proyek Akhir 600-1000). Tulis alasanmu, sumber belajar yang dipakai, lalu kerjakan poin 3 dan 4. **Tidak ada penalti.**

## 5. Kebijakan AI

AI boleh dipakai untuk belajar, tetapi dengan batas yang berubah seiring sesi.

| Sesi | Boleh | Tidak boleh |
|---|---|---|
| P1-P3 | penjelasan syntax, diagnosis error | menulis core logic tanpa analisis sendiri |
| P4-P5 | debugging, review error | tidak memahami perubahan data layer sendiri |
| P6-P7 | ide test/optimasi | tidak mencatat interaksi AI |

Setiap pemakaian AI **wajib dicatat** di AI Interaction Log: tujuan, prompt, ringkasan respons, perubahan yang dipilih/ditolak, dan **cara kamu memverifikasi** pemahaman.

Kamu harus mampu menjelaskan kode yang dibantu AI, lewat **narasi tertulis** di setiap tugas dan lewat **demo tatap muka** di Proyek Akhir. Narasi yang dangkal, atau yang tidak cocok dengan source/jawaban lisanmu, dapat membatalkan poin tugas meski source benar.

## 6. Alur kerja mingguan

1. **Sebelum sesi**: selesaikan `Checklist-Environment.md` (hanya sekali di awal). Baca learning goals sesi.
2. **Saat sesi**: ikuti checkpoint 2-3 per sesi. Setiap checkpoint wajib **bisa di-run dan diuji** sebelum lanjut.
3. **Exit ticket**: kumpulkan screenshot/log + satu konsep yang belum jelas.
4. **Tugas**: kerjakan sendiri setelah tugas dibuka. Catat AI log bila pakai AI.
5. **Sebelum kumpul**: jalankan `flutter analyze` dan `flutter test`; pastikan bersih atau warning dijelaskan.

## 7. Kapan tugas dianggap selesai

Tugas dianggap selesai bila **semua** berikut benar:
- Semua indikator gate rubrik (bertanda ) tercapai.
- `flutter analyze` bersih atau warning dijelaskan.
- `flutter test` lulus.
- Bukti (source, **narasi**, screenshot, README, AI log) lengkap.
- Narasi memuat seluruh poin wajib dan cocok dengan kode yang kamu kumpulkan.
- Kamu lulus penjelasan saat demo/wawancara (Proyek Akhir).

## 8. Kalau buntu

- Ulangi checkpoint: jangan lanjut dengan broken state.
- Tanya dosen/asisten saat sesi praktik individual.
- Pakai AI **dengan log** untuk diagnosis dan penjelasan, bukan untuk menulis inti logika.
- Catat konsep yang belum jelas di exit ticket, itu jadi bahan retrieval sesi berikutnya.
