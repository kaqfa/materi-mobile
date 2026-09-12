import '../../../domain/task.dart';

/// Fixture JSON offline. Dipakai [MockTaskApiClient] sebagai fallback bila
/// tidak ada server. Bentuknya persis mengikuti `06-Starter-Code/API-CONTRACT.md`.
///
/// Disimpan sebagai `List<Map>` mentah agar path parsing JSON tetap diuji
/// lewat `Task.fromJson`, bukan di-bypass.
class TaskFixtures {
  const TaskFixtures._();

  /// Tanggal dipakai: `2026-09-01T00:00:00.000Z` (stabil, tidak relatif).
  static const List<Map<String, Object?>> tasks = [
    {
      'id': 'f01',
      'title': 'Fixture: Math Assignment',
      'description': 'Dari fixture offline, bukan server.',
      'due_date': '2026-09-01T00:00:00.000Z',
      'priority': 'high',
      'is_completed': false,
    },
    {
      'id': 'f02',
      'title': 'Fixture: History Reading',
      'description': 'Membuktikan GET tanpa internet.',
      'due_date': '2026-09-05T00:00:00.000Z',
      'priority': 'medium',
      'is_completed': false,
    },
    {
      'id': 'f03',
      'title': 'Fixture: Submitted Essay',
      'description': 'Contoh completed.',
      'due_date': '2026-08-25T00:00:00.000Z',
      'priority': 'medium',
      'is_completed': true,
    },
  ];

  /// Parse seluruh fixture menjadi model. Berguna untuk mock + test.
  static List<Task> toTasks() => tasks.map(Task.fromJson).toList();
}
