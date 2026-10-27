import 'package:flutter/material.dart';

import '../models/leave_request.dart';
import 'leave_visuals.dart';

/// Avatar inisial karyawan, diwarnai sesuai tipe cuti.
/// Dibungkus [Hero] agar beranimasi saat berpindah ke layar detail.
class EmployeeAvatar extends StatelessWidget {
  const EmployeeAvatar({super.key, required this.request, this.radius = 22});

  final LeaveRequest request;
  final double radius;

  String get _initials {
    final words = request.employee.trim().split(RegExp(r'\s+'));
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final color = request.type.color;
    return Hero(
      tag: 'avatar-${request.id}',
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Color.alphaBlend(
          color.withAlpha(36),
          Colors.white,
        ),
        child: Text(
          _initials,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: radius * 0.7,
          ),
        ),
      ),
    );
  }
}
