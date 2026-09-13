import 'package:flutter/material.dart';

import 'screens/task_api_screen.dart';
import 'services/remote_task_api_client.dart';
import 'services/task_api.dart';

void main() {
  // Konfigurasi lewat dart-define — TIDAK di-commit (keamanan).
  // flutter run --dart-define=API_BASE_URL=... --dart-define=API_KEY=...
  const baseUrl = String.fromEnvironment('API_BASE_URL');
  const apiKey = String.fromEnvironment('API_KEY');

  final TaskApi api = baseUrl.isEmpty || apiKey.isEmpty
      ? MockTaskApi() // fallback kelas: tetap bisa jalan tanpa backend
      : RemoteTaskApiClient(baseUrl: baseUrl, apiKey: apiKey);

  runApp(StudyTrackerApp(api: api));
}

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key, required this.api});

  final TaskApi api;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTracker P09',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
      ),
      home: TaskApiScreen(api: api),
    );
  }
}
