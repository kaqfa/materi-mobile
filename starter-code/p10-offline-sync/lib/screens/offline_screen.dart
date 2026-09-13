import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/local/task_dao.dart';
import '../services/remote/remote_task_api.dart';
import '../services/sync/sync_service.dart';

/// UI offline-first: baca-tulis SQLite lokal; tombol sync menjembatani
/// ke server. Perhatikan: semua operasi offline TIDAK menunggu jaringan.
class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  late final TaskDao _dao;
  late final SyncService _sync;
  final _remote = MemoryRemoteApi(seed: [
    Task(
      id: 'srv-1',
      title: 'Dibuat di server (orang lain)',
      updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ]);

  List<Task> _tasks = [];
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _dao = TaskDao();
    _sync = SyncService(dao: _dao, remote: _remote);
    _reload();
  }

  Future<void> _reload() async {
    final tasks = await _dao.getAll();
    setState(() => _tasks = tasks);
  }

  Future<void> _addTask() async {
    final task = Task(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Tugas offline #${_tasks.length + 1}',
      updatedAt: DateTime.now(),
      syncState: SyncState.pending, // <- lahir dalam keadaan pending
    );
    await _dao.upsert(task);
    _reload();
  }

  Future<void> _toggle(Task task) async {
    await _dao.upsert(
      task.copyWith(completed: !task.completed, updatedAt: DateTime.now(), syncState: SyncState.pending),
    );
    _reload();
  }

  Future<void> _syncNow() async {
    setState(() => _syncing = true);
    try {
      final result = await _sync.syncNow();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sinkronisasi selesai — $result')),
        );
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudyTracker — Offline-First')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: _syncing ? null : _syncNow,
            icon: _syncing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            label: const Text('Sinkronkan sekarang'),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, i) {
          final t = _tasks[i];
          return ListTile(
            leading: IconButton(
              icon: Icon(
                t.completed ? Icons.check_circle : Icons.circle_outlined,
                color: t.completed ? Colors.green : null,
              ),
              onPressed: () => _toggle(t),
            ),
            title: Text(t.title),
            subtitle: Text(
              '${t.syncState == SyncState.pending ? "⏳ pending" : "✓ synced"} • ${t.updatedAt.hour}:${t.updatedAt.minute.toString().padLeft(2, '0')}',
            ),
          );
        },
      ),
    );
  }
}
