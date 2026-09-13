/// Model + konstanta kategori untuk latihan form P05.
library;

enum Priority { low, medium, high }

class Task {
  final String title;
  final String description;
  final String category;
  final Priority priority;
  final DateTime? dueDate;

  const Task({
    required this.title,
    this.description = '',
    this.category = 'Belajar',
    this.priority = Priority.medium,
    this.dueDate,
  });
}

const categories = ['Belajar', 'Tugas', 'Proyek', 'Lainnya'];
