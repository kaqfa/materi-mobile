import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/tasks/data/remote/api_config.dart';
import 'features/tasks/presentation/screens/task_list_screen.dart';

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const TaskListScreen(),
    );
  }
}

/// Badge kecil yang menunjukkan sumber data aktif (mock vs live).
/// Dipakai di AppBar `TaskListScreen`.
String activeModeLabel() =>
    ApiConfig.useMock ? AppStrings.modeMock : AppStrings.modeLive;
