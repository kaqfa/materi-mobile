import '../../../../core/errors/api_error.dart';
import '../../domain/task.dart';
import 'fixtures/task_fixtures.dart';
import 'task_api_client.dart';

/// Implementasi [TaskApiClient] yang sepenuhnya offline. Memakai [TaskFixtures]
/// sebagai sumber data sehingga aplikasi tetap bisa diuji tanpa server.
///
/// Menyimpan state in-memory sederhana agar create/update/delete terlihat
/// efeknya dalam sesi yang sama (tidak meniru persistence nyata — itu tugas P04).
class MockTaskApiClient implements TaskApiClient {
  MockTaskApiClient({List<Map<String, Object?>>? seed})
      : _store = {
          for (final t in (seed ?? TaskFixtures.tasks))
            t['id'] as String: Map<String, Object?>.from(t),
        };

  final Map<String, Map<String, Object?>> _store;

  /// Bila true, [listTasks] melempar [NetworkError] untuk mendemokan state
  /// error di UI tanpa harus mematikan internet sungguhan.
  bool simulateNetworkError = false;

  @override
  Future<List<Task>> listTasks() async {
    await _delay();
    _maybeThrowNetwork();
    return _store.values.map(Task.fromJson).toList();
  }

  @override
  Future<Task> createTask(Task task) async {
    await _delay();
    _maybeThrowNetwork();
    if (_store.containsKey(task.id)) {
      throw const ClientError(409, 'Task id sudah ada (409).');
    }
    _store[task.id] = task.toJson();
    return task;
  }

  @override
  Future<Task> updateTask(Task task) async {
    await _delay();
    _maybeThrowNetwork();
    if (!_store.containsKey(task.id)) {
      throw const NotFoundError();
    }
    _store[task.id] = task.toJson();
    return task;
  }

  @override
  Future<void> deleteTask(String id) async {
    await _delay();
    _maybeThrowNetwork();
    if (!_store.containsKey(id)) {
      throw const NotFoundError();
    }
    _store.remove(id);
  }

  // Meniru latensi jaringan kecil agar loading state terlihat.
  Future<void> _delay() => Future<void>.delayed(const Duration(milliseconds: 150));

  void _maybeThrowNetwork() {
    if (simulateNetworkError) throw const NetworkError();
  }
}
