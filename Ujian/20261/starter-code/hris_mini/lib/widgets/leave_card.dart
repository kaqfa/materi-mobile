import 'package:flutter/material.dart';

import '../models/leave_request.dart';
import '../utils/date_format.dart';
import 'employee_avatar.dart';
import 'leave_visuals.dart';
import 'status_chip.dart';

/// Kartu pengajuan cuti: karyawan, tipe, rentang tanggal, durasi, dan status.
class LeaveCard extends StatelessWidget {
  const LeaveCard({super.key, required this.request, this.onTap});

  final LeaveRequest request;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.colorScheme.onSurfaceVariant;
    final days = leaveDurationInDays(request.startDate, request.endDate);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  EmployeeAvatar(request: request),
                  const SizedBox(width: 12),
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
                        Row(
                          children: [
                            Icon(request.type.icon,
                                size: 14, color: request.type.color),
                            const SizedBox(width: 4),
                            Text(
                              request.type.label,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: mutedColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  StatusChip(status: request.status),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.event_rounded, size: 16, color: mutedColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${formatShortDate(request.startDate)} – ${formatDate(request.endDate)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '$days hari',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
