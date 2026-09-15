import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/environment_report.dart';
import 'check_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Jalankan sekali setelah frame pertama: pengguna tidak perlu menekan
    // apa pun untuk tahu lingkungannya sehat.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnvironmentReport>().runAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final report = context.watch<EnvironmentReport>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Env Check'),
        actions: [
          IconButton(
            key: const Key('copy-report'),
            tooltip: 'Salin laporan JSON',
            onPressed: report.running
                ? null
                : () async {
                    await Clipboard.setData(
                      ClipboardData(text: report.toPrettyJson()),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Laporan disalin')),
                    );
                  },
            icon: const Icon(Icons.copy_all_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          _Summary(report: report),
          Expanded(
            child: ListView.builder(
              key: const Key('check-list'),
              itemCount: report.results.length,
              itemBuilder: (context, index) =>
                  CheckTile(result: report.results[index]),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Probe kamera dan lokasi hanya memeriksa bahwa plugin hidup; '
                'keduanya tidak meminta izin agar pemeriksaan tidak menggantung.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('run-all'),
        onPressed: report.running ? null : report.runAll,
        icon: report.running
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.play_arrow),
        label: Text(report.running ? 'Menjalankan' : 'Jalankan ulang'),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.report});

  final EnvironmentReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final (message, color) = switch ((report.allDone, report.failed)) {
      (false, _) => ('Memeriksa lingkungan...', scheme.surfaceContainerHighest),
      (true, 0) => ('Lingkungan siap dipakai sampai bab 14', scheme.primaryContainer),
      (true, _) => ('${report.failed} pemeriksaan gagal', scheme.errorContainer),
    };

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            message,
            key: const Key('summary-message'),
            style: theme.textTheme.titleMedium,
          ),
          Text(
            '${report.passed} lolos · ${report.failed} gagal · '
            '${report.skipped} dilewati',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
