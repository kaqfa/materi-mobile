import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p07_release/app.dart';
import 'package:p07_release/features/perf/perf_demo_screen.dart';

/// Widget smoke untuk gate release P07. Hijau sejak starter.
void main() {
  testWidgets('app render home dengan list task', (tester) async {
    await tester.pumpWidget(const TaskTrackerApp());
    await tester.pumpAndSettle();
    expect(find.text('Polish README'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('perf demo: tombol bump memperbarui counter', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PerfDemoScreen()));
    expect(find.textContaining('Counter: 0'), findsOneWidget);
    await tester.tap(find.text('Bump (rebuild stateful)'));
    await tester.pump();
    expect(find.textContaining('Counter: 1'), findsOneWidget);
  });
}
