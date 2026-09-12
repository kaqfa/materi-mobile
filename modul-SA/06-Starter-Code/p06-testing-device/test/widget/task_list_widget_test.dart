import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p06_testing_device/core/constants/app_strings.dart';
import 'package:p06_testing_device/features/tasks/domain/task.dart';
import 'package:p06_testing_device/features/tasks/presentation/providers/task_provider.dart';
import 'package:p06_testing_device/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:provider/provider.dart';

/// Widget test target #2 (empty/error/list states). Hijau sejak starter.
Widget _harness({required TaskProvider provider}) {
  return MaterialApp(
    home: ChangeNotifierProvider<TaskProvider>.value(
      value: provider,
      child: const TaskListScreen(),
    ),
  );
}

void main() {
  testWidgets('daftar kosong -> empty state', (tester) async {
    final provider = TaskProvider();
    await tester.pumpWidget(_harness(provider: provider));
    await tester.pump();
    expect(find.text(AppStrings.emptyAll), findsOneWidget);
  });

  testWidgets('state error -> tampilkan Retry', (tester) async {
    final provider = TaskProvider();
    provider.seedError('Network down.');
    await tester.pumpWidget(_harness(provider: provider));
    await tester.pump();
    expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    expect(find.text('Network down.'), findsOneWidget);
    expect(find.text(AppStrings.actionRetry), findsOneWidget);
  });

  testWidgets('daftar terisi -> tampilkan ListTile per task', (tester) async {
    final provider = TaskProvider();
    provider.seedTasks([
      Task(
        id: 'w1',
        title: 'Widget Task One',
        description: '',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      ),
      Task(
        id: 'w2',
        title: 'Widget Task Two',
        description: '',
        dueDate: DateTime.now().add(const Duration(days: 2)),
      ),
    ]);
    await tester.pumpWidget(_harness(provider: provider));
    await tester.pump();
    expect(find.text('Widget Task One'), findsOneWidget);
    expect(find.text('Widget Task Two'), findsOneWidget);
  });
}
