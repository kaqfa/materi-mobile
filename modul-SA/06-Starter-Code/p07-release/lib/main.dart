import 'package:flutter/material.dart';

import 'app.dart';

/// P07 starter: shell release-ready. Quality gate:
///   flutter analyze  -> bersih (strict const).
///   flutter test     -> smoke hijau.
///   flutter build apk --release -> APK (lihat RELEASE-CHECKLIST.md).
/// Tidak ada signing key/secret di repo (lihat .gitignore).
void main() {
  runApp(const TaskTrackerApp());
}
