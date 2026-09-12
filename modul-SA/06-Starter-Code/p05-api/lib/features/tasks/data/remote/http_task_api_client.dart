import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/errors/api_error.dart';
import '../../domain/task.dart';
import 'api_config.dart';
import 'task_api_client.dart';

/// Implementasi [TaskApiClient] memakai `package:http`.
///
/// Membaca base URL + token dari [ApiConfig] (compile-time `--dart-define`).
/// Setiap response non-2xx dipetakan ke subtype [ApiError] agar UI bisa
/// menampilkan pesan sesuai jenis kegagalan. Lihat `API-CONTRACT.md`.
class HttpTaskApiClient implements TaskApiClient {
  HttpTaskApiClient({
    required this.baseUrl,
    String? token,
    http.Client? client,
  })  : _token = token,
        _client = client ?? http.Client();

  final String baseUrl;
  final String? _token;
  final http.Client _client;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null && _token!.isNotEmpty)
          'Authorization': 'Bearer $_token',
      };

  @override
  Future<List<Task>> listTasks() async {
    final res = await _send(() => _client.get(_uri('/tasks'), headers: _headers));
    final body = _decodeList(res.body);
    return body.map(Task.fromJson).toList();
  }

  @override
  Future<Task> createTask(Task task) async {
    final res = await _send(() => _client.post(
          _uri('/tasks'),
          headers: _headers,
          body: jsonEncode(task.toJson()),
        ));
    return Task.fromJson(_decode(res.body));
  }

  @override
  Future<Task> updateTask(Task task) async {
    final res = await _send(() => _client.patch(
          _uri('/tasks/${task.id}'),
          headers: _headers,
          body: jsonEncode(task.toJson()),
        ));
    return Task.fromJson(_decode(res.body));
  }

  @override
  Future<void> deleteTask(String id) async {
    await _send(() => _client.delete(_uri('/tasks/$id'), headers: _headers));
  }

  /// Wrapper: jalankan request, tangani timeout & status non-2xx.
  Future<http.Response> _send(
    Future<http.Response> Function() request,
  ) async {
    try {
      final res = await request().timeout(ApiConfig.timeout);
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw mapResponseToError(res.statusCode);
      }
      return res;
    } on ApiError {
      rethrow;
    } catch (_) {
      // timeout, socket exception, DNS, dll.
      throw const NetworkError();
    }
  }

  Map<String, Object?> _decode(String body) {
    try {
      return jsonDecode(body) as Map<String, Object?>;
    } catch (_) {
      throw const ParseError();
    }
  }

  List<Map<String, Object?>> _decodeList(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is List) {
        return decoded
            .map((e) => Map<String, Object?>.from(e as Map))
            .toList();
      }
      // Beberapa server membungkus list di key `data`.
      if (decoded is Map && decoded['data'] is List) {
        return (decoded['data'] as List)
            .map((e) => Map<String, Object?>.from(e as Map))
            .toList();
      }
      throw const ParseError();
    } catch (e) {
      if (e is ParseError) rethrow;
      throw const ParseError();
    }
  }
}
