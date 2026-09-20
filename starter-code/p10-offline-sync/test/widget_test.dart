import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:study_tracker_p10/main.dart';

void main() {
  // Starter ini memakai plugin (sqflite) di initState layar utama.
  // Plugin tidak tersedia di lingkungan widget test, jadi smoke test
  // cukup memastikan root widget dapat dikonstruksi; alur layar
  // diuji manual di emulator/device.
  testWidgets('smoke test: root widget dapat dikonstruksi', (WidgetTester tester) async {
    expect(const StudyTrackerApp(), isA<Widget>());
  });
}
