/// Konstanta visual terpusat — contoh isi folder `utils/`.
///
/// Tujuan: satu sumber kebenaran untuk nilai yang dipakai di banyak
/// tempat, sehingga konsistensi terjaga tanpa magic number tersebar.
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const seed = Color(0xFF00695C);
  static const done = Color(0xFF2E7D32);
  static const overdue = Color(0xFFC62828);
}

abstract final class AppSpacing {
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
}
