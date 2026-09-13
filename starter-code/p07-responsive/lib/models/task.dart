/// Model ringkas P07 (pola sama dengan starter sebelumnya).
library;

enum Priority { low, medium, high }

class Task {
  final String title;
  final String category;
  final Priority priority;
  final bool completed;

  const Task({
    required this.title,
    this.category = 'Belajar',
    this.priority = Priority.medium,
    this.completed = false,
  });
}

const mockTasks = [
  Task(title: 'Uji di phone portrait', category: 'Praktikum', priority: Priority.high),
  Task(title: 'Uji di phone landscape'),
  Task(title: 'Uji di tablet', category: 'Praktikum', priority: Priority.high),
  Task(title: 'Uji font scaling besar', priority: Priority.low),
  Task(title: 'Uji dynamic padding', completed: true),
];
