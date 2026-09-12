import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p02_ui_navigation/features/tasks/domain/task.dart';
import 'package:p02_ui_navigation/features/tasks/presentation/widgets/task_card.dart';

void main() {
  testWidgets('TaskCard menampilkan title dan callback onTap', (tester) async {
    var tapped = 0;
    final task = Task(
      id: 'x',
      title: 'Read Flutter Docs',
      description: 'Layouts chapter.',
      dueDate: DateTime(2026, 8, 10),
      priority: TaskPriority.high,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(task: task, onTap: () => tapped++),
        ),
      ),
    );

    expect(find.text('Read Flutter Docs'), findsOneWidget);
    expect(find.text('HIGH'), findsOneWidget);

    await tester.tap(find.byType(TaskCard));
    expect(tapped, 1);
  });

  testWidgets('TaskCard completed → title strikethrough', (tester) async {
    final task = Task(
      id: 'y',
      title: 'Done Task',
      description: 'd',
      dueDate: DateTime(2026, 8, 1),
      isCompleted: true,
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TaskCard(task: task))),
    );

    final title = tester.widget<Text>(find.text('Done Task'));
    expect(title.style?.decoration, TextDecoration.lineThrough);
  });
}
