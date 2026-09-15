import 'package:env_check/models/check_result.dart';
import 'package:env_check/services/environment_report.dart';
import 'package:env_check/services/probe.dart';
import 'package:env_check/ui/home_page.dart';
import 'package:env_check/ui/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class _StubProbe extends Probe {
  const _StubProbe(this.id, {this.fails = false, this.delay = Duration.zero});

  @override
  final String id;
  final bool fails;

  /// Menunda penyelesaian probe agar keadaan "sedang berjalan" sempat
  /// teramati oleh test; tanpa ini probe selesai dalam microtask yang sama.
  final Duration delay;

  @override
  String get label => 'Stub $id';

  @override
  int get chapter => 3;

  @override
  Future<String> probe() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (fails) throw StateError('gagal terkendali');
    return 'baik';
  }
}

Widget _app(EnvironmentReport report) {
  return ChangeNotifierProvider.value(
    value: report,
    child: MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const HomePage(),
    ),
  );
}

void main() {
  testWidgets('menampilkan satu kartu per probe setelah selesai', (tester) async {
    final report = EnvironmentReport(probes: const [
      _StubProbe('a'),
      _StubProbe('b'),
    ]);

    await tester.pumpWidget(_app(report));
    await tester.pumpAndSettle();

    expect(find.text('Stub a'), findsOneWidget);
    expect(find.text('Stub b'), findsOneWidget);
    expect(find.byType(StatusChip), findsNWidgets(2));
  });

  testWidgets('ringkasan menyatakan siap ketika semua lolos', (tester) async {
    final report = EnvironmentReport(probes: const [_StubProbe('a')]);

    await tester.pumpWidget(_app(report));
    await tester.pumpAndSettle();

    expect(
      find.text('Lingkungan siap dipakai sampai bab 14'),
      findsOneWidget,
    );
    expect(find.text('1 lolos · 0 gagal · 0 dilewati'), findsOneWidget);
  });

  testWidgets('ringkasan menyebut jumlah kegagalan', (tester) async {
    final report = EnvironmentReport(probes: const [
      _StubProbe('a'),
      _StubProbe('b', fails: true),
    ]);

    await tester.pumpWidget(_app(report));
    await tester.pumpAndSettle();

    expect(find.text('1 pemeriksaan gagal'), findsOneWidget);
    expect(find.textContaining('gagal terkendali'), findsOneWidget);
  });

  testWidgets('tombol jalankan ulang memulai pemeriksaan lagi', (tester) async {
    final report = EnvironmentReport(
      probes: const [
        _StubProbe('a', delay: Duration(milliseconds: 50)),
      ],
    );

    await tester.pumpWidget(_app(report));
    await tester.pumpAndSettle();
    expect(report.results.single.status, CheckStatus.passed);

    await tester.tap(find.byKey(const Key('run-all')));
    await tester.pump();
    expect(report.running, isTrue);

    await tester.pumpAndSettle();
    expect(report.results.single.status, CheckStatus.passed);
  });

  testWidgets('daftar bisa di-scroll saat probe banyak', (tester) async {
    final report = EnvironmentReport(
      probes: [for (var i = 0; i < 20; i++) _StubProbe('p$i')],
    );

    await tester.pumpWidget(_app(report));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(const Key('check-list')), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
