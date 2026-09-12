import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/tasks/data/remote/api_config.dart';
import 'features/tasks/data/remote/http_task_api_client.dart';
import 'features/tasks/data/remote/mock_task_api_client.dart';
import 'features/tasks/data/remote/remote_task_datasource.dart';
import 'features/tasks/data/remote/task_api_client.dart';
import 'features/tasks/data/repositories/task_repository.dart';
import 'features/tasks/presentation/providers/task_provider.dart';

void main() {
  // Pilih klien: bila API_BASE_URL kosong -> Mock (fixture offline).
  // Otherwise -> HttpTaskApiClient memakai --dart-define.
  final TaskApiClient client = ApiConfig.useMock
      ? MockTaskApiClient()
      : HttpTaskApiClient(baseUrl: ApiConfig.baseUrl, token: ApiConfig.apiToken);

  final repository = RemoteTaskRepository(RemoteTaskDatasource(client));

  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(repository)..loadTasks(),
      child: const TaskTrackerApp(),
    ),
  );
}
