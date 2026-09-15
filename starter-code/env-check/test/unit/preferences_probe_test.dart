import 'package:env_check/models/check_result.dart';
import 'package:env_check/services/probes_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  // Store dalam memori menggantikan plugin preferences. Yang dibuktikan di
  // sini adalah logika probe-nya, BUKAN bahwa preferences benar-benar awet
  // di disk perangkat; klaim yang terakhir itu milik integration test.
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('PreferencesProbe lolos dengan store dalam memori', () async {
    const probe = PreferencesProbe();

    final result = await probe.safeRun();

    expect(result.status, CheckStatus.passed, reason: result.detail);
    expect(result.duration, isNotNull);
  });
}
