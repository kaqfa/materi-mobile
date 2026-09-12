# Modul Kelas P04, SQLite dan Offline-First

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi:** 150 menit (3 × 50) | **Rasio praktik minimal:** 65%
**Pasangan:** `../02-Materi/P04-SQLite-Offline-First.md` (materi)
**Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Runbook-Dosen.md`, `../05-Assessment/Lembar-Observasi.md`

> **Untuk dosen/asisten.** Modul ini panduan menjalankan kelas, bukan handout mahasiswa. `solution-reference/` **jangan dibagikan** sebelum sesi selesai. **Assignment 1 ditenggat sebelum P04**, kumpulkan/cek di blok 1; mahasiswa yang belum selesai wajib tuntaskan (action dosen, catat tenggat individual). **Assignment 2 baru dibuka di P05**, bukan hari ini.

---

## BAGIAN 1: Overview

### Tujuan Hari Ini

Mahasiswa mampu:
1. Membuka database SQLite lewat `TaskDatabase` (lazy open + `onCreate`) dan menjelaskan pemetaan tipe Dart -> SQLite.
2. Mengimplementasikan `TaskMapper.fromRow`/`toRow` sampai `task_mapper_test.dart` hijau (marshaling `DateTime`/`enum`/`bool`).
3. Mengisi query `LocalTaskDatasource` + menghubungkan `TaskProvider` CRUD ke repository, lalu **membuktikan persistensi: data bertahan setelah restart app**.
4. Menjelaskan konsep migration (`version`/`onUpgrade`) dengan contoh kecil.

### Rundown Kelas (150 menit)

```
00-10 Gate Assignment 1 (kumpul/cek) + retrieval quiz P03 (Provider/async) (10 menit)
10-30 Konsep SQLite + arsitektur layer + live demo (20 menit)
30-85 Guided lab + 3 checkpoint (55 menit)
85-125 Praktik individual + observasi dosen (40 menit)
125-140 Demo persistence + challenge reveal (15 menit)
140-150 Exit ticket + PR + persiapan P05 (10 menit)
```

> Alokasi mengikuti format tetap (`Runbook-Dosen.md` bagian 3). Blok 1 menyisipkan **gate Assignment 1** (tenggat sebelum P04). Bila banyak mahasiswa belum selesai Assignment 1, **tahan** mereka menyelesaikan minimal search+filter reaktif sebelum lanjut SQLite, fondasi P03 wajib utuh sebelum data layer. Jangan kurangi blok observasi (40').

### Yang Harus Sudah Ready (sebelum kelas)

- [ ] Starter `06-Starter-Code/p04-sqlite/` lolos `pub get`/`analyze`; `widget_test.dart` smoke hijau, `task_mapper_test.dart` + `local_task_datasource_test.dart` sebagian merah (baseline TODO terkonfirmasi).
- [ ] `flutter doctor` bersih; versi kelas dipin; dependency `sqflite ^2.3.3+1`, `path ^1.9.0`, `provider ^6.1.2` (dev: `sqflite_common_ffi ^2.3.3+1`) terkunci. Target demo **Android** (bukan web, `sqflite` butuh native).
- [ ] Assignment 1: `04-Penugasan/Assignment-01-Task-Tracker-Core.md` + `Rubrik-Assignment-01.md` siap untuk **pengecekan/kumpul** di blok 1.
- [ ] `Lembar-Observasi.md` (satu per mahasiswa) siap diisi.
- [ ] Mahasiswa pita merah di P03 (Provider/async) sudah dipasangkan anchor hijau; siap dengan **demo restart** (perangkat/emulator).
- [ ] `solution-reference/` di kanal privat, tidak terlihat mahasiswa.
- [ ] DB Browser for SQLite (atau alat serupa) terinstall di mesin dosen untuk **demo file `tasks.db`** bila perlu.

---

## BAGIAN 2: Live Coding (Konsep + Demo)

### Demo 1: Arsitektur layer + persistensi (10 menit)

_Ikuti dosen, jangan maju sendiri._

Tampilkan `main.dart` + `task_database.dart` + rantai dependency. Tunjukkan:

1. `main.dart` -> wiring `TaskDatabase` -> `LocalTaskDatasource` -> `LocalTaskRepository` -> `TaskProvider`.
2. `task_database.dart` -> `TaskSchema.createTable` (skema `tasks`) + lazy `database()`.
3. `flutter run` (first run, tabel kosong) -> loading -> empty state.

**Penting:**
- **Sumber kebenaran pindah dari memori (P03) ke file SQLite.** App dibunuh -> data tetap.
- **Offline-first:** lokal = source of truth. P05 menambah remote, lokal tetap jadi fallback.
- **Layer terpisah:** provider hanya kenal abstraksi `TaskRepository`. Swap ke remote (P05) tanpa ubah UI.
- **Lazy open:** DB dibuka saat pertama butuh, bukan di konstruktor.

**Test live (diskusi):**
- "Kalau saya ubah skema setelah ada data user, apa yang terjadi?" (jawaban: butuh migration `version`/`onUpgrade`; tanpa itu `no such column`/data lama tak cocok).
- "Kenapa `is_completed` disimpan 0/1, bukan `true`/`false`?" (jawaban: SQLite tak punya BOOLEAN; integer 0/1 konvensi; query `WHERE is_completed = 1` tak match string).

### Demo 2: Marshaling tipe + pola CRUD persisten (10 menit)

Live coding di scratch atau tampilkan `task_mapper.dart` + `local_task_datasource.dart` (belum diisi). Tunjukkan pola, **bukan** implementasi penuh:

```dart
// Mapper: marshaling tipe eksplisit
Map<String, Object?> toRow(Task t) => {
 TaskSchema.columnDueDate: t.dueDate.toIso8601String(), // DateTime -> ISO
 TaskSchema.columnPriority: t.priority.name, // enum -> nama
 TaskSchema.columnIsCompleted: t.isCompleted ? 1 : 0, // bool -> int
};

