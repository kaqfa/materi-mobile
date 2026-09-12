# P04, SQLite dan Offline-First

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi sesi:** 150 menit (3 × 50) | **Estimasi belajar mandiri:** 5-7 jam
**Sub-CPMK:** 53.2 (SQLite, persistensi) | **Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`

> **Baca juga:** `../02-Materi/P03-Form-CRUD-Provider.md`, `../01-Orientasi/Panduan-Mahasiswa.md`. Pasangan kelas: `../03-Modul-Kelas/Modul-P04-SQLite-Offline-First.md`. Basis konsep: `../../Tutorial/outline-p08-database.md`, dipersempit ke skema/mapper/datasource/repository/restart persistence sesuai starter P04.

---

## Tujuan Pembelajaran

Setelah materi ini dikuasai, kamu mampu:

1. **Membuka database SQLite** dan mendefinisikan skema tabel `tasks` lewat `TaskSchema` + `TaskDatabase` (`sqflite` + `path`), termasuk lazy open dan `onCreate`.
2. **Mengkonversi tipe** antara model `Task` dan baris SQLite (`Map<String, Object?>`) lewat `TaskMapper`: `DateTime`/ISO-8601, `enum`/nama, `bool`/integer 0/1, sampai `task_mapper_test.dart` hijau.
3. **Menghubungkan datasource/repository/provider** sehingga CRUD menulis ke SQLite dan data **bertahan setelah restart app**; menjelaskan konsep migration via `version`/`onUpgrade` dengan contoh kecil.

**Outcome sesi (bukti observable):**
- Starter `06-Starter-Code/p04-sqlite/` berjalan: loading singkat -> empty state (tabel masih kosong).
- `flutter test test/task_mapper_test.dart`, semua test **hijau** (konversi tipe benar).
- `flutter test test/local_task_datasource_test.dart`, semua test **hijau** (CRUD persisten via `sqflite_common_ffi`).
- CRUD end-to-end: FAB -> form -> save -> muncul; tap -> edit; swipe -> delete; tap centang -> toggle.
- **Persistence terbukti:** kill app, `flutter run` lagi -> task tetap ada (termasuk perubahan edit/delete/toggle).

---

## Prasyarat

- Menyelesaikan `../02-Materi/P03-Form-CRUD-Provider.md`: paham `ChangeNotifier`/Provider, `context.watch`/`context.read`, CRUD reaktif, validator, lifecycle controller, dan pola "simpan provider sebelum `await` + `mounted` guard".
- `../01-Orientasi/Checklist-Environment.md` lulus; `flutter doctor` bersih. Target demo **Android** (emulator/physical), `sqflite` **tidak** berjalan di web.
- Starter P04 sudah di-copy ke workspace kosong (lihat "Setup").

> **Kebijakan AI P04:** AI boleh untuk **debugging dan review error data layer** (mis. "kenapa mapper test merah pada field date?"). AI **tidak boleh** menulis core `fromRow`/`toRow`/query datasource/provider CRUD tanpa analisis sendiri, kamu **wajib memahami perubahan data layer** (ini kriteria ujian). Bila memakai AI, isi `../01-Orientasi/Template-AI-Interaction-Log.md` dan pastikan kamu dapat menjelaskan tiap baris dengan kata sendiri.

---

## Setup

```bash
# 1. Copy folder starter ke workspace kosong, lalu di dalamnya:
flutter create --platforms=android. # hasilkan platform runner (sqflite butuh native)
flutter pub get # menambah: sqflite ^2.3.3+1, path ^1.9.0, provider ^6.1.2
 # dev: sqflite_common_ffi ^2.3.3+1 (untuk test headless)
flutter analyze
flutter test # widget_test.dart (smoke) hijau;
 # task_mapper_test.dart & local_task_datasource_test.dart
 # sebagian MERAH (TODO inti)

flutter run # Android emulator/physical
```

> Folder `android/`, dll. sengaja **tidak** disertakan. Jalankan `flutter create` dari dalam folder starter; pulihkan `pubspec.yaml`/`analysis_options.yaml` dari Git bila ditimpa. **Jangan ubah `pubspec.yaml`**, dependency sudah dipasang dan dipin. **Jangan** target web: `sqflite` memakai native SQLite yang tidak ada di browser.

---

## Struktur starter P04

```text
06-Starter-Code/p04-sqlite/
├── pubspec.yaml # sqflite ^2.3.3+1, path ^1.9.0, provider ^6.1.2
│ # dev: sqflite_common_ffi ^2.3.3+1
├── lib/
│ ├── main.dart # wiring: DB -> datasource -> repo -> provider
│ ├── app.dart
│ ├── core/{constants,theme}/
│ └── features/tasks/
│ ├── domain/task.dart # model + enum (sama P01-P03, immutable)
│ ├── data/
│ │ ├── local/
│ │ │ ├── task_database.dart # TaskSchema + TaskDatabase (open lazy + onCreate)
│ │ │ ├── task_mapper.dart # fromRow/toRow = TODO (CP2)
│ │ │ └── local_task_datasource.dart # CRUD query = TODO (CP3)
│ │ └── repositories/
│ │ └── task_repository.dart # LocalTaskRepository (upsert, SUDAH BENAR)
│ └── presentation/
│ ├── providers/task_provider.dart # wiring CRUD ke repo = TODO (CP3)
│ └── screens/{task_list_screen,task_form_screen}.dart
└── test/
 ├── widget_test.dart # smoke (hijau: loading -> empty)
 ├── task_mapper_test.dart # MERAH sampai CP2
 └── local_task_datasource_test.dart # MERAH sampai CP3 (pakai ffi)
