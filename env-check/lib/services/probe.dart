import '../models/check_result.dart';

/// Kontrak satu pemeriksaan.
///
/// Setiap probe harus mengembalikan hasil, bukan melempar: kegagalan satu
/// paket tidak boleh menghentikan pemeriksaan paket lain. Itulah alasan
/// [run] menangkap semua error di [safeRun].
abstract class Probe {
  const Probe();

  String get id;
  String get label;
  int get chapter;

  /// Kerjakan pemeriksaannya. Boleh melempar; [safeRun] yang menangkap.
  /// Kembalikan keterangan singkat yang berguna saat lolos.
  Future<String> probe();

  CheckResult get initial =>
      CheckResult(id: id, label: label, chapter: chapter);

  Future<CheckResult> safeRun() async {
    final stopwatch = Stopwatch()..start();
    try {
      final detail = await probe();
      stopwatch.stop();
      return initial.copyWith(
        status: CheckStatus.passed,
        detail: detail,
        duration: stopwatch.elapsed,
      );
    } on UnsupportedOnThisPlatform catch (e) {
      stopwatch.stop();
      return initial.copyWith(
        status: CheckStatus.skipped,
        detail: e.message,
        duration: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      return initial.copyWith(
        status: CheckStatus.failed,
        detail: e.toString(),
        duration: stopwatch.elapsed,
      );
    }
  }
}

/// Dilempar probe yang memang tidak berlaku di platform berjalan, misalnya
/// `sqflite` di web. Ini bukan kegagalan lingkungan, jadi statusnya skipped.
class UnsupportedOnThisPlatform implements Exception {
  const UnsupportedOnThisPlatform(this.message);
  final String message;

  @override
  String toString() => message;
}
