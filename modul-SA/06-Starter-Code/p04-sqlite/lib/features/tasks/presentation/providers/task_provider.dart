import 'package:flutter/foundation.dart';

import '../../data/repositories/task_repository.dart';
import '../../domain/task.dart';

/// State manajemen task dengan [ChangeNotifier], menyimpan ke
/// [TaskRepository] (SQLite lewat P04).
///
/// PERHATIAN (P04): method CRUD (add/update/delete/toggle) sengaja dibuat
/// **no-op** sebagai TODO inti. Hubungkan ke [_repo] (save/remove + muat
/// ulang list) sampai semua test CRUD menjadi hijau. Lihat README checkpoint.
///
/// Konvensi state:
/// - [_tasks] sumber data reaktif hasil baca repo.
/// - [_isLoading] untuk loading state UI.
/// - [_error] != null => error state UI (dengan retry).
class TaskProvider extends ChangeNotifier {
  TaskProvider(this._repo);

  final TaskRepository _repo;

  List<Task> _tasks = const [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get count => _tasks.length;

  Task? findById(String id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  /// Memuat seluruh task dari repository. Bila tabel kosong (first run),
  /// list menampilkan empty state sampai mahasiswa menambah data via form.
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _repo.getAll();
    } catch (e) {
      _error = 'Failed to load tasks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---- CRUD inti (TODO student) ------------------------------------------

  /// Menyimpan task baru (insert).
  Future<void> addTask(Task task) async {
    // TODO(student): panggil _repo.save(task) lalu refresh list + notify.
  }

  /// Memperbarui task yang sudah ada.
  Future<void> updateTask(Task task) async {
    // TODO(student): panggil _repo.save(task) lalu refresh list + notify.
  }

  /// Menghapus task berdasarkan [id].
  Future<void> deleteTask(String id) async {
    // TODO(student): panggil _repo.remove(id) lalu refresh list + notify.
  }

  /// Toggle status selesai task dengan [id].
  Future<void> toggleComplete(String id) async {
    // TODO(student): cari task, copyWith(isCompleted: !...), _repo.save, refresh.
  }
}