```

**Aturan batas (penting):**
- Boleh mengubah `task_mapper.dart` (`fromRow`/`toRow`), `local_task_datasource.dart` (isi TODO query), `task_provider.dart` (hubungkan CRUD ke repo).
- Tidak boleh mengubah `Task` class/enum, `TaskSchema` (nama tabel/kolom, dipakai mapper+test), `LocalTaskRepository` (sudah benar), `main.dart` wiring, atau menambah package.
- Tidak boleh mengubah signature metode datasource/provider yang sudah didefinisikan.

**Role starter:** shell arsitektur data lengkap. DB terbuka, skema ada, repo upsert benar, UI tampil (loading/empty/error/list), form terbangun. Yang sengaja no-op: **mapper** (CP2), **query datasource + wiring provider CRUD** (CP3). Bukan bug, tugas implementasi yang diverifikasi oleh test merah.

---

## Mengapa SQLite, dan Kenapa Sekarang

Di P03, `_tasks` hidup di memori `TaskProvider`. App dibunuh -> data hilang. P04 memindahkan **sumber kebenaran** dari memori ke **file SQLite** di storage perangkat. Empat prinsip yang dilatih di sini:

1. **Offline-first = lokal adalah source of truth.** App bekerja penuh tanpa internet. P05 nanti menambah sumber remote, tapi yang lokal tetap menjadi cadangan/fallback. Dengan SQLite, data bertahan lintas restart dan tetap bisa diuji tanpa server.
2. **Layer terpisah: datasource -> repository -> provider.** Provider (UI) hanya kenal `TaskRepository` (abstraksi), bukan `sqflite`. Saat P05 menukar/ menambah sumber remote, UI tak berubah, ini inti *clean architecture* skala kecil.
3. **Marshaling tipe eksplisit.** SQLite hanya kenal `TEXT`, `INTEGER`, `REAL`, `NULL`/`BLOB`. Dart punya `DateTime`, `enum`, `bool`. Perubahan bentuk dilakukan di **satu tempat** (`TaskMapper`), bukan tersebar. Satu mapper salah (mis. simpan `bool` sebagai string) -> seluruh app rusak.
4. **Persistensi terbukti lewat restart.** Kriteria sukses P04 bukan "data muncul di layar" (itu sudah bisa di P03). Kriterianya: **kill app -> run lagi -> data tetap ada**. Kalau restart kosong, datasource CRUD masih no-op.

> **Sambungan dengan P03:** `TaskProvider.loadTasks()` di P03 mengisi `_tasks` dari `Task.getDummyTasks()`. Di P04, baris itu tetap ada, tapi sumbernya kini `await _repo.getAll()` yang membaca SQLite. `notifyListeners` tetap jadi kontrak reaktif. Yang berubah cuma **sumber data di belakang provider**, bukan arsitektur UI.

> **Mengapa bukan `shared_preferences`?** SharedPreferences cocok untuk key-value kecil (pengaturan, flag "first launch"). Bukan untuk list data relasional dengan query/filter/sort. SQLite menyimpan tabel, mendukung query `WHERE`/`ORDER BY`, dan berskala ke ribuan baris. P04 pakai SQLite karena `tasks` adalah data utama yang butuh query.

---

## CHECKPOINT 1: Buka Database + Skema

**Goal:** aplikasi jalan, tabel `tasks` tercipta saat first run, tidak ada exception SQLite.
**Time:** ~15 menit

### 1.1 Baca `task_database.dart`, skema sebagai kontrak

```dart
class TaskSchema {
 const TaskSchema._();
 static const String table = 'tasks';
 static const String columnId = 'id';
 static const String columnTitle = 'title';
 static const String columnDescription = 'description';
 static const String columnDueDate = 'due_date';
 static const String columnPriority = 'priority';
 static const String columnIsCompleted = 'is_completed';

 static const String createTable = '''
CREATE TABLE $table (
 $columnId TEXT PRIMARY KEY,
 $columnTitle TEXT NOT NULL,
 $columnDescription TEXT NOT NULL DEFAULT '',
 $columnDueDate TEXT NOT NULL,
 $columnPriority TEXT NOT NULL,
 $columnIsCompleted INTEGER NOT NULL DEFAULT 0
)
''';
}
```

**Penting:**

1. **Nama kolom diseragamkan lewat konstanta.** Mapper, datasource, dan test memakai `TaskSchema.columnXxx`, bukan string mentah `'id'`. Typo di satu tempat -> query salah diam-diam. Konsistensi nama lewat konstanta mencegah itu.
2. **Pemetaan tipe Dart -> SQLite.** Lihat tabel pemetaan di bawah. Tidak ada `BOOLEAN` di SQLite; tidak ada `DATETIME` native. Wajib pilih representasi dan konsisten.

| Field Dart | Kolom SQLite | Tipe storage | Catatan |
|------------------|--------------|--------------|-------------------------------------------|
| `String id` | `id` | TEXT | primary key |
| `String title` | `title` | TEXT | NOT NULL |
| `String desc` | `description`| TEXT | NOT NULL DEFAULT '' |
| `DateTime` | `due_date` | TEXT | ISO-8601 string (lihat CP2) |
| `TaskPriority` | `priority` | TEXT | nama enum: `low`/`medium`/`high` |
| `bool` | `is_completed`| INTEGER | 0/1, **jangan** string `"true"` |

> Starter P04 memakai **ISO-8601 string** untuk tanggal (bukan `INTEGER` milliseconds seperti beberapa tutorial). Konsisten dengan starter, ini yang diuji `task_mapper_test.dart`. Tipe alternatif valid di dunia nyata, tapi di kelas ini ikuti starter.

3. **`DEFAULT ''` dan `DEFAULT 0`.** Mencegah NULL tak terduga saat kolom tak diisi. `Task.description` bisa kosong string, `isCompleted` default false (=0). Aman untuk insert parsial.

### 1.2 Buka koneksi, pola lazy

```dart
class TaskDatabase {
 TaskDatabase({this.fileName = 'tasks.db'});
 final String fileName;
 Database? _db;

 Future<Database> database() async {
 _db ??= await _open(); // buka sekali, simpan di _db
 return _db!;
 }

