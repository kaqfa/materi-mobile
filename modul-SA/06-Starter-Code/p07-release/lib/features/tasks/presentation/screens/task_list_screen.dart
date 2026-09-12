import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/task.dart';

/// Layar daftar sederhana dengan subtree sebanyak mungkin `const`
/// (demo const/rebuild basics P07). StatelessWidget murni -> tidak
/// menyimpan state -> rebuild hanya bila parent/memberikan list baru.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks yet.'));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, i) {
        final task = tasks[i];
        return _TaskTile(task: task);
      },
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: _color(task.status),
      ),
      title: Text(
        task.title,
        style: task.isCompleted
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
    );
  }

  Color _color(TaskStatus s) => switch (s) {
        TaskStatus.pending => AppColors.statusPending,
        TaskStatus.overdue => AppColors.statusOverdue,
        TaskStatus.completed => AppColors.statusCompleted,
      };
}
