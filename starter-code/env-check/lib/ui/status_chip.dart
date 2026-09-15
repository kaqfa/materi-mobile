import 'package:flutter/material.dart';

import '../models/check_result.dart';

/// Bab 6: custom widget kecil yang dipakai berulang.
///
/// Warnanya diambil dari ColorScheme, bukan konstanta Colors.*, supaya
/// tema terang dan gelap sama-sama terbaca, sesuai bab 5.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final CheckStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (label, bg, fg, icon) = switch (status) {
      CheckStatus.pending => (
          'Menunggu',
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
          Icons.schedule,
        ),
      CheckStatus.running => (
          'Berjalan',
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
          Icons.autorenew,
        ),
      CheckStatus.passed => (
          'Lolos',
          scheme.primaryContainer,
          scheme.onPrimaryContainer,
          Icons.check_circle_outline,
        ),
      CheckStatus.failed => (
          'Gagal',
          scheme.errorContainer,
          scheme.onErrorContainer,
          Icons.error_outline,
        ),
      CheckStatus.skipped => (
          'Dilewati',
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
          Icons.remove_circle_outline,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Icon(icon, size: 16, color: fg),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: fg, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
