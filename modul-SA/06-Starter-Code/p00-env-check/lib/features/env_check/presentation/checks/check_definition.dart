import '../../domain/check_result.dart';

/// Definisi satu smoke test: id unik, judul, deskripsi, dan fungsi run.
class CheckDefinition {
  const CheckDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.run,
  });

  /// Identifier stabil (mis. 'provider') untuk key/diagnostik.
  final String id;

  /// Nama library yang diuji: ditampilkan apa adanya.
  final String title;

  /// Apa yang dibuktikan oleh check ini.
  final String description;

  /// Eksekutor async yang mengembalikan [CheckResult].
  final CheckRunner run;
}

/// Signature fungsi smoke test.
typedef CheckRunner = Future<CheckResult> Function();