 Future<Database> _open() async {
 final dbPath = await getDatabasesPath();
 final path = '$dbPath/$fileName';
 return openDatabase(
 path,
 version: 1,
 onCreate: (db, version) async {
 await db.execute(TaskSchema.createTable);
 },
 );
 }
}
```

**Poin:**

1. **Lazy open via `??=`.** Database tidak dibuka saat konstruktor, melainkan saat pertama `database()` dipanggil. Manfaat: app bisa start cepat, DB dibuka hanya saat benar-benar butuh. Koneksi disimpan di `_db` dan dipakai ulang.
2. **`getDatabasesPath()`** mengembalikan direktori storage aplikasi (di Android: `/data/data/<package>/databases/`). File `tasks.db` di-path itu bertahan lintas restart. Ini yang membuat persistensi mungkin.
3. **`onCreate` jalan sekali**, saat file DB belum ada (first run). Di sinilah `CREATE TABLE` dieksekusi. Kalau file sudah ada, `onCreate` **tidak** dipanggil lagi.
4. **`version: 1`** + (opsional) `onUpgrade` = hook migration (lihat bagian "Konsep Migration" di akhir CP1). Versi naik -> `onUpgrade` jalan.
5. **Test headless butuh ffi.** `sqflite` default memakai plugin native Android/iOS. Test (CI, tanpa emulator) tidak punya native itu, jadi `local_task_datasource_test.dart` menyuntik `sqflite_common_ffi` (SQLite murni Dart) lewat `databaseFactory = databaseFactoryFfi`. App production tetap pakai native, ffi hanya untuk test.

### 1.3 Baca wiring `main.dart`

```dart
void main() {
 final database = TaskDatabase();
 final datasource = LocalTaskDatasource(database);
 final repository = LocalTaskRepository(datasource);

 runApp(
 ChangeNotifierProvider(
 create: (_) => TaskProvider(repository)..loadTasks(),
 child: const TaskTrackerApp(),
 ),
 );
}
```

**Poin:**

1. **Rantai dependency:** `TaskDatabase` -> `LocalTaskDatasource` -> `LocalTaskRepository` -> `TaskProvider`. Tiap lapisan hanya kenal lapisan di bawahnya, tidak di atasnya. Provider tak tahu soal `sqflite`; repo tak tahu soal UI.
2. **Provider menerima `repository` (abstraksi).** Saat P05 menambah sumber remote, kamu bisa buat `RemoteTaskRepository` yang implement `TaskRepository` juga, provider tak berubah. Ini manfaat abstraksi.
3. **`..loadTasks()`** (cascade) memicu baca DB saat app start. Di first run tabel kosong -> `_tasks = []` -> UI empty state.

### 1.4 Verifikasi first run

```bash
flutter analyze
flutter test test/widget_test.dart # smoke: app mounts, loading -> empty
flutter run # Android
```

Amati: spinner singkat -> empty state ("No tasks yet. Tap + to add one."). Tidak ada exception SQLite di `flutter logs`/logcat. **Tabel `tasks` sudah tercipta di storage** walau belum terlihat, itu yang penting di CP1.

> **Cek DB benar-benar ada (opsional, Android):** via Device File Explorer di Android Studio, buka `/data/data/<package>/databases/tasks.db`. Pull file, buka di DB Browser for SQLite, tabel `tasks` ada (kosong). Ini bukti fisik persistensi di-track untuk demo.

### Checkpoint Validation

- [ ] `flutter test test/widget_test.dart` lulus (smoke).
- [ ] `flutter run`: loading singkat -> empty state, tidak ada exception SQLite.
- [ ] Kamu bisa menjelaskan **kenapa** `database()` pakai lazy `??=` (bukan di konstruktor).
- [ ] Kamu bisa menjelaskan pemetaan tipe Dart -> SQLite untuk `DateTime`, `enum`, `bool`.
- [ ] Kamu bisa menjelaskan **kapan** `onCreate` dipanggil (dan kapan tidak).

**Run & Test:**
```bash
flutter run
# Expected: loading -> empty state; file tasks.db tercipta; no SQLite exception.
```

---

## CHECKPOINT 2: Mapper Baris/Model

**Goal:** `TaskMapper.fromRow`/`toRow` mengonversi tipe dengan benar; `task_mapper_test.dart` hijau.
**Time:** ~20 menit

**Melanjutkan CP 1:**
- Sudah punya: tabel `tasks` + koneksi DB + pemahaman pemetaan tipe.
- 🆕 Akan tambah: marshaling tipe eksplisit (`DateTime`/ISO, `enum`/nama, `bool`/int).

### 2.1 Baca test yang merah dulu

```bash
flutter test test/task_mapper_test.dart
```

Baca nama test yang gagal, mereka menyebut ekspektasi:
- `toRow` menghasilkan kolom sesuai `TaskSchema` -> kunci benar (`id`, `title`, `due_date`, `priority`, `is_completed`), `priority = 'high'`, `is_completed = 1`.
- `fromRow` menghasilkan `Task` setara -> `dueDate` parse benar, `priority` jadi enum, `isCompleted` jadi `false`.
- round-trip `toRow -> fromRow` menjaga data.

### 2.2 Implementasi `toRow`

```dart
import '../../../domain/task.dart';
import 'task_database.dart';

class TaskMapper {
 const TaskMapper._();

