import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';

/// Stub screen tambah task. Mahasiswa mengembangkan form di P02/P03.
/// Saat ini langsung mengembalikan task contoh saat tombol save ditekan
/// agar alur navigasi bisa diuji; ganti dengan input form sungguhan.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addTaskTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO(student): P02 — ganti placeholder ini dengan form
            // (title, description, due date, priority) + validasi.
            const Text(
              'Form tambah task belum diimplementasikan. '
              'Lengkapi di P02/P03.',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_sampleTask()),
              child: const Text('Save (sample)'),
            ),
          ],
        ),
      ),
    );
  }

  Task _sampleTask() {
    return Task(
      id: 'new-${DateTime.now().millisecondsSinceEpoch}',
      title: 'New Task',
      description: 'Created from AddTaskScreen stub.',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.medium,
    );
  }
}
