import 'package:flutter_test/flutter_test.dart';
import 'package:p04_sqlite/features/tasks/data/local/task_database.dart';
import 'package:p04_sqlite/features/tasks/data/local/task_mapper.dart';
import 'package:p04_sqlite/features/tasks/domain/task.dart';

/// Test mapper SQLite. **SENGAJA GAGAL (merah)** selama [TaskMapper.fromRow]
/// dan [TaskMapper.toRow] belum diimplementasikan. Target checkpoint 2.
void main() {
  final baseDate = DateTime.utc(2026, 9, 1, 8);

  test(
    'TODO(student): toRow menghasilkan kolom sesuai TaskSchema',
    () {
      final task = Task(
        id: 't01',
        title: 'Complete Math Assignment',
        description: 'Finish calculus homework chapter 4.',
        dueDate: baseDate,
        priority: TaskPriority.high,
        isCompleted: true,
      );

      final row = TaskMapper.toRow(task);

      expect(row[TaskSchema.columnId], 't01');
      expect(row[TaskSchema.columnTitle], 'Complete Math Assignment');
      expect(row[TaskSchema.columnDescription],
          'Finish calculus homework chapter 4.');
      expect(row[TaskSchema.columnDueDate], baseDate.toIso8601String());
      expect(row[TaskSchema.columnPriority], 'high');
      expect(row[TaskSchema.columnIsCompleted], 1);
    },
  );

  test(
    'TODO(student): fromRow menghasilkan Task yang setara',
    () {
      final row = <String, Object?>{
        TaskSchema.columnId: 't02',
        TaskSchema.columnTitle: 'Read History Chapter 3',
        TaskSchema.columnDescription: 'Summarize key events.',
        TaskSchema.columnDueDate: baseDate.toIso8601String(),
        TaskSchema.columnPriority: 'medium',
        TaskSchema.columnIsCompleted: 0,
      };

      final task = TaskMapper.fromRow(row);

      expect(task.id, 't02');
      expect(task.title, 'Read History Chapter 3');
      expect(task.description, 'Summarize key events.');
      expect(task.dueDate, baseDate);
      expect(task.priority, TaskPriority.medium);
      expect(task.isCompleted, isFalse);
    },
  );

  test(
    'TODO(student): round-trip toRow -> fromRow menjaga data',
    () {
      final original = Task(
        id: 't03',
        title: 'Round Trip',
        description: 'persist then read back',
        dueDate: baseDate,
        priority: TaskPriority.low,
      );

      final restored = TaskMapper.fromRow(TaskMapper.toRow(original));

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.description, original.description);
      expect(restored.dueDate, original.dueDate);
      expect(restored.priority, original.priority);
      expect(restored.isCompleted, original.isCompleted);
    },
  );
}
