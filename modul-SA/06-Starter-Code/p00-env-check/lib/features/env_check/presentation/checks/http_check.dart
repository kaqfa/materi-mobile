import 'dart:async';

import 'package:http/http.dart' as http;

import '../../domain/check_result.dart';

/// Endpoint publik placeholder (bukan layanan kelas). Dipakai hanya untuk
/// membuktikan `http` bisa resolve DNS + TLS + GET 200.
const _probeUrl = 'https://jsonplaceholder.typicode.com/todos/1';

/// Probe HTTP GET. Network error (offline / DNS / timeout) ditangani sebagai
/// CheckFail dengan pesan: bukan throw. Tidak ada token/credential.
Future<CheckResult> runHttpCheck() async {
  try {
    final response = await http.get(Uri.parse(_probeUrl)).timeout(
          const Duration(seconds: 10),
        );
    if (response.statusCode != 200) {
      return CheckFail('HTTP ${response.statusCode} dari $_probeUrl.');
    }
    final body = response.body;
    if (body.isEmpty) {
      return CheckFail('Body kosong dari $_probeUrl.');
    }
    return CheckOk('HTTP 200, ${body.length} byte (jsonplaceholder).');
  } catch (e) {
    return CheckFail(
      'Network error: $e. Cek koneksi/DNS/proxy lalu ulangi.',
    );
  }
}
