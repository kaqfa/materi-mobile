import 'package:flutter/material.dart';

import '../models/leave_request.dart';
import 'leave_visuals.dart';

/// Chip status pengajuan cuti; ikon & warna membedakan status.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final LeaveStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: status.foreground),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: status.foreground,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
