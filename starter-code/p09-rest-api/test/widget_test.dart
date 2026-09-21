import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:study_tracker_p09/main.dart';
import 'package:study_tracker_p09/services/task_api.dart';

void main() {
  testWidgets('smoke test: aplikasi ter-render', (WidgetTester tester) async {
    await tester.pumpWidget(StudyTrackerApp(api: MockTaskApi()));
    await tester.pump(const Duration(seconds: 1)); // lewati delay mock (400ms)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
