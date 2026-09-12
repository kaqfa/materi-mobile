import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/tasks/data/local/local_task_datasource.dart';
import 'features/tasks/data/local/task_database.dart';
import 'features/tasks/data/repositories/task_repository.dart';
import 'features/tasks/presentation/providers/task_provider.dart';

void main() {
  // Wiring arsitektur: TaskDatabase -> LocalTaskDatasource -> LocalTaskRepository
  // -> TaskProvider. Mahasiswa tidak perlu mengubah main.dart ini.
  final database = TaskDatabase();
  final datasource = LocalTaskDatasource(database);
  final repository = LocalTaskRepository(datasource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(repository)..loadTasks(),
      child: const TaskTrackerApp(),
    ),
  );
}