// Datasource: query pakai placeholder anti-injection
await db.update(
 TaskSchema.table, TaskMapper.toRow(t),
 where: '${TaskSchema.columnId} = ?', whereArgs: [t.id],
);
```

Dan pola provider persisten:

```dart
Future<void> addTask(Task task) async {
 await _repo.save(task); // tulis DB dulu
 await loadTasks(); // reload dari source of truth
 notifyListeners(); // UI reaktif
}
```

**Penting:**
- **CRUD sekarang async** (I/O DB). Pola anti context misuse dari P03 tetap berlaku: simpan provider sebelum `await`, cek `mounted` setelahnya.
- **Tulis dulu, reload, notify**, urutan ini. Terbalik -> race / UI data lama.
- **Mapper = satu tempat konversi tipe.** Salah di mapper -> rusak seluruh app.

**Common errors (antisipasi):**
```
'Data hilang setelah restart' -> datasource CRUD masih no-op / path DB salah.
'FormatException due_date' -> simpan millis, parse ISO (inkonsisten).
'CastException int -> bool' -> simpan string "true", baca as int.
'SqfliteDatabaseException: no such table' -> onCreate tak jalan / version naik tanpa onUpgrade.
```

> **Jangan** tunjukkan implementasi `fromRow`/`toRow` lengkap atau query datasource penuh di demo. Beri pola (snippet di atas); biarkan mahasiswa menerjemahkan ke starter P04.

---

## BAGIAN 3: Guided Lab, 3 Checkpoint (55 menit)

Ikuti materi `../02-Materi/P04-SQLite-Offline-First.md`. Tiap checkpoint harus jalan sebelum lanjut (no broken state).

### CHECKPOINT 1: Buka Database + Skema (≈15')
- Mahasiswa baca `task_database.dart`/`main.dart`; `flutter test test/widget_test.dart`; `flutter run` tampil loading -> empty, no exception SQLite.
- **Gate dosen:** skema dipahami (pemetaan tipe Dart -> SQLite), lazy open dijelaskan, file `tasks.db` tercipta (cek via Device File Explorer bila ragu). Mahasiswa bisa menjelaskan kapan `onCreate` dipanggil.

### CHECKPOINT 2: Mapper Baris/Model (≈20')
- Mahasiswa implementasi `fromRow`/`toRow` (`toIso8601String`/`DateTime.parse`, `.name`/`.byName`, `? 1 : 0`/`!= 0`). Jalankan `flutter test test/task_mapper_test.dart` -> semua hijau.
- **Gate dosen:** 3 test mapper hijau (termasuk round-trip). Mapper = prasyarat datasource; **jangan izinkan lanjut CP3 sebelum hijau**. Tanyakan "kenapa boolean 0/1 bukan string?", wajib bisa jawab.

### CHECKPOINT 3: Datasource + Provider CRUD Persisten (≈20')
- Mahasiswa isi query `LocalTaskDatasource` + hubungkan `TaskProvider` CRUD ke repo. Jalankan `flutter test test/local_task_datasource_test.dart` -> semua hijau. Uji CRUD end-to-end + **restart persistence**.
- **Gate dosen:** test datasource hijau + **demo restart** (kill app -> run -> data tetap). Ini gate utama P04, tahan mahasiswa sampai persistensi terbukti. Cek tiga jebakan: path DB, boolean string, tanggal ISO/millis.

> Bila ada mahasiswa buntu > 10 menit di CP2/CP3, beri pertanyaan pengarah (bukan jawaban): "Kolom `is_completed` di DB Browser kelihatan apa, `0`/`1` atau `true`?" / "Setelah `save`, apa yang kamu lupa muat ulang?" / "Coba round-trip test dulu, `dueDate` sama setelah `toRow -> fromRow`?" Catat bantuan di `Lembar-Observasi.md`.

---

## BAGIAN 4: Praktik Individual + Observasi (40 menit)

**Tujuan:** mengukur kemampuan individu mengimplementasikan-membuktikan persistensi, **tanpa AI untuk core mapper/query/provider wiring**.

### Praktik Mandiri (30')

Kerjakan di luar checkpoint wajib: perkaya **query datasource dan ketahanan data**.

**Task:**
1. Tambah **unit test** di `local_task_datasource_test.dart`: `clear()` mengosongkan tabel; insert dengan id yang sudah ada + `ConflictAlgorithm.replace` menimpa (bukan duplikat); `getAll()` urut judul naik.
2. Tambah method `getByPriority(TaskPriority)` di datasource (query `WHERE priority = ?` + `whereArgs`), tanpa ubah skema. Tambah satu test.
3. Pastikan `flutter analyze` + `flutter test` tetap hijau. Lakukan **demo restart** sendiri: add -> kill -> run -> data tetap.

**Checklist progres:**
- [ ] 2-3 edge case test baru lulus (clear, replace, orderBy).
- [ ] `getByPriority` + test lulus; `analyze` bersih.
- [ ] Restart persistence terbukti (screenshot before/after kill).
- [ ] Tidak ada string boolean; tanggal konsisten ISO.

**Expected output (uji manual):**
```
datasource.clear() -> getAll() kosong.
insert task A, insert task A (id sama) -> getAll() length 1, data terbaru.
getByPriority(high) -> hanya task high, urut judul.
kill app -> run -> task tetap ada (persistence).
```

**Bantuan:**
- `ConflictAlgorithm.replace`: bila id primary key bentrok, baris lama diganti. Test: insert dua kali id sama, cek `length == 1` + field terbaru.
- `getByPriority`: `db.query(table, where: '${TaskSchema.columnPriority} = ?', whereArgs: [p.name])`. Jangan lupa `orderBy` bila mau konsisten.
- Restart: hentikan `flutter run` (`q` atau Ctrl-C) atau stop dari recent apps. Jangan hot reload, itu tidak membunuh app.

### Challenge Individual (10')

Pilih satu level, kerjakan sendiri, siapkan bukti. Dinilai via `Lembar-Observasi.md`.

**Level 1 (Basic):** Unit test `getAll()` urut judul naik (verifikasi `orderBy` benar).

**Level 2 (Medium):** Method `getByPriority(TaskPriority)` + test, tanpa ubah skema. Relevan untuk filter **Assignment 2**.

**Level 3 (Advanced):** Simulasi migration v2, naikkan `version: 2`, `onUpgrade` `ALTER TABLE tasks ADD COLUMN tags TEXT NOT NULL DEFAULT ''`. Uninstall app, jalankan, cek `tags` ada di DB tanpa data lama hilang. Jelaskan (2-3 kalimat) **kenapa** `onUpgrade` penting di app yang sudah punya user.

**Submit:** screenshot + paste kode + 2-3 kalimat penjelasan.

> Challenge Level 2/3 langsung relevan untuk **Assignment 2** (filter by status/category di sumber data; evolusi skema). Mahasiswa yang selesaikan = semakin siap P05.

---

## BAGIAN 5: Demo Persistence + Challenge Reveal (15 menit)

**Pada menit 125, hentikan praktik individual.** Jalankan demo persistence gabungan:

1. **Pilih 1-2 mahasiswa** (rotasi, catat di observasi) untuk **demo restart di depan kelas**:
 - Add task -> tunjukkan di list.
 - Kill app (stop terminal / recent apps).
 - `flutter run` lagi -> **task tetap ada**.
 - Jelaskan **di file mana** data disimpan (`/data/data/<package>/databases/tasks.db`) dan **kenapa** bertahan.
2. **Reveal challenge:** siapa yang selesaikan Level 2/3 tunjukkan singkat (1-2 menit). Catat di observasi untuk pita Hijau.
3. **Common pitfall review:** tampilkan satu kasus buntu tadi (anonim), diskusikan root cause (mis. boolean string, path DB). Ini pembelajaran kolektif.

> **Bila waktu mepet:** pangkas demo ke 1 mahasiswa; challenge reveal cukup yang Level 2. **Jangan** pangkas exit ticket (blok 6), feedback loop wajib.

---

## BAGIAN 6: Take-Home / PR + Exit Ticket (10 menit terakhir)

**PR minggu depan (menuju P05):**
1. Pastikan `task_mapper_test.dart` + `local_task_datasource_test.dart` **semua hijau**; kumpulkan diff + screenshot demo restart (add/edit/delete/toggle masing-masing bertahan).
2. Selesaikan ulang CP3 bila persistence belum terbukti (data hilang setelah restart = belum lulus P04).
3. Baca ulang abstraksi `TaskRepository`; bayangkan implementasi kedua `RemoteTaskRepository` yang juga implement interface itu, catat satu pertanyaan untuk retrieval quiz P05.
4. Catat **satu konsep SQLite/migration yang belum jelas** untuk retrieval P05.

**Persiapan P05:**
- `TaskRepository` dapat implementasi remote (HTTP/JSON). Mapper JSON (`toJson`/`fromJson`) meniru pola `toRow`/`fromRow`.
- Provider menangani state lokal vs remote, network-error, 4xx/5xx, retry manual. **Assignment 2 dibuka di P05.Exit ticket:** satu konsep belum jelas + satu hal sudah jelas + screenshot demo restart + pernyataan pemakaian AI (lampirkan log bila ya).

Dosen mengisi pita praktik di `Lembar-Observasi.md` (Merah/Kuning/Hijau) + satu rekomendasi per mahasiswa. Mahasiswa yang persistence belum terbukti wajib selesai sebelum mulai Assignment 2 (action dosen).

---

## BAGIAN 7: References

- Materi: `../02-Materi/P04-SQLite-Offline-First.md`.
- Diagnosis: `../01-Orientasi/Tes-Diagnostik-Konsep.md`, `../05-Assessment/Lembar-Observasi.md`.
- Tugas: `../04-Penugasan/Assignment-01-Task-Tracker-Core.md`, `../04-Penugasan/Rubrik-Assignment-01.md` (gate di blok 1).
- Starter: `../06-Starter-Code/p04-sqlite/` (+ `solution-reference/`, dosen).
- Standar: `../../Standar Tutorial Koding PPB.md`, `../../Standar Pengembangan Materi PPB.md`.
- Konsep dasar: `../../Tutorial/outline-p08-database.md` (dipersempit ke starter P04).

---

## Catatan Dosen (Notes)

- **Gate Assignment 1 (tenggat sebelum P04).** Di blok 1, kumpulkan/cek Assignment 1. Mahasiswa yang belum selesai (minimal search + filter reaktif) **wajib tuntaskan** sebelum lanjut SQLite sungguhan, fondasi P03 (Provider/async/CRUD reaktif) adalah prasyarat data layer. Catat tenggat individual; bila perlu pasangkan anchor. **Assignment 2 baru dibuka di P05**, jangan bahas detail hari ini.
- **Penegakan AI (P4-P5):** AI boleh debugging/review error data layer, **tidak** menulis core `fromRow`/`toRow`/query/provider wiring tanpa analisis. Tolak tempelan AI tanpa penjelasan; minta kerja ulang + jelaskan tiap baris. Catat di `Lembar-Observasi.md` D7. Saat demo, tanya "baris ini ngapain?" di mapper/query/provider.
- **Broken state = jangan lanjut.** Mapper merah (CP2) = belum boleh CP3. Datasource merah atau persistence gagal = belum lulus P04. Mahasiswa yang broken wajib selesai sebelum Assignment 2.
- **Tiga jebakan utama, tekankan:**
 1. **Database path** (`await getDatabasesPath()` + fileName; jangan hardcode; cek file di Device File Explorer).
 2. **Boolean 0/1** (jangan string `"true"`; konsisten `toRow`/`fromRow`; verifikasi di DB Browser).
 3. **Tanggal ISO/millis** (pilih satu, konsisten; round-trip test; hati-hati timezone UTC vs local).
- **Restart demo = gate utama.** "Data muncul di layar" bukan bukti P04 (itu sudah bisa P03). Bukti: kill app -> run -> data tetap. Latih mahasiswa melakukan kill yang benar (hentikan `flutter run`/stop recent apps, **bukan** hot reload).
- **Async + context misuse.** Provider CRUD sekarang `Future<void>`. Pastikan pola "simpan provider sebelum `await` + `mounted` guard" tertanam (warisan P03); kritis di P05 (network latency lebih besar).
- **Target platform.** Demo di Android (emulator/physical). **Bukan web**, `sqflite` butuh native SQLite. Test headless pakai `sqflite_common_ffi` (sudah di `setUpAll`); pastikan mahasiswa tak menghapus baris ffi itu.
- **Migration = konsep, bukan kebutuhan fungsional P04.** Starter `version: 1` tanpa `onUpgrade` cukup untuk sesi. Jangan menyuruh semua mahasiswa migrasi; cukup challenge Level 3 bagi yang cepat. Bahas konsep di demo 1.
- **Anchor pairing.** Mahasiswa pita merah di async/Provider dari P03 dipasangkan anchor hijau; SQLite memperberat beban async, yang masih merah setelah P04, tunda eksplorasi challenge Level 2/3 sampai fondasi aman.
- **Jangan bagikan solution-reference.** Peta pita + rekomendasi saja yang dikembalikan.
- **Pacing.** Observasi 40' tidak boleh dipangkas. Bila mepet, pangkas challenge Level 3 / demo ke 1 mahasiswa, bukan observasi maupun exit ticket.
- **Versi toolchain.** Catat versi kelas; starter memakai `sdk: ^3.4.0`, `flutter: ">=3.22.0"`, `sqflite: ^2.3.3+1`, `path: ^1.9.0`, `provider: ^6.1.2` (dev `sqflite_common_ffi: ^2.3.3+1`). Sesuaikan bila berubah.

---

**Kepatuhan produksi:**
- Rundown 150 menit, rasio praktik ≥ 65%, **gate Assignment 1 di blok 1** (tenggat sebelum P04).
- 3 checkpoint + validasi testable + troubleshooting (mapper tipe, query placeholder, restart persistence, path/boolean/date).
- Live demo (arsitektur layer + marshaling), praktik mandiri (edge case test + `getByPriority`), challenge 3 level, demo persistence, exit ticket.
- Notes dosen + penegakan AI (P4-P5: debugging boleh, core logic analisis sendiri) + rujuk rubrik/observasi/tugas.
- Semua path merujuk starter P04 (`06-Starter-Code/p04-sqlite/`), materi `02-Materi/P04-SQLite-Offline-First.md`, dan Assignment 1 (`04-Penugasan/`).

**Updated:** 2026-08-08
