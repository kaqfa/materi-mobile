import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/task.dart';
import 'task_api.dart';

/// REST client untuk endpoint `/tasks`.
///
/// Jalankan dengan backend sendiri:
///   flutter run --dart-define=API_BASE_URL=https://xxx.supabase.co/rest/v1 \
///               --dart-define=API_KEY=eyJ...
/// Tanpa dart-define, app otomatis memakai MockTaskApi (lihat main.dart).
class RemoteTaskApiClient implements TaskApi {
  RemoteTaskApiClient({
    required String baseUrl,
    required String apiKey,
    http.Client? client,
  })  : _baseUrl = baseUrl,
        _apiKey = apiKey,
        _client = client ?? http.Client();

  final String _baseUrl;
  final String _apiKey;
  final http.Client _client;

  /// Header standar Supabase REST: apikey + Authorization Bearer.
  ///
  /// Di produksi, token JWT user dipasang di sini setelah signIn —
  /// jangan pernah menempel anon key di repositori publik.
  Map<String, String> get _headers => {
        'apikey': _apiKey,
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      };

  Uri _uri(String path, [Map<String, String>? query]) => Uri.parse('$_baseUrl/tasks$path').replace(
      queryParameters: query);

  /// Peta status code -> pesan yang bermakna bagi user.
  String _messageFor(int status) => switch (status) {
        200 || 201 => 'OK',
        401 => 'Sesi berakhir — silakan login ulang',
        403 => 'Tidak punya akses ke data ini',
        404 => 'Data tidak ditemukan',
        422 => 'Data tidak valid (periksa kembali input)',
        _ => 'Server bermasalah (HTTP $status)',
      };

  @override
  Future<List<Task>> fetchTasks() async {
    final response = await _client.get(_uri(''), headers: _headers);
    if (response.statusCode != 200) {
      throw ApiException(_messageFor(response.statusCode), response.statusCode);
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Task> createTask(String title) async {
    final response = await _client.post(
      _uri(''),
      headers: _headers,
      body: jsonEncode({'title': title, 'completed': false}),
    );
    if (response.statusCode != 201) {
      throw ApiException(_messageFor(response.statusCode), response.statusCode);
    }
    return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // TODO(student) P09-2: implementasikan updateTask — PUT /tasks/{id}
  // body: jsonEncode(task.toJson()); status sukses 200.
  @override
  Future<void> updateTask(Task task) async {
    final response = await _client.put(
      _uri('/${task.id}'),
      headers: _headers,
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode != 200) {
      throw ApiException(_messageFor(response.statusCode), response.statusCode);
    }
  }

  // TODO(student) P09-3: implementasikan deleteTask — DELETE /tasks/{id}
  // status sukses 204 (No Content).
  @override
  Future<void> deleteTask(int id) async {
    final response = await _client.delete(_uri('/$id'), headers: _headers);
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw ApiException(_messageFor(response.statusCode), response.statusCode);
    }
  }
}

/// Exception khusus jaringan — membedakan kesalahan HTTP dari bug kode.
class ApiException implements Exception {
  ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
