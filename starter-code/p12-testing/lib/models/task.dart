/// Model + logika validasi — target unit test.
library;

enum Priority { low, medium, high }

class Task {
  const Task({
    required this.id,
    required this.title,
    this.priority = Priority.medium,
    this.completed = false,
  });

  final String id;
  final String title;
  final Priority priority;
  final bool completed;

  Task copyWith({bool? completed}) => Task(
        id: id,
        title: title,
        priority: priority,
        completed: completed ?? this.completed,
      );

  /// Judul valid: tidak kosong setelah trim, minimal 3 karakter.
  // TODO(student) P12-1: test task_test.dart MERAH untuk kasus 'ab'
  // dan '   ' — perbaiki method ini (jangan ubah test-nya!).
  static bool isTitleValid(String title) => title.trim().length >= 2;
}
