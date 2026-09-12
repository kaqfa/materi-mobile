/// Hirarki error API memakai `sealed class` (Dart 3). UI/repository bisa
/// melakukan `switch` exhaustif atas subtype. Lihat `API-CONTRACT.md`.
sealed class ApiError implements Exception {
  const ApiError(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Tidak bisa menjangkau server (offline, DNS, timeout, koneksi diputus).
class NetworkError extends ApiError {
  const NetworkError([super.message = 'Network error: tidak ada koneksi.']);
}

/// Server mengembalikan HTTP 5xx.
class ServerError extends ApiError {
  const ServerError(this.status, [String? message])
      : super(message ??
            'Server error ($status): coba lagi nanti atau pakai fallback.');
  final int status;
}

/// Klien salah (HTTP 4xx selain 404), mis. 400/401/403/422.
class ClientError extends ApiError {
  const ClientError(this.status, [String? message])
      : super(message ?? 'Client error ($status): permintaan tidak valid.');
  final int status;
}

/// Resource tidak ditemukan (HTTP 404).
class NotFoundError extends ApiError {
  const NotFoundError([super.message = 'Task tidak ditemukan (404).']);
}

/// Response tidak bisa di-parse menjadi JSON / model.
class ParseError extends ApiError {
  const ParseError([super.message = 'Response tidak dapat di-parse.']);
}

/// Memetakan status HTTP + kondisi jaringan ke [ApiError] yang sesuai.
ApiError mapResponseToError(int status) {
  if (status >= 500) return ServerError(status);
  if (status == 404) return const NotFoundError();
  if (status >= 400) return ClientError(status);
  return ClientError(status, 'Unexpected status $status');
}
