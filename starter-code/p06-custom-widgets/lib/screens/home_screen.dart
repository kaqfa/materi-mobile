import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/progress_summary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [...mockTasks];

  void _toggle(String id, bool value) => setState(() {
        final i = _tasks.indexWhere((t) => t.id == id);
        if (i != -1) _tasks[i] = _tasks[i].copyWith(completed: value);
      });

  // Hapus dengan konfirmasi — pola dialog async lewat Future<bool>.
  Future<void> _confirmDelete(Task task) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus tugas?'),
        content: Text('"${task.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true) setState(() => _tasks.removeWhere((t) => t.id == task.id));
  }

  @override
  Widget build(BuildContext context) {
    final done = _tasks.where((t) => t.completed).length;
    return Scaffold(
      appBar: AppBar(title: const Text('StudyTracker — Custom Widgets')),
      body: Column(
        children: [
          ProgressSummary(done: done, total: _tasks.length),
          Expanded(
            // TODO(student) P06-1: bungkus tiap TaskCard dengan Dismissible
            // (background merah + panah) yang memanggil _confirmDelete.
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, i) => TaskCard(
                task: _tasks[i],
                onToggle: (v) => _toggle(_tasks[i].id, v),
                onDelete: () => _confirmDelete(_tasks[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
