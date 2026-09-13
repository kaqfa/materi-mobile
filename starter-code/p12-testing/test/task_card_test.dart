import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_tracker_p12/models/task.dart';
import 'package:study_tracker_p12/widgets/task_card.dart';

void main() {
  // Widget test butuh MaterialApp (inherited widgets: Theme, Directionality).
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('TaskCard menampilkan judul (hijau)', (tester) async {
    const task = Task(id: 't1', title: 'Judul uji');
    await tester.pumpWidget(wrap(const TaskCard(task: task, onToggle: null)));

    expect(find.text('Judul uji'), findsOneWidget);
    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
  });

  testWidgets('tap toggle memanggil callback (hijau)', (tester) async {
    const task = Task(id: 't1', title: 'Judul uji');
    var dipanggil = 0;
    await tester.pumpWidget(wrap(TaskCard(task: task, onToggle: () => dipanggil++)));

    await tester.tap(find.byKey(const Key('toggle-t1')));
    await tester.pump(); // proses frame setelah tap

    expect(dipanggil, 1);
  });

  testWidgets('tugas selesai pakai ikon centang (MERAH: belum di-handle?)',
      (tester) async {
    // TODO(student) P12-3: ikon card masih circle_outlined untuk
    // completed=true — amati test ini gagal, lalu perbaiki TaskCard
    // (bukan test-nya).
    const task = Task(id: 't9', title: 'Sudah selesai', completed: true);
    await tester.pumpWidget(wrap(const TaskCard(task: task, onToggle: null)));

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
