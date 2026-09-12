import 'package:flutter_test/flutter_test.dart';
import 'package:p02_ui_navigation/app.dart';

void main() {
  testWidgets('app mounts and shows home title + add button', (tester) async {
    await tester.pumpWidget(const TaskTrackerApp());
    await tester.pumpAndSettle();

    expect(find.text('My Tasks'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
