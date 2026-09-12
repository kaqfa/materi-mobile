# Bank Soal Live Modification, PPB Remidi 7 Pertemuan (Dosen)

> **Status:** v1.0, 2026-08-08
> **Klasifikasi:DOSEN/ASISTEN, untuk persiapan & pelaksanaan demo final P07.** Bagian "Kunci singkat" () jangan dibagikan ke mahasiswa sebelum/di luar sesi.
> **Aplikasi jangkar:Remedial Task Tracker**
> **Tujuan:** menyediakan ≥10 variasi soal live modification yang **setara** (durasi, kesulitan, kriteria konsisten) untuk menguji pemahaman individual. Soal ditarik acak oleh dosen di sesi final P07.
> **Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../02-Materi/P06-Device-Testing-QA.md`, `../02-Materi/P07-Release-Live-Coding-Demo.md`, `../00-Planning/Rubrik-Remedial.md` §5.
> **Rubrik penilaian demo + live mod:** `Rubrik-Demo-dan-Wawancara.md`. **Rubrik Proyek Akhir:** `../04-Penugasan/Rubrik-Proyek-Akhir.md`.

## 0. Cara pakai (dosen)

1. **Sebelum sesi P07**: pilih 1 soal acak per mahasiswa dari bank ini. Jangan mengulang soal yang sama pada dua mahasiswa berurutan; jaga kesetaraan (durasi 20-25 menit, kesulitan Basic/Medium).
2. **Saat demo**: tampilkan **hanya prompt soal** (bagian "Prompt") + "Kriteria sukses". Sembunyikan "Kunci singkat" ().
3. **Alur kerja yang dinilai** (bukan hanya hasil): baca soal -> tanya klarifikasi bila ambigu -> identifikasi file -> rencana sebelum ngetik -> implement -> jalankan `flutter analyze` + `flutter test` -> jelaskan dengan kata sendiri.
4. **Gate pasca-modifikasi**: `analyze` + `test` tetap hijau (atau test baru ditambahkan sesuai perubahan). Gate merah tanpa perbaikan = penalti (lihat `Rubrik-Demo-dan-Wawancara.md`).
5. **Variasi setara untuk semester berikutnya**: ganti field (mis. `priority` -> `category`), tukar arah sort, ubah nilai konstanta, namun **jaga** struktur kriteria (prompt + 3-5 acceptance + kunci) dan rubrik demo. Jangan membagikan kunci ke kanal mahasiswa.

### Aturan umum seluruh soal
- Titik mulai: hasil **Assignment 1 + Assignment 2** mahasiswa (app utuh: UI/state + REST/mock; sumber lokal boleh in-memory **atau** SQLite, keduanya sah).
- **Sebelum menarik soal, cek jalur lokal mahasiswa (A/B) di README.** Jangan menarik soal kategori **mapper SQLite** untuk mahasiswa jalur A (in-memory), pilih varian JSON/filter/validasi yang setara.
- Tidak boleh menonaktifkan linter / skip test / `// ignore:` tanpa alasan tertulis.
- Boleh memakai AI **untuk penjelasan/debugging/strategi**, **tidak boleh** menyelesaikan core logic tanpa analisis sendiri (kebijakan AI P07). Pemakaian AI dicatat di `../01-Orientasi/Template-AI-Interaction-Log.md`.
- Konsistensi model: `Task { id, title, description, dueDate, priority: TaskPriority{low,medium,high}, isCompleted }` dengan `status` turunan (`pending`/`overdue`/`completed`). `TaskFilterService.apply(tasks, TaskFilter{status, search})` = AND. Jangan mengubah signature inti tanpa seizin dosen.

## 1. Ringkasan bank (12 soal, ≥10 variasi)

