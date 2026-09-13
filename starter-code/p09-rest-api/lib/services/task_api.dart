import '../models/task.dart';

/// Kontrak API — remote & mock sama-sama memenuhi ini.
/// (Dependency inversion: UI/service tinggal bergantung pada abstraksi.)
abstract interface class TaskApi {
  Future<List<Task>> fetchTasks();
  Future<Task> createTask(String title);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int id);
}

/// Mock tanpa jaringan — dipakai bila API_BASE_URL tidak diisi,
/// supaya starter tetap bisa dijalankan di kelas tanpa backend.
class MockTaskApi implements TaskApi {
  final List<Task> _tasks = List.generate(
    5,
    (i) => Task(id: i + 1, title: 'Tugas contoh #${i + 1}', completed: i % 2 == 0),
  );

  @override
  Future<List<Task>> fetchTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return List.of(_tasks);
  }

  @override
  Future<Task> createTask(String title) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final task = Task(id: _tasks.length + 100, title: title);
    _tasks.add(task);
    return task;
  }

  @override
  Future<void> updateTask(Task task) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final i = _tasks.indexWhere((t) => t.id == task.id);
    if (i != -1) _tasks[i] = task;
  }

  @override
  Future<void> deleteTask(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _tasks.removeWhere((t) => t.id == id);
  }
}
