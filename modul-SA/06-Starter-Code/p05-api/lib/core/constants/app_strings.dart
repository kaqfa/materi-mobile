/// String konstan aplikasi.
class AppStrings {
  const AppStrings._();

  static const String appTitle = 'Remedial Task Tracker';
  static const String homeTitle = 'My Tasks';
  static const String addTaskTitle = 'Add Task';
  static const String editTaskTitle = 'Edit Task';

  static const String fieldTitle = 'Title';
  static const String fieldTitleHint = 'e.g. Complete Math Assignment';
  static const String fieldDescription = 'Description';
  static const String fieldPriority = 'Priority';
  static const String fieldDueDate = 'Due date';
  static const String actionSave = 'Save';
  static const String actionDelete = 'Delete';
  static const String actionRetry = 'Retry';

  static const String emptyAll = 'No tasks yet. Tap + to add one.';
  static const String loading = 'Loading tasks...';
  static const String deleteConfirm = 'Delete this task?';

  static const String modeMock = 'MOCK API';
  static const String modeLive = 'LIVE API';
  static const String networkOffline =
      'Tidak ada koneksi. Bekerja lokal / fallback mock.';

  static const String errTitleRequired = 'Title is required.';
  static const String errTitleTooShort = 'Title must be at least 3 characters.';
}
