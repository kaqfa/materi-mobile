import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/check_result.dart';
import '../providers/env_check_provider.dart';

/// Satu-satunya screen: daftar smoke test + tombol Run all.
class EnvCheckScreen extends StatelessWidget {
  const EnvCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EnvCheckProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FilledButton.icon(
              onPressed: provider.running
                  ? null
                  : () => context.read<EnvCheckProvider>().runAll(),
              icon: provider.running
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: const Text(AppStrings.runAll),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryBar(provider: provider),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: provider.items.length,
              itemBuilder: (context, index) {
                final item = provider.items[index];
                return _CheckTile(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.provider});

  final EnvCheckProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final done = provider.items.where((i) => i.status == CheckStatus.done).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.subtitle,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              _Chip('Done $done/${provider.items.length}', AppColors.pending),
              _Chip('OK ${provider.okCount}', AppColors.ok),
              _Chip('FAIL ${provider.failCount}', AppColors.fail),
              _Chip('SKIP ${provider.skipCount}', AppColors.skip),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: CircleAvatar(backgroundColor: color, radius: 6),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _CheckTile extends StatelessWidget {
  const _CheckTile({required this.item});
  final CheckItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: _StatusIcon(status: item.status, result: item.result),
      title: Text(item.definition.title, style: theme.textTheme.titleSmall),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.definition.description),
          if (item.result != null) _ResultLine(result: item.result!),
        ],
      ),
      isThreeLine: true,
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({required this.result});
  final CheckResult result;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (result) {
      CheckOk() => ('OK', AppColors.ok),
      CheckFail() => ('GAGAL', AppColors.fail),
      CheckSkip() => ('SKIP', AppColors.skip),
    };
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            TextSpan(text: result.message),
          ],
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status, required this.result});
  final CheckStatus status;
  final CheckResult? result;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      CheckStatus.pending => const Icon(Icons.hourglass_empty,
          color: AppColors.pending),
      CheckStatus.running => const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      CheckStatus.done => Icon(
          switch (result) {
            CheckOk() => Icons.check_circle,
            CheckFail() => Icons.error,
            CheckSkip() => Icons.skip_next,
            null => Icons.help_outline,
          },
          color: switch (result) {
            CheckOk() => AppColors.ok,
            CheckFail() => AppColors.fail,
            CheckSkip() => AppColors.skip,
            null => AppColors.pending,
          },
        ),
    };
  }
}
