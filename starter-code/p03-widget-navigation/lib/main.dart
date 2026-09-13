import 'package:flutter/material.dart';

import 'screens/task_list_screen.dart';

void main() => runApp(const StudyTrackerApp());

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(student) P03-1: tambahkan `theme:` dengan ThemeData(colorScheme:
    // ColorScheme.fromSeed(seedColor: Colors.teal)) lalu rasakan perubahan.
    return MaterialApp(
      title: 'StudyTracker P03',
      debugShowCheckedModeBanner: false,
      home: const TaskListScreen(),
    );
  }
}
