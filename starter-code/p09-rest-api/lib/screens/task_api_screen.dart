import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_api.dart';
import '../services/remote_task_api_client.dart';

class TaskApiScreen extends StatefulWidget {
  const TaskApiScreen({super.key, required this.api});

  final TaskApi api;

  @override
  State<TaskApiScreen> createState() => _TaskApiScreenState();
}

class _TaskApiScreenState extends State<TaskApiScreen> {
  late Future<List<Task>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => _future = widget.api.fetchTasks());

  Future<void> _addTask() async {
    final title = await showDialog<String>(
      context: context,
      builder: (context) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Tugas baru'),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Judul tugas'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            FilledButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
    if (title == null || title.isEmpty) return;
    try {
      await widget.api.createTask(title);
      _load();
    } on ApiException catch (e) {
      if (mounted) _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudyTracker — REST API')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _load(),
        child: FutureBuilder<List<Task>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView( // tetap scrollable agar RefreshIndicator jalan
                children: [
                  const SizedBox(height: 120),
                  Icon(Icons.cloud_off, size: 56, color: Theme.of(context).disabledColor),
                  const SizedBox(height: 8),
                  Center(child: Text('${snapshot.error}')),
                  const SizedBox(height: 8),
                  Center(child: TextButton(onPressed: _load, child: const Text('Coba lagi'))),
                ],
              );
            }
            final tasks = snapshot.data ?? const <Task>[];
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                final task = tasks[i];
                return ListTile(
                  leading: task.completed
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.circle_outlined),
                  title: Text(task.title),
                  subtitle: Text('id: ${task.id}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      try {
                        await widget.api.deleteTask(task.id);
                        _load();
                      } on ApiException catch (e) {
                        _showError(e.toString());
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
