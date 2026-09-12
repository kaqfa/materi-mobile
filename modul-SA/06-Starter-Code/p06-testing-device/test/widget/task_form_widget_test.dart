import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p06_testing_device/core/constants/app_strings.dart';
import 'package:p06_testing_device/features/tasks/domain/task.dart';
import 'package:p06_testing_device/features/tasks/presentation/screens/task_form_screen.dart';

/// Widget test target #1 (form validation). Hijau sejak starter.
void main() {
  testWidgets('submit title kosong -> pesan error validasi', (tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskFormScreen(onSubmit: (_) {})));
    await tester.tap(find.byKey(const Key('btn_save')));
    await tester.pump();
    expect(find.text(AppStrings.errTitleRequired), findsOneWidget);
  });

  testWidgets('submit title < 3 char -> pesan terlalu pendek', (tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskFormScreen(onSubmit: (_) {})));
    await tester.enterText(find.byKey(const Key('field_title')), 'ab');
    await tester.tap(find.byKey(const Key('btn_save')));
    await tester.pump();
    expect(find.text(AppStrings.errTitleTooShort), findsOneWidget);
  });

  testWidgets('submit valid -> onSubmit dipanggil dengan Task', (tester) async {
    Task? captured;
    await tester.pumpWidget(
      MaterialApp(home: TaskFormScreen(onSubmit: (t) => captured = t)),
    );
    await tester.enterText(find.byKey(const Key('field_title')), 'Valid Title');
    await tester.tap(find.byKey(const Key('btn_save')));
    await tester.pump();
    expect(captured, isNotNull);
    expect(captured!.title, 'Valid Title');
  });
}
