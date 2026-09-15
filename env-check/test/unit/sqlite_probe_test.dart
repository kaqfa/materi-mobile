import 'package:env_check/models/check_result.dart';
import 'package:env_check/services/probes_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // sqflite adalah plugin Android/iOS/macOS. Agar migrasinya bisa diuji di
  // host tanpa emulator, factory-nya ditukar dengan implementasi FFI.
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('SqliteProbe: migrasi v1 ke v2 lolos di host', () async {
    const probe = SqliteProbe();

    final result = await probe.safeRun();

    expect(result.status, CheckStatus.passed, reason: result.detail);
    expect(result.detail, contains('migrasi v1→v2'));
  });
}
