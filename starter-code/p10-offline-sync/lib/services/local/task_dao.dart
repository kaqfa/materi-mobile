import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../models/task.dart';

/// Akses data SQLite lokal — sumber kebenaran saat offline.
class TaskDao {
  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    return openDatabase(
      p.join(dir, 'study_tracker.db'),
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE tasks(
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          completed INTEGER NOT NULL,
          updated_at TEXT NOT NULL,
          sync_state TEXT NOT NULL
        )
      '''),
    );
  }

  Future<List<Task>> getAll() async {
    final db = await database;
    final rows = await db.query('tasks', orderBy: 'updated_at DESC');
    return rows.map(Task.fromRow).toList();
  }

  /// Baris yang menunggu diunggah ke server.
  Future<List<Task>> pendingOnly() async {
    final db = await database;
    final rows = await db.query(
      'tasks',
      where: 'sync_state = ?',
      whereArgs: [SyncState.pending.name],
    );
    return rows.map(Task.fromRow).toList();
  }

  Future<void> upsert(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toRow(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
