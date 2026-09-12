import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../attachments/attachment_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';
import '../providers/task_provider.dart';

/// Layar daftar tugas. Membaca [TaskProvider]. Memperlihatkan tiga state:
/// loading, error (dengan retry), empty, dan list hasil filter.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.homeTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/add'),
        child: const Icon(Icons.add),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const _CenteredMessage(text: AppStrings.loading);
          }
          if (provider.error != null) {
            return _ErrorView(
              message: provider.error!,
              onRetry: provider.loadTasks,
            );
          }
          final tasks = provider.filteredTasks;
          if (tasks.isEmpty) {
            return const _CenteredMessage(text: AppStrings.emptyAll);
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, i) => _TaskTile(task: tasks[i]),
          );
        },
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: _statusColor(task.status),
      ),
      title: Text(
        task.title,
        style: task.isCompleted
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: task.attachmentPath == null
          ? null
          : const Row(
              children: [
                Icon(Icons.attach_file, size: 14),
                SizedBox(width: 4),
                Text('has attachment'),
              ],
            ),
    );
  }

  Color _statusColor(TaskStatus s) => switch (s) {
        TaskStatus.pending => AppColors.statusPending,
        TaskStatus.overdue => AppColors.statusOverdue,
        TaskStatus.completed => AppColors.statusCompleted,
      };
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text, textAlign: TextAlign.center),
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 48),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(message, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: const Text(AppStrings.actionRetry),
          ),
        ],
      ),
    );
  }
}

/// Banner kecil untuk menampilkan hasil attachment terakhir (debug/demo).
/// Dipakai di demo CP2 untuk membuktikan fallback device/permission.
class AttachmentStatusBanner extends StatelessWidget {
  const AttachmentStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final result = provider.lastAttachment;
    if (result == null && provider.attachmentError == null) {
      return const SizedBox.shrink();
    }
    final text = switch (result) {
      AttachmentSuccess(:final path) => 'Attached: $path',
      AttachmentUnavailable(:final reason) =>
        '${AppStrings.attachDeviceUnavailable} ($reason)',
      AttachmentDenied(:final reason) =>
        '${AppStrings.attachPermissionDenied} ($reason)',
      null => provider.attachmentError ?? AppStrings.attachNone,
    };
    return Material(
      color: AppColors.surfaceMuted,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
