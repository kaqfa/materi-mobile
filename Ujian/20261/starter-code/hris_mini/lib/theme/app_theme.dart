import 'package:flutter/material.dart';

/// Tema terpusat HRIS mini. Satu sumber kebenaran warna & bentuk komponen,
/// sehingga widget Material baru (chip, tombol) otomatis tampil seragam.
abstract final class AppTheme {
  static const seedColor = Color(0xFF3F51B5);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: seedColor);
    final roundedShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF5F6FA),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant.withAlpha(120)),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: scheme.outlineVariant),
        showCheckmark: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: roundedShape),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: roundedShape),
      ),
      dividerTheme:
          DividerThemeData(color: scheme.outlineVariant.withAlpha(120)),
    );
  }
}
