import 'package:flutter/material.dart';

import 'models/task.dart';
import 'services/task_api_mock.dart';

/// P02 — UI tipis untuk mengamati model Task & async mock di layar.
/// Fokus pertemuan ini ada di `lib/models/task.dart`, bukan di UI.
void main() => runApp(const StudyTrackerApp());

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTracker P02',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _api = TaskApiMock();
  late Future<List<Task>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchTasks();
  }

  void _reload() => setState(() => _future = _api.fetchTasks());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudyTracker — Dart OOP')),
      floatingActionButton: FloatingActionButton(
        onPressed: _reload,
        tooltip: 'Muat ulang (perhatikan error handling)',
        child: const Icon(Icons.refresh),
      ),
      body: FutureBuilder<List<Task>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // Error-First: 1 dari ±5 reload akan masuk cabang ini.
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}'),
                ],
              ),
            );
          }
          final tasks = snapshot.data ?? const <Task>[];
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, i) {
              final task = tasks[i];
              return ListTile(
                leading: Icon(
                  task.completed ? Icons.check_circle : Icons.circle_outlined,
                ),
                title: Text(task.title),
                subtitle: Text('${task.category} • ${task.priority.label}'),
                trailing: Text(task.tags.isEmpty ? '—' : task.tags.first),
              );
            },
          );
        },
      ),
    );
  }
}