| ID | Kategori | Kesulitan | Durasi | Area RPS | Inti perubahan |
|---|---|:---:|---:|---|---|
| SORT-01 | Sorting | Basic | 20' | 53.1 | Sort daftar by `priority` descending |
| SORT-02 | Sorting | Medium | 25' | 53.1 | Sort overdue-first lalu by dueDate |
| FILT-01 | Filter baru | Basic | 20' | 53.1 | Chip filter "overdue only" |
| FILT-02 | Filter baru | Medium | 25' | 53.1 | Filter `priority` + `status` AND (ekstensi `TaskFilter`) |
| FILT-03 | Filter/Search | Medium | 25' | 53.1 | Search mencakup `description` (cek/fix) |
| DATE-01 | Validasi tanggal | Basic | 20' | 92.1 | Form tolak due date lampau saat add |
| DATE-02 | Filter tanggal | Medium | 25' | 53.1 | Filter task jatuh tempo ≤7 hari ke depan |
| EMPTY-01 | Empty state khusus | Basic | 20' | 92.1 | Pesan berbeda "semua completed" vs "belum ada task" |
| EMPTY-02 | Empty state khusus | Medium | 25' | 92.1 | Empty state menyebut filter aktif |
| MAP-01 | Mapper JSON | Medium | 25' | 53.1/53.2 | Tambah field `tags` ke `toJson`/`fromJson` |
| MAP-02 | Mapper JSON | Medium | 25' | 53.2 | Tambah `updatedAt` (ISO) round-trip di mapper SQLite + JSON |
| IMM-01 | Immutability/const | Basic | 20' | 53.1/53.2 | Toggle via `copyWith` tanpa mutasi asli + `const` assertion |

> Total 12 variasi ≥ ambang 10. Kategori terliput: sorting (2), filter/search (3), tanggal (2), empty state (2), mapper JSON (2), immutability/const (1). Kesulitan distribusi: Basic 5 / Medium 7.

---

## 2. Detail soal

### SORT-01, Sort by priority descending (Basic)

**Area RPS:** 53.1 | **Durasi:** 20' | **Prasyarat:** `TaskFilterService`, `TaskPriority{low,medium,high}`.

**Prompt (tampilkan ke mahasiswa):**
> Saat ini daftar task tampil dalam urutan input. Ubah agar daftar **selalu diurutkan menurun berdasarkan prioritas** (high -> medium -> low). Untuk prioritas sama, urutkan `title` menaik sebagai tie-breaker deterministik. Pastikan urutan ini berlaku **setelah** filter/search.

**Kriteria sukses:**
- [ ] Task `high` muncul sebelum `medium` sebelum `low`.
- [ ] Prioritas sama diurutkan `title` menaik sebagai tie-breaker.
- [ ] Sort berlaku **setelah** filter/search (hasil filter tetap terurut).
- [ ] `flutter analyze` + `flutter test` hijau; tambah unit test untuk urutan.

**Kunci singkat (dosen):**
```dart
// Komparator via index enum; index tinggi = prioritas tinggi.
// enum TaskPriority { low, medium, high } -> high.index=2 paling besar.
final sorted = [...filtered]..sort((a, b) {
 final priority = b.priority.index.compareTo(a.priority.index);
 return priority != 0 ? priority : a.title.compareTo(b.title);
});
```
Gunakan `[...filtered]` (copy) agar sort tidak mutasi list asli. Jangan mengandalkan `List.sort` sebagai stable sort; tie-breaker `title` membuat hasil deterministik. Verifikasi dengan list campuran + filter aktif.

**Referensi:** `../02-Materi/P06-Device-Testing-QA.md` (`TaskFilterService`), `../02-Materi/P01-Diagnosis-Dart-Debugging.md` (enum/index).

---

### SORT-02, Overdue-first lalu by dueDate (Medium)

**Area RPS:** 53.1 | **Durasi:** 25' | **Prasyarat:** `Task.status` turunan, comparator.

**Prompt:**
> Ubah urutan daftar: **task overdue muncul paling atas**, diikuti sisanya **diurutkan by `dueDate` naik** (paling cepat jatuh tempo dulu). Completed boleh di bawah. Sort berlaku setelah filter.

**Kriteria sukses:**
- [ ] Task overdue (`status == overdue`) di paling atas.
- [ ] Sisanya terurut by `dueDate` naik.
- [ ] Sort stabil & pasca-filter.
- [ ] `analyze` + `test` hijau; unit test minimal 2 kasus (ada overdue, tidak ada overdue).

**Kunci singkat (dosen):**
```dart
int rank(Task t) => t.status == TaskStatus.overdue ? 0 : 1;
final sorted = [...filtered]..sort((a, b) {
 final r = rank(a).compareTo(rank(b));
 if (r != 0) return r;
 return a.dueDate.compareTo(b.dueDate);
 });
```
Hati-hati: `status` pakai `DateTime.now()`, test harus pakai tanggal relatif.

