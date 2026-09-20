import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:study_tracker_p13/main.dart';

void main() {
  testWidgets('smoke test: aplikasi ter-render', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyTrackerApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
