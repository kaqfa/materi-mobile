import '../domain/task.dart';

/// Kriteria filter untuk daftar tugas. [TaskStatus.all] = tidak difilter.
/// Target unit test (P06 CP1): filter by status + search + kombinasi.
class TaskFilter {
  final TaskStatus? status;
  final String search;

  const TaskFilter({this.status, this.search = ''});

  static const TaskFilter empty = TaskFilter();

  bool get isEmpty => status == null && search.isEmpty;

  TaskFilter copyWith({TaskStatus? status, String? search}) {
    return TaskFilter(
      status: status ?? this.status,
      search: search ?? this.search,
    );
  }
}

/// Layanan filter pure-Dart (tanpa Flutter). Mudah di-unit-test.
///
/// Kontrak:
/// - [status] != null: hanya task berstatus sama yang lolos.
/// - [search] non-kosong: title mengandung search (case-insensitive, trim).
/// - Keduanya: kondisi di-AND (filter-status DAN cocok-search).
/// - Input null/empty => kembalikan list kosong (defensive), bukan error.
class TaskFilterService {
  const TaskFilterService();

  List<Task> apply(List<Task> tasks, TaskFilter filter) {
    if (tasks.isEmpty) return const [];

    final q = filter.search.trim().toLowerCase();
    final byStatus = filter.status;

    return tasks.where((t) {
      final statusOk = byStatus == null || t.status == byStatus;
      final searchOk = q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          t.description.toLowerCase().contains(q);
      return statusOk && searchOk;
    }).toList(growable: false);
  }

  /// Shortcut: hanya filter status.
  List<Task> byStatus(List<Task> tasks, TaskStatus status) =>
      apply(tasks, TaskFilter(status: status));

  /// Shortcut: hanya filter search.
  List<Task> bySearch(List<Task> tasks, String search) =>
      apply(tasks, TaskFilter(search: search));
}
