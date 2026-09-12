/// String konstan aplikasi. Hindari hardcode teks UI di widget.
class AppStrings {
  const AppStrings._();

  static const String appTitle = 'Remedial Task Tracker';

  static const String homeTitle = 'My Tasks';
  static const String searchHint = 'Search tasks...';

  static const String filterAll = 'All';
  static const String filterPending = 'Pending';
  static const String filterOverdue = 'Overdue';
  static const String filterCompleted = 'Completed';

  static const String emptyAll = 'No tasks yet. Add one to get started.';
  static const String emptyFiltered = 'No tasks with status "{status}".';
  static const String emptySearch = 'No tasks match "{query}". Try another keyword.';

  static const String dueLabel = 'Due';
}
