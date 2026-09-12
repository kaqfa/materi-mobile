import '../../domain/task.dart';
// Catatan: saat mengimplementasi TODO, tambahkan import berikut untuk
// memakai konstanta nama kolom:
//   import 'task_database.dart';

/// Mengkonversi antara model [Task] dan baris SQLite (Map<String, Object?>).
///
/// Catatan tipe:
/// - [Task.dueDate] disimpan sebagai ISO-8601 string.
/// - [Task.priority] disimpan sebagai nama enum (`low`/`medium`/`high`).
/// - [Task.isCompleted] disimpan sebagai integer 0/1.
///
/// Implementasi `fromRow` dan `toRow` sengaja **TODO** agar mahasiswa
/// mempraktikkan marshaling tipe eksplisit. Lihat README checkpoint.
class TaskMapper {
  const TaskMapper._();

  /// Mengubah sebuah baris hasil query menjadi [Task].
  static Task fromRow(Map<String, Object?> row) {
    // TODO(student): parse [row] menjadi Task.
    // Petunjuk:
    //  - title/description/id        -> String
    //  - due_date                    -> DateTime.parse(...)
    //  - priority                    -> TaskPriority.values.byName(...)
    //  - is_completed (int 0/1)      -> bool (!= 0)
    throw UnimplementedError('TaskMapper.fromRow belum diimplementasikan');
  }

  /// Mengubah sebuah [Task] menjadi Map siap INSERT/UPDATE.
  static Map<String, Object?> toRow(Task task) {
    // TODO(student): bangun Map<String,Object?> dengan kunci dari [TaskSchema].
    // Contoh kunci: columnId, columnTitle, ..., columnIsCompleted.
    throw UnimplementedError('TaskMapper.toRow belum diimplementasikan');
  }
}
