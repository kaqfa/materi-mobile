import 'package:flutter/material.dart';

import '../models/task.dart';

/// Indikator prioritas: dot warna + label singkat.
class PriorityIndicator extends StatelessWidget {
  const PriorityIndicator({super.key, required this.priority});

  final Priority priority;

  Color get _color => switch (priority) {
        Priority.high => const Color(0xFFC62828),
        Priority.medium => const Color(0xFFF9A825),
        Priority.low => const Color(0xFF2E7D32),
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(priority.name),
      ],
    );
  }
}