**Referensi:** `Task.status` (`p06/lib/features/tasks/domain/task.dart`), P06.

---

### FILT-01, Chip filter "overdue only" (Basic)

**Area RPS:** 53.1 | **Durasi:** 20' | **Prasyarat:** `TaskFilter`, UI chip filter.

**Prompt:**
> Tambah satu chip filter baru: **"Overdue"**. Saat aktif, hanya task berstatus `overdue` yang tampil. Chip ini bekerja **bersama** search & filter yang sudah ada (AND). Beri indikator aktif jelas.

**Kriteria sukses:**
- [ ] Chip "Overdue" muncul & toggle aktif/non-aktif.
- [ ] Aktif -> hanya `status == overdue`.
- [ ] Bekerja AND dengan search & filter lain.
- [ ] Indikator aktif jelas (warna/filled).
- [ ] `analyze` + `test` hijau; widget/unit test chip ada.

**Kunci singkat (dosen):**
Bila UI sudah pakai `TaskFilter.status: TaskStatus?`, chip "Overdue" = set `status = TaskStatus.overdue`. Bila sudah ada chip per-status, ini sekadar praset filter; pastikan tidak duplikat state. Kalau ingin chip terpisah dari filter status, tambah `bool overdueOnly` di `TaskFilter` + kondisi AND di `apply`.

**Referensi:** `TaskFilterService` (P06), chip filter P03.

---

### FILT-02, Filter `priority` + `status` AND (Medium)

**Area RPS:** 53.1 | **Durasi:** 25' | **Prasyarat:** `TaskFilter`, `TaskPriority`.

**Prompt:**
> Saat ini `TaskFilter` hanya mendukung `status` + `search`. Tambahkan field `priority` (`TaskPriority?`). Saat di-set, hanya task dengan prioritas itu yang lolos. **Tiga kondisi (status AND priority AND search) bekerja bersamaan.** Sediakan UI picker/chip untuk priority.

**Kriteria sukses:**
- [ ] `TaskFilter` punya field `priority: TaskPriority?` + `copyWith`.
- [ ] `TaskFilterService.apply` memfilter priority (AND dengan status + search).
- [ ] UI priority picker/chip bekerja & reaktif.
- [ ] Hasil benar pada dataset campuran.
- [ ] `analyze` + `test` hijau; unit test kombinasi AND (≥2 kasus).

**Kunci singkat (dosen):**
```dart
class TaskFilter {
 final TaskStatus? status;
 final TaskPriority? priority; // <- baru
 final String search;
 const TaskFilter({this.status, this.priority, this.search = ''});
 // copyWith: priority: priority ?? this.priority
}
// di apply:
final pOk = filter.priority == null || t.priority == filter.priority;
```
Jebakan umum: lupa AND (pakai `||`) atau `copyWith` tak meneruskan `priority`.

**Referensi:** `TaskFilterService` (P06), `Rubrik-Assignment-01.md` A4/A5 (AND logic).

---

### FILT-03, Search mencakup description (Medium)

**Area RPS:** 53.1 | **Durasi:** 25' | **Prasyarat:** `TaskFilterService.apply`.

**Prompt:**
> Verifikasi: apakah search saat ini **juga** mencocokkan `description` (bukan hanya `title`)? Bila belum, perbaiki agar query mencocokkan **title ATAU description** (case-insensitive). Bila sudah, buktikan via test. Tetap AND dengan filter status.

**Kriteria sukses:**
- [ ] Query cocok dengan `title` **atau** `description` (case-insensitive, trim).
- [ ] AND dengan filter status tetap benar.
- [ ] Defensive: input null/empty -> list kosong (bukan error).
- [ ] `analyze` + `test` hijau; unit test: match title-only, match desc-only, no-match.

**Kunci singkat (dosen):**
Catatan: starter P06 `TaskFilterService` **sudah** mencocokkan title+description. Soal ini menguji apakah mahasiswa **membaca** kode (bukan asumsi). Jawaban benar bisa "sudah benar, ini test pembuktinya". Yang dinilai: bukti test + penjelasan. Jebakan: mahasiswa yang asing dengan starter justru menambah duplikasi.

