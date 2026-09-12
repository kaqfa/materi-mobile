import 'package:flutter_test/flutter_test.dart';
import 'package:p06_testing_device/features/tasks/domain/task.dart';
import 'package:p06_testing_device/features/tasks/services/task_filter_service.dart';

/// Unit test target #2 (filter-validator): [TaskFilterService].
/// Hijau sejak starter. Membuktikan gate "3 unit test".
void main() {
  late List<Task> sample;

  setUp(() {
    sample = [
      Task(
        id: 'a',
        title: 'Complete Math Assignment',
        description: 'calculus',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        priority: TaskPriority.high,
      ),
      Task(
        id: 'b',
        title: 'Read History Chapter 3',
        description: 'cold war',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        priority: TaskPriority.medium,
      ),
      Task(
        id: 'c',
        title: 'Submit English Essay',
        description: 'climate',
        dueDate: DateTime.now().add(const Duration(days: 4)),
        priority: TaskPriority.medium,
        isCompleted: true,
      ),
    ];
  });

  test('byStatus menyaring sesuai TaskStatus', () {
    const service = TaskFilterService();
    final overdue = service.byStatus(sample, TaskStatus.overdue);
    expect(overdue.map((t) => t.id), ['b']);

    final completed = service.byStatus(sample, TaskStatus.completed);
    expect(completed.map((t) => t.id), ['c']);
  });

  test('bySearch case-insensitive terhadap title', () {
    const service = TaskFilterService();
    final hits = service.bySearch(sample, 'MATH');
    expect(hits.map((t) => t.id), ['a']);
  });

  test('kombinasi status + search di-AND', () {
    const service = TaskFilterService();
    // 'Read History' overdue (bukan pending) => kombinasi pending+read kosong.
    final pendingRead = service.apply(
      sample,
      const TaskFilter(status: TaskStatus.pending, search: 'read'),
    );
    expect(pendingRead, isEmpty);

    final overdueRead = service.apply(
      sample,
      const TaskFilter(status: TaskStatus.overdue, search: 'read'),
    );
    expect(overdueRead.map((t) => t.id), ['b']);
  });

  test('input kosong/empty list => defensive empty', () {
    const service = TaskFilterService();
    expect(service.apply(const [], TaskFilter.empty), isEmpty);
    expect(service.apply(sample, TaskFilter.empty).length, sample.length);
  });
}
