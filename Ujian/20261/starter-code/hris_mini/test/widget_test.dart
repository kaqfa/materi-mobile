import 'package:flutter_test/flutter_test.dart';

import 'package:hris_mini/main.dart';

void main() {
  testWidgets('HRIS menampilkan daftar pengajuan cuti', (tester) async {
    await tester.pumpWidget(const HrisApp());
    expect(find.text('Budi Santoso'), findsOneWidget);
  });
}
