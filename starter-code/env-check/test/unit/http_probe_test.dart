import 'package:env_check/models/check_result.dart';
import 'package:env_check/services/probes_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final url = Uri.parse('https://contoh.invalid/probe.json');

  test('HttpProbe lolos pada 200 dengan body JSON', () async {
    final client = MockClient((_) async => http.Response('{"ok":true}', 200));

    final result = await HttpProbe(client: client, endpoint: url).safeRun();

    expect(result.status, CheckStatus.passed, reason: result.detail);
  });

  test('HttpProbe gagal pada status non-200', () async {
    final client = MockClient((_) async => http.Response('nope', 503));

    final result = await HttpProbe(client: client, endpoint: url).safeRun();

    expect(result.status, CheckStatus.failed);
    expect(result.detail, contains('503'));
  });

  test('HttpProbe gagal bila body bukan JSON', () async {
    final client = MockClient((_) async => http.Response('<html>', 200));

    final result = await HttpProbe(client: client, endpoint: url).safeRun();

    expect(result.status, CheckStatus.failed);
  });
}
