import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p01_diagnosis/app.dart';

/// Smoke test: aplikasi bisa di-pump dan judul home tampil.
/// Test ini tidak memvalidasi filter (bug diagnosis ada di task_filter_test.dart).
void main() {
  testWidgets('app mounts and shows home title', (tester) async {
    await tester.pumpWidget(const TaskTrackerApp());
    await tester.pumpAndSettle();

    expect(find.text('My Tasks'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
