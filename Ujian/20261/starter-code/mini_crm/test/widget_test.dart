import 'package:flutter_test/flutter_test.dart';

import 'package:mini_crm/main.dart';

void main() {
  testWidgets('Mini CRM menampilkan daftar lead', (tester) async {
    await tester.pumpWidget(const MiniCrmApp());
    expect(find.text('PT Nusantara Logistik'), findsOneWidget);
  });
}
