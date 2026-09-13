/// Model P06 — sama dengan P03, dipakai komponen custom widget.
library;

enum Priority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String details;
  final String category;
  final Priority priority;
  final bool completed;

  const Task({
    required this.id,
    required this.title,
    this.details = '',
    this.category = 'Belajar',
    this.priority = Priority.medium,
    this.completed = false,
  });

  Task copyWith({bool? completed}) => Task(
        id: id,
        title: title,
        details: details,
        category: category,
        priority: priority,
        completed: completed ?? this.completed,
      );
}

const mockTasks = [
  Task(id: 't1', title: 'Rancang TaskCard', details: 'Komposisi: leading, konten, actions.', category: 'Proyek', priority: Priority.high),
  Task(id: 't2', title: 'Latihan callback', details: 'onToggle & onDelete dipass dari parent.', category: 'Praktikum'),
  Task(id: 't3', title: 'Baca modul bab 6', category: 'Belajar', priority: Priority.low, completed: true),
];
