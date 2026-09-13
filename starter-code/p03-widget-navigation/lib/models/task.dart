/// Model sederhana untuk P03 — cukup untuk latihan widget & navigasi.
/// (Versi lengkap dengan mixin/JSON ada di starter P02.)
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

const mockTasks = [
  Task(id: 't1', title: 'Baca bab 3: Flutter Fundamentals', category: 'Belajar', priority: Priority.high),
  Task(id: 't2', title: 'Latihan Navigator.push', category: 'Praktikum'),
  Task(id: 't3', title: 'Review widget tree', category: 'Belajar', priority: Priority.low, completed: true),
];
