import 'package:flutter_test/flutter_test.dart';
import 'package:study_tracker_p12/models/task.dart';
import 'package:study_tracker_p12/services/task_filter.dart';

/// Sebagian MERAH by design — kerjakan TODO di lib/, bukan di test.
void main() {
  group('Task.isTitleValid (P12-1)', () {
    test('judul normal valid', () {
      expect(Task.isTitleValid('Belajar Flutter'), isTrue);
    });

    test('judul < 3 karakter tidak valid', () {
      expect(Task.isTitleValid('ab'), isFalse); // MERAH: starter mengizinkan 2
    });

    test('spasi saja tidak valid', () {
      expect(Task.isTitleValid('   '), isFalse); // MERAH
    });
  });

  group('TaskFilter.apply (P12-2)', () {
    const tasks = [
      Task(id: 'a', title: 'Belajar test'),
      Task(id: 'b', title: 'Latihan widget', completed: true),
    ];

    test('filter open: hanya yang belum selesai', () {
      final open = TaskFilter.apply(tasks, status: StatusFilter.open);
      expect(open.length, 1);
      expect(open.first.id, 'a'); // MERAH: cabang open terbalik
    });

    test('filter done: hanya yang selesai', () {
      final done = TaskFilter.apply(tasks, status: StatusFilter.done);
      expect(done.length, 1);
      expect(done.first.id, 'b'); // hijau
    });

    test('query case-insensitive', () {
      final hasil = TaskFilter.apply(tasks, query: 'WIDGET');
      expect(hasil.length, 1);
      expect(hasil.first.id, 'b'); // hijau
    });
  });

  group('TaskFilter.sortByPriority', () {
    test('high di depan, urutan asli stabil', () {
      const tasks = [
        Task(id: 'x1', title: 'low', priority: Priority.low),
        Task(id: 'x2', title: 'high', priority: Priority.high),
        Task(id: 'x3', title: 'medium', priority: Priority.medium),
      ];
      final hasil = TaskFilter.sortByPriority(tasks);
      expect(hasil.map((t) => t.id).toList(), ['x2', 'x3', 'x1']); // hijau
    });
  });
}
