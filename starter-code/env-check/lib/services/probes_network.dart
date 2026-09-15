import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'probe.dart';

/// Bab 9: HTTP nyata ke internet. Ini satu-satunya probe yang butuh jaringan,
/// dan sengaja dipisah agar kegagalan di sini terbaca sebagai masalah
/// jaringan/permission INTERNET, bukan masalah paket.
class HttpProbe extends Probe {
  const HttpProbe({this.client, this.endpoint});

  /// Disuntikkan saat pengujian; di aplikasi nyata dibiarkan null.
  final http.Client? client;
  final Uri? endpoint;

  @override
  String get id => 'http';

  @override
  String get label => 'http: GET ke internet + decode JSON';

  @override
  int get chapter => 9;

  @override
  Future<String> probe() async {
    final c = client ?? http.Client();
    final url = endpoint ??
        Uri.parse(
          'https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION',
        );
    try {
      final response = await c
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw StateError('status ${response.statusCode} dari $url');
      }
      // Decode dilakukan supaya kegagalan parsing ikut ketahuan di sini.
      jsonDecode(response.body);
      return 'HTTP 200 dari ${url.host}, body ter-decode sebagai JSON';
    } finally {
      if (client == null) c.close();
    }
  }
}

/// Bab 9: penyimpanan aman. Di Android butuh keystore, di iOS butuh keychain;
/// kegagalan di sini biasanya soal konfigurasi platform, bukan kode Dart.
class SecureStorageProbe extends Probe {
  const SecureStorageProbe();

  @override
  String get id => 'secure-storage';

  @override
  String get label => 'flutter_secure_storage: simpan & hapus token';

  @override
  int get chapter => 9;

  @override
  Future<String> probe() async {
    const storage = FlutterSecureStorage();
    const key = 'env_check.session';
    const value = 'token-percobaan';

    await storage.write(key: key, value: value);
    final read = await storage.read(key: key);
    await storage.delete(key: key);

    if (read != value) {
      throw StateError('nilai rahasia tidak pulih utuh');
    }
    if (await storage.read(key: key) != null) {
      throw StateError('delete tidak menghapus nilai');
    }
    return 'tulis, baca, hapus di penyimpanan aman platform';
  }
}

/// Bab 10: deteksi konektivitas sebagai pemicu sinkronisasi offline-first.
class ConnectivityProbe extends Probe {
  const ConnectivityProbe();

  @override
  String get id => 'connectivity';

  @override
  String get label => 'connectivity_plus: baca status jaringan';

  @override
  int get chapter => 10;

  @override
  Future<String> probe() async {
    final results = await Connectivity()
        .checkConnectivity()
        .timeout(const Duration(seconds: 10));
    if (results.isEmpty) {
      throw StateError('checkConnectivity mengembalikan daftar kosong');
    }
    final names = results.map((r) => r.name).join(', ');
    // Stream-nya ikut diuji: bab 10 memakai listener ini untuk memicu sync.
    final sub = Connectivity().onConnectivityChanged.listen((_) {});
    await sub.cancel();
    final where = kIsWeb ? 'web' : 'native';
    return 'status: $names (listener $where dibuat dan ditutup)';
  }
}
