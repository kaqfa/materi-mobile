import 'package:flutter/material.dart';

import '../models/task.dart';

/// Tile satu tugas — dipakai di mode list DAN grid.
class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    task.completed ? Icons.check_circle : Icons.circle_outlined,
                    size: 20,
                    color: task.completed ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(  // Expanded: judul boleh memanjang, chip tidak
                    child: Text(
                      task.title,
                      style: textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(), // di dalam Card dengan tinggi tetap
              Text(task.category, style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
