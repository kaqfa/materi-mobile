import 'package:flutter/foundation.dart';

import '../../domain/task.dart';

/// State manajemen task dengan [ChangeNotifier].
///
/// PERHATIAN (P03): metode CRUD (add/update/delete/toggle) sengaja dibuat
/// **no-op** sebagai TODO inti. Implementasikan sampai semua test di
/// `test/task_provider_test.dart` menjadi hijau. Lihat README checkpoint.
///
/// Konvensi state:
/// - [_tasks] sumber data reaktif.
/// - [_isLoading] untuk loading state UI.
/// - [_error] != null => error state UI (dengan retry).
class TaskProvider extends ChangeNotifier {
  TaskProvider({List<Task> initialTasks = const []}) : _tasks = initialTasks;

  List<Task> _tasks;
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

  /// Memuat data awal. Sumber data persisten (SQLite) datang di P04; untuk
  /// P03 cukup seed dummy. Method ini TIDAK termasuk TODO inti.
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      _tasks = Task.getDummyTasks();
    } catch (e) {
      _error = 'Failed to load tasks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---- CRUD inti (TODO student) ------------------------------------------

  /// Menambahkan task baru ke daftar.
  void addTask(Task task) {
    _tasks = [..._tasks, task];
    notifyListeners();
  }

  /// Memperbarui task yang sudah ada (dicocokkan berdasarkan id).
  void updateTask(Task task) {
    _tasks = [
      for (final t in _tasks)
        if (t.id == task.id) task else t
    ];
    notifyListeners();
  }

  /// Menghapus task berdasarkan [id].
  void deleteTask(String id) {
    _tasks = _tasks.where((t) => t.id != id).toList();
    notifyListeners();
  }

  /// Toggle status selesai task dengan [id].
  void toggleComplete(String id) {
    _tasks = [
      for (final t in _tasks)
        if (t.id == id) t.copyWith(isCompleted: !t.isCompleted) else t
    ];
    notifyListeners();
  }
}
