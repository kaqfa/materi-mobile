import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

/// StatefulWidget — daftar tugas berubah (toggle selesai) lewat setState.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [...mockTasks];

  void _toggleComplete(String id, bool value) {
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == id);
      if (i != -1) _tasks[i] = _tasks[i].copyWith(completed: value);
    });
  }

  Future<void> _openDetail(Task task) async {
    // push mengembalikan Future<bool?> — nilai dari Navigator.pop di detail.
    final hasil = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
    );
    if (hasil != null) _toggleComplete(task.id, hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudyTracker — Daftar Tugas')),
      // TODO(student) P03-3: ganti Column+ListView tetap menjadi ListView.builder
      // agar aman untuk daftar panjang (gunakan itemCount & itemBuilder).
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Total: ${_tasks.length} tugas'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, i) => TaskCard(
                task: _tasks[i],
                onTap: () => _openDetail(_tasks[i]),
                onToggle: (v) => _toggleComplete(_tasks[i].id, v),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
