import 'package:flutter/material.dart';

import '../models/leave_request.dart';
import 'status_chip.dart';

/// Kartu pengajuan cuti: karyawan, tipe, rentang tanggal, dan status.
class LeaveCard extends StatelessWidget {
  const LeaveCard({super.key, required this.request});

  final LeaveRequest request;

  String _format(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.employee,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${request.type.label} · ${_format(request.startDate)} – ${_format(request.endDate)}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            StatusChip(status: request.status),
          ],
        ),
      ),
    );
  }
}
