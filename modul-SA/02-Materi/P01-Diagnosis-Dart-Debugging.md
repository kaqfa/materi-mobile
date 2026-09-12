# P01, Diagnosis, Dart, dan Debugging

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi sesi:** 150 menit (3 × 50) | **Estimasi belajar mandiri:** 4-5 jam
**Sub-CPMK:** 53.1 (Dart, widget, state) | **Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`

> **Baca juga:** `../01-Orientasi/Panduan-Mahasiswa.md`, `../01-Orientasi/Checklist-Environment.md`, `../01-Orientasi/Tes-Diagnostik-Konsep.md`, `../01-Orientasi/Tes-Diagnostik-Praktik.md`.

---

## Tujuan Pembelajaran

Setelah materi ini dikuasai, kamu mampu:

1. **Memvalidasi environment** Flutter/Dart: `pub get` dan `analyze` lulus; smoke test lulus, sedangkan test target filter/search merah adalah kondisi diagnosis yang diharapkan sebelum diperbaiki.
2. **Membaca dan menjelaskan** model `Task`, `enum` status/prioritas, getter `status`, serta operasi koleksi (`where`, `map`, `sort`, `toList`).
3. **Mendiagnosis dan memperbaiki** bug filter/search pada layanan murni, lalu **membuktikan** perbaikan dengan unit test dan uji manual R1-R4.

**Outcome sesi (bukti observable):**
- Starter `06-Starter-Code/p01-diagnosis/` berjalan dan menampilkan ≥ 20 task dummy.
- `flutter test test/task_filter_test.dart` hijau semua.
- Uji manual 1-7 (lihat Checkpoint 3) terdokumentasi via screenshot.
- Diagnosis konsep + praktik menghasilkan peta pita Merah/Kuning/Hijau.

---

## Prasyarat

- Mengerjakan `../01-Orientasi/Checklist-Environment.md`: `flutter doctor` bersih, perangkat/emulator aktif.
- Menyelesaikan `../01-Orientasi/Tes-Diagnostik-Konsep.md` **tanpa AI** sebelum sesi.
- Starter P01 sudah di-copy ke workspace kosong (lihat "Setup" di bawah).
- Membaca `../01-Orientasi/Panduan-Mahasiswa.md` bagian 5 (kebijakan AI P1-P3).

> **Kebijakan AI P01:** AI boleh untuk **penjelasan syntax dan diagnosis error**. AI **tidak boleh** menulis core logic filter/search tanpa analisis sendiri. Bila memakai AI, isi `../01-Orientasi/Template-AI-Interaction-Log.md`.

---

## Setup

```bash
# 1. Copy folder starter ke workspace kosong, lalu di dalamnya:
flutter create --platforms=android,web. # hasilkan platform runner (android/, web/...)
flutter pub get
flutter analyze
flutter test # target filter/search merah sebelum Checkpoint 3; smoke tetap hijau

flutter run
```

> Folder `android/`, `web/`, dll. sengaja **tidak** disertakan; dibuat oleh `flutter create`. Jalankan dari dalam folder starter; bila `flutter create` menimpa `pubspec.yaml`, pulihkan dari Git.

---

## Struktur starter P01

```text
06-Starter-Code/p01-diagnosis/
├── pubspec.yaml
├── analysis_options.yaml
├── lib/
│ ├── main.dart
│ ├── app.dart
│ ├── core/{constants,theme}/
│ └── features/tasks/
│ ├── domain/
│ │ ├── task.dart # model + enum + getDummyTasks()
│ │ └── task_filter.dart # layanan sengaja RUSAK (target diagnosis)
│ └── presentation/screens/task_list_screen.dart
└── test/
 ├── widget_test.dart # smoke (hijau)
 └── task_filter_test.dart # beberapa test sengaja MERAH
