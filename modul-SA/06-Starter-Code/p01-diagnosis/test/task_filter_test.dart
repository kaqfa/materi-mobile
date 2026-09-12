import 'package:flutter_test/flutter_test.dart';
import 'package:p01_diagnosis/features/tasks/domain/task.dart';
import 'package:p01_diagnosis/features/tasks/domain/task_filter.dart';

/// Test diagnosis untuk P01.
///
/// Beberapa test di sini **SENGAJA GAGAL (merah)** karena memvalidasi perilaku
/// yang benar, sedangkan [TaskFilterService] sengaja dibuat rusak. Target
/// checkpoint: perbaiki `lib/features/tasks/domain/task_filter.dart` sampai
/// seluruh test di file ini hijau. Lihat `README.md` P01.
void main() {
  late List<Task> sample;

  setUp(() {
    final now = DateTime.now();
    sample = [
      Task(
        id: 'a',
        title: 'Complete Math Assignment',
        description: 'd',
        dueDate: now.add(const Duration(days: 2)), // pending
        priority: TaskPriority.high,
      ),
      Task(
        id: 'b',
        title: 'Physics Lab Report',
        description: 'd',
        dueDate: now.subtract(const Duration(days: 1)), // overdue
        priority: TaskPriority.high,
      ),
      Task(
        id: 'c',
        title: 'Submit English Essay',
        description: 'd',
        dueDate: now.add(const Duration(days: 3)), // completed via flag
        priority: TaskPriority.medium,
        isCompleted: true,
      ),
    ];
  });

  const filter = TaskFilterService();

  group('filterByStatus', () {
    test('status == null mengembalikan semua task (all)', () {
      expect(filter.filterByStatus(sample, null).length, sample.length);
    });

    test(
      'TODO(student): mengembalikan HANYA task pending',
      () {
        // Ekspektasi benar: hanya task 'a' yang pending.
        final result = filter.filterByStatus(sample, TaskStatus.pending);
        expect(result, hasLength(1));
        expect(result.single.id, 'a');
      },
    );

    test(
      'TODO(student): mengembalikan HANYA task overdue',
      () {
        final result = filter.filterByStatus(sample, TaskStatus.overdue);
        expect(result, hasLength(1));
        expect(result.single.id, 'b');
      },
    );

    test(
      'TODO(student): mengembalikan HANYA task completed',
      () {
        final result = filter.filterByStatus(sample, TaskStatus.completed);
        expect(result, hasLength(1));
        expect(result.single.id, 'c');
      },
    );
  });

  group('searchByTitle', () {
    test('query kosong mengembalikan semua task', () {
      expect(filter.searchByTitle(sample, '').length, sample.length);
      expect(filter.searchByTitle(sample, '   ').length, sample.length);
    });

    test(
      'TODO(student): case-insensitive + substring (cari "math")',
      () {
        final result = filter.searchByTitle(sample, 'math');
        expect(result, hasLength(1));
        expect(result.single.id, 'a');
      },
    );

    test(
      'TODO(student): tidak menemukan kata yang tidak ada',
      () {
        expect(filter.searchByTitle(sample, 'chemistry'), isEmpty);
      },
    );
  });
}
