import 'package:flutter/material.dart';

import '../models/check_result.dart';
import 'status_chip.dart';

/// Bab 5-6: satu baris hasil pemeriksaan sebagai widget mandiri.
class CheckTile extends StatelessWidget {
  const CheckTile({super.key, required this.result});

  final CheckResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ms = result.duration?.inMilliseconds;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: Text(
                    result.label,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                StatusChip(status: result.status),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Text(
                  'Bab ${result.chapter}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (ms != null)
                  Text(
                    '· ${ms}ms',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            if (result.detail.isNotEmpty)
              Text(
                result.detail,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: result.status == CheckStatus.failed
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
