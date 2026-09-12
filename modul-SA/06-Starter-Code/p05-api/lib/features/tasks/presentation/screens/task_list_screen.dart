import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';
import '../providers/task_provider.dart';
import 'task_form_screen.dart';

/// Versi P05 dari list screen. Memperlihatkan mode (MOCK/LIVE) di AppBar
/// dan state error jaringan dengan tombol retry manual.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Chip(
                visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                labelPadding: EdgeInsets.zero,
                label: Text(activeModeLabel(), style: const TextStyle(fontSize: 11)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: _body(context, provider),
    );
  }

  Widget _body(BuildContext context, TaskProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return _ErrorView(
        message: provider.error!,
        onRetry: () => context.read<TaskProvider>().loadTasks(),
      );
    }
    if (provider.tasks.isEmpty) {
      return const Center(child: Text(AppStrings.emptyAll));
    }
    return RefreshIndicator(
      onRefresh: () => context.read<TaskProvider>().loadTasks(),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: provider.tasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final task = provider.tasks[index];
          return Dismissible(
            key: ValueKey(task.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              color: Theme.of(context).colorScheme.errorContainer,
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.delete,
                  color: Theme.of(context).colorScheme.onErrorContainer),
            ),
            confirmDismiss: (_) => _confirmDelete(context),
            onDismissed: (_) =>
                context.read<TaskProvider>().deleteTask(task.id),
            child: _TaskTile(
              task: task,
              onTap: () => _openForm(context, task: task),
              onToggle: () =>
                  context.read<TaskProvider>().toggleComplete(task.id),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {Task? task}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TaskFormScreen(task: task),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: const Text(AppStrings.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.actionDelete),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: IconButton(
          icon: Icon(
            task.isCompleted
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: task.isCompleted
                ? const Color(0xFF2E7D32)
                : const Color(0xFFFFA000),
          ),
          onPressed: onToggle,
        ),
        title: Text(
          task.title,
          style: task.isCompleted
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(
          task.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Wrap(
          spacing: 6,
          children: [
            _MiniChip(label: task.priority.name.toUpperCase()),
            _MiniChip(label: task.status.name.toUpperCase()),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      labelPadding: EdgeInsets.zero,
      labelStyle: TextStyle(color: theme.colorScheme.primary, fontSize: 11),
      label: Text(label),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.actionRetry),
            ),
          ],
        ),
      ),
    );
  }
}
