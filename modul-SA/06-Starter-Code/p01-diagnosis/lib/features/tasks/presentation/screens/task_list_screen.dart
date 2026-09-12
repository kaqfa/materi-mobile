import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';
import '../../domain/task_filter.dart';

/// Pilihan filter di UI. [all] memetakan ke `null` di [TaskFilterService].
enum StatusFilter { all, pending, overdue, completed }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late final List<Task> _tasks;
  late final TextEditingController _searchController;

  StatusFilter _statusFilter = StatusFilter.all;
  String _searchQuery = '';

  final TaskFilterService _filter = const TaskFilterService();

  @override
  void initState() {
    super.initState();
    _tasks = Task.getDummyTasks();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  TaskStatus? _resolveStatus(StatusFilter f) {
    switch (f) {
      case StatusFilter.all:
        return null;
      case StatusFilter.pending:
        return TaskStatus.pending;
      case StatusFilter.overdue:
        return TaskStatus.overdue;
      case StatusFilter.completed:
        return TaskStatus.completed;
    }
  }

  Color _statusColor(StatusFilter f) {
    switch (f) {
      case StatusFilter.all:
        return AppColors.primary;
      case StatusFilter.pending:
        return AppColors.statusPending;
      case StatusFilter.overdue:
        return AppColors.statusOverdue;
      case StatusFilter.completed:
        return AppColors.statusCompleted;
    }
  }

  String _statusLabel(StatusFilter f) {
    switch (f) {
      case StatusFilter.all:
        return AppStrings.filterAll;
      case StatusFilter.pending:
        return AppStrings.filterPending;
      case StatusFilter.overdue:
        return AppStrings.filterOverdue;
      case StatusFilter.completed:
        return AppStrings.filterCompleted;
    }
  }

  List<Task> get _visible {
    // Urutan: filter status dulu, lalu search. Keduanya memakai layanan yang
    // (sengaja) rusak — lihat task_filter.dart.
    var result = _filter.filterByStatus(_tasks, _resolveStatus(_statusFilter));
    result = _filter.searchByTitle(result, _searchQuery);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.homeTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: StatusFilter.values
                  .map((f) => _buildFilterChip(f))
                  .toList(),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(child: _buildBody(visible)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(StatusFilter f) {
    final selected = _statusFilter == f;
    final color = _statusColor(f);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(_statusLabel(f)),
        selected: selected,
        selectedColor: color.withOpacity(0.25),
        checkmarkColor: color,
        onSelected: (_) => setState(() => _statusFilter = f),
      ),
    );
  }

  Widget _buildBody(List<Task> visible) {
    if (visible.isEmpty) {
      return _buildEmpty();
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
      itemCount: visible.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _TaskRow(task: visible[index]),
    );
  }

  Widget _buildEmpty() {
    final String message;
    if (_searchQuery.trim().isNotEmpty) {
      message = AppStrings.emptySearch.replaceAll('{query}', _searchQuery.trim());
    } else if (_statusFilter != StatusFilter.all) {
      message = AppStrings.emptyFiltered.replaceAll(
        '{status}',
        _statusLabel(_statusFilter),
      );
    } else {
      message = AppStrings.emptyAll;
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted
              ? AppColors.statusCompleted
              : AppColors.statusPending,
        ),
        title: Text(
          task.title,
          style: task.isCompleted
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(task.description),
        trailing: Wrap(
          spacing: 6,
          children: [
            _PriorityBadge(priority: task.priority),
            _StatusBadge(status: task.status),
          ],
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});
  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      TaskPriority.high => AppColors.priorityHigh,
      TaskPriority.medium => AppColors.priorityMedium,
      TaskPriority.low => AppColors.priorityLow,
    };
    return Chip(
      labelPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      labelStyle: TextStyle(color: color, fontSize: 11),
      label: Text(priority.name.toUpperCase()),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      TaskStatus.pending => AppColors.statusPending,
      TaskStatus.overdue => AppColors.statusOverdue,
      TaskStatus.completed => AppColors.statusCompleted,
    };
    return Chip(
      labelPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      labelStyle: TextStyle(color: color, fontSize: 11),
      label: Text(status.name.toUpperCase()),
    );
  }
}
