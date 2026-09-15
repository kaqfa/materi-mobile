import 'dart:convert';

import 'package:env_check/models/check_result.dart';
import 'package:env_check/services/environment_report.dart';
import 'package:env_check/services/probe.dart';
import 'package:flutter_test/flutter_test.dart';

/// Probe palsu: tidak menyentuh plugin apa pun, sehingga logika laporan
/// bisa diuji murah di host. Ini persis batas yang dijelaskan bab 11.
class _FakeProbe extends Probe {
  const _FakeProbe(this.id, this.outcome);

  @override
  final String id;

  /// 'pass', 'fail', atau 'skip'.
  final String outcome;

  @override
  String get label => 'Probe $id';

  @override
  int get chapter => 1;

  @override
  Future<String> probe() async {
    return switch (outcome) {
      'fail' => throw StateError('sengaja gagal'),
      'skip' => throw const UnsupportedOnThisPlatform('tidak berlaku di sini'),
      _ => 'baik',
    };
  }
}

void main() {
  group('EnvironmentReport', () {
    test('mulai dengan semua probe pending dan belum sehat', () {
      final report = EnvironmentReport(
        probes: const [_FakeProbe('a', 'pass')],
      );

      expect(report.results.single.status, CheckStatus.pending);
      expect(report.allDone, isFalse);
      expect(report.healthy, isFalse);
    });

    test('runAll menghitung lolos, gagal, dan dilewati', () async {
      final report = EnvironmentReport(probes: const [
        _FakeProbe('a', 'pass'),
        _FakeProbe('b', 'fail'),
        _FakeProbe('c', 'skip'),
      ]);

      await report.runAll();

      expect(report.passed, 1);
      expect(report.failed, 1);
      expect(report.skipped, 1);
      expect(report.allDone, isTrue);
      expect(report.healthy, isFalse);
    });

    test('probe yang di-skip tidak membuat laporan dianggap gagal', () async {
      final report = EnvironmentReport(probes: const [
        _FakeProbe('a', 'pass'),
        _FakeProbe('c', 'skip'),
      ]);

      await report.runAll();

      expect(report.failed, 0);
      expect(report.healthy, isTrue);
    });

    test('kegagalan satu probe tidak menghentikan probe sesudahnya', () async {
      final report = EnvironmentReport(probes: const [
        _FakeProbe('a', 'fail'),
        _FakeProbe('b', 'pass'),
      ]);

      await report.runAll();

      expect(report.results.last.status, CheckStatus.passed);
    });

    test('pesan kesalahan ikut tersimpan di detail', () async {
      final report = EnvironmentReport(
        probes: const [_FakeProbe('a', 'fail')],
      );

      await report.runAll();

      expect(report.results.single.detail, contains('sengaja gagal'));
    });

    test('notifyListeners dipanggil saat status berubah', () async {
      final report = EnvironmentReport(
        probes: const [_FakeProbe('a', 'pass')],
      );
      var notifications = 0;
      report.addListener(() => notifications++);

      await report.runAll();

      // Setidaknya: reset awal, running, selesai, dan penutup.
      expect(notifications, greaterThanOrEqualTo(4));
    });

    test('laporan JSON bisa di-decode dan memuat ringkasan', () async {
      final report = EnvironmentReport(probes: const [
        _FakeProbe('a', 'pass'),
        _FakeProbe('b', 'fail'),
      ]);

      await report.runAll();
      final decoded = jsonDecode(report.toPrettyJson()) as Map<String, dynamic>;

      expect(decoded['healthy'], isFalse);
      expect((decoded['summary'] as Map)['passed'], 1);
      expect((decoded['results'] as List), hasLength(2));
    });
  });
}