```

**Aturan batas (penting):**
- Boleh mengubah state lokal di `_TaskListScreenState` dan logika di `task_filter.dart`.
- Tidak boleh mengubah `Task`, `TaskStatus`, `TaskPriority`, menambah package, atau mengubah `List<Task>` menjadi tipe lain.

---

## Mengapa Diagnosis Lebih Dahulu

Remidi ini bukan ringkasan materi reguler. Kamu sudah pernah belajar Dart dan Flutter, tetapi ada pengetahuan retak yang membuat nilai belum lulus. Diagnosis memetakan titik retak itu **secara jujur** agar sesi berikutnya tepat sasaran.

**Mindset debug yang dilatih di P01:**

1. **Baca dulu, baru ubah.** Gejala di layar bukan sumber kebenaran; kode dan test adalah.
2. **Persempit kemungkinan.** Kosongkan? Apakah sumber data, filter, atau render yang salah?
3. **Buktikan dengan data uji**, bukan asumsi. Pakai ≥ 8 task campuran status + keyword berbeda.
4. **Jangan lanjut dengan broken state.** Tiap checkpoint harus jalan sebelum maju.

Mindset ini berlaku lintas sesi (P02 layout, P04 SQLite, P05 REST) dan menjadi dasar rubrik "verifikasi & sikap debug" (`../05-Assessment/Kunci-Diagnostik.md` bagian 3).

---

## CHECKPOINT 1: Environment & Mindset Diagnosis

**Goal:** starter berjalan, gejala bug teridentifikasi, hipotesis tertulis.
**Time:** ~20 menit

### Apa yang dibangun
- Starter dapat `flutter run` dan menampilkan 20 task dummy.
- Kamu mencatat dua gejala (F1 filter, F2 search) dan menyusun minimal satu hipotesis penyebab per gejala.

### Langkah

1. **Validasi toolchain** (jika belum di `Checklist-Environment.md`):

 ```bash
 flutter --version # catat versi kelas
 flutter doctor -v # tidak ada [] pada Flutter/Android/device
 flutter pub get # "Got dependencies!"
 flutter analyze # No issues found! (atau warning dijelaskan)
 flutter test test/widget_test.dart # smoke hijau
 ```

2. **Jalankan aplikasi**:

 ```bash
 flutter run
 ```

 Amati: AppBar "My Tasks", kotak pencarian, deretan chip filter (All/Pending/Overdue/Completed), daftar 20 task.

3. **Reproduksi gejala** (catat di catatanmu):

 - **F1, Filter rusak.** Ketuk chip "Pending" -> perhatikan task mana yang muncul. Bandingkan dengan badge status di kanan tiap baris.
 - **F2, Search rusak.** Ketik `math` (huruf kecil) -> apakah "Complete Math Assignment" muncul? Ketik `Math` (huruf besar) -> beda hasil?
 - **F3 (observasi).** Ketik query lalu pilih chip, apakah keduanya bekerja bersama?

4. **Susun hipotesis** (belum baca `task_filter.dart` detail):
 - Filter "salah arah" atau "tidak terikat sumber"? Bukti observasimu?
 - Search gagal karena case-sensitivity, `startsWith` vs `contains`, atau sumber data?

### Checkpoint Validation

- [ ] `flutter pub get` sukses tanpa konflik versi.
- [ ] `flutter analyze` keluar tanpa `error`.
- [ ] `flutter run` menampilkan 20 task dummy, chip muncul.
- [ ] `flutter test test/widget_test.dart` lulus (smoke).
- [ ] Catatan gejala F1 + F2 tertulis dengan bukti konkret (screenshot/kutipan).

**Run & Test:**
```bash
flutter run
# Expected: AppBar "My Tasks"; 20 task tampil; chip All aktif; search kosong.
```

---

## CHECKPOINT 2: Model `Task`, Enum, dan Koleksi Dart

**Goal:** membaca dan menjelaskan model, getter `status`, `getDummyTasks`, serta operasi koleksi.
**Time:** ~25 menit

**Melanjutkan CP 1:**
- Sudah punya: starter berjalan, gejala teridentifikasi.
- 🆕 Akan tambah: pemahaman fondasi Dart untuk membaca logika filter.

### 2.1 Baca `lib/features/tasks/domain/task.dart`

```dart
enum TaskPriority { low, medium, high }
enum TaskStatus { pending, overdue, completed }

class Task {
 final String id;
 final String title;
 final String description;
 final DateTime dueDate;
 final TaskPriority priority;
 final bool isCompleted;

 const Task({
 required this.id,
 required this.title,
 required this.description,
 required this.dueDate,
 this.priority = TaskPriority.medium,
 this.isCompleted = false,
 });

