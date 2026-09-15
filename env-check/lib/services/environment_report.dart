import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/check_result.dart';
import 'probe.dart';
import 'probes_device.dart';
import 'probes_language.dart';
import 'probes_network.dart';
import 'probes_storage.dart';

/// Daftar probe bawaan, diurutkan mengikuti urutan bab buku.
List<Probe> defaultProbes() => const [
      DartLanguageProbe(),
      PreferencesProbe(),
      FileStorageProbe(),
      SqliteProbe(),
      HttpProbe(),
      SecureStorageProbe(),
      ConnectivityProbe(),
      ImagePickerProbe(),
      GeolocatorProbe(),
    ];

/// Bab 7: state aplikasi lewat ChangeNotifier + Provider.
///
/// Probe dijalankan berurutan, bukan paralel, supaya keluaran mudah dibaca
/// dan supaya satu probe yang menggantung tidak menyamarkan probe lain.
class EnvironmentReport extends ChangeNotifier {
  EnvironmentReport({List<Probe>? probes})
      : _probes = probes ?? defaultProbes() {
    _results = [for (final p in _probes) p.initial];
  }

  final List<Probe> _probes;
  late List<CheckResult> _results;
  bool _running = false;

  List<CheckResult> get results => List.unmodifiable(_results);
  bool get running => _running;

  int get passed =>
      _results.where((r) => r.status == CheckStatus.passed).length;
  int get failed =>
      _results.where((r) => r.status == CheckStatus.failed).length;
  int get skipped =>
      _results.where((r) => r.status == CheckStatus.skipped).length;

  bool get allDone => _results.every((r) => r.isDone);

  /// True hanya bila setiap probe selesai dan tidak ada yang gagal.
  /// Probe yang di-skip tidak dihitung sebagai kegagalan: ia memang tidak
  /// berlaku di platform yang sedang berjalan.
  bool get healthy => allDone && failed == 0;

  Future<void> runAll() async {
    if (_running) return;
    _running = true;
    _results = [for (final p in _probes) p.initial];
    notifyListeners();

    for (var i = 0; i < _probes.length; i++) {
      _results[i] = _results[i].copyWith(status: CheckStatus.running);
      notifyListeners();

      _results[i] = await _probes[i].safeRun();
      notifyListeners();
    }

    _running = false;
    notifyListeners();
  }

  /// Laporan yang bisa ditempel ke LMS atau dikirim ke dosen saat minta bantuan.
  String toPrettyJson() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert({
      'generatedAt': DateTime.now().toIso8601String(),
      'healthy': healthy,
      'summary': {'passed': passed, 'failed': failed, 'skipped': skipped},
      'results': [for (final r in _results) r.toJson()],
    });
  }
}
