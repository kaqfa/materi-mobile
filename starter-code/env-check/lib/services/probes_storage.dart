import 'dart:convert';
import 'dart:io' show File, Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'probe.dart';

/// Bab 7: shared_preferences lewat API asinkron yang dipakai buku.
class PreferencesProbe extends Probe {
  const PreferencesProbe();

  @override
  String get id => 'shared-preferences';

  @override
  String get label => 'shared_preferences: tulis, baca, hapus';

  @override
  int get chapter => 7;

  @override
  Future<String> probe() async {
    final prefs = SharedPreferencesAsync();
    const key = 'env_check.probe';
    final payload = jsonEncode({'stamp': DateTime.now().toIso8601String()});

    await prefs.setString(key, payload);
    final read = await prefs.getString(key);
    if (read != payload) {
      throw StateError('nilai yang dibaca berbeda dari yang ditulis');
    }
    await prefs.remove(key);
    if (await prefs.getString(key) != null) {
      throw StateError('remove tidak menghapus kunci');
    }
    return 'round-trip string berhasil, kunci bersih kembali';
  }
}

/// Bab 8: berkas di direktori dokumen lewat path_provider + path.
class FileStorageProbe extends Probe {
  const FileStorageProbe();

  @override
  String get id => 'path-provider';

  @override
  String get label => 'path_provider + dart:io: tulis berkas dokumen';

  @override
  int get chapter => 8;

  @override
  Future<String> probe() async {
    if (kIsWeb) {
      throw const UnsupportedOnThisPlatform('dart:io tidak tersedia di web');
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'env-check-probe.json'));
    await file.writeAsString(jsonEncode({'ok': true}));
    final back = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    await file.delete();
    if (back['ok'] != true) throw StateError('isi berkas tidak cocok');
    return 'berkas ditulis dan dibaca di ${p.basename(dir.path)}/';
  }
}

/// Bab 8 dan 10: sqflite, termasuk migrasi skema yang jadi inti bab 8.
class SqliteProbe extends Probe {
  const SqliteProbe();

  @override
  String get id => 'sqflite';

  @override
  String get label => 'sqflite: buka, migrasi v1→v2, transaksi';

  @override
  int get chapter => 8;

  @override
  Future<String> probe() async {
    if (kIsWeb) {
      throw const UnsupportedOnThisPlatform('sqflite tidak berjalan di web');
    }

    final dir = await databaseFactory.getDatabasesPath();
    final path = p.join(dir, 'env_check_probe.db');
    await databaseFactory.deleteDatabase(path);

    // Buka sebagai versi 1, lalu tutup: mensimulasikan instalasi lama.
    final v1 = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE tasks (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              done INTEGER NOT NULL DEFAULT 0
            )
          ''');
        },
      ),
    );
    await v1.insert('tasks', {'title': 'tugas lama', 'done': 0});
    await v1.close();

    // Buka ulang sebagai versi 2: onUpgrade harus jalan tanpa kehilangan data.
    var upgraded = false;
    final v2 = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          throw StateError('onCreate tidak boleh jalan pada berkas yang ada');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          upgraded = oldVersion == 1 && newVersion == 2;
          await db.execute('ALTER TABLE tasks ADD COLUMN due_at TEXT');
        },
      ),
    );

    if (!upgraded) throw StateError('onUpgrade tidak terpanggil dari v1 ke v2');

    await v2.transaction((txn) async {
      await txn.insert('tasks', {
        'title': 'tugas baru',
        'done': 1,
        'due_at': DateTime(2026, 12, 1).toIso8601String(),
      });
    });

    final rows = await v2.query('tasks', orderBy: 'id');
    await v2.close();
    await databaseFactory.deleteDatabase(path);

    if (rows.length != 2) {
      throw StateError('harusnya 2 baris setelah migrasi, dapat ${rows.length}');
    }
    if (rows.first['title'] != 'tugas lama') {
      throw StateError('data lama hilang saat migrasi');
    }
    if (!rows.last.containsKey('due_at')) {
      throw StateError('kolom hasil migrasi tidak ada');
    }

    final where = kIsWeb ? 'web' : Platform.operatingSystem;
    return 'migrasi v1→v2 utuh, transaksi jalan di $where';
  }
}
