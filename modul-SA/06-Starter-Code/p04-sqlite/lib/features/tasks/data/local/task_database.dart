import 'package:sqflite/sqflite.dart';

/// Skema tabel `tasks`. Kontrak kolom dipakai bersama oleh
/// [TaskMapper] dan [LocalTaskDatasource].
///
/// | kolom          | tipe | catatan                                   |
/// |----------------|------|-------------------------------------------|
/// | id             | TEXT | primary key                               |
/// | title          | TEXT | not null                                  |
/// | description    | TEXT | not null, default ''                      |
/// | due_date       | TEXT | not null, ISO-8601                        |
/// | priority       | TEXT | not null, nama enum `TaskPriority`        |
/// | is_completed   | INT  | not null, 0/1                             |
class TaskSchema {
  const TaskSchema._();

  static const String table = 'tasks';

  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnDueDate = 'due_date';
  static const String columnPriority = 'priority';
  static const String columnIsCompleted = 'is_completed';

  /// DDL tabel `tasks`.
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

/// Membuka (dan membuat) database SQLite lokal.
///
/// Koneksi dibuka lazy lewat [database]. Pada sesi kelas target Android,
/// [getDatabasesPath] mengembalikan path aplikasi. Untuk pengujian headless
/// (lihat `test/local_task_datasource_test.dart`) disuntikkan factory ffi.
class TaskDatabase {
  TaskDatabase({this.fileName = 'tasks.db'});

  final String fileName;
  Database? _db;

  /// Mengembalikan koneksi database, membuat file + skema bila belum ada.
  Future<Database> database() async {
    _db ??= await _open();
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

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
