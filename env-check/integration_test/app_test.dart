import 'package:env_check/main.dart';
import 'package:env_check/models/check_result.dart';
import 'package:env_check/services/environment_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

/// Integration test: berjalan di emulator atau perangkat sungguhan, dan
/// karena itu ia menjalankan probe yang sebenarnya, bukan stub. Inilah
/// satu-satunya lapisan yang boleh mengklaim "lingkungan ini benar-benar
/// siap", karena hanya di sini plugin platform hidup.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('seluruh probe nyata selesai tanpa kegagalan', (tester) async {
    await tester.pumpWidget(const EnvCheckApp());
    await tester.pumpAndSettle(const Duration(seconds: 60));

    final context = tester.element(find.byType(Scaffold).first);
    final report = Provider.of<EnvironmentReport>(context, listen: false);

    expect(report.allDone, isTrue, reason: 'ada probe yang tidak selesai');

    final gagal = report.results
        .where((r) => r.status == CheckStatus.failed)
        .map((r) => '${r.label}: ${r.detail}')
        .toList();

    expect(gagal, isEmpty, reason: gagal.join('\n'));

    // Cetak laporan agar terbaca di keluaran CI maupun terminal.
    debugPrint(report.toPrettyJson());
  });
}
