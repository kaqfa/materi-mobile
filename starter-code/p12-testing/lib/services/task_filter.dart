import '../models/task.dart';

enum StatusFilter { all, open, done }

/// Logika filter/sort murni — tanpa Flutter, mudah di-unit-test.
class TaskFilter {
  /// Filter status + pencarian judul (case-insensitive).
  // TODO(student) P12-2: task_filter_test.dart MERAH untuk kasus
  // StatusFilter.open — perbaiki cabang yang terbalik (jangan ubah test).
  static List<Task> apply(
    List<Task> tasks, {
    StatusFilter status = StatusFilter.all,
    String query = '',
  }) {
    return tasks.where((t) {
      final statusOk = switch (status) {
        StatusFilter.all => true,
        StatusFilter.open => t.completed,
        StatusFilter.done => t.completed,
      };
      final queryOk =
          query.isEmpty || t.title.toLowerCase().contains(query.toLowerCase());
      return statusOk && queryOk;
    }).toList();
  }

  /// Urutkan: high dulu, lalu medium, lalu low; stabil untuk prioritas sama.
  static List<Task> sortByPriority(List<Task> tasks) {
    final rank = {Priority.high: 0, Priority.medium: 1, Priority.low: 2};
    final copy = [...tasks]..sort((a, b) => rank[a.priority]!.compareTo(rank[b.priority]!));
    return copy;
  }
}
