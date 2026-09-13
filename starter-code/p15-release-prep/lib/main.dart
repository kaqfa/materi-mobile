import 'package:flutter/material.dart';

import 'utils/app_logger.dart';

void main() {
  // Menangkap error yang TIDAK dilempar di dalam build framework.
  WidgetsFlutterBinding.ensureInitialized();

  // Error framework (build/layout) mengalir ke sini.
  FlutterError.onError = (details) {
    AppLogger.error(details.exception, details.stack ?? StackTrace.empty);
  };

  runApp(const StudyTrackerApp());
}

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTracker P15',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudyTracker — Release Prep')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Cek log di flutter run — lalu bayangkan di produksi.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => AppLogger.debug('Tombol ditekan ${DateTime.now()}'),
              child: const Text('Tulis log debug'),
            ),
            // TODO(student) P15-1: tambahkan tombol yang melempar Exception
            // lalu amati jalurnya lewat FlutterError.onError + AppLogger.
          ],
        ),
      ),
    );
  }
}
