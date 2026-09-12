import 'package:flutter/material.dart';

/// Warna aplikasi Remedial Task Tracker.
/// Sumber tunggal untuk warna status agar konsisten di seluruh UI.
class AppColors {
  const AppColors._();

  static const Color seed = Color(0xFF3F51B5);

  static const Color primary = seed;
  static const Color onPrimary = Colors.white;

  static const Color statusPending = Color(0xFFFFA000);
  static const Color statusOverdue = Color(0xFFE53935);
  static const Color statusCompleted = Color(0xFF2E7D32);

  static const Color priorityHigh = Color(0xFFE53935);
  static const Color priorityMedium = Color(0xFFFFA000);
  static const Color priorityLow = Color(0xFF1E88E5);

  static const Color surfaceMuted = Color(0xFFF5F5F5);
}
