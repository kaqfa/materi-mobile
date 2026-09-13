/// Model P11 — sama dengan starter P03.
library;

enum Priority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String category;
  final Priority priority;
  final bool completed;

  const Task({
    required this.id,
    required this.title,
    this.category = 'Umum',
    this.priority = Priority.medium,
    this.completed = false,
  });

  Task copyWith({bool? completed}) => Task(
        id: id,
        title: title,
        category: category,
        priority: priority,
        completed: completed ?? this.completed,
      );
}
