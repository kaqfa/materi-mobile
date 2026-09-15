/// Hasil satu pemeriksaan lingkungan.
///
/// Sengaja dibuat sebagai class biasa dengan `copyWith`, bukan record atau
/// sealed class, agar bab 1-2 (tipe data, null safety, immutability) punya
/// bentuk yang sudah dikenal saat mahasiswa membaca ulang proyek ini.
enum CheckStatus { pending, running, passed, failed, skipped }

class CheckResult {
  const CheckResult({
    required this.id,
    required this.label,
    required this.chapter,
    this.status = CheckStatus.pending,
    this.detail = '',
    this.duration,
  });

  final String id;
  final String label;

  /// Bab buku yang memperkenalkan kemampuan ini. Dipakai untuk mengurutkan
  /// tampilan supaya kegagalan bisa langsung dirujuk ke materinya.
  final int chapter;

  final CheckStatus status;
  final String detail;
  final Duration? duration;

  bool get isDone =>
      status == CheckStatus.passed ||
      status == CheckStatus.failed ||
      status == CheckStatus.skipped;

  CheckResult copyWith({
    CheckStatus? status,
    String? detail,
    Duration? duration,
  }) {
    return CheckResult(
      id: id,
      label: label,
      chapter: chapter,
      status: status ?? this.status,
      detail: detail ?? this.detail,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'chapter': chapter,
        'status': status.name,
        'detail': detail,
        'durationMs': duration?.inMilliseconds,
      };

  factory CheckResult.fromJson(Map<String, dynamic> json) {
    return CheckResult(
      id: json['id'] as String,
      label: json['label'] as String,
      chapter: json['chapter'] as int,
      status: CheckStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => CheckStatus.pending,
      ),
      detail: json['detail'] as String? ?? '',
      duration: json['durationMs'] == null
          ? null
          : Duration(milliseconds: json['durationMs'] as int),
    );
  }

  @override
  String toString() => 'CheckResult($id, ${status.name})';
}
