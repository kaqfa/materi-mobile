import 'dart:async';
import 'dart:convert';

import 'probe.dart';

/// Bab 1-2: bahasanya sendiri. Kalau ini gagal, yang salah bukan paket,
/// melainkan versi SDK Dart yang dipakai.
class DartLanguageProbe extends Probe {
  const DartLanguageProbe();

  @override
  String get id => 'dart-language';

  @override
  String get label => 'Dart: null safety, generics, pattern matching';

  @override
  int get chapter => 2;

  @override
  Future<String> probe() async {
    // Null safety dan promosi tipe.
    String? maybe = DateTime.now().isUtc ? null : 'ada';
    final promoted = maybe == null ? 'kosong' : maybe.toUpperCase();
    if (promoted != 'ADA') {
      throw StateError('promosi tipe null safety tidak seperti yang diduga');
    }

    // Generics dan collection-if/for.
    final squares = <int, int>{for (var i = 1; i <= 4; i++) i: i * i};
    if (squares[3] != 9) throw StateError('generics/map literal gagal');

    // Records dan destructuring (Dart 3).
    final (name, score) = ('tracker', 88);
    if (name.isEmpty || score < 0) throw StateError('record gagal');

    // Pattern matching pada switch expression.
    final grade = switch (score) {
      >= 85 => 'A',
      >= 70 => 'B',
      _ => 'C',
    };
    if (grade != 'A') throw StateError('switch expression gagal');

    // Async/await dan Future.
    final delayed = await Future<int>.delayed(
      const Duration(milliseconds: 1),
      () => 42,
    );
    if (delayed != 42) throw StateError('async/await gagal');

    // Stream.
    final sum = await Stream.fromIterable([1, 2, 3]).fold<int>(0, (a, b) => a + b);
    if (sum != 6) throw StateError('stream gagal');

    // JSON: dasar semua serialisasi di bab 9-10.
    final round = jsonDecode(jsonEncode({'ok': true})) as Map<String, dynamic>;
    if (round['ok'] != true) throw StateError('jsonEncode/Decode gagal');

    return 'null safety, generics, records, pattern matching, async, stream, JSON';
  }
}
