import 'package:flutter/material.dart';

/// Theme terpusat — jantung konsistensi visual (RPS P05).
///
/// Hindari hardcode warna/spacing di screen; ambil dari sini
/// atau dari `Theme.of(context)`.
abstract final class AppTheme {
  static const seed = Color(0xFF00695C);

  static ThemeData light() {
    // TODO(student) P05-1: kustomisasi minimal: ganti seedColor,
    // tambahkan inputDecorationTheme (border rounded + padding),
    // dan atur cardTheme elevation 2.
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seed),
    );
  }
}
