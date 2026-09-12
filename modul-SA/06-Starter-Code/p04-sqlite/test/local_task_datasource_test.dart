import 'package:flutter_test/flutter_test.dart';
import 'package:p04_sqlite/features/tasks/data/local/local_task_datasource.dart';
import 'package:p04_sqlite/features/tasks/data/local/task_database.dart';
import 'package:p04_sqlite/features/tasks/domain/task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Test datasource SQLite headless memakai sqflite_common_ffi.
///
/// **SENGAJA GAGAL (merah)** selama [LocalTaskDatasource] CRUD belum
/// diimplementasikan. Target checkpoint 3. Pastikan [TaskMapper] sudah hijau
/// lebih dulu (checkpoint 2).
void main() {
  late LocalTaskDatasource datasource;

  setUpAll(() {
    // Inisialisasi ffi agar `getDatabasesPath`/`openDatabase` jalan di CI/test.
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // In-memory file per test via nama unik; factory ffi menulis ke file sementara.
    final db = TaskDatabase(fileName: 'tasks_test.db');
    await (await db.database()).execute('DELETE FROM ${TaskSchema.table}');
    datasource = LocalTaskDatasource(db);
  });

  test(
    'TODO(student): insert lalu getAll mengembalikan task tersebut',
    () async {
      await datasource.insert(
        Task(
          id: 't01',
          title: 'Alpha',
          description: 'first persisted task',
          dueDate: DateTime.utc(2026, 9, 1),
          priority: TaskPriority.high,
        ),
      );

      final all = await datasource.getAll();
      expect(all, hasLength(1));
      expect(all.first.id, 't01');
      expect(all.first.title, 'Alpha');
    },
  );

  test(
    'TODO(student): update mengganti field task yang ada',
    () async {
      final task = Task(
        id: 't02',
        title: 'Beta',
        description: 'original',
        dueDate: DateTime.utc(2026, 9, 2),
        priority: TaskPriority.medium,
      );
      await datasource.insert(task);
      await datasource.update(task.copyWith(title: 'Beta Updated'));

      final all = await datasource.getAll();
      expect(all.first.title, 'Beta Updated');
      expect(all, hasLength(1));
    },
  );

  test(
    'TODO(student): delete menghapus task berdasarkan id',
    () async {
      await datasource.insert(
        Task(
          id: 't03',
          title: 'Gamma',
          description: 'to be deleted',
          dueDate: DateTime.utc(2026, 9, 3),
          priority: TaskPriority.low,
        ),
      );
      await datasource.delete('t03');

      expect(await datasource.getAll(), isEmpty);
    },
  );
}
