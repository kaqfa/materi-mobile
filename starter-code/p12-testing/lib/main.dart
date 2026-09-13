import 'package:flutter/material.dart';

import 'models/task.dart';
import 'services/task_filter.dart';
import 'widgets/task_card.dart';

void main() => runApp(const StudyTrackerApp());

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTracker P12',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const tasks = [
    Task(id: 't1', title: 'Tulis test dulu', priority: Priority.high),
    Task(id: 't2', title: 'Perbaiki sampai hijau', priority: Priority.medium),
    Task(id: 't3', title: 'Refactor', completed: true),
  ];

  @override
  Widget build(BuildContext context) {
    final open = TaskFilter.apply(tasks, status: StatusFilter.open);
    return Scaffold(
      appBar: AppBar(title: Text('StudyTracker — Testing (${open.length} terbuka)')),
      body: ListView(
        children: [
          for (final t in tasks)
            TaskCard(task: t, onToggle: () {}),
        ],
      ),
    );
  }
}
