import 'package:flutter_test/flutter_test.dart';
import 'package:study_tracker_p02/models/task.dart';

/// Merah saat starter pertama kali dijalankan — normal.
/// Kerjakan TODO di `lib/models/task.dart`, lalu `flutter test` harus hijau.
void main() {
  group('Task model (P02)', () {
    test('P02-2 fromJson mem-parse semua field', () {
      final task = Task.fromJson(const {
        'id': 't9',
        'title': 'Belajar Dart',
        'category': 'Belajar',
        'priority': 'high',
        'dueDate': '2026-03-01T23:59:00.000',
        'completed': false,
        'tags': ['dart', 'p02'],
      });

      expect(task.id, 't9');
      expect(task.priority, Priority.high);
      expect(task.dueDate, isNotNull);
      expect(task.hasTag('DART'), isTrue); // mixin, case-insensitive
    });

    test('P02-3 isOverdue: terlambat bila lewat dueDate & belum selesai', () {
      final terlambat = Task(
        id: 'a',
        title: 'Terlambat',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      );
      final terlambatTapiSelesai = terlambat.copyWith(completed: true);
      final tanpaDeadline = Task(id: 'b', title: 'Bebas');

      expect(terlambat.isOverdue, isTrue);
      expect(terlambatTapiSelesai.isOverdue, isFalse);
      expect(tanpaDeadline.isOverdue, isFalse);
    });

    test('P02-4 copyWith mengganti field terpilih saja', () {
      final task = Task(id: 'c', title: 'Awal', category: 'Umum');
      final salinan = task.copyWith(title: 'Baru', completed: true);

      expect(salinan.title, 'Baru');
      expect(salinan.completed, isTrue);
      expect(salinan.category, 'Umum'); // tidak ikut berubah
      expect(salinan.id, task.id); // id tidak pernah diganti copyWith
    });

    test('toJson round-trip: fromJson(toJson(x)) == x (field utama)', () {
      final task = Task(
        id: 'd',
        title: 'Round trip',
        category: 'Tugas',
        priority: Priority.high,
        tags: const ['p02'],
      );
      final hasil = Task.fromJson(task.toJson());

      expect(hasil.title, task.title);
      expect(hasil.priority, task.priority);
      expect(hasil.tags, task.tags);
    });
  });
}
