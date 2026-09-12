import 'package:flutter/foundation.dart';

import '../../data/repositories/task_repository.dart';
import '../../domain/task.dart';

/// State manajemen task dengan [ChangeNotifier], menyimpan via [TaskRepository]
/// (remote P05).
///
/// PERHATIAN (P05): method CRUD (add/update/delete/toggle) sengaja dibuat
/// **no-op** sebagai TODO inti. Hubungkan ke [_repo] lalu refresh list.
/// `loadTasks` sudah terhubung sehingga GET memperlihatkan data fixture/mock.
///
/// Konvensi state:
/// - [_tasks] hasil GET dari repo (mock by default).
/// - [_isLoading] => loading state UI.
/// - [_error] != null => error state UI (dengan retry manual).
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

  /// Memuat seluruh task dari repository. Bila mock (default), mengembalikan
  /// fixture. Bila jaringan gagal, [_error] terisi untuk state error UI.
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

  /// Membuat task baru via POST.
  Future<void> addTask(Task task) async {
    try {
      await _repo.save(task);
      await loadTasks();
    } catch (e) {
      _error = 'Failed to add task: $e';
      notifyListeners();
    }
  }

  /// Memperbarui task via PATCH.
  Future<void> updateTask(Task task) async {
    try {
      await _repo.save(task);
      await loadTasks();
    } catch (e) {
      _error = 'Failed to update task: $e';
      notifyListeners();
    }
  }

  /// Menghapus task via DELETE.
  Future<void> deleteTask(String id) async {
    try {
      await _repo.remove(id);
      await loadTasks();
    } catch (e) {
      _error = 'Failed to delete task: $e';
      notifyListeners();
    }
  }

  /// Toggle status selesai task dengan [id].
  Future<void> toggleComplete(String id) async {
    try {
      final task = findById(id);
      if (task != null) {
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        await _repo.save(updatedTask);
        await loadTasks();
      }
    } catch (e) {
      _error = 'Failed to toggle task completion: $e';
      notifyListeners();
    }
  }
}
