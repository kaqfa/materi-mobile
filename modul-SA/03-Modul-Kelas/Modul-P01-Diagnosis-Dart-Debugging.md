# Modul Kelas P01, Diagnosis, Dart, dan Debugging

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi:** 150 menit (3 × 50) | **Rasio praktik minimal:** 65%
**Pasangan:** `../02-Materi/P01-Diagnosis-Dart-Debugging.md` (materi)
**Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Runbook-Dosen.md`, `../05-Assessment/Lembar-Observasi.md`, `../05-Assessment/Kunci-Diagnostik.md`

> **Untuk dosen/asisten.** Modul ini panduan menjalankan kelas, bukan handout mahasiswa. Kunci diagnosis (`Kunci-Diagnostik.md`) dan `solution-reference/` **jangan dibagikan** sebelum sesi selesai.

---

## BAGIAN 1: Overview

### Tujuan Hari Ini

Mahasiswa mampu:
1. Memvalidasi environment dan mereproduksi gejala bug dengan bukti.
2. Membaca model `Task`, enum, getter `status`, dan operasi koleksi Dart.
3. Memperbaiki filter/search sampai `flutter test` hijau dan uji manual R1-R4 lulus, serta **menjelaskan** kenapa perbaikan benar.

### Rundown Kelas (150 menit)

```
00-10 Retrieval quiz + review expectation (10 menit)
10-30 Konsep minimum + live demo (20 menit)
30-85 Guided lab + 3 checkpoint (55 menit)
85-125 Praktik individual + observasi dosen (40 menit)
125-140 Demo singkat + challenge reveal (15 menit)
140-150 Exit ticket + instruksi PR / preview (10 menit)
```

> Catatan: alokasi di atas mengikuti format tetap (`Runbook-Dosen.md` bagian 3). Bila kelas lemah di Dart, geser 10 menit dari guided lab ke konsep; jangan kurangi blok observasi (40').

### Yang Harus Sudah Ready (sebelum kelas)

- [ ] `Checklist-Environment.md` lulus pada mesin target; `flutter doctor` bersih.
- [ ] Flutter/Dart version kelas dipin (catat di compatibility matrix).
- [ ] Starter `06-Starter-Code/p01-diagnosis/` lolos `pub get`/`analyze`; smoke test hijau dan test filter/search merah terkonfirmasi sebagai baseline diagnosis sebelum bug-fix mahasiswa.
- [ ] `Tes-Diagnostik-Konsep.md` sudah dikoreksi -> peta pita per area siap.
- [ ] `Lembar-Observasi.md` (satu per mahasiswa) siap diisi selama blok praktik individual.
- [ ] `solution-reference/` dan `Kunci-Diagnostik.md` di kanal privat, tidak terlihat mahasiswa.

---

## BAGIAN 2: Live Coding (Konsep + Demo)

### Demo 1: Membaca gejala, bukan menebak (10 menit)

_Ikuti dosen, jangan maju sendiri._

Tampilkan starter P01 yang masih rusak di proyektor. Reproduksi:

1. `flutter run` -> 20 task muncul.
2. Ketuk chip "Pending" -> tunjukkan task **bukan** pending ikut tampil.
3. Ketik `math` -> "Complete Math Assignment" tidak ditemukan.

**Penting:**
- Gejala di layar **bukan** sumber kebenaran; kode + test adalah.
- Mindset: **baca gejala -> persempit (sumber vs filter vs render) -> buktikan dengan data uji**.
- Diagnosis ini yang dipakai rubrik "verifikasi & sikap debug" (`Kunci-Diagnostik.md` bagian 3).

**Test live (diskusi):**
- "Kalau chip 'Pending' menampilkan overdue, apakah sumber data rusak atau filter?"
- Tunjukkan badge status di kanan baris sebagai sumber kebenaran.

### Demo 2: Koleksi Dart + string matching (10 menit)

Live coding di DartPad atau file `scratch.dart`:

```dart
enum Priority { low, medium, high }