 TaskStatus get status {
 if (isCompleted) return TaskStatus.completed;
 final now = DateTime.now();
 if (dueDate.isBefore(now)) return TaskStatus.overdue;
 return TaskStatus.pending;
 }
 //... copyWith, ==, hashCode, toString, getDummyTasks
}
```

**Poin penting kamu jelaskan (tanya dirimu sendiri):**

1. **Null safety.** Kenapa field `title` non-nullable + `required`? Apa bedanya `String title`, `String? title`, dan `final String title`? (Lihat soal konsep 1.1.)
2. **Immutability.** Semua field `final`; perubahan lewat `copyWith`. Kenapa aman untuk rebuild UI?
3. **Getter turunan.** `status` dihitung dari `isCompleted` dan `dueDate`. **Urutan if penting:** `completed` dicek sebelum `overdue`. Kenapa? (Task yang `isCompleted=true` tapi lewat jatuh tempo harus tetap `completed`, bukan `overdue`.)
4. **Enum.** `TaskStatus.values` = `[pending, overdue, completed]`. `.index` = posisi deklarasi (0,1,2); `.name` = string nama. Sort by `index` mengembalikan urutan deklarasi (soal konsep 1.2).

> **Gotcha diagnosis:** bila kamu mengubah `status` getter, kamu melanggar batas. Bug ada di **konsumen** getter (`task_filter.dart`), bukan di getter itu sendiri.

### 2.2 `getDummyTasks` sebagai sumber uji

Data dummy dihitung relatif `DateTime.now()` agar overdue/pending stabil saat run. Catat kategori sampel untuk uji nanti:

| ID | Judul (kata kunci) | Status terhitung |
|----|--------------------|------------------|
| t01 | "Complete **Math** Assignment" | pending |
| t03 | "Physics **Lab** Report" | overdue (lewat 1 hari) |
| t04 | "Submit English Essay" | completed |
| t08 | "Chemistry Problem Set" | overdue |
| t11 | "**Math** Practice Sheet" | pending |
|... |... |... |

**Aturan uji R1-R4** (dari `../01-Orientasi/Tes-Diagnostik-Praktik.md`): pakai ≥ 8 task campuran status + judul dengan kata seperti "Math", "History", "Lab", "Report".

### 2.3 Koleksi Dart (resep untuk filter/search)

```dart
// where: mempertahankan elemen yang memenuhi predikat
final open = tasks.where((t) => t.status == TaskStatus.pending);

// map: transformasi elemen
final titles = tasks.map((t) => t.title.toLowerCase());

// sort: urutkan in-place (bila perlu); index enum -> urutan deklarasi
tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));

// toList: bekukan iterable menjadi List; growable:false untuk hasil immutable-ish
final result = tasks.where(pred).toList(growable: false);

// String: case-insensitive substring
'Complete Math Assignment'.toLowerCase().contains('math'); // true
'Complete Math Assignment'.startsWith('math'); // false <- petunjuk
```

**Latihan mini (tanpa kode starter):**

```dart
final xs = [3, 1, 4, 1, 5];
print(xs.where((n) => n.isOdd).length); // ?
print(xs.map((n) => n * 10).join(', ')); // ?
```

Kunci (coba sendiri dulu): `3` dan `30, 10, 40, 10, 50`. Bandingkan dengan soal konsep 1.4, pola yang sama.

### Checkpoint Validation

- [ ] Kamu bisa menjelaskan urutan if pada `status` getter dan **kenapa** urutan itu penting.
- [ ] Kamu bisa membedakan `String`, `String?`, `final String`, dan `required`.
- [ ] Kamu bisa menulis ulang `where` + `map` + `toLowerCase().contains()` untuk contoh bebas.
- [ ] Kamu dapat mengidentifikasi minimal 4 ID task dengan status berbeda dari `getDummyTasks`.

**Run & Test (latihan di DartPad atau file `scratch.dart`):**
```bash
dart run scratch.dart
# Expected: keluaran latihan mini sesuai kunci.
```

---

## CHECKPOINT 3: Bug Fixing, Filter & Search (Inti)

**Goal:** semua test `task_filter_test.dart` hijau + uji manual R1-R4 lulus.
**Time:** ~35 menit

**Melanjutkan CP 2:**
- Sudah punya: pemahaman model + koleksi.
- 🆕 Akan tambah: layanan filter/search yang benar + bukti.

### 3.1 Baca test yang merah dulu

Jalankan:

```bash
flutter test test/task_filter_test.dart
```

Baca **nama test** yang gagal, nama test menyebut ekspektasi benar (mis. "mengembalikan HANYA task pending", "case-insensitive + substring"). Pesan kegagalan adalah petunjuk, bukan musuh.

### 3.2 Buka `lib/features/tasks/domain/task_filter.dart`

Dua metode ditandai `// TODO(student) BUG`. Untuk tiap bug, kerjakan siklus ini:

```
baca gejala -> baca test ekspektasi -> baca implementasi rusak
-> identifikasi kesalahan logika -> tulis perbaikan -> jalankan test -> buktikan dengan uji manual
```

**Diagnosis terarah, jangan tebak.** Tanyakan:

**BUG filter (R1):**
- Ekspektasi: "hanya task dengan status terpilih".
- Saat ini: apa operator pembandingnya? Apakah menahan elemen yang **sesuai** atau yang **tidak sesuai**?
- Apakah hasil ini konsisten dengan gejala F1 (chip "Pending" menampilkan bukan-pending)?