**Referensi:** `TaskFilterService` (P06), `Kunci-Diagnostik.md` §2.5 (membaca logika).

---

### DATE-01, Tolak due date lampau saat add (Basic)

**Area RPS:** 92.1 | **Durasi:** 20' | **Prasyarat:** form validator (P03), `DateTime`.

**Prompt:**
> Saat **add** task, form harus **menolak due date di masa lalu** (hari ini boleh, kemarin tidak). Gunakan pesan `AppStrings.errDueDateInPast` (atau setara). Saat **edit**, masa lalu tetap boleh.

**Kriteria sukses:**
- [ ] Add: tanggal < hari ini -> pesan error, form tidak submit.
- [ ] Edit: masa lalu diperbolehkan.
- [ ] Pesan error jelas & muncul di bawah field.
- [ ] `analyze` + `test` hijau; widget test validasi ada.

**Kunci singkat (dosen):**
```dart
String? validateDueDate(DateTime? v, {required bool isEdit}) {
 if (v == null) return AppStrings.errDueDateRequired;
 if (!isEdit) {
 final today = DateTime.now();
 final dateOnly = DateTime(today.year, today.month, today.day);
 final vDay = DateTime(v.year, v.month, v.day);
 if (vDay.isBefore(dateOnly)) return AppStrings.errDueDateInPast;
 }
 return null;
}
```
Bandingkan **komponen tanggal saja** (bukan `DateTime` mentah) agar jam 00:00 hari ini tidak salah dianggap lampau.

**Referensi:** `Rubrik-Assignment-01.md` C6, P03 form validation.

---

### DATE-02, Filter task jatuh tempo ≤7 hari (Medium)

**Area RPS:** 53.1 | **Durasi:** 25' | **Prasyarat:** `TaskFilter`, `dueDate`, `DateTime`.

**Prompt:**
> Tambah filter **"Due soon"**: hanya task ber-`dueDate` dalam **7 hari ke depan** (termasuk hari ini), **tidak completed**. Bekerja AND dengan search. Sediakan chip/toggle UI.

**Kriteria sukses:**
- [ ] "Due soon" aktif -> hanya task `!isCompleted && dueDate <= now+7d && dueDate >= startOfToday`.
- [ ] AND dengan search tetap benar.
- [ ] Completed tidak lolos meski jatuh tempo dekat.
- [ ] `analyze` + `test` hijau; unit test batas (0 hari, 7 hari, 8 hari, completed).

**Kunci singkat (dosen):**
```dart
bool dueSoon(Task t, {DateTime? now}) {
 if (t.isCompleted) return false;
 final base = now ?? DateTime.now();
 final start = DateTime(base.year, base.month, base.day);
 final endExclusive = start.add(const Duration(days: 8)); // hari ini + 7 hari
 final due = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
 return !due.isBefore(start) && due.isBefore(endExclusive);
}
```
Bandingkan tanggal saja agar batas hari ini dan hari ke-7 tidak salah karena komponen jam. Test pakai `now` relatif.

**Referensi:** P06 `TaskFilterService`, P04 `DateTime`.

---

### EMPTY-01, Empty state: "all completed" vs "no tasks" (Basic)

**Area RPS:** 92.1 | **Durasi:** 20' | **Prasyarat:** empty state widget (P02/P03).

**Prompt:**
> Saat ini empty state menampilkan satu pesan generik. Ubah agar **membedakan dua konteks**:
> - Ada task tapi **semua completed** -> "Semua tugas selesai. Kerja bagus!".
> - Belum ada task sama sekali -> "Belum ada tugas. Tambahkan satu.".
> (Pertimbangkan juga konteks hasil filter kosong.)

**Kriteria sukses:**
- [ ] Pesan berbeda untuk "semua completed" vs "belum ada task".
- [ ] (Bonus) hasil filter kosong -> pesan "Tidak ada hasil untuk filter/search ini".
- [ ] Tidak ada layar blank.
- [ ] `analyze` + `test` hijau; widget test untuk ≥2 konteks.

