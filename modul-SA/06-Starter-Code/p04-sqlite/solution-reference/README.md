# Solution Reference, p04-sqlite

> **KHUSUS DOSEN. Jangan dibagikan ke mahasiswa sebelum sesi P04 selesai.**

## Lokasi solusi lengkap

Repo/tag privat dosen: `solution/p04`. File ini ringkasan pendekatan.

## Mapper yang diharapkan

`lib/features/tasks/data/local/task_mapper.dart`:

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
```

## Datasource yang diharapkan

```dart
Future<List<Task>> getAll() async {
 final db = await _db.database();
 final rows = await db.query(
 TaskSchema.table,
 orderBy: '${TaskSchema.columnTitle} ASC',
 );
 return rows.map(TaskMapper.fromRow).toList();
}

Future<void> insert(Task task) async {
 final db = await _db.database();
 await db.insert(TaskSchema.table, TaskMapper.toRow(task),
 conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> update(Task task) async {
 final db = await _db.database();
 await db.update(TaskSchema.table, TaskMapper.toRow(task),
 where: '${TaskSchema.columnId} = ?', whereArgs: [task.id]);
}

Future<void> delete(String id) async {
 final db = await _db.database();
 await db.delete(TaskSchema.table,
 where: '${TaskSchema.columnId} = ?', whereArgs: [id]);
}
```

## Provider CRUD yang diharapkan

```dart
Future<void> addTask(Task task) async {
 await _repo.save(task);
 _tasks = await _repo.getAll();
 notifyListeners();
}
// updateTask / deleteTask / toggleComplete serupa: repo op lalu reload list.
```

## Titik pengajaran

- Layering: UI -> provider -> repository -> datasource -> DB. Ganti sumber data tanpa sentuh UI.
- Marshaling tipe eksplisit: tipe SQLite terbatas (TEXT/INT/REAL); `bool`, `enum`, `DateTime` butuh konversi.
- Persistence test: kill + restart membuktikan "offline-first".
- `sqflite_common_ffi` agar test jalan tanpa emulator.

## Koneksi ke tugas

Ini menjadi baseline Assignment 2, bagian persistence. P05 menambah remote datasource + error handling di atas repository contract yang sama.
