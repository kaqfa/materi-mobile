import 'package:flutter_test/flutter_test.dart';
import 'package:p07_release/features/tasks/domain/task.dart';

/// Unit smoke untuk gate release. Hijau sejak starter. Membuktikan
/// `flutter test` minimal hijau sebelum `flutter build`.
void main() {
  test('releaseDummyTasks mengembalikan 3 task', () {
    final tasks = releaseDummyTasks();
    expect(tasks.length, 3);
    expect(tasks.every((t) => t.id.isNotEmpty), isTrue);
  });

  test('Task.status: overdue untuk due date lampau', () {
    final task = Task(
      id: 'x',
      title: 'Past',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    );
    expect(task.status, TaskStatus.overdue);
  });

  test('Task immutability: copyWith tidak mengubah asli', () {
    final a = Task(id: 'a', title: 'A', dueDate: DateTime.now());
    final b = a.copyWith(title: 'B');
    expect(a.title, 'A');
    expect(b.title, 'B');
  });
}