 static Map<String, Object?> toRow(Task task) {
 return <String, Object?>{
 TaskSchema.columnId: task.id,
 TaskSchema.columnTitle: task.title,
 TaskSchema.columnDescription: task.description,
 TaskSchema.columnDueDate: task.dueDate.toIso8601String(),
 TaskSchema.columnPriority: task.priority.name,
 TaskSchema.columnIsCompleted: task.isCompleted ? 1 : 0,
 };
 }
 // fromRow diisi di 2.3
}
```

**Penting:**

1. **`DateTime.toIso8601String()`.** Konversi tanggal ke teks format `2026-09-01T08:00:00.000Z` (atau tanpa Z untuk non-UTC). Bisa dibalik persis lewat `DateTime.parse`. Representasi yang dipilih starter P04, konsisten dengan test.
2. **`task.priority.name`.** Enum Dart punya getter `.name` (Dart 2.15+): `TaskPriority.high.name == 'high'`. Stingy dan aman, tak ada typo string manual.
3. **`task.isCompleted ? 1 : 0`.** SQLite tak punya boolean; integer 0/1 adalah konvensi. **Jangan** simpan `'true'`/`'false'` string, query `WHERE is_completed = 1` tidak akan match string. Ini bug paling umum P04.
4. **Kunci pakai konstanta `TaskSchema`.** Bukan `'id'` mentah. Konsistensi dengan `fromRow` dan datasource. `columnIsCompleted` = `'is_completed'` (snake_case di DB), bukan `'isCompleted'` (camelCase Dart).
5. **`Map<String, Object?>`** (nullable value). Sqflite mengharapkan tipe ini untuk insert/update. `Object?` karena kolom bisa NULL di skema lain (di starter P04 semua NOT NULL, tapi tetap pakai tipe ini demi kontrak sqflite).

### 2.3 Implementasi `fromRow`

```dart
static Task fromRow(Map<String, Object?> row) {
 return Task(
 id: row[TaskSchema.columnId] as String,
 title: row[TaskSchema.columnTitle] as String,
 description: row[TaskSchema.columnDescription] as String,
 dueDate: DateTime.parse(row[TaskSchema.columnDueDate] as String),
 priority: TaskPriority.values.byName(row[TaskSchema.columnPriority] as String),
 isCompleted: (row[TaskSchema.columnIsCompleted] as int) != 0,
 );
}
```

**Poin:**

1. **`DateTime.parse(...)`.** Kebalikan `toIso8601String`. Menerima string ISO, kembalikan `DateTime`. Bila string rusak -> `FormatException`. Validasi input penting bila data bisa datang dari sumber tak terpercaya (P05: API).
2. **`TaskPriority.values.byName(...)`.** Kebalikan `.name`. `TaskPriority.values = [low, medium, high]`; `.byName('high')` cari enum dengan nama cocok. **Throw `ArgumentError` bila nama tak ada**, selalu tangani bila data bisa invalid. Di P04 sumbernya mapper sendiri, jadi aman.
3. **`as int) != 0`.** Kebalikan `? 1 : 0`. Integer dari sqflite, bukan bool. Cast ke `int` dulu, baru bandingkan. **Hati-hati**: beberapa versi driver sqflite kadang kembalikan `int`, kadang `num`, bila test gagal tipe, cek dengan `(row[...] as num).toInt()`.
4. **`as String`.** Cast eksplisit. Sqflite kembalikan `Object?` (kolom TEXT -> `String` di runtime, tapi statis tetap `Object?`). Cast memberi tahu Dart tipe sebenarnya. Aman karena skema NOT NULL TEXT.
5. **`description` default ''.** Skema `DEFAULT ''`; bila NULL masuk lewat jalur lain, `as String` akan throw. Di starter P04 tidak terjadi (NOT NULL), tapi sadari konsekuensinya.

### 2.4 Round-trip = uji kebenaran

Test ketiga (`round-trip`) adalah yang paling kuat: `Task -> toRow -> fromRow -> Task'`. Kalau `Task == Task'` (id sama, semua field sama), maka mapper lossless. `Task.==` membandingkan `id` saja (lihat `domain/task.dart`), tapi test membandingkan tiap field eksplisit, jadi verifikasi field benar-benar terjaga.

> **Mengapa round-trip penting?** Bila kamu simpan `priority = 'HIGH'` (huruf besar) tapi parse dengan `.byName('HIGH')`, round-trip lolos, namun bila sumber lain menulis `'high'` kecil, `.byName` meledak. Konsistensi kasus lintas `toRow`/`fromRow` adalah bug diam-diam. Test round-trip menangkap inkonstitensi internal; bila kamu mengintegrasikan sumber eksternal (P05), tambah test dengan input yang berbeda format.

### 2.5 Verifikasi mapper

```bash
flutter test test/task_mapper_test.dart # All tests passed!
flutter analyze
```

Tiga test harus hijau: `toRow` kolom benar, `fromRow` setara, round-trip menjaga data. **Jangan lanjut CP3 sebelum mapper hijau**, datasource memakai mapper; mapper salah -> datasource rusak.

### Checkpoint Validation

- [ ] `flutter test test/task_mapper_test.dart`, **semua 3 test hijau**.
- [ ] `toRow`: `due_date` = ISO-8601 string, `priority` = nama enum kecil, `is_completed` = integer 0/1.
- [ ] `fromRow`: `dueDate` parse benar, `priority` jadi enum, `isCompleted` jadi `bool`.
- [ ] `flutter analyze` tetap bersih.
- [ ] Kamu bisa menjelaskan **kenapa** boolean disimpan 0/1 (bukan string), dan risiko bila tidak konsisten.

**Run & Test:**
```bash
flutter test test/task_mapper_test.dart # All tests passed!
```

---

## CHECKPOINT 3: Datasource + Repository + Provider CRUD Persisten

**Goal:** query di datasource + hubungkan provider CRUD ke repository; data **bertahan setelah restart**.
**Time:** ~20 menit

**Melanjutkan CP 2:**
- Sudah punya: mapper hijau (konversi tipe benar).
- 🆕 Akan tambah: query SQLite + wiring provider CRUD + bukti persistensi.

### 3.1 Implementasi `LocalTaskDatasource`

Isi tiap TODO memakai `_db.database()` + `TaskSchema` + `TaskMapper`.

```dart
import 'package:sqflite/sqflite.dart';
import '../../../domain/task.dart';
import 'task_database.dart';
import 'task_mapper.dart';

class LocalTaskDatasource {
 LocalTaskDatasource(this._db);
 final TaskDatabase _db;

 Future<List<Task>> getAll() async {
 final db = await _db.database();
 final rows = await db.query(
 TaskSchema.table,
 orderBy: '${TaskSchema.columnTitle} ASC',
 );
 return [for (final row in rows) TaskMapper.fromRow(row)];
 }

 Future<void> insert(Task task) async {
 final db = await _db.database();
 await db.insert(
 TaskSchema.table,
 TaskMapper.toRow(task),
 conflictAlgorithm: ConflictAlgorithm.replace,
 );
 }