**BUG search (R2):**
- Ekspektasi: "case-insensitive + substring di seluruh judul".
- Saat ini: apakah `startsWith` cukup untuk substring? Apakah ada normalisasi case?
- Apakah query kosong/whitespace sudah dihandle (R2: query kosong -> semua)?

> **Petunjuk teknis (bukan jawaban):** normalisasi string pakai `toLowerCase()`. Substring pakai `contains()`, bukan `startsWith()`. Pembanding status yang benar mempertahankan elemen yang **sesuai**. Jangan ubah signature metode atau model.

### 3.3 Kombinasi filter + search (R3) dan empty state (R4)

Lihat getter `_visible` di `task_list_screen.dart`:

```dart
List<Task> get _visible {
 var result = _filter.filterByStatus(_tasks, _resolveStatus(_statusFilter));
 result = _filter.searchByTitle(result, _searchQuery);
 return result;
}
```

- **R3 (AND):** filter dulu, search di atas hasil filter. Urutan input tetap karena `where` mempertahankan urutan.
- **R4 (empty state kontekstual):** `_buildEmpty()` sudah membedakan pesan untuk search kosong vs filter kosong vs all kosong (memakai `AppStrings.emptySearch`/`emptyFiltered`/`emptyAll`). Pastikan pesan menyebut `{query}` atau `{status}`, jangan diubah jadi generik.

> Bila R4 tidak bekerja setelah R1-R2 diperbaiki, periksa: apakah `_statusFilter` dan `_searchQuery` benar-benar dipakai di `_buildEmpty`? Apakah `setState` dipanggil pada `onChanged`?

### 3.4 Verifikasi R1-R4 (uji manual, wajib didokumentasikan)

Ikuti urutan `Tes-Diagnostik-Praktik.md` bagian 6:

1. Buka layar -> semua tampil, chip **All** aktif, search kosong.
2. Ketik `lab` -> hanya task dengan "Lab"/"lab" pada judul.
3. Kosongkan search -> semua tampil lagi.
4. Ketuk **Overdue** -> hanya task berstatus overdue.
5. **Overdue** aktif + ketik `report` -> overdue yang judulnya memuat "report".
6. **Completed** + ketik `zzz` -> empty state menyebut query.
7. **All** + kosongkan search -> semua tampil, urutan sama awal.

### Checkpoint Validation

- [ ] `flutter test test/task_filter_test.dart`, semua test **hijau**.
- [ ] R1: 4 chip bekerja; hanya status terpilih tampil; All menampilkan semua.
- [ ] R2: case-insensitive + substring + real-time; query kosong -> semua; ada tombol clear.
- [ ] R3: filter+search AND; urutan input dipertahankan.
- [ ] R4: empty state membedakan "kosong karena filter" vs "tidak cocok query", menyebut status/query.
- [ ] `flutter analyze` tetap bersih (tidak menambah error).
- [ ] Hot reload (`r`) bekerja setelah perubahan.

**Run & Test:**
```bash
flutter test test/task_filter_test.dart # All tests passed!
flutter analyze # No issues found!
flutter run # uji manual 1-7
# Expected: filter/search benar; empty state kontekstual muncul.
```

---

## Summary

**Yang kamu kerjakan:**
- Memvalidasi environment dan mereproduksi gejala bug dengan bukti.
- Membaca model `Task`, enum, getter `status`, dan `getDummyTasks`.
- Memperbaiki layanan filter/search sampai seluruh test hijau dan R1-R4 lulus.

**Konsep kunci:**
- **Null safety & immutability**, `final` field, `required`, `copyWith`.
- **Enum + index/name**, status turunan, komparator `index`.
- **Koleksi Dart**, `where`, `map`, `sort`, `toList(growable: false)`.
- **String matching**, `toLowerCase().contains()` untuk case-insensitive substring.
- **Mindset debug**, baca gejala, persempit sumber/filter/render, buktikan dengan data uji.
- **Verifikasi**, `flutter test` (perilaku) ≠ `flutter analyze` (statis); keduanya wajib.

**Preview sesi berikutnya (P02):**
- Widget tree, layout `Column`/`Row`/`Expanded`/`Wrap` agar tidak overflow di portrait+landscape.
- Navigasi list-detail dan add screen; `TaskCard` reusable.
- Fondasi: model `Task` dan koleksi yang kamu kuasai di P01 dipakai untuk membangun UI.

---

## Troubleshooting

