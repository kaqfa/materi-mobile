import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:p00_env_check/app.dart';

/// Widget smoke: app ter-render, judul + tombol Run tampil, dan daftar
/// check muncul dalam keadaan pending. Check asli (plugin native) tidak
/// dijalankan di sini: hanya render.
void main() {
  testWidgets('renders env check screen with title, run button, and pending checks',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EnvCheckApp());
    await tester.pumpAndSettle();

    expect(find.text('P00 Environment Check'), findsOneWidget);
    expect(find.text('Run all checks'), findsOneWidget);
    expect(find.text('provider'), findsOneWidget);
    expect(find.text('sqflite + sqflite_common_ffi'), findsOneWidget);
    expect(find.byIcon(Icons.hourglass_empty), findsNWidgets(6));
  });
}
