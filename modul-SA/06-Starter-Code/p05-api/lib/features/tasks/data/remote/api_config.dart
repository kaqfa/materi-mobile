/// Konfigurasi API dibaca dari `--dart-define` (compile-time), BUKAN hardcode.
///
/// Contoh menjalankan dengan endpoint nyata:
/// ```bash
/// flutter run \
///   --dart-define=API_BASE_URL=https://your-server.example.com \
///   --dart-define=API_TOKEN=***
/// ```
///
/// Bila `API_BASE_URL` kosong (default), aplikasi otomatis memakai
/// [MockTaskApiClient] (fixture offline) sehingga tetap bisa diuji tanpa
/// server eksternal. JANGAN menaruh secret di sini; isi lewat define/env.
class ApiConfig {
  const ApiConfig._();

  /// Base URL server. Kosong => mode mock/fallback.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Token bearer (opsional). Hanya dipakai saat [baseUrl] tidak kosong.
  /// Disediakan via `--dart-define=API_TOKEN=...`; tidak ada nilai default.
  static const String apiToken = String.fromEnvironment(
    'API_TOKEN',
    defaultValue: '',
  );

  /// Timeout default untuk request HTTP.
  static const Duration timeout = Duration(seconds: 10);

  /// True bila tidak ada base URL => gunakan mock fixture.
  static bool get useMock => baseUrl.isEmpty;
}
