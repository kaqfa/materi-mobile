# Tes Diagnostik Praktik, PPB Remidi 7 Pertemuan

> **Status:** v2.0, 2026-08-10 (format pilihan ganda skenario debugging)
> **Aplikasi jangkar:Remedial Task Tracker**
> **Untuk:** mahasiswa peserta remidi, dikerjakan pada **P01** setelah tes konsep.
> **Durasi:** 30 menit.
> **Sumber variasi:** `../UTS/UJIAN_01_FILTER_BY_STATUS.md`, `../UTS/UJIAN_02_SEARCH_BY_TITLE.md`.
> **Pasangan:** `Tes-Diagnostik-Konsep.md`, `../05-Assessment/Kunci-Diagnostik.md` (kunci, khusus dosen), `../05-Assessment/Lembar-Observasi.md`.
> **Versi Moodle:** `../05-Assessment/Moodle-Question-Bank.xml`, kategori `PPB-Remidi/Diagnostik/Praktik`.

## 0. Tujuan

Tes ini menguji kemampuan **membaca, mendiagnosis, dan memverifikasi** kode, bukan menulis dari nol. Semua soal berbasis skenario nyata dari starter `Remedial Task Tracker` yang **sengaja rusak** pada fitur **filter** dan **search**: kau membaca gejala, kode, dan hasil test, lalu memilih diagnosis/perbaikan/langkah verifikasi yang benar.

Hasil tes memetakan kemampuan diagnostikmu ke Merah/Kuning/Hijau dan menentukan titik awal bimbingan dosen. Tes ini bukan penentu kelulusan, tetapi **tidak boleh** dikerjakan dengan AI (lihat `Panduan-Mahasiswa.md` bagian 5).

- **Format:** 20 soal pilihan ganda, satu jawaban benar per soal.
- **Skor:** 1 poin per soal → dinormalkan ke 0-100 sebagai `SkorPraktik`.
- **Boleh:** membaca dokumentasi Flutter/Dart resmi. **Tidak boleh:** AI, mencontek.

## 1. Konteks bersama (baca dulu)

Model yang dipakai seluruh soal:

```dart
enum TaskStatus { pending, overdue, completed }
enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String title;
  final DateTime dueDate;
  final bool isCompleted;

  TaskStatus get status {
    if (isCompleted) return TaskStatus.completed;
    if (dueDate.isBefore(DateTime.now())) return TaskStatus.overdue;
    return TaskStatus.pending;
  }
}
```

**Gejala bug yang dilaporkan:**

- **F1, Filter rusak.** Mengetuk chip "Completed" tidak mengubah daftar; tugas yang tampil justru yang **bukan** completed.
- **F2, Search rusak.** Mengetik `hist` tidak menemukan "Read History"; query kosong malah mengosongkan daftar.

**Requirement yang benar (R1-R4):** R1 filter empat chip (All/Pending/Overdue/Completed) dengan indikator aktif; R2 search *case-insensitive substring* pada `title`, real-time, query kosong tampil semua, ada clear; R3 filter + search bekerja bersama (AND), urutan sumber dipertahankan; R4 empty state kontekstual (menyebut status atau query).

---

## 2. Diagnosis bug filter (R1)

### Soal 2.1
Implementasi berikut menyebabkan gejala F1. Apa kesalahan logikanya?

```dart
List<Task> filterByStatus(List<Task> tasks, TaskStatus status) =>
    tasks.where((t) => t.status != status).toList();
```

- A. `where` tidak boleh dipakai pada `List`; harus `map`.
- B. Operator pembanding terbalik: `!=` menahan elemen yang **tidak** sesuai, seharusnya `==`.
- C. Hasil perlu `growable: false` agar filter bekerja.
- D. `status` getter harus diubah agar mengembalikan `String`.

### Soal 2.2
Chip "All" harus menampilkan semua tugas. Manakah implementasi yang benar tanpa merusak R1?

- A. `if (selected == null) return []; return filterByStatus(tasks, selected);`
- B. `if (selected == null) return tasks; return filterByStatus(tasks, selected);`
- C. `return filterByStatus(tasks, TaskStatus.pending);`
- D. `return tasks.where((t) => t.status == null).toList();`

### Soal 2.3
Seorang mahasiswa "memperbaiki" F1 dengan mengubah getter `status` di `task.dart`. Mengapa ini keliru?

