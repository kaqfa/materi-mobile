import '../../models/task.dart';

/// Kontrak sisi server untuk sinkronisasi.
/// Implementasi nyata: pola RemoteTaskApiClient (starter P09).
abstract interface class RemoteTaskApi {
  Future<List<Task>> fetchAll();
  Future<void> upsert(Task task);
}

/// Server palsu in-memory — cukup untuk mensimulasikan pull/push/konflik
/// di kelas tanpa jaringan.
class MemoryRemoteApi implements RemoteTaskApi {
  final Map<String, Task> _data = {};

  MemoryRemoteApi({List<Task> seed = const []}) {
    for (final t in seed) {
      _data[t.id] = t;
    }
  }

  @override
  Future<List<Task>> fetchAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _data.values.toList();
  }

  @override
  Future<void> upsert(Task task) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _data[task.id] = task;
  }

  /// Simulasi: orang lain mengubah data di server (untuk latihan konflik).
  void debugServerSideEdit(String id, String newTitle) {
    final t = _data[id];
    if (t != null) {
      _data[id] = t.copyWith(title: newTitle, updatedAt: DateTime.now());
    }
  }
}
