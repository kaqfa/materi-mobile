import 'package:env_check/models/check_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CheckResult', () {
    const base = CheckResult(id: 'a', label: 'A', chapter: 1);

    test('copyWith mengganti status tanpa menyentuh identitas', () {
      final updated = base.copyWith(status: CheckStatus.passed, detail: 'ok');

      expect(updated.id, 'a');
      expect(updated.label, 'A');
      expect(updated.chapter, 1);
      expect(updated.status, CheckStatus.passed);
      expect(updated.detail, 'ok');
    });

    test('isDone benar hanya untuk status terminal', () {
      expect(base.isDone, isFalse);
      expect(base.copyWith(status: CheckStatus.running).isDone, isFalse);
      expect(base.copyWith(status: CheckStatus.passed).isDone, isTrue);
      expect(base.copyWith(status: CheckStatus.failed).isDone, isTrue);
      expect(base.copyWith(status: CheckStatus.skipped).isDone, isTrue);
    });

    test('round-trip JSON memulihkan seluruh field', () {
      final original = base.copyWith(
        status: CheckStatus.failed,
        detail: 'pesan kesalahan',
        duration: const Duration(milliseconds: 120),
      );

      final restored = CheckResult.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.status, CheckStatus.failed);
      expect(restored.detail, 'pesan kesalahan');
      expect(restored.duration, const Duration(milliseconds: 120));
    });

    test('status tak dikenal jatuh ke pending, bukan melempar', () {
      final restored = CheckResult.fromJson({
        'id': 'x',
        'label': 'X',
        'chapter': 3,
        'status': 'entah-apa',
      });

      expect(restored.status, CheckStatus.pending);
    });
  });
}
