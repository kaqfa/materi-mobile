/// Prioritas tugas.
enum TaskPriority { low, medium, high }

/// Status tugas turunan. Komputasi dari [Task.isCompleted] dan
/// [Task.dueDate] relatif [DateTime.now]. Target unit test (P06).
enum TaskStatus { pending, overdue, completed }

/// Model tugas. Immutable; gunakan [copyWith] untuk perubahan.
///
/// Diseragamkan dengan starter P01–P05. P06 menambah [attachmentPath]
/// opsional (hasil image picker) sebagai bukti device feature.
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool isCompleted;
  final String? attachmentPath;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.isCompleted = false,
    this.attachmentPath,
  });

  /// Status turunan. Komputasi konsisten dengan [TaskFilterService].
  /// Target unit test: completed / overdue / pending.
  TaskStatus get status {
    if (isCompleted) return TaskStatus.completed;
    final now = DateTime.now();
    if (dueDate.isBefore(now)) return TaskStatus.overdue;
    return TaskStatus.pending;
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
    String? attachmentPath,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      attachmentPath: attachmentPath ?? this.attachmentPath,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Task && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Task(id: $id, title: $title, priority: $priority, status: $status)';
}

/// Data dummy kecil untuk demo/test P06. Lebih ringan dari P05 karena P06
/// fokus testing/device, bukan daftar panjang.
List<Task> dummyTasks({DateTime? now}) {
  final base = now ?? DateTime.now();
  return [
    Task(
      id: 't01',
      title: 'Complete Math Assignment',
      description: 'Finish calculus homework chapter 4.',
      dueDate: base.add(const Duration(days: 2)),
      priority: TaskPriority.high,
    ),
    Task(
      id: 't02',
      title: 'Read History Chapter 3',
      description: 'Summarize key events for the quiz.',
      dueDate: base.add(const Duration(days: 5)),
      priority: TaskPriority.medium,
    ),
    Task(
      id: 't03',
      title: 'Physics Lab Report',
      description: 'Write pendulum experiment analysis.',
      dueDate: base.subtract(const Duration(days: 1)),
      priority: TaskPriority.high,
    ),
    Task(
      id: 't04',
      title: 'Submit English Essay',
      description: 'Final draft on climate change.',
      dueDate: base.add(const Duration(days: 7)),
      priority: TaskPriority.medium,
      isCompleted: true,
    ),
  ];
}
