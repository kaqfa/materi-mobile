import 'package:flutter/material.dart';

/// Tampilan pengganti daftar saat hasil filter kosong.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.title = 'Tidak ada pengajuan',
    this.message = 'Tidak ada pengajuan yang cocok dengan filter. '
        'Coba kombinasikan status dan tipe cuti yang lain.',
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_off_rounded,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
