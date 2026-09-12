import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:p05_api/app.dart';
import 'package:p05_api/features/tasks/data/remote/mock_task_api_client.dart';
import 'package:p05_api/features/tasks/data/remote/remote_task_datasource.dart';
import 'package:p05_api/features/tasks/data/repositories/task_repository.dart';
import 'package:p05_api/features/tasks/presentation/providers/task_provider.dart';

/// Smoke test: default (useMock true) => fixture tampil tanpa server.
/// Membuktikan acceptance "P05 punya mock/fixture fallback".
void main() {
  testWidgets('app mounts, loading lalu list fixture tampil (mode mock)',
      (tester) async {
    final repo = RemoteTaskRepository(
      RemoteTaskDatasource(MockTaskApiClient()),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TaskProvider(repo)..loadTasks(),
        child: const TaskTrackerApp(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('My Tasks'), findsOneWidget);
    expect(find.text('MOCK API'), findsOneWidget);
    // Salah satu judul fixture tampil (GET via mock).
    expect(find.text('Fixture: Math Assignment'), findsOneWidget);
  });
}
