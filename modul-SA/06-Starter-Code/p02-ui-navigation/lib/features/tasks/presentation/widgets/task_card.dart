import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/task.dart';

/// Kartu task reusable. Tidak mengelola state sendiri; semua aksi lewat callback.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted
                    ? AppColors.statusCompleted
                    : AppColors.statusPending,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _DueChip(dueDate: task.dueDate),
                        _PriorityChip(priority: task.priority),
                        _StatusChip(status: task.status),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DueChip extends StatelessWidget {
  const _DueChip({required this.dueDate});
  final DateTime dueDate;

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      labelPadding: EdgeInsets.zero,
      avatar: const Icon(Icons.event, size: 14),
      label: Text(
        '${dueDate.month}/${dueDate.day}/${dueDate.year}',
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});
  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      TaskPriority.high => AppColors.priorityHigh,
      TaskPriority.medium => AppColors.priorityMedium,
      TaskPriority.low => AppColors.priorityLow,
    };
    return Chip(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      labelPadding: EdgeInsets.zero,
      labelStyle: TextStyle(color: color, fontSize: 11),
      label: Text(priority.name.toUpperCase()),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      TaskStatus.pending => AppColors.statusPending,
      TaskStatus.overdue => AppColors.statusOverdue,
      TaskStatus.completed => AppColors.statusCompleted,
    };
    return Chip(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      labelPadding: EdgeInsets.zero,
      labelStyle: TextStyle(color: color, fontSize: 11),
      label: Text(status.name.toUpperCase()),
    );
  }
}
