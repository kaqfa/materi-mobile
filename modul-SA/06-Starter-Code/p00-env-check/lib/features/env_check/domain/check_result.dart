/// Hasil satu smoke test. Sealed agar UI `switch` exhaustif menampilkan
/// tiap cabang status tanpa fallback default.
sealed class CheckResult {
  const CheckResult();
  String get message;
}

/// Library/feature terpanggil dan sukses.
class CheckOk extends CheckResult {
  const CheckOk(this.message);
  @override
  final String message;
}

/// Library gagal dieksekusi (exception / data salah).
class CheckFail extends CheckResult {
  const CheckFail(this.message);
  @override
  final String message;
}

/// Library tersedia namun sengaja tidak diuji nyata (mis. perlu interaksi
/// UI / device fisik). Bukan kegagalan toolchain.
class CheckSkip extends CheckResult {
  const CheckSkip(this.message);
  @override
  final String message;
}
