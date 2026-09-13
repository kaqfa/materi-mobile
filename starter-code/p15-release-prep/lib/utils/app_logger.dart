import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

/// Logger terpusat: riuh di debug, sunyi di rilis.
///
/// Log yang bocor ke produksi = kebocoran informasi (data user,
/// struktur internal). Kunci: `kReleaseMode`.
abstract final class AppLogger {
  static void debug(String message) {
    if (kReleaseMode) return; // tidak ada log debug di build rilis
    dev.log(message, name: 'StudyTracker');
  }

  static void error(Object error, StackTrace stack) {
    if (kReleaseMode) {
      // TODO(student) P15-2: hubungkan ke layanan pelaporan error
      // (Crashlytics/Sentry — lihat modul bab 14). Jangan hanya print.
      return;
    }
    dev.log('$error', name: 'StudyTracker-error', error: error, stackTrace: stack);
  }
}
