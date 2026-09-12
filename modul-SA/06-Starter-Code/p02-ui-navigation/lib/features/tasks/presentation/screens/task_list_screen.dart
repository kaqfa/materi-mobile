import 'package:flutter/material.dart';
import 'package:p02_ui_navigation/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:p02_ui_navigation/features/tasks/presentation/screens/task_detail_screen.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';
import '../widgets/task_card.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = Task.getDummyTasks();
  }

  void _openDetail(Task task) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );
  }

  void _addTask() async {
    final result = await Navigator.of(context).push<Task>(
      MaterialPageRoute(
        builder: (_) => const AddTaskScreen(),
      ),
    );
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _tasks.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.homeTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text(AppStrings.emptyAll))
          : LayoutBuilder(
              builder: (context, constraints) {
                // TODO(student): P02 — sesuaikan breakpoint responsive.
                final wide = constraints.maxWidth >= 600;
                return wide ? _grid() : _list();
              },
            ),
    );
  }

  Widget _list() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => TaskCard(
        task: _tasks[index],
        onTap: () => _openDetail(_tasks[index]),
      ),
    );
  }

  Widget _grid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 132,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _tasks.length,
      itemBuilder: (context, index) => TaskCard(
        task: _tasks[index],
        onTap: () => _openDetail(_tasks[index]),
      ),
    );
  }
}
