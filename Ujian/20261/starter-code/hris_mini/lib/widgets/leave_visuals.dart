import 'package:flutter/material.dart';

import '../models/leave_request.dart';

/// Ikon & warna per tipe cuti, dipakai bersama oleh kartu dan layar detail.
extension LeaveTypeVisual on LeaveType {
  IconData get icon => switch (this) {
        LeaveType.annual => Icons.beach_access_rounded,
        LeaveType.sick => Icons.medical_services_rounded,
        LeaveType.unpaid => Icons.money_off_rounded,
      };

  Color get color => switch (this) {
        LeaveType.annual => const Color(0xFF1E88E5),
        LeaveType.sick => const Color(0xFF8E24AA),
        LeaveType.unpaid => const Color(0xFFEF6C00),
      };
}

/// Ikon & pasangan warna (latar, teks) per status pengajuan.
extension LeaveStatusVisual on LeaveStatus {
  IconData get icon => switch (this) {
        LeaveStatus.pending => Icons.schedule_rounded,
        LeaveStatus.approved => Icons.check_circle_rounded,
        LeaveStatus.rejected => Icons.cancel_rounded,
      };

  Color get background => switch (this) {
        LeaveStatus.pending => const Color(0xFFFFF3D6),
        LeaveStatus.approved => const Color(0xFFDDF4E4),
        LeaveStatus.rejected => const Color(0xFFFDE2E1),
      };

  Color get foreground => switch (this) {
        LeaveStatus.pending => const Color(0xFF8A5A00),
        LeaveStatus.approved => const Color(0xFF1B6B34),
        LeaveStatus.rejected => const Color(0xFFB3261E),
      };
}
