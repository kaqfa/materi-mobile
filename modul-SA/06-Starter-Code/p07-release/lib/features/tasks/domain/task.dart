/// Prioritas tugas.
enum TaskPriority { low, medium, high }

/// Status turunan. Target unit smoke test (gate release P07).
enum TaskStatus { pending, overdue, completed }

/// Model tugas. Immutable + `const`-friendly (semua field final).
class Task {
  final String id;
  final String title;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.isCompleted = false,
  });

  TaskStatus get status {
    if (isCompleted) return TaskStatus.completed;
    if (dueDate.isBefore(DateTime.now())) return TaskStatus.overdue;
    return TaskStatus.pending;
  }

  /// Salinan immutable. Dipakai unit smoke gate (lihat
  /// `test/domain/task_model_test.dart`) dan demo live modification P07.
  Task copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Task && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// Data dummy kecil untuk demo release.
List<Task> releaseDummyTasks({DateTime? now}) {
  final base = now ?? DateTime.now();
  return [
    Task(
      id: 'r01',
      title: 'Polish README',
      dueDate: base.add(const Duration(days: 1)),
      priority: TaskPriority.high,
    ),
    Task(
      id: 'r02',
      title: 'Run flutter analyze',
      dueDate: base.add(const Duration(days: 2)),
      priority: TaskPriority.medium,
    ),
    Task(
      id: 'r03',
      title: 'Build release APK',
      dueDate: base.subtract(const Duration(days: 1)),
      priority: TaskPriority.high,
    ),
  ];
}
