import 'package:flutter/material.dart';

import '../models/task.dart';

/// Screen detail — menerima [Task] lewat constructor (passing data
/// dengan Navigator.push), dan mengembalikan hasil lewat Navigator.pop.
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategori: ${task.category}'),
            const SizedBox(height: 8),
            Text('Prioritas: ${task.priority.name}'),
            const SizedBox(height: 8),
            Text('Status: ${task.completed ? 'Selesai' : 'Belum'}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.check),
                label: Text(task.completed ? 'Tandai belum selesai' : 'Tandai selesai'),
                // Navigator.pop dengan nilai -> dikembalikan ke `await push(...)`
                onPressed: () => Navigator.of(context).pop(!task.completed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