 Future<void> update(Task task) async {
 final db = await _db.database();
 await db.update(
 TaskSchema.table,
 TaskMapper.toRow(task),
 where: '${TaskSchema.columnId} = ?',
 whereArgs: [task.id],
 );
 }

 Future<void> delete(String id) async {
 final db = await _db.database();
 await db.delete(
 TaskSchema.table,
 where: '${TaskSchema.columnId} = ?',
 whereArgs: [id],
 );
 }

 Future<void> clear() async {
 final db = await _db.database();
 await db.delete(TaskSchema.table);
 }
}
```

**Penting:**

1. **`db.query(...)` = SELECT.** Mengembalikan `List<Map<String, Object?>>`, daftar baris. `orderBy` langsung jadi `ORDER BY title ASC`. Bisa tambah `where`/`whereArgs`/`limit` bila perlu.
2. **`db.insert(...)` = INSERT.** `conflictAlgorithm: ConflictAlgorithm.replace` berarti bila primary key bentrok, baris lama diganti. Cocok untuk upsert sederhana (lihat repo 3.3).
3. **`db.update(...)` = UPDATE.** `where` + `whereArgs` menentukan baris mana. **Selalu pakai placeholder `?`**, jangan konkatenasi string (`"... WHERE id = $id"`). Itu celah **SQL injection** dan bug kutipan.
4. **`db.delete(...)` = DELETE.** Sama, pakai `where`/`whereArgs`. Tanpa `where` = hapus semua (fungsi `clear`).
5. **Mapper di kedua arah.** `getAll` petakan tiap baris lewat `fromRow`; `insert`/`update` kirim `toRow`. Datasource tak tahu soal `DateTime`/`enum`/`bool`, semua urusan tipe di mapper. Ini manfaat pemisahan mapper (CP2): datasource murni SQL.
6. **`await _db.database()` di tiap method.** Karena `database()` lazy, panggilan pertama membuka koneksi, panggilan berikutnya pakai cache `_db`. Bisa `await` berkali-kali dengan aman, murah setelah pertama.

### 3.2 Baca `LocalTaskRepository` (sudah benar, pahami, jangan ubah)

```dart
abstract class TaskRepository {
 Future<List<Task>> getAll();
 Future<void> save(Task task);
 Future<void> remove(String id);
}

class LocalTaskRepository implements TaskRepository {
 LocalTaskRepository(this._local);
 final LocalTaskDatasource _local;

 @override
 Future<List<Task>> getAll() => _local.getAll();

 @override
 Future<void> save(Task task) async {
 final existing = await _local.getAll();
 final exists = existing.any((t) => t.id == task.id);
 if (exists) {
 await _local.update(task);
 } else {
 await _local.insert(task);
 }
 }

 @override
 Future<void> remove(String id) => _local.delete(id);
}
```

**Poin:**

1. **`save` = upsert.** Cek apakah id sudah ada -> update bila ya, insert bila tidak. Logika ini sah; bukan TODO. Catatan performa: `getAll()` untuk cek tiap save boros untuk dataset besar, di produksi pakai `SELECT... WHERE id = ?`. Untuk kelas ini cukup.
2. **Abstraksi `TaskRepository`.** Provider hanya kenal interface ini, bukan `LocalTaskDatasource` konkret. Saat P05 menambah `RemoteTaskRepository` (atau `SyncedRepository`), provider tak berubah, ganti saja instance yang di-inject di `main.dart`.
3. **`getAll()`/`save()`/`remove()` = kontrak minimal.** UI/provider butuh tiga operasi ini. Abstraksi dipakai untuk testability (mock repo) dan swapability (P05).

### 3.3 Hubungkan `TaskProvider` CRUD ke repo

Siklus yang sama untuk semua: **tulis ke repo -> muat ulang -> `notifyListeners`**.

```dart
Future<void> addTask(Task task) async {
 await _repo.save(task);
 await loadTasks();
 notifyListeners();
}

Future<void> updateTask(Task task) async {
 await _repo.save(task);
 await loadTasks();
 notifyListeners();
}

Future<void> deleteTask(String id) async {
 await _repo.remove(id);
 await loadTasks();
 notifyListeners();
}

