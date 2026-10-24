import 'package:flutter/material.dart';

/// Tema terpusat HRIS mini. Satu sumber kebenaran warna aplikasi.
abstract final class AppTheme {
  static const seedColor = Color(0xFF1565C0);

  static ThemeData light() => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      );
}
