import '../../models/task.dart';
import '../local/task_dao.dart';
import '../remote/remote_task_api.dart';

class SyncResult {
  const SyncResult({this.pushed = 0, this.pulled = 0, this.conflicts = 0});

  final int pushed;
  final int pulled;
  final int conflicts;

  @override
  String toString() => 'terkirim: $pushed, ditarik: $pulled, konflik: $conflicts';
}

/// Orkestrator sinkronisasi dua arah: push pending lokal → pull server.
class SyncService {
  SyncService({required this.dao, required this.remote});

  final TaskDao dao;
  final RemoteTaskApi remote;

  Future<SyncResult> syncNow() async {
    var pushed = 0;
    var pulled = 0;
    var conflicts = 0;

    // 1) PUSH: unggah semua pending lokal, tandai synced.
    for (final task in await dao.pendingOnly()) {
      await remote.upsert(task.copyWith(syncState: SyncState.synced));
      await dao.upsert(task.copyWith(syncState: SyncState.synced));
      pushed++;
    }

    // 2) PULL: bandingkan data server dengan lokal.
    final localAll = {for (final t in await dao.getAll()) t.id: t};
    for (final remoteTask in await remote.fetchAll()) {
      final localTask = localAll[remoteTask.id];

      if (localTask == null) {
        // TODO(student) P10-2: item baru dari server -> simpan lokal
        // (dao.upsert) lalu pulled++.
        continue;
      }

      // TODO(student) P10-3: KONFLIK — item ada di dua pihak dan beda.
      // Strategi last-write-wins: bandingkan remoteTask.updatedAt vs
      // localTask.updatedAt; yang lebih baru menang (lalu simpan
      // hasilnya ke dao). Tambah conflicts++ setiap kali beda.
      // Catatan: item lokal yang synced harus mengikuti server bila
      // server lebih baru — jangan menimpa pending lokal dengan data lama.
    }

    return SyncResult(pushed: pushed, pulled: pulled, conflicts: conflicts);
  }
}
