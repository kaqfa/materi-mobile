import 'dart:io';

// Sengaja di-import eksplisit: env checker ini justru ingin membuktikan
// paket `sqflite` sendiri ter-resolve di mesin mahasiswa, bukan hanya
// re-export lewat sqflite_common_ffi.
// ignore: unnecessary_import
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../domain/check_result.dart';

/// Pilih factory sesuai platform:
/// - Android/iOS: `sqflite` native (plugin sudah membundel SQLite OS).
/// - Desktop/test: `sqflite_common_ffi` (butuh libsqlite3 dari sistem).
///
/// Memakai FFI di Android akan gagal `dlopen libsqlite3.so` karena APK tidak
/// membundel .so tersebut, jadi pemisahan ini wajib bukan sekadar preferensi.
DatabaseFactory _factoryForPlatform() {
  if (Platform.isAndroid || Platform.isIOS) {
    return databaseFactory;
  }
  sqfliteFfiInit();
  return databaseFactoryFfi;
}

/// Membuktikan sqflite bisa open DB, create table, insert, dan query.
/// Pakai in-memory DB agar tidak menulis file fisik.
Future<CheckResult> runSqliteCheck() async {
  try {
    final factory = _factoryForPlatform();
    final backend =
        (Platform.isAndroid || Platform.isIOS) ? 'native' : 'FFI';
    final db = await factory.openDatabase(inMemoryDatabasePath);
    await db.execute(
      'CREATE TABLE probes (id INTEGER PRIMARY KEY, label TEXT)',
    );
    final insertedId = await db.insert(
      'probes',
      <String, Object?>{'label': 'hello'},
    );
    final rows = await db.query('probes');
    await db.close();

    if (insertedId != 1 || rows.length != 1) {
      return CheckFail(
        'insert id=$insertedId rows=${rows.length}; expected id=1 rows=1.',
      );
    }
    final value = rows.first['label'];
    if (value != 'hello') {
      return CheckFail('Query label=$value; expected "hello".');
    }
    return CheckOk('open + create + insert + query OK (in-memory, $backend).');
  } catch (e) {
    return CheckFail(e.toString());
  }
}