**Kunci singkat (dosen):**
Logika di widget empty-state: cek `allTasks.isEmpty` vs `allTasks.every((t) => t.isCompleted)` vs `filteredTasks.isEmpty && allTasks.isNotEmpty`. Pisahkan branch. Jebakan: salah membandingkan `filteredTasks.isEmpty` saja (hilangkan nuansa).

**Referensi:** P02/P03 empty state, `Rubrik-Assignment-01.md` B4.

---

### EMPTY-02, Empty state menyebut filter aktif (Medium)

**Area RPS:** 92.1 | **Durasi:** 25' | **Prasyarat:** empty state, `TaskFilter` aktif.

**Prompt:**
> Saat hasil filter/search kosong, tampilkan pesan yang **menyebut filter aktif**: mis. "Tidak ada task berstatus **Overdue** yang cocok '**lab**'. Coba reset filter." Tombol "Reset filter" membersihkan filter+search.

**Kriteria sukses:**
- [ ] Pesan menyebut status/priority aktif + query search (bila ada).
- [ ] Tombol "Reset filter" mengosongkan filter & search; daftar kembali penuh.
- [ ] Pesan tetap masuk akal saat hanya search atau hanya filter aktif.
- [ ] `analyze` + `test` hijau; widget test reset filter.

**Kunci singkat (dosen):**
`TaskFilter` punya `status`/`search`; render label status (`status?.name`/humanized) + `'"$search"'`. Tombol reset -> `provider.setFilter(TaskFilter.empty)` + clear controller search. Test: isi filter -> expect empty state teks -> tap reset -> expect list.

**Referensi:** P06 `TaskFilter`, P03 provider state.

---

### MAP-01, Tambah field `tags` ke mapper JSON (Medium)

**Area RPS:** 53.1/53.2 | **Durasi:** 25' | **Prasyarat:** `Task.toJson`/`fromJson`, `API-CONTRACT.md`.

**Prompt:**
> Tambah field baru `tags: List<String>` (default `const []`) ke `Task`. Perbarui `toJson`/`fromJson` agar `tags` ikut round-trip (JSON array of string). Jaga snake_case konsisten. Tambah unit test round-trip.

**Kriteria sukses:**
- [ ] `Task` punya `tags: List<String>` (default kosong, `const []`).
- [ ] `toJson` -> `"tags": [...]`; `fromJson` membaca `tags` (default `[]` bila null).
- [ ] Round-trip `Task -> toJson -> fromJson -> Task'` menjaga `tags`.
- [ ] `copyWith` mendukung `tags`.
- [ ] `analyze` + `test` hijau; unit test round-trip.

**Kunci singkat (dosen):**
```dart
final List<String> tags; // final List<String> tags; default const []
'tags': tags, // toJson
tags: (j['tags'] as List?)?.cast<String>() ?? const [], // fromJson
```
Jebakan: `List<String>` mutable di field final -> gunakan `List.unmodifiable` di getter **atau** simpan `const []` default dan copy saat `copyWith`. Pastikan tidak pecah `const Task(...)`: field `tags` default `const []` agar constructor tetap const-friendly.

**Referensi:** `API-CONTRACT.md`, P04/P05 mapper, `Rubrik-Assignment-02.md` B3/B5.

---

### MAP-02, Tambah `updatedAt` (ISO) round-trip SQLite + JSON (Medium)

**Area RPS:** 53.2 | **Durasi:** 25' | **Prasyarat:** `TaskMapper.toRow`/`fromRow` + `toJson`/`fromJson`, `TaskSchema`.

**Prompt:**
> Tambah field `updatedAt: DateTime?` ke `Task`. Set `updatedAt = DateTime.now()` saat `copyWith` melakukan mutasi nyata (title/dueDate/priority/isCompleted berubah). Simpan di SQLite (kolom `updated_at` ISO-8601 text) **dan** JSON (`"updated_at"` ISO). Null boleh (task lama belum punya). Round-trip benar.

**Kriteria sukses:**
- [ ] `Task.updatedAt: DateTime?`; null untuk task lama.
- [ ] SQLite: kolom `updated_at` (ISO text); `TaskMapper` benar (null-aware).
- [ ] JSON: `"updated_at"` ISO; `fromJson` null-safe.
- [ ] `copyWith` menyetel `updatedAt` saat field inti berubah.
- [ ] Round-trip SQLite + JSON lossless (termasuk null).
- [ ] `analyze` + `test` hijau; unit test round-trip + null.

