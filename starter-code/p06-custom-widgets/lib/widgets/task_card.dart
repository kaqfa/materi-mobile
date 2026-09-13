import 'package:flutter/material.dart';

import '../models/task.dart';
import 'category_chip.dart';
import 'priority_indicator.dart';

/// Kartu tugas dengan aksi built-in (toggle, hapus) + detail expandable.
///
/// Prinsip komposisi: widget kecil (PriorityIndicator, CategoryChip)
/// dirangkai jadi widget lebih besar; semua interaksi mengalir keluar
/// lewat callback — kartu tidak mengubah datanya sendiri.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final Task task;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: ExpansionTile(
          // TODO(student) P06-2: bungkus title dengan AnimatedOpacity
          // (opacity: task.completed ? 0.45 : 1, duration 300ms)
          // agar tugas selesai memudar halus.
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.completed ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                PriorityIndicator(priority: task.priority),
                const SizedBox(width: 12),
                CategoryChip(label: task.category),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: task.completed ? 'Buka lagi' : 'Tandai selesai',
                onPressed: () => onToggle(!task.completed),
                icon: Icon(
                  task.completed ? Icons.undo : Icons.check,
                  color: task.completed ? Colors.grey : Colors.green,
                ),
              ),
              IconButton(
                tooltip: 'Hapus',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 12),
                child: Text(task.details.isEmpty ? '— tanpa detail —' : task.details),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
