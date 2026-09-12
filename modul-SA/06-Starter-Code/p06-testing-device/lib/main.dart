import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/tasks/presentation/providers/task_provider.dart';

/// P06 starter: default tanpa AttachmentService (attachPhoto no-op TODO).
/// Mahasiswa menyuntik ImagePickerAttachmentService di CP2/CP3.
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider()..loadTasks(),
      child: const TaskTrackerApp(),
    ),
  );
}
