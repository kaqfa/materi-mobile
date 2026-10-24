import 'package:flutter/material.dart';

/// Tema terpusat Mini CRM. Satu sumber kebenaran warna aplikasi.
abstract final class AppTheme {
  static const seedColor = Color(0xFF00695C);

  static ThemeData light() => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      );
}
