import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:p04_sqlite/app.dart';
import 'package:p04_sqlite/features/tasks/data/local/local_task_datasource.dart';
import 'package:p04_sqlite/features/tasks/data/local/task_database.dart';
import 'package:p04_sqlite/features/tasks/data/repositories/task_repository.dart';
import 'package:p04_sqlite/features/tasks/presentation/providers/task_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Smoke test: app ter-mount, menampilkan loading lalu empty state (karena
/// datasource CRUD masih TODO sehingga tabel kosong pada first run).
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('app mounts, loading lalu empty state', (tester) async {
    final db = TaskDatabase(fileName: 'tasks_widget_test.db');
    final repo =
        LocalTaskRepository(LocalTaskDatasource(db));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TaskProvider(repo)..loadTasks(),
        child: const TaskTrackerApp(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('My Tasks'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    // datasource TODO => getAll() mengembalikan [] => empty state.
    expect(find.text('No tasks yet. Tap + to add one.'), findsOneWidget);
  });
}
