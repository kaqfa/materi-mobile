import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';

/// Stub screen detail. Mahasiswa mengembangkan konten di P02.
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    // TODO(student): P02 — tampilkan detail task (deskripsi penuh, due date,
    // priority, status) dengan layout yang rapi.
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.detailTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(task.description),
            const SizedBox(height: 16),
            // TODO(student): lengkapi baris info due/priority/status.
            _InfoRow(
              label: AppStrings.dueLabel,
              value: '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
            ),
            _InfoRow(
              label: AppStrings.priorityLabel,
              value: task.priority.name.toUpperCase(),
              color: _priorityColor(task.priority),
            ),
            _InfoRow(
              label: AppStrings.statusLabel,
              value: task.status.name.toUpperCase(),
              color: _statusColor(task.status),
            ),
          ],
        ),
      ),
    );
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
        TaskPriority.high => AppColors.priorityHigh,
        TaskPriority.medium => AppColors.priorityMedium,
        TaskPriority.low => AppColors.priorityLow,
      };

  Color _statusColor(TaskStatus s) => switch (s) {
        TaskStatus.pending => AppColors.statusPending,
        TaskStatus.overdue => AppColors.statusOverdue,
        TaskStatus.completed => AppColors.statusCompleted,
      };
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
