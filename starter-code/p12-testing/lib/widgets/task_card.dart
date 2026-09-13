import 'package:flutter/material.dart';

import '../models/task.dart';

/// Target widget test: render + interaksi.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onToggle});

  final Task task;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey('card-${task.id}'),
      child: ListTile(
        leading: IconButton(
          key: Key('toggle-${task.id}'),
          icon: Icon(
            task.completed ? Icons.check_circle : Icons.circle_outlined,
            color: task.completed ? Colors.green : Colors.grey,
          ),
          onPressed: onToggle,
        ),
        title: Text(task.title),
      ),
    );
  }
}
