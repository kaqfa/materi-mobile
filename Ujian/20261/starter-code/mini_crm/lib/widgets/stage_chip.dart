import 'package:flutter/material.dart';

import '../models/lead.dart';

/// Chip tahapan pipeline; warna membedakan tiap tahap.
class StageChip extends StatelessWidget {
  const StageChip({super.key, required this.stage});

  final LeadStage stage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (stage) {
      LeadStage.newLead => (
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
        ),
      LeadStage.contacted => (
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
        ),
      LeadStage.qualified => (
          scheme.tertiaryContainer,
          scheme.onTertiaryContainer,
        ),
      LeadStage.closed => (scheme.primaryContainer, scheme.onPrimaryContainer),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        stage.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