**`flutter create` menimpa `pubspec.yaml` / `analysis_options.yaml`.**
Pulihkan dari Git (`git checkout -- pubspec.yaml analysis_options.yaml`). Jalankan `flutter create` dari dalam folder starter. Bila tetap, hapus file hasil create yang tidak relevan (`README.md` auto, dll.) dan pulihkan milikmu.

**`flutter analyze` menambah error setelah edit `task_filter.dart`.**
Cek tanda kurung, tipe kembalian (`List<Task>`), dan apakah kamu tidak mengubah signature. Jalankan `dart format.` lalu `flutter analyze` ulang.

**`flutter test` tetap merah padahal filter sudah diperbaiki.**
Periksa: apakah kamu mengubah `status` getter? Jangan. Apakah hasil memang mempertahankan urutan? Apakah `growable: false` dipakai konsisten? Jalankan satu test: `flutter test test/task_filter_test.dart --plain-name "pending"`.

**Chip "Pending" tetap menampilkan bukan-pending setelah fix.**
Hot restart (`R`), bukan hanya hot reload. State `StatusFilter` lama mungkin masih di memori.

**Search `math` tidak menemukan apa pun walau sudah pakai `contains`.**
Pastikan normalisasi dilakukan pada **kedua** sisi: `t.title.toLowerCase()` dan `q.toLowerCase()`. `startsWith` tidak cukup untuk substring di tengah/awal kapital.

**`Color.withValues` tidak dikenal / lint peringatan `withOpacity`.**
Flutter < 3.27 pakai `.withOpacity()`; starter memakainya. Lihat constraint versi di `pubspec.yaml` (`sdk: ^3.4.0`, `flutter: ">=3.22.0"`). Konsisten dengan yang ada.

**Layar blank / crash saat `flutter run`.**
Cek `flutter devices` (satu perangkat aktif). Bila emulator lambat, tunggu `pumpAndSettle`. Jangan lanjut dengan broken state, selesaikan environment dulu.

**Ingin konfirmasi pemahaman.**
Bandingkan pendekatanmu dengan rubrik `../05-Assessment/Kunci-Diagnostik.md` (khusus dosen, minta peta pita, bukan jawaban). Yang dinilai: **cara membuktikan**, bukan kode final saja.

---

## Self-Assessment (sebelum & sesudah)

**Skor kepercayaan 1-5, sebelum & sesudah P01:**
- Membaca pesan kegagalan `flutter test`: -> 
- Null safety + immutability model Dart: -> 
- Operasi koleksi `where/map/sort`: -> 
- Case-insensitive substring search: -> 
- Mempersempit bug (sumber vs filter vs render): -> 

**Verifikasi praktik:**
- Tulis satu test tambahan untuk edge case (mis. list kosong, query whitespace).
- Jelaskan dengan kata sendiri **kenapa** implementasi lama salah, ini yang ditanyakan saat demo.

---

## AI-Enhanced Learning (P01)

**Penggunaan AI produktif di P01:**
- "Jelaskan perbedaan `String`, `String?`, dan `required String` di Dart null safety."
- "Kenapa `startsWith('math')` tidak cocok dengan 'Complete Math Assignment'?"
- "Bagaimana cara membaca pesan kegagalan `flutter test` ini: …?"
- "Apa beda `flutter analyze` dan `flutter test`?"

**Hindari:**
- "Tulis kode filterByStatus yang benar untuk starter ini."
- "Perbaiki bug di task_filter.dart." (core logic, harus analisis sendiri)

**Wajib bila memakai AI:** isi `../01-Orientasi/Template-AI-Interaction-Log.md`, tujuan, prompt, ringkasan respons, perubahan dipilih/ditolak, dan **verifikasi pemahaman** (jelaskan ulang dengan kata sendiri + bukti `flutter test`).

---

## Resources

- **Resmi:** [dart.dev/language/collections](https://dart.dev/language/collections), [dart.dev/null-safety](https://dart.dev/null-safety), [docs.flutter.dev/cookbook](https://docs.flutter.dev/cookbook).
- **Dalam paket:** `../01-Orientasi/Checklist-Environment.md`, `../01-Orientasi/Tes-Diagnostik-Konsep.md`, `../01-Orientasi/Tes-Diagnostik-Praktik.md`, `../05-Assessment/Lembar-Observasi.md`.
- **Starter:** `../06-Starter-Code/p01-diagnosis/` (README + struktur di atas).

**Persiapan P02:** baca ulang model `Task` dan `getDummyTasks`; coba bayangkan bagaimana `ListView.separated` + `Column`/`Expanded` akan menampung chip filter dan daftar tanpa overflow.

---

**Estimasi belajar mandiri:** 4-5 jam | **Kesulitan:** dasar-menengah | **Updated:** 2026-08-08