- A. Karena getter tidak boleh diubah dalam bahasa Dart.
- B. Karena bug ada di **konsumen** getter (`task_filter.dart`); mengubah model melanggar batasan dan merusak perilaku status di layar lain.
- C. Karena getter `status` sudah `final`.
- D. Karena `status` hanya dipakai oleh test, bukan UI.

### Soal 2.4
Sebuah task punya `isCompleted = true` tetapi `dueDate` sudah lewat. Status apa yang benar, dan mengapa urutan `if` pada getter penting?

- A. `overdue`, karena tanggal lebih menentukan daripada penyelesaian.
- B. `completed`, karena pengecekan `isCompleted` dilakukan lebih dulu; tugas selesai tidak boleh dianggap terlambat.
- C. `pending`, karena keduanya saling meniadakan.
- D. Status menjadi `null` dan harus ditangani pemanggil.

### Soal 2.5
Chip aktif tidak punya indikator visual. Manakah perbaikan yang memenuhi R1 tanpa menambah dependency?

- A. Menambah package `chips_ui` dari pub.dev.
- B. Memakai `FilterChip`/`ChoiceChip` dengan properti `selected` yang dibandingkan ke state filter aktif.
- C. Mengganti chip dengan `AlertDialog`.
- D. Menyimpan warna chip di database SQLite.

---

## 3. Diagnosis bug search (R2)

### Soal 3.1
Implementasi berikut menyebabkan `hist` tidak menemukan "Read History". Apa penyebabnya?

```dart
List<Task> searchByTitle(List<Task> tasks, String query) =>
    tasks.where((t) => t.title.startsWith(query)).toList();
```

- A. `startsWith` hanya mencocokkan awal judul dan bersifat case-sensitive; butuh `toLowerCase().contains(...)`.
- B. `where` tidak mendukung `String`.
- C. `query` harus dikonversi ke `int` dulu.
- D. `title` harus dijadikan nullable.

### Soal 3.2
Manakah implementasi search yang memenuhi R2 sepenuhnya (case-insensitive, substring, query kosong tampil semua)?

- A. `tasks.where((t) => t.title.contains(query)).toList()`
- B. `query.trim().isEmpty ? tasks : tasks.where((t) => t.title.toLowerCase().contains(query.toLowerCase())).toList()`
- C. `tasks.where((t) => t.title == query).toList()`
- D. `query.isEmpty ? [] : tasks.where((t) => t.title.toLowerCase() == query).toList()`

### Soal 3.3
Query kosong justru mengosongkan seluruh daftar. Bagian mana yang paling mungkin salah?

- A. Guard untuk query kosong/whitespace tidak ada, sehingga string kosong tetap diproses sebagai filter yang tidak cocok.
- B. `TextField` tidak boleh dipakai untuk pencarian.
- C. `ListView` kehabisan memori saat query kosong.
- D. `setState` dipanggil terlalu jarang.

### Soal 3.4
Hasil pencarian harus diperbarui **real-time** saat mengetik. Mekanisme mana yang tepat?

- A. Tombol "Search" yang memanggil `Navigator.push`.
- B. `TextField(onChanged: (v) => setState(() => query = v))` (atau listener pada controller) sehingga tiap ketikan memicu rebuild.
- C. `initState` yang membaca controller sekali saja.
- D. `FutureBuilder` yang menunggu 5 detik sebelum menampilkan hasil.

### Soal 3.5
`TextEditingController` dibuat di `_TaskListScreenState`. Apa yang wajib dilakukan agar tidak bocor memori?

- A. Memanggil `controller.clear()` di `build`.
- B. Memanggil `controller.dispose()` di `dispose()` milik State.
- C. Menjadikan controller `static`.
- D. Membuat controller baru di setiap `build`.

---

## 4. Kombinasi, empty state, dan kualitas (R3-R4)

### Soal 4.1
Filter "Overdue" aktif dan query "lab". Manakah implementasi yang memenuhi R3?

- A. `searchByTitle(tasks, query)` saja, filter diabaikan.
- B. `searchByTitle(filterByStatus(tasks, TaskStatus.overdue), query)`, dua kondisi diterapkan berurutan (AND).
- C. `filterByStatus(tasks, ...) + searchByTitle(tasks, query)` digabung dengan operator `+`.
- D. Menampilkan hasil filter **atau** hasil search (OR), mana pun yang tidak kosong.

### Soal 4.2
R3 mensyaratkan urutan tugas tetap sama dengan sumber asli. Praktik mana yang menjaganya?