Future<void> toggleComplete(String id) async {
 final task = findById(id);
 if (task == null) return;
 await _repo.save(task.copyWith(isCompleted: !task.isCompleted));
 await loadTasks();
 notifyListeners();
}
```

**Poin:**

1. **Async sekarang.** Di P03 CRUD sinkron (memori); di P04 **semua async** (I/O DB). Signature provider sudah `Future<void>`. `task_form_screen._submit` sudah `await provider.addTask(...)` dengan `if (mounted) Navigator.pop()`, pola anti context misuse dari P03 tetap berlaku.
2. **`loadTasks()` setelah tulis.** Cara termudah menjaga `_tasks` sinkron dengan DB: tulis lalu baca ulang seluruh tabel. Untuk dataset kecil cukup dan jelas. Optimasi (mutasi lokal tanpa reload) = bahan challenge.
3. **`notifyListeners()` wajib** di akhir tiap metode, sama seperti P03. Tanpa ini UI diam walau DB berubah.
4. **`findById` + `copyWith` untuk toggle.** Cari task di memori (`_tasks`), balik `isCompleted` lewat `copyWith` (immutability, sama P03), simpan ke repo. Bila id tak ada -> return awal (idempotent, tidak crash).
5. **Urutan: tulis dulu, baru reload.** Kalau terbalik (reload sebelum tulis), UI tampil data lama, bug race. `await` memastikan urutan.

> **Alternatif (tanpa reload penuh):** bila kamu mau tantangan, setelah `save` mutasi `_tasks` langsung (insert/update/delete elemen list) lalu `notifyListeners`, tanpa `loadTasks`. Lebih cepat (1 query, bukan 2) tapi rawan inkonsistensi bila ada error parsial. Reload penuh = simple dan aman; pilih sesuai konteks.

### 3.4 Verifikasi datasource + persistence

```bash
flutter test test/local_task_datasource_test.dart # All tests passed! (via ffi)
flutter analyze
flutter run
```

Uji manual end-to-end:
1. FAB -> form -> isi title "Belajar SQLite" -> Save -> task muncul di list.
2. Tap card -> edit title jadi "Belajar SQLite Lanjut" -> Save -> data berubah.
3. Tap centang -> status flip (strikethrough + chip `COMPLETED`).
4. Swipe kiri -> dialog -> Delete -> task hilang.

**Uji persistensi (KRITE­RIA UTAMA P04):**
5. Kill app (hentikan terminal `flutter run` / stop dari recent apps di device).
6. `flutter run` lagi.
7. **Task yang tadi di-add/edit masih ada** dengan perubahan terbaru (termasuk toggle & delete yang bertahan).

Bila setelah restart daftar kosong padahal tadi sudah add -> datasource CRUD masih no-op atau menulis ke tempat lain. Periksa ulang CP3.

### 3.5 Troubleshooting khusus P04 (database path / map boolean / date)

Bagian ini wajib dipahami, tiga jebakan paling sering di P04:

**Jebakan 1: Database path salah / file tidak dibuat.**
- Gejala: data hilang setelah restart, atau `SqfliteDatabaseException: no such table`.
- Penyebab: `getDatabasesPath()` dipanggil di luar `await` (tidak nunggu), atau `path` di-hardcode relatif tanpa prefix direktori app.
- Solusi: selalu `await getDatabasesPath()` lalu gabungkan dengan `fileName`. Jangan hardcode `/sdcard/...`, storage eksternal butuh permission dan tidak persistent untuk app data.
- Cek: pull `tasks.db` via Device File Explorer, pastikan tabel ada dan berisi data.

**Jebakan 2: Boolean di-marshal sebagai string.**
- Gejala: `toggleComplete` tidak bertahan, atau query `WHERE is_completed = 1` mengembalikan kosong.
- Penyebab: `toRow` menyimpan `'true'`/`'false'` (string) alih-alih `1`/`0` (int). `fromRow` lalu membaca string sebagai int -> `CastException`.
- Solusi: `task.isCompleted ? 1 : 0` di `toRow`; `(row[...] as int) != 0` di `fromRow`. Konsisten integer di kedua arah.
- Tes cepat: lihat nilai `is_completed` di DB Browser, harus `0` atau `1`, bukan `true`.

**Jebakan 3: Tanggal (ISO vs millis vs zona waktu).**
- Gejala: `dueDate` bergeser beberapa jam setelah round-trip, atau `FormatException` saat parse.
- Penyebab: campur representasi (simpan millis, parse sebagai ISO) atau timezone UTC vs local tidak konsisten.
- Solusi: pilih satu representasi (starter = ISO-8601 string), pakai di kedua arah. `DateTime.toIso8601String()` / `DateTime.parse()`. Untuk konsistensi zona, uji dengan `DateTime.utc(...)` di test (lihat `task_mapper_test.dart` pakai `DateTime.utc(2026, 9, 1, 8)`).
- Tes cepat: round-trip test, bila `dueDate` sama persis setelah `toRow -> fromRow`, representasi benar.

### Checkpoint Validation

- [ ] `flutter test test/local_task_datasource_test.dart`, **semua test hijau** (insert/update/delete via ffi).
- [ ] FAB -> form -> save -> task muncul.
- [ ] Edit -> data berubah; delete -> hilang; toggle -> status flip.
- [ ] **Kill app -> `flutter run` lagi -> task tetap ada** (persistence terbukti).
- [ ] Restart setelah edit/delete/toggle -> perubahan bertahan.
- [ ] `flutter analyze` tetap bersih.
- [ ] Kamu bisa menjelaskan tiga jebakan (path, boolean, date) dan cara mendeteksinya.

**Run & Test:**
```bash
flutter test test/local_task_datasource_test.dart # All tests passed!
flutter analyze # No issues found!
flutter run # uji CRUD + restart persistence
```

---

## Konsep Migration (versi + onUpgrade)

Skema database berkembang. Kolom baru ditambah, tabel baru dibuat. Mengganti skema di aplikasi yang sudah ter-install butuh strategi: **migration**. P04 membahas konsep + contoh kecil; advanced migration di luar scope.

### Cara kerja `version` + `onUpgrade`

`openDatabase` menerima `version`. Saat file DB ada dengan versi **lebih lama** dari versi kode, `onUpgrade(db, oldVersion, newVersion)` dipanggil. Di sinilah kamu menjalankan `ALTER TABLE` / `CREATE TABLE` bertahap.

```dart
return openDatabase(
 path,
 version: 2, // naik dari 1 -> 2
 onCreate: (db, version) async {
 await db.execute(TaskSchema.createTable); // versi awal
 },
 onUpgrade: (db, oldVersion, newVersion) async {
 if (oldVersion < 2) {
 // v2: tambah kolom tags (TEXT, opsional)
 await db.execute(
 'ALTER TABLE ${TaskSchema.table} ADD COLUMN tags TEXT NOT NULL DEFAULT \'\'',
 );
 }
 // if (oldVersion < 3) {... } // v3 dst, bertahap
 },
);
```

**Aturan migration aman:**

1. **Hanya tambah, jangan hapus/migrasi ulang tanpa data copy.** `ALTER TABLE ADD COLUMN` aman di SQLite (preserve data lama). Hapus kolom tidak didukung langsung SQLite, butuh recreate tabel.
2. **Cek `oldVersion < N` berurutan.** Tiap blok jalan untuk semua upgrade yang melewatinya. User dari v1 langsung ke v3 harus lewati blok v2 **dan** v3.
3. **Default untuk kolom baru.** `NOT NULL` wajib `DEFAULT` agar baris lama valid.
4. **`onCreate` membuat skema TERBARU** untuk first run (user baru), `onUpgrade` memigrasi yang sudah ada. Keduanya harus konsisten, skema hasil migration = skema first run.
5. **Test migration manual:** install versi lama, isi data, naikkan versi, jalankan ulang -> data tetap + kolom baru ada.

> **Di starter P04, `version: 1`** tanpa `onUpgrade`, skema stabil untuk sesi ini. Challenge Level 3 (akhir materi) minta kamu menambahkan `onUpgrade` untuk simulasi v2. Itu latihan konsep, bukan kebutuhan fungsional P04.

### Migration vs Seeding (bedakan!)

- **Migration** = ubah **struktur** skema (kolom/tabel). Jalan otomatis saat versi naik.
- **Seeding** = isi **data awal** (mis. task contoh di first run). Tidak ada di starter P04, tabel kosong di first run, user tambah sendiri. Bila kamu ingin seed, jalankan sekali di `onCreate` atau lewat flag "first launch" (di luar scope P04, konsep di `../../Tutorial/outline-p08-database.md` CP3).

---

## Summary

**Yang kamu kerjakan:**
- Membuka database SQLite lewat `TaskDatabase` (lazy open) dan mendefinisikan skema `tasks` lewat `TaskSchema`.
- Mengimplementasikan `TaskMapper.fromRow`/`toRow` (marshaling `DateTime`/ISO, `enum`/nama, `bool`/int) sampai `task_mapper_test.dart` hijau.
- Mengisi query `LocalTaskDatasource` (query/insert/update/delete), memahami `LocalTaskRepository` (upsert), dan menghubungkan `TaskProvider` CRUD ke repo.
- **Membuktikan persistensi: data bertahan setelah restart app.**
- Memahami konsep migration via `version`/`onUpgrade`.

**Konsep kunci:**
- **Offline-first**, lokal (SQLite) adalah source of truth; app bekerja tanpa internet.
- **Layer terpisah**, datasource -> repository -> provider; abstraksi `TaskRepository` memungkinkan swap ke remote (P05) tanpa ubah UI.
- **Marshaling tipe eksplisit**, konversi Dart/SQLite di satu tempat (`TaskMapper`); konsistensi boolean (0/1) dan tanggal (ISO) adalah dua jebakan utama.
- **Persistensi ≠ data muncul**, kriteria sukses: kill app -> run lagi -> data tetap.
- **Migration**, `version` + `onUpgrade` untuk evolusi skema; hanya tambah, bertahap, dengan default.

**Preview sesi berikutnya (P05):**
- `TaskRepository` dapat implementasi kedua: `RemoteTaskRepository` (HTTP/JSON).
- Provider menangani state lokal vs remote, network-error, 4xx/5xx, retry manual.
- Mapper JSON (`toJson`/`fromJson`), pola mirip `toRow`/`fromRow` tapi untuk JSON, bukan baris SQLite.
- Mode offline: operasi lokal tetap jalan walau remote gagal (fondasi offline-first P04 dipakai).

---

## Troubleshooting

**Data hilang setelah restart.**
Hampir selalu: datasource CRUD masih no-op (TODO belum diisi), atau `toRow`/`fromRow` salah sehingga insert baca kembali kosong. Jalankan `flutter test test/local_task_datasource_test.dart`, harus hijau. Lalu cek file `tasks.db` via Device File Explorer/`adb`: tabel berisi data? Bila path DB berubah (mis. reinstall app dengan package berbeda), data lama di tempat lain, data per-app dihapus saat uninstall.

**`SqfliteDatabaseException: no such table: tasks`.**
`onCreate` tidak menjalankan `TaskSchema.createTable`, atau `version` diubah tanpa `onUpgrade` (file DB lama tetap, tabel tak dibuat ulang). Untuk sesi lab: uninstall app (`flutter uninstall` atau hapus data aplikasi) supaya file DB dibuat ulang, lalu `flutter run`. Setelah itu persistensi normal.

**Mapper test merah `UnimplementedError`.**
`fromRow`/`toRow` belum diisi, itu TODO CP2. Implementasi (lihat CP2), jalankan test lagi. Bila masih merah padahal sudah diisi, cek: import `task_database.dart` (untuk `TaskSchema`), `.name`/`.byName` konsisten kasus, `DateTime.parse` vs `toIso8601String` match.

**`FormatException` saat parse `due_date`.**
Data di kolom `due_date` bukan ISO-8601 (mis. kamu dulunya simpan millis, lalu ganti ke ISO tanpa migrasi). Hapus file DB (uninstall app) supaya tabel dibuat ulang dengan data baru. Atau bila ada data penting, migrasi manual (di luar scope P04).

**Boolean tidak bertahan / `CastException int -> bool`.**
`toRow` simpan `'true'`/`'false'` (string), `fromRow` baca `as int`. Konsistenkan: `? 1 : 0` di `toRow`, `as int) != 0` di `fromRow`. Cek DB Browser: kolom `is_completed` harus `0`/`1`.

**Test datasource gagal `MissingPluginException` / `databaseFactoryFfi`.**
`setUpAll` test belum memanggil `sqfliteFfiInit()` + `databaseFactory = databaseFactoryFfi`. Starter sudah benar, jangan hapus. ffi menyediakan SQLite murni Dart untuk test headless; app production tetap pakai plugin native Android.

**`toggleComplete` tidak bertahan walau UI berubah.**
`copyWith(isCompleted: !task.isCompleted)` sudah benar, tapi lupa `await _repo.save(...)`, jadi UI berubah (karena reload dari memori yang belum ditulis). Atau `save` lewat `update` tapi `where` tak match id. Pastikan urutan: `findById` -> `copyWith` -> `await _repo.save` -> `await loadTasks` -> `notifyListeners`.

**`A ValueNotifier/ChangeNotifier used after dispose` atau `Looking up a deactivated widget's ancestor`.**
Pola dari P03: simpan provider sebelum `await`, cek `mounted` setelahnya. Di `task_form_screen._submit`, `context.read<TaskProvider>()` diambil sebelum `await addTask`, lalu `if (mounted) Navigator.pop`. Bila kamu menambah async di provider tanpa guard ini, error muncul saat user cepat menutup form sebelum DB selesai.

