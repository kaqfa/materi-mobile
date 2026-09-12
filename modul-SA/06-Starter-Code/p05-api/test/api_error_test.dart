import 'package:flutter_test/flutter_test.dart';
import 'package:p05_api/core/errors/api_error.dart';

/// Test pemetaan status HTTP -> [ApiError]. Hijau sejak starter; membuktikan
/// hirarki error terstruktur (sealed) untuk switch exhaustif di UI/repository.
void main() {
  test('5xx -> ServerError dengan status', () {
    final err = mapResponseToError(503);
    expect(err, isA<ServerError>());
    expect((err as ServerError).status, 503);
  });

  test('404 -> NotFoundError', () {
    expect(mapResponseToError(404), isA<NotFoundError>());
  });

  test('400/401/403/422 -> ClientError dengan status', () {
    for (final status in [400, 401, 403, 422]) {
      final err = mapResponseToError(status);
      expect(err, isA<ClientError>());
      expect((err as ClientError).status, status);
    }
  });

  test('NetworkError dan ParseError punya pesan default', () {
    expect(const NetworkError().message, isNotEmpty);
    expect(const ParseError().message, isNotEmpty);
  });

  test('ApiError dapat di-switch exhaustif (sealed)', () {
    String describe(ApiError e) => switch (e) {
          NetworkError() => 'network',
          ServerError() => 'server',
          ClientError() => 'client',
          NotFoundError() => 'notfound',
          ParseError() => 'parse',
        };

    expect(describe(const NetworkError()), 'network');
    expect(describe(const ServerError(500)), 'server');
    expect(describe(const ClientError(400)), 'client');
    expect(describe(const NotFoundError()), 'notfound');
    expect(describe(const ParseError()), 'parse');
  });
}