- A. Memanggil `tasks.sort(...)` setelah filter agar rapi.
- B. Menggunakan `where().toList()` yang mempertahankan urutan sumber, tanpa `sort` tambahan.
- C. Menggunakan `Set` untuk membuang duplikat.
- D. Membalik hasil dengan `reversed` agar terbaru di atas.

### Soal 4.3
Filter "Completed" aktif dan query `zzz` tidak menghasilkan apa pun. Pesan empty state mana yang memenuhi R4?

- A. "Tidak ada data."
- B. "Tidak ada tugas yang cocok dengan 'zzz'."
- C. "Error 404."
- D. Menampilkan `CircularProgressIndicator` terus-menerus.

### Soal 4.4
Mengapa `filterByStatus` dan `searchByTitle` ditaruh di service/domain terpisah, bukan langsung di dalam `build()`?

- A. Agar bisa diuji unit test tanpa merender widget, dan logika tidak terulang di banyak tempat.
- B. Agar aplikasi berjalan lebih cepat di emulator.
- C. Karena Flutter melarang logika di `build()`.
- D. Agar tidak perlu `setState` sama sekali.

### Soal 4.5
Layar menyimpan `List<Task> filteredTasks` sebagai field State **sekaligus** menghitung ulang filter di `build()`. Apa risikonya?

- A. Tidak ada risiko, justru lebih cepat.
- B. State ganda yang bisa saling konflik/basi (stale), sehingga UI menampilkan hasil tidak konsisten; cukup simpan filter+query lalu turunkan daftar saat build.
- C. Aplikasi menolak dikompilasi.
- D. `ListView` otomatis mengurutkan ulang datanya.

---

## 5. Verifikasi dan sikap debug

### Soal 5.1
Sebelum menyentuh kode, langkah pertama yang paling efektif adalah:

- A. Menulis ulang seluruh layar dari nol.
- B. Menjalankan `flutter test` dan membaca **nama test yang gagal** beserta pesan ekspektasinya.
- C. Menambahkan package baru untuk filter.
- D. Menghapus test yang merah agar build hijau.

### Soal 5.2
Test bernama "mengembalikan HANYA task pending" gagal. Apa makna paling langsung dari nama test itu?

- A. Nama test hanya dekorasi, abaikan.
- B. Test menyatakan ekspektasi perilaku yang benar; hasil aktual saat ini memuat status selain `pending`.
- C. Test butuh perangkat fisik.
- D. Test gagal karena data dummy kurang dari 20.

### Soal 5.3
Setelah memperbaiki filter, bukti mana yang paling kuat bahwa perbaikan benar?

- A. Kode "terlihat benar" saat dibaca ulang.
- B. `flutter test` hijau **dan** uji manual: ketuk tiap chip lalu cek daftar sesuai status.
- C. Aplikasi berhasil di-`hot reload` tanpa error.
- D. `flutter analyze` tidak menampilkan issue.

### Soal 5.4
`flutter analyze` bersih, tetapi filter masih menampilkan hasil salah. Kesimpulan yang tepat?

- A. Analyze pasti keliru; abaikan hasil filter.
- B. Analyze hanya memeriksa statis (lint/tipe); bug logika runtime tetap lolos, jadi butuh test/uji manual.
- C. Bug pasti ada di Flutter SDK.
- D. Perlu `flutter clean` lalu masalah hilang sendiri.

### Soal 5.5
Daftar tampil kosong setelah perbaikan. Urutan investigasi paling efektif adalah:

- A. Cek warna teks → cek font → cek padding.
- B. Cek sumber data terisi → cek nilai filter/query aktif → cek kondisi render/empty-state.
- C. Reinstall Flutter SDK → hapus emulator → buat project baru.
- D. Ganti `ListView` ke `GridView` → rotasi layar → restart IDE.

---

## 6. Penyerahan

- Kerjakan langsung di Moodle, atau tulis huruf jawaban (A/B/C/D) di lembar jawaban bernama.
- Satu jawaban per soal; tidak ada pengurangan untuk jawaban salah.
- Dosen mengisi `../05-Assessment/Lembar-Observasi.md` berdasarkan pola jawaban (area mana yang dominan salah).

> Catatan: soal ini menguji **cara berpikir saat debugging**, bukan hafalan sintaks. Bila banyak yang meleset, itu peta yang berguna, bukan vonis.
