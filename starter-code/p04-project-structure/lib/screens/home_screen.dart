import 'package:flutter/material.dart';

import '../app_routes.dart';

/// Screen sementara — kerangka routing yang akan diisi di P05+.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudyTracker — P04')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Struktur project siap. Lanjut ke daftar tugas:'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.taskList),
              child: const Text('Buka Daftar Tugas (named route)'),
            ),
          ],
        ),
      ),
    );
  }
}
