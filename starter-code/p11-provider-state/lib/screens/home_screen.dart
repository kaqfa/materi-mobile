import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer: rebuild saat TaskProvider berubah (notifyListeners).
    return Consumer<TaskProvider>(
      builder: (context, tasks, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('StudyTracker — Provider'),
            actions: [
              // Selector: hanya rebuild bila canUndo berubah,
              // bukan setiap perubahan daftar tugas.
              Selector<TaskProvider, bool>(
                selector: (_, p) => p.canUndo,
                builder: (context, canUndo, _) => IconButton(
                  tooltip: 'Undo',
                  onPressed: canUndo ? () => context.read<TaskProvider>().undo() : null,
                  icon: const Icon(Icons.undo),
                ),
              ),
              IconButton(
                tooltip: 'Keluar',
                icon: const Icon(Icons.logout),
                onPressed: () => context.read<AuthProvider>().signOut(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => tasks.addTask('Tugas baru ${tasks.tasks.length + 1}'),
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Cari tugas',
                    border: OutlineInputBorder(),
                  ),
                  // context.read = aksi TANPA listen (tidak rebuild).
                  onChanged: (v) => context.read<TaskProvider>().setQuery(v),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('${tasks.doneCount} dari ${tasks.tasks.length} selesai'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.tasks.length,
                  itemBuilder: (context, i) {
                    final task = tasks.tasks[i];
                    return ListTile(
                      leading: Icon(
                        task.completed ? Icons.check_circle : Icons.circle_outlined,
                        color: task.completed ? Colors.green : null,
                      ),
                      title: Text(task.title),
                      subtitle: Text(task.category),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => context.read<TaskProvider>().deleteTask(task.id),
                      ),
                      onTap: () => context.read<TaskProvider>().toggleComplete(task.id),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
