import 'dart:async';

import '../../domain/task.dart';
import '../local/local_task_datasource.dart';

/// Kontrak repository task. UI/Provider hanya mengenal abstraksi ini,
/// bukan detail SQLite. Memudahkan penggantian sumber data (mis. REST di P05).
abstract class TaskRepository {
  Future<List<Task>> getAll();
  Future<void> save(Task task);
  Future<void> remove(String id);
}

/// Implementasi repository yang menyimpan ke [LocalTaskDatasource].
///
/// [save] bersifat upsert: bila id sudah ada, jalankan update; jika belum,
/// insert. Logika ini boleh dipakai langsung (bukan TODO inti). Yang perlu
/// diselesaikan mahasiswa ada di [LocalTaskDatasource] + [TaskMapper].
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