void main() {
 final xs = [Priority.high, Priority.low, Priority.medium];
 xs.sort((a, b) => a.index.compareTo(b.index));
 print(xs.map((p) => p.name).toList());
 // -> [low, medium, high] (urutan deklarasi, bukan abjad)

 final title = 'Complete Math Assignment';
 print(title.startsWith('math')); // false
 print(title.toLowerCase().contains('math')); // true
}
```

**Penting:**
- `index` enum = posisi deklarasi; sort by `index` kembalikan urutan deklarasi (soal konsep 1.2).
- `startsWith` + tidak lower-case gagal untuk substring case-insensitive.
- `toList(growable: false)` membekukan hasil agar tidak mudah diubah tak sengaja.

**Common errors (antisipasi):**
```
'A value of type X cannot be returned' -> cek tipe kembalian method, jangan ubah signature.
'The argument type String? cannot be assigned' -> normalisasi null: `query.trim()` lalu cek `isEmpty`.
```

> **Jangan** tunjukkan diff perbaikan `task_filter.dart` di demo. Biarkan mahasiswa mendiagnosis. Dosen boleh mengonfirmasi **pendekatan**, bukan jawaban.

---

## BAGIAN 3: Guided Lab, 3 Checkpoint (55 menit)

Ikuti materi `../02-Materi/P01-Diagnosis-Dart-Debugging.md`. Tiap checkpoint harus jalan sebelum lanjut (no broken state).

### CHECKPOINT 1: Environment & Mindset (≈15')
- Mahasiswa: `flutter create --platforms=android,web.` -> `pub get` -> `analyze` -> `test widget_test.dart` -> `flutter run`.
- Reproduksi F1/F2, tulis hipotesis.
- **Gate dosen:** starter jalan; gejala tercatat dengan bukti. Lompat ke CP2 bila lingkungan siap.

### CHECKPOINT 2: Model + Koleksi (≈15')
- Mahasiswa baca `task.dart`: null safety, immutability, getter `status`, `getDummyTasks`.
- Latihan mini `where/map/sort` + `toLowerCase().contains()`.
- **Gate dosen:** mahasiswa bisa menjelaskan urutan if di `status` getter dan **kenapa**.

### CHECKPOINT 3: Bug Fixing (≈25')
- Mahasiswa: jalankan `flutter test test/task_filter_test.dart`, baca nama test gagal, perbaiki `task_filter.dart`, verifikasi R1-R4.
- **Gate dosen:** semua test hijau + uji manual 1-7 terdokumentasi + `analyze` bersih.

> Bila ada mahasiswa buntu > 10 menit di CP3, beri pertanyaan pengarah (bukan jawaban): "Operator pembanding mana yang dipakai? Menahan yang sesuai atau yang tidak?" Catat di `Lembar-Observasi.md` bantuan yang diberikan.

---

## BAGIAN 4: Praktik Individual + Observasi (40 menit)

**Tujuan:** mengukur kemampuan individu membaca-memperbaiki-membuktikan, **tanpa AI untuk core logic**.

### Praktik Mandiri (30')

Kerjakan di luar perbaikan R1-R4: tambahkan **validasi dan edge case** pada filter/search yang sudah diperbaiki.

**Task:**
1. Tambah satu **unit test edge case** di `task_filter_test.dart`: list kosong, dan query whitespace `" "` -> harus kembalikan semua.
2. Tambah satu filter turunan bebas (pilih satu):
 - **Filter prioritas** (chip High/Medium/Low) yang **AND** dengan filter status dan search.
 - **Sort** hasil akhir by `priority.index` (tetap pertahankan opsi "no sort").
3. Pastikan `flutter analyze` + `flutter test` tetap hijau.

**Checklist progres:**
- [ ] Edge case test baru ditulis dan lulus.
- [ ] Filter/sort tambahan bekerja + AND dengan filter status/search.
- [ ] `flutter analyze` bersih.
- [ ] Urutan input awal tetap dipertahankan (R3).

**Expected output (uji manual):**
```
list kosong -> [] (tidak crash)
query " " -> semua task (trim -> empty)
filter High + overdue + search "lab" -> hanya task high-priority, overdue, judul memuat "lab"
```

**Bantuan:**
- Edge case gagal? Periksa urutan `trim()` sebelum `isEmpty`.
- Sort tidak stabil? `sort` memang mengubah list in-place; bila ingin non-destruktif, `toList()` dulu.
- Stuck di struktur test? Lihat pola `task_filter_test.dart` yang sudah ada; pakai `expect(result, everyElement(...))` atau `hasLength`.

### Challenge Individual (10')

Pilih satu level, kerjakan sendiri, siapkan bukti screenshot. Dinilai via `Lembar-Observasi.md`.

**Level 1 (Basic):** Tambah test "search menemukan substring di akhir judul" (mis. query "slides" -> "Group Presentation Slides").

**Level 2 (Medium):** Tambah metode `filterByPriority` di `TaskFilterService` + satu unit test. Pastikan bisa dipakai AND dengan `filterByStatus`.

**Level 3 (Advanced):** Refaktor `_visible` menjadi satu metode `apply(tasks, status, query, {priority})` yang mengembalikan hasil terurut; tulis 2 unit test untuk kombinasi AND + urutan.

**Submit:** screenshot hasil + paste kode tambahan di chat/LMS + 2-3 kalimat penjelasan pendekatan.

**Kriteria evaluasi:**
- Level 1: test lulus, edge tercakup.
- Level 2: logika benar + terpisah dari UI + test ada.
- Level 3: abstraksi bersih, urutan terjaga, kombinasi AND teruji.

---

## BAGIAN 5: Take-Home / PR

> P01 **tidak membuka tugas formal** (Assignment 1 dibuka setelah P03). PR P01 adalah refleksi dan penguatan.

**PR minggu depan:**
1. Selesaikan kembali `Tes-Diagnostik-Praktik.md` bila belum tuntas dalam sesi; kumpulkan diff + screenshot langkah 6-7 + satu paragraf refleksi.
2. Catat **satu konsep yang belum jelas** di exit ticket (bawa untuk retrieval quiz P02).
3. Bila pita konsep **Dart atau Widget merah**, baca ulang materi P01 bagian model + koleksi sebelum P02; dosen akan menambah micro-quiz retrieval.

**Persiapan P02:**
- Baca ulang `Task.getDummyTasks()`; bayangkan `ListView` + `Column`/`Expanded` menampung chip + daftar.
- Coba sketsa wireframe list-detail untuk portrait & landscape (bawa ke kelas).

---

## BAGIAN 6: Exit Ticket (selama 15' terakhir)

Kumpulkan dari tiap mahasiswa:
- **Satu konsep yang belum jelas** (spesifik, bukan "semua").
- **Satu hal yang sekarang sudah jelas** (bukti pemahaman).
- Screenshot hasil filter tunggal + kombinasi filter+search (R1-R4).
- Pernyataan: apakah memakai AI? Bila ya, lampirkan `Template-AI-Interaction-Log.md`.

Dosen mengisi pita praktik di `Lembar-Observasi.md` bagian 6 (Merah/Kuning/Hijau) dan satu rekomendasi tindak lanjut per mahasiswa.

---

## BAGIAN 7: References

- Materi: `../02-Materi/P01-Diagnosis-Dart-Debugging.md`.
- Diagnosis: `../01-Orientasi/Tes-Diagnostik-Konsep.md`, `../01-Orientasi/Tes-Diagnostik-Praktik.md`, `../05-Assessment/Kunci-Diagnostik.md` (dosen), `../05-Assessment/Lembar-Observasi.md`.
- Starter: `../06-Starter-Code/p01-diagnosis/` (+ `solution-reference/`, dosen).
- Standar: `../../Standar Tutorial Koding PPB.md`, `../../Standar Pengembangan Materi PPB.md`.

---

## Catatan Dosen (Notes)

- **Penegakan AI (P1-P3):** AI hanya untuk penjelasan syntax/diagnosis. Tolak bila core logic filter/search tempel AI tanpa analisis; minta kerja ulang. Catat di `Lembar-Observasi.md` D7.
- **Broken state = jangan lanjut.** Mahasiswa merah/kuning yang masih broken di CP3 wajib ulang checkpoint sebelum P02 (action dosen, `Kunci-Diagnostik.md` bagian 6).
- **Anchor pairing.** Mahasiswa pita merah dipasangkan dengan anchor hijau di lab P02; bila Dart+widget merah, tunda mulai Assignment 1 sampai P02 CP1 lulus.
- **Jangan bagikan kunci/solution-reference.** Peta pita + rekomendasi saja yang dikembalikan.
- **Pacing.** Observasi 40' tidak boleh dipangkas; itu sumber bukti rubrik utama. Bila waktu mepet, pangkas challenge, bukan observasi.
- **Versi toolchain.** Catat versi kelas (`flutter --version`) di compatibility matrix; starter memakai `sdk: ^3.4.0`, `flutter: ">=3.22.0"`. Sesuaikan bila berubah.

---

**Kepatuhan produksi:**
- Rundown 150 menit, rasio praktik ≥ 65%.
- 2-3 checkpoint + validasi testable + troubleshooting (lihat materi).
- Live demo, praktik mandiri, challenge 3 level, exit ticket.
- Notes dosen + penegakan AI + rujuk rubrik/observasi.
- Semua path merujuk starter P01 (`06-Starter-Code/p01-diagnosis/`).

**Updated:** 2026-08-08
