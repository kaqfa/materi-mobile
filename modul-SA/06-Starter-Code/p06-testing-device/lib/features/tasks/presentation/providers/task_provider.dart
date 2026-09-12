import 'package:flutter/foundation.dart';

import '../../../attachments/attachment_service.dart';
import '../../domain/task.dart';
import '../../services/task_filter_service.dart';

/// State tugas P06: daftar, filter, lampiran, error.
///
/// PERHATIAN (P06): wiring `attachPhoto` ke [AttachmentService] sengaja
/// **no-op** sebagai TODO CP2. Cabang hasil sukses/unavailable/denied sudah
/// ditentukan (sealed `AttachmentResult`); kamu hanya menghubungkan pemanggilan
/// service + memperbarui [lastAttachment] + [attachmentError].
///
/// `loadTasks` sudah memuat dummy sehingga UI tampil sejak first run.
class TaskProvider extends ChangeNotifier {
  TaskProvider({
    TaskFilterService? filterService,
    AttachmentService? attachmentService,
  })  : _filterService = filterService ?? const TaskFilterService(),
        _attachmentService = attachmentService;

  final TaskFilterService _filterService;
  final AttachmentService? _attachmentService;

  List<Task> _all = const [];
  TaskFilter _filter = TaskFilter.empty;
  bool _isLoading = false;
  String? _error;

  /// Hasil attachment terakhir (untuk UI fallback device/permission).
  AttachmentResult? lastAttachment;
  String? attachmentError;

  List<Task> get filteredTasks => _filterService.apply(_all, _filter);
  List<Task> get allTasks => List.unmodifiable(_all);
  TaskFilter get filter => _filter;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get hasAttachmentService => _attachmentService != null;

  void setFilter(TaskFilter next) {
    _filter = next;
    notifyListeners();
  }

  /// Memuat daftar dummy (P06 tidak fokus persistensi — itu P04/Tugas 2).
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _all = dummyTasks();
    } catch (e) {
      _error = 'Failed to load tasks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Memilih lampiran via service. TODO(student) CP2: panggil
  /// [_attachmentService] (gallery atau camera), simpan hasil ke
  /// [lastAttachment] (switch over AttachmentResult), lalu notifyListeners.
  /// Bila [_attachmentService] null -> set [attachmentError].
  Future<void> attachPhoto({bool fromCamera = false}) async {
    // TODO(student): hubungkan ke _attachmentService.
    // Contoh kerangka (JANGAN dianggap selesai):
    //   final svc = _attachmentService;
    //   if (svc == null) { attachmentError = '...'; notifyListeners(); return; }
    //   final result = fromCamera
    //       ? await svc.pickFromCamera()
    //       : await svc.pickFromGallery();
    //   switch (result) {
    //     case AttachmentSuccess(:final path): ...; break;
    //     case AttachmentUnavailable(:final reason): ...; break;
    //     case AttachmentDenied(:final reason): ...; break;
    //   }
    //   notifyListeners();
    attachmentError = 'attachPhoto not wired yet.';
    notifyListeners();
  }

  /// Helper test: menyuntik daftar langsung tanpa loadTasks.
  @visibleForTesting
  void seedTasks(List<Task> tasks) {
    _all = List.unmodifiable(tasks);
    notifyListeners();
  }

  /// Helper test: memaksa state error agar UI retry dapat diuji widget test.
  @visibleForTesting
  void seedError(String message) {
    _isLoading = false;
    _error = message;
    notifyListeners();
  }
}
