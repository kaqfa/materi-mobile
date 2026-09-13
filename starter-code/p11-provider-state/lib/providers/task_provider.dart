import 'package:flutter/foundation.dart';

import '../models/task.dart';

/// State tugas terpusat: satu sumber kebenaran untuk seluruh app.
///
/// Bandingkan dengan P03: dulu tiap perubahan = setState di screen
/// (state tersebar, prop drilling saat widget membesar). Sekarang
/// screen cukup memanggil metode di sini; widget yang listen
/// otomatis dibangun ulang.
class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [
    const Task(id: 't1', title: 'Refactor ke Provider', category: 'Proyek', priority: Priority.high),
    const Task(id: 't2', title: 'Coba Consumer vs Selector', category: 'Belajar'),
    const Task(id: 't3', title: 'Hapus semua setState', completed: true),
  ];

  // Riwayat untuk undo/redo (TODO P11-2).
  final List<void Function()> _undoStack = [];

  /// Kata kunci filter — screen lain bisa mengubahnya tanpa callback.
  String query = '';

  List<Task> get tasks {
    if (query.isEmpty) return List.unmodifiable(_tasks);
    return List.unmodifiable(
      _tasks.where((t) => t.title.toLowerCase().contains(query.toLowerCase())),
    );
  }

  int get doneCount => _tasks.where((t) => t.completed).length;

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void addTask(String title) {
    _tasks.add(Task(id: 't${DateTime.now().millisecondsSinceEpoch}', title: title));
    notifyListeners();
  }

  void toggleComplete(String id) {
    // TODO(student) P11-1: sebelum mengubah, dorong operasi kebalikan
    // ke _undoStack (pola: _undoStack.add(() { ...kembalikan state lama... })).
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _tasks[i] = _tasks[i].copyWith(completed: !_tasks[i].completed);
    notifyListeners();
  }

  void deleteTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    final removed = _tasks.removeAt(index);
    _undoStack.add(() {
      _tasks.insert(index >= _tasks.length ? _tasks.length : index, removed);
      notifyListeners();
    });
    notifyListeners();
  }

  // TODO(student) P11-2: implementasikan undo() — ambil operasi terakhir
  // dari _undoStack dan jalankan. Kosong/stack habis -> tidak melakukan
  // apa-apa (aman dipanggil berulang). Jangan lupa notifyListeners().
  bool get canUndo => _undoStack.isNotEmpty;

  void undo() {
    // TODO(student) P11-2: isi badan undo() (lihat komentar di atas).
  }
}