**Hot reload tidak mengaktifkan perubahan DB/provider.**
Hot reload mempertahankan instance. Bila kamu mengubah `TaskDatabase`/`TaskMapper`, lakukan **hot restart** (`R`) agar instance baru dibuat dan DB/skema di-inisialisasi ulang. Bila skema berubah, sering perlu **uninstall + reinstall** app agar file DB dibuat ulang.

**`flutter run` di web error `Sqflite not supported`.**
`sqflite` butuh native (Android/iOS/desktop). Jangan target web untuk P04. Gunakan `flutter run -d <android-device/emulator>`.

---

## Self-Assessment (sebelum & sesudah)

**Skor kepercayaan 1-5, sebelum & sesudah P04:**
- Membuka koneksi SQLite (lazy open, `onCreate`): -> 
- Marshaling tipe (`DateTime`/`enum`/`bool`/SQLite): -> 
- Query SQLite (query/insert/update/delete + `whereArgs`): -> 
- Repository pattern + abstraksi `TaskRepository`: -> 
- Persistensi lintas restart + debug path/bool/date: -> 
- Konsep migration (`version`/`onUpgrade`): -> 

**Verifikasi praktik:**
- Tulis satu unit test tambahan di `local_task_datasource_test.dart`: `clear()` benar-benar mengosongkan tabel; `insert` dengan id yang sudah ada + `ConflictAlgorithm.replace` menimpa (bukan duplikat).
- Jelaskan dengan kata sendiri **kenapa** provider hanya kenal `TaskRepository` (abstraksi), bukan `LocalTaskDatasource` konkret, dan apa manfaatnya saat P05.
- Lakukan demo restart di depan teman/dosen: add -> kill -> run -> task tetap. Jelaskan **di file mana** data disimpan.