**Kunci singkat (dosen):**
SQLite: `null -> null`; non-null -> `.toIso8601String()`. JSON sama. `copyWith`: deteksi perubahan field inti (`title != this.title ||...`) -> set `updatedAt: DateTime.now()` bila berubah & pemanggil tak override eksplisit. Jebakan: lupa null-handling di `fromRow`/`fromJson`; `toRow` menulis `null` string bukan SQL NULL.

**Referensi:** `TaskSchema`/`TaskMapper` (P04), `API-CONTRACT.md`, `Rubrik-Assignment-02.md` A3.

---

### IMM-01, Toggle via `copyWith` tanpa mutasi asli + `const` assertion (Basic)

**Area RPS:** 53.1/53.2 | **Durasi:** 20' | **Prasyarat:** `Task.copyWith`, immutability, `const`.

**Prompt:**
> Implementasikan toggle completion via `copyWith(isCompleted: !t.isCompleted)` di `TaskProvider.toggleComplete`. Buktikan **asli tidak termutasi** (immutability). Lalu tambah unit test: `const Task(...)` kompilasi + setelah toggle, instance asli `isCompleted` tetap nilai awal.

**Kriteria sukses:**
- [ ] Toggle memakai `copyWith`; asli tidak berubah.
- [ ] `const Task(...)` tetap valid (semua field final/default const).
- [ ] Unit test: toggle tidak mutasi asli; dua kali toggle kembali semula (idempotent).
- [ ] `analyze` + `test` hijau.

**Kunci singkat (dosen):**
```dart
final toggled = original.copyWith(isCompleted: !original.isCompleted);
expect(original.isCompleted, isFalse); // asli utuh
expect(toggled.isCompleted, isTrue);
final back = toggled.copyWith(isCompleted: !toggled.isCompleted);
expect(back.isCompleted, original.isCompleted);
```
`const` assertion: `const Task(id: 'x', title: 'A', dueDate:...)` harus kompilasi (semua field punya default/const). Jebakan: menambah field mutable atau menyetel langsung `t.isCompleted =...` (tidak bisa karena final, tapi nilai tesnya).

**Referensi:** P07 `task_model_test.dart`, P01 model, `Rubrik-Assignment-01.md` D4.

---

## 3. Catatan konsistensi & variasi setara

- **Model `Task`**: field `id`, `title`, `description`, `dueDate`, `priority`, `isCompleted`, getter `status`. Jangan mengubah signature inti tanpa seizin dosen (aturan batas starter P03/P04/P05/P06). Soal MAP-01/MAP-02 menambah field, izinkan sebagai bagian soal, dokumentasikan perubahan.
- **`TaskFilter`/`TaskFilterService`** (P06): `apply(tasks, filter)` AND status + search; input empty -> `[]`. Soal FILT-02/FILT-03/DATE-02 memperluas, jaga kontrak AND & defensive empty.
- **Tanggal**: selalu relatif (`DateTime.now()`/`subtract`/`add`) di test. Status overdue bergantung `now()`.
- **Gate pasca-modifikasi**: `flutter analyze` + `flutter test` harus hijau (atau test baru ditambahkan). Tidak boleh skip/ignore tanpa alasan tertulis (`Rubrik-Demo-dan-Wawancara.md`).
- **Variasi semester berikutnya**: ganti field (`priority` -> `category`), tukar arah sort, ubah konstanta (7 hari -> 3 hari), tukar posisi branch empty state. Jaga: prompt + 3-5 kriteria + kunci + durasi/kesulitan setara. Jangan membagikan kunci ke kanal mahasiswa.
- **AI policy P07**: AI boleh untuk penjelasan/debugging/strategi, **tidak boleh** menyelesaikan core logic tanpa analisis. Pemakaian AI wajib dicatat di `../01-Orientasi/Template-AI-Interaction-Log.md`. Ketidakmampuan menjelaskan = penalti gate (`Rubrik-Demo-dan-Wawancara.md`).

---

**Status bank:** v1.0, 2026-08-08 | **Jumlah variasi:** 12 (≥ ambang 10) | **Konsistensi:** rujuk `Peta-Capaian-dan-Assessment.md` bila ada pertentangan angka.
