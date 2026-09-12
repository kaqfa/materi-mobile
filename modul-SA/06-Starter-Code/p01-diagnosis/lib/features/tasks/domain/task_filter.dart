import 'task.dart';

class TaskFilterService {
  const TaskFilterService();

  List<Task> filterByStatus(List<Task> tasks, TaskStatus? status) {
    if (status == null) return List<Task>.unmodifiable(tasks);

    return tasks.where((t) => t.status == status).toList(growable: false);
  }

  List<Task> searchByTitle(List<Task> tasks, String query) {
    final q = query.trim();
    if (q.isEmpty) return List<Task>.unmodifiable(tasks);

    return tasks
        .where((t) => t.title.toLowerCase().contains(q.toLowerCase()))
        .toList(growable: false);
  }
}
