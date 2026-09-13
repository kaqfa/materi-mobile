import 'package:flutter/material.dart';

import '../models/task.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [const Task(title: 'Setup tema konsisten', category: 'Proyek')];

  Future<void> _openForm() async {
    final task = await Navigator.of(context).push<Task>(
      MaterialPageRoute(builder: (_) => const TaskFormScreen()),
    );
    if (task == null) return;
    setState(() => _tasks.add(task)); // push bisa return non-const list ops
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyTracker'),
        actions: [
          IconButton(
            // TODO(student) P05-4: buka filter bottom sheet (chips kategori).
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('Tugas baru'),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('Belum ada tugas — tekan tombol Tugas baru'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final t = _tasks[i];
                return Card(
                  child: ListTile(
                    title: Text(t.title),
                    subtitle: Text(
                      '${t.category} • ${t.priority.name}'
                      '${t.dueDate != null ? ' • ${t.dueDate!.day}/${t.dueDate!.month}' : ''}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
