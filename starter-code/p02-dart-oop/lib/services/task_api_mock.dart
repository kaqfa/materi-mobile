import 'dart:math';

import '../models/task.dart';

/// Simulasi REST API: latihan async + error handling TANPA backend nyata.
///
/// Pola yang dipelajari di sini (Future, delayed, try-catch, throw)
/// dipakai apa adanya saat bertemu `http` di P09.
class TaskApiMock {
  static const _seedTasks = [
    {
      'id': 't1',
      'title': 'Baca bab 1 modul Flutter',
      'category': 'Belajar',
      'priority': 'high',
      'dueDate': null,
      'completed': false,
      'tags': ['modul', 'flutter'],
    },
    {
      'id': 't2',
      'title': 'Kerjakan Dart OOP Challenge',
      'category': 'Tugas',
      'priority': 'high',
      'dueDate': '2026-03-01T23:59:00.000',
      'completed': false,
      'tags': ['p02'],
    },
    {
      'id': 't3',
      'title': 'Review catatan OOP',
      'category': 'Belajar',
      'priority': 'low',
      'completed': true,
      'tags': [],
    },
  ];

  final _random = Random();

  /// Simulasi GET /tasks. 20% kemungkinan gagal (jaringan tidak stabil).
  Future<List<Task>> fetchTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (_random.nextInt(5) == 0) {
      throw Exception('Network error: request timeout');
    }
    return _seedTasks.map(Task.fromJson).toList();
  }

  /// Simulasi POST /tasks.
  Future<Task> createTask(String title) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final task = Task(id: 't${100 + _random.nextInt(900)}', title: title);
    return task;
  }
}
