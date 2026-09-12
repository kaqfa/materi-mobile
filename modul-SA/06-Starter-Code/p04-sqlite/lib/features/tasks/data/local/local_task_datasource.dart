import '../../domain/task.dart';
import 'task_database.dart';
// Catatan: saat mengimplementasi TODO, tambahkan import berikut:
//   import 'package:sqflite/sqflite.dart';
//   import 'task_mapper.dart';

/// Sumber data lokal berbasis SQLite.
///
/// Semua method CRUD sengaja **no-op/TODO**. Selesaikan [TaskMapper] lebih
/// dulu (checkpoint 2), lalu implementasikan method di sini memakai
/// [TaskDatabase.database()] dan [TaskMapper]. Lihat README checkpoint.
class LocalTaskDatasource {
  LocalTaskDatasource(this._db);

  final TaskDatabase _db;

  /// Mengambil seluruh task, urut judul naik.
  Future<List<Task>> getAll() async {
    // TODO(student): (await _db.database()).query(TaskSchema.table,
    // orderBy: '${TaskSchema.columnTitle} ASC'), lalu petakan tiap baris
    // memakai TaskMapper.fromRow.
    return const [];
  }

  /// Menyisipkan task baru. Gunakan conflictAlgorithm.replace agar aman.
  Future<void> insert(Task task) async {
    // TODO(student): (await _db.database()).insert(
    //   TaskSchema.table, TaskMapper.toRow(task),
    //   conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Memperbarui task yang sudah ada (dicocokkan berdasarkan id).
  Future<void> update(Task task) async {
    // TODO(student): (await _db.database()).update(
    //   TaskSchema.table, TaskMapper.toRow(task),
    //   where: '${TaskSchema.columnId} = ?', whereArgs: [task.id]);
  }

  /// Menghapus task berdasarkan [id].
  Future<void> delete(String id) async {
    // TODO(student): (await _db.database()).delete(TaskSchema.table,
    //   where: '${TaskSchema.columnId} = ?', whereArgs: [id]);
  }

  /// Mengosongkan tabel. Berguna untuk reset sesi lab.
  Future<void> clear() async {
    // TODO(student): (await _db.database()).delete(TaskSchema.table);
  }
}
