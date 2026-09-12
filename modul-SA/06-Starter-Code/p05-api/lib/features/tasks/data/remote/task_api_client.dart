import '../../domain/task.dart';

/// Kontrak klien REST task. UI/repository hanya mengenal abstraksi ini.
///
/// Implementasi:
/// - [HttpTaskApiClient] : memanggil server via `package:http`.
/// - [MockTaskApiClient] : fallback fixture offline (lihat `task_fixtures.dart`).
///
/// Endpoint + bentuk JSON mengikuti `06-Starter-Code/API-CONTRACT.md`.
abstract class TaskApiClient {
  /// GET /tasks
  Future<List<Task>> listTasks();

  /// POST /tasks
  Future<Task> createTask(Task task);

  /// PATCH /tasks/:id
  Future<Task> updateTask(Task task);

  /// DELETE /tasks/:id
  Future<void> deleteTask(String id);
}
