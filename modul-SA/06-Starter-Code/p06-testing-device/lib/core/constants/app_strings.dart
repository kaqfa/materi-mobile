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
  static const String attachment = 'Attachment';
  static const String actionSave = 'Save';
  static const String actionDelete = 'Delete';
  static const String actionRetry = 'Retry';
  static const String actionPickPhoto = 'Pick photo';
  static const String actionClearPhoto = 'Clear';

  static const String emptyAll = 'No tasks yet. Tap + to add one.';
  static const String loading = 'Loading tasks...';

  static const String errTitleRequired = 'Title is required.';
  static const String errTitleTooShort = 'Title must be at least 3 characters.';

  static const String attachDeviceUnavailable =
      'Camera/gallery tidak tersedia di perangkat ini.';
  static const String attachPermissionDenied =
      'Izin kamera/galeri ditolak. Aktifkan di pengaturan aplikasi.';
  static const String attachNone = 'Tidak ada lampiran.';
}
