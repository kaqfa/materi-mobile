import 'package:flutter/material.dart';

import '../models/leave_request.dart';

/// Chip status pengajuan cuti; warna membedakan status.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final LeaveStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (status) {
      LeaveStatus.pending => (
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
        ),
      LeaveStatus.approved => (
          scheme.primaryContainer,
          scheme.onPrimaryContainer,
        ),
      LeaveStatus.rejected => (scheme.errorContainer, scheme.onErrorContainer),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
