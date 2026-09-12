# p04-sqlite, SQLite & Offline-First

> **Pertemuan 4**, fokus: skema SQLite, local datasource, mapper baris/model, repository, persistensi setelah restart.
> **Role starter:** shell arsitektur data lengkap (database -> datasource -> repository -> provider). Mapper, datasource CRUD, dan wiring provider CRUD sengaja no-op TODO. UI sudah tampil (loading/empty/error/list).

## Prasyarat

- Selesai P03 (Provider + CRUD reaktif).
- `flutter doctor` bersih; target demo Android (atau desktop test via ffi).

## Instruksi run

```bash
flutter create --platforms=android. # di dalam folder ini; `sqflite` tidak mendukung web
flutter pub get
flutter analyze
flutter test
flutter run
```

> Catatan: `sqflite` tidak berjalan di web. Untuk demo tanpa internet gunakan
> Android (emulator/physical). Test headless otomatis memakai `sqflite_common_ffi`.

## Struktur penting

```text
lib/
├── main.dart # wiring: DB -> datasource -> repo -> provider
├── app.dart
├── core/{constants,theme}/
└── features/tasks/
 ├── domain/task.dart
 ├── data/
 │ ├── local/
 │ │ ├── task_database.dart # open + skema (CREATE TABLE tasks)
 │ │ ├── task_mapper.dart # fromRow/toRow = TODO
 │ │ └── local_task_datasource.dart # CRUD = TODO
 │ └── repositories/
 │ └── task_repository.dart # LocalTaskRepository (upsert)
 └── presentation/
 ├── providers/task_provider.dart # CRUD wiring ke repo = TODO
 └── screens/{task_list_screen,task_form_screen}.dart
test/
├── task_mapper_test.dart # MERAH sampai mapper selesai
├── local_task_datasource_test.dart # MERAH sampai datasource selesai
└── widget_test.dart # smoke (hijau: loading -> empty)
```

## Skema tabel `tasks`

| kolom | tipe | catatan |
|----------------|------|----------------------------------------|
| `id` | TEXT | primary key |
| `title` | TEXT | not null |
| `description` | TEXT | not null, default '' |
| `due_date` | TEXT | not null, ISO-8601 |
| `priority` | TEXT | not null, nama enum `TaskPriority` |
| `is_completed` | INT | not null, 0/1 |

## Target checkpoint

### CHECKPOINT 1: Buka database + skema
**Goal:** aplikasi jalan, tabel `tasks` tercipta saat first run.
**Time:** ~20 menit

**Validasi:**
- [ ] `flutter run` menampilkan loading singkat lalu empty state (karena tabel kosong).
- [ ] Tidak ada exception SQLite di logcat.
- [ ] `test/widget_test.dart` lulus (loading -> empty).

### CHECKPOINT 2: Mapper baris/model
**Goal:** `TaskMapper.fromRow`/`toRow` mengonversi tipe dengan benar.
**Time:** ~25 menit

**Melanjutkan CP 1:**
- Already have: tabel `tasks` + koneksi DB.
- 🆕 Will add: konversi `DateTime`/ISO, `enum`/nama, `bool`/int 0/1.

**Validasi:**
- [ ] `flutter test test/task_mapper_test.dart`, semua **hijau** (3 test).

### CHECKPOINT 3: Datasource + provider CRUD persisten
**Goal:** add/update/delete/toggle menulis ke SQLite dan data bertahan setelah restart.
**Time:** ~40 menit

**Melanjutkan CP 2:**
- Already have: mapper hijau.
- 🆕 Will add: query di datasource + hubungkan provider CRUD ke repository.

**Validasi:**
- [ ] `flutter test test/local_task_datasource_test.dart`, semua **hijau**.
- [ ] FAB -> form -> save -> task muncul di list.
- [ ] Kill aplikasi, `flutter run` lagi -> **task tetap ada** (persistence terbukti).
- [ ] Swipe delete -> task hilang; restart -> tetap hilang.
- [ ] Toggle complete -> status berubah; restart -> status bertahan.

## Yang TIDAK boleh diubah

- `Task` class dan enum.
- `TaskSchema` (nama tabel/kolom), dipakai mapper dan test.
- `LocalTaskRepository` (sudah benar; upsert).
- `main.dart` wiring (kecuali menambah provider lain yang relevan).

## Petunjuk

- Buka koneksi lewat `(await _db.database())` di tiap method datasource.
- Mapper dulu, baru datasource. Test mapper merah = sinyal mapper belum selesai.
- Provider CRUD: setelah `_repo.save(...)`/`_repo.remove(...)`, panggil `await loadTasks()` (atau mutasi `_tasks` manual) lalu `notifyListeners()`.
- `bool` di SQLite = integer; jangan simpan string `"true"`.

## Troubleshooting

- **`SqfliteDatabaseException: no such table`?** Pastikan `_onCreate` menjalankan `TaskSchema.createTable` dan versi DB konsisten.
- **Data hilang setelah restart?** Method datasource CRUD masih no-op TODO; selesaikan checkpoint 3.
- **Mapper test merah `UnimplementedError`?** `fromRow`/`toRow` memang sengaja dilempar, implementasikan.
- **Test gagal `MissingPluginException` SQLite?** Test harus pakai `sqflite_common_ffi`; cek `setUpAll` mengaktifkan `databaseFactoryFfi`.

## Status verifikasi host

Host produksi tidak punya Flutter SDK. `pub get/analyze/test` belum dijalankan di sini; verifikasi runtime ditangguhkan sampai SDK tersedia (lihat `06-Starter-Code/README.md`).
