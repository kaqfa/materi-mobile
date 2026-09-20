import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:study_tracker_p09/main.dart';
import 'package:study_tracker_p09/services/task_api.dart';

void main() {
  testWidgets('smoke test: aplikasi ter-render', (WidgetTester tester) async {
    await tester.pumpWidget(StudyTrackerApp(api: MockTaskApi()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
