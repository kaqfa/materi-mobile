import 'package:flutter/material.dart';

import '../models/task.dart';

/// Custom widget reusable: kartu satu tugas.
/// StatelessWidget — tidak punya state sendiri; perubahan visual
/// datang lewat properti [task] dan callback [onToggle].
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  final Task task;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        // TODO(student) P03-2: ganti ikon leading jadi IconButton yang
        // memanggil onToggle(!task.completed).
        leading: Icon(
          task.completed ? Icons.check_circle : Icons.circle_outlined,
          color: task.completed ? Colors.green : Colors.grey,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.category),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
