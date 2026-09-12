import 'package:flutter_test/flutter_test.dart';
import 'package:p06_testing_device/features/tasks/domain/task.dart';

/// Unit test target #1 (model): turunan [Task.status] konsisten dengan filter.
/// Hijau sejak starter.
void main() {
  test('completed task -> TaskStatus.completed', () {
    final task = Task(
      id: 'c1',
      title: 'Done item',
      description: '',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      isCompleted: true,
    );
    expect(task.status, TaskStatus.completed);
  });

  test('uncompleted past due -> TaskStatus.overdue', () {
    final task = Task(
      id: 'o1',
      title: 'Late item',
      description: '',
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
    );
    expect(task.status, TaskStatus.overdue);
  });

  test('uncompleted future due -> TaskStatus.pending', () {
    final task = Task(
      id: 'p1',
      title: 'Upcoming item',
      description: '',
      dueDate: DateTime.now().add(const Duration(days: 3)),
    );
    expect(task.status, TaskStatus.pending);
  });
}
