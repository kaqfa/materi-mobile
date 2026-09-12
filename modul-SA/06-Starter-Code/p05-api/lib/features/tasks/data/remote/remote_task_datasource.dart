import '../../domain/task.dart';
import 'task_api_client.dart';

/// Remote datasource: pembungkus tipis atas [TaskApiClient]. Dapat ditukar
/// antara implementasi HTTP dan Mock tanpa mengubah repository/provider.
class RemoteTaskDatasource {
  RemoteTaskDatasource(this._client);

  final TaskApiClient _client;

  Future<List<Task>> getAll() => _client.listTasks();
  Future<Task> create(Task task) => _client.createTask(task);
  Future<Task> update(Task task) => _client.updateTask(task);
  Future<void> remove(String id) => _client.deleteTask(id);
}