---

## Challenge Bertingkat (kerja sendiri, siapkan bukti)

Pilih satu level. Semua boleh pakai AI untuk **penjelasan/debugging**, bukan menulis core query/logic tanpa analisis.

**Level 1 (Basic):** Tambah unit test di `local_task_datasource_test.dart`: insert dua task, panggil `getAll()` -> urut judul naik (verifikasi `orderBy`). Kriteria: test lulus.

**Level 2 (Medium):** Tambah method `getByPriority(TaskPriority)` di datasource (query `WHERE priority = ?` + `whereArgs: [p.name]`) dan satu test. Jangan ubah skema. Kriteria: test hijau, `analyze` bersih. Ini relevan untuk filter di Assignment 2.

**Level 3 (Advanced):** Simulasikan migration v2, naikkan `version` jadi 2, tambah `onUpgrade` yang `ALTER TABLE tasks ADD COLUMN tags TEXT NOT NULL DEFAULT ''`. Uninstall app, jalankan, tambah task, cek `tags` ada di DB. Lalu jelaskan (2-3 kalimat) **kenapa** `onUpgrade` penting di app yang sudah punya user. Kriteria: data lama tidak hilang setelah migration; `tags` bisa dilihat di DB Browser.

**Submit:** screenshot + paste kode + 2-3 kalimat penjelasan pendekatan.

> Challenge Level 2 langsung relevan untuk **Assignment 2** (filter by status/category di sumber data). Level 3 melatih mindset migration yang dipakai di proyek nyata.

---

## AI-Enhanced Learning (P04)

**Penggunaan AI produktif di P04:**
- "Kenapa `sqflite` tidak bisa di web? Alternatifnya apa?" (konsep native plugin)
- "Jelaskan `ConflictAlgorithm.replace` dan kapan bahayanya."
- "Kenapa `WHERE id = ?` lebih aman dari `WHERE id = $id`?" (SQL injection)
- "Bagaimana cara debug `no such table` di SQLite Android?" (Device File Explorer, path DB)
- "Bandingkan `DateTime.toIso8601String()` vs `millisecondsSinceEpoch`, pro/kontra."

**Hindari:**
- "Tulis `fromRow`/`toRow` untuk skema ini." (core mapper, analisis sendiri; wajib pahami)
- "Buatkan query insert/update/delete datasource saya." (core query, analisis sendiri)
- "Implementasikan `addTask`/`toggleComplete` provider." (wiring core, analisis sendiri)

**Wajib bila memakai AI:** isi `../01-Orientasi/Template-AI-Interaction-Log.md`, tujuan, prompt, ringkasan respons, perubahan dipilih/ditolak, dan **verifikasi pemahaman** (jelaskan ulang dengan kata sendiri + bukti `flutter test` hijau + demo restart). Saat demo, dosen bisa tanya "baris ini ngapain?" di mapper/query/provider, kamu harus bisa jawab.

---

## Resources

- **Resmi:** [pub.dev/packages/sqflite](https://pub.dev/packages/sqflite), [pub.dev/packages/sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi), [sqlite.org/lang.html](https://www.sqlite.org/lang.html) (sintaks SQL), [docs.flutter.dev/cookbook/persistence/sqlite](https://docs.flutter.dev/cookbook/persistence/sqlite).
- **Dalam paket:** `../02-Materi/P03-Form-CRUD-Provider.md` (fondasi Provider/async), `../01-Orientasi/Panduan-Mahasiswa.md`, `../05-Assessment/Lembar-Observasi.md`.
- **Konsep dasar:** `../../Tutorial/outline-p08-database.md` (basis konsep database, dipersempit ke starter P04), `../../Handout/P10-Offline-First-SQLite.md`.
- **Starter:** `../06-Starter-Code/p04-sqlite/` (README + struktur di atas).

**Persiapan P05:** baca ulang `TaskRepository` abstraksi, bayangkan implementasi kedua `RemoteTaskRepository` yang juga implement interface itu. Mapper JSON (`toJson`/`fromJson`) akan meniru pola `toRow`/`fromRow` tapi untuk `Map` JSON. Fondasi offline-first P04 dipakai: saat remote gagal, operasi lokal tetap jalan.

---

**Estimasi belajar mandiri:** 5-7 jam | **Kesulitan:** menengah-tinggi | **Updated:** 2026-08-08
