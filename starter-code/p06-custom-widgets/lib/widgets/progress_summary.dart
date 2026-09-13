import 'package:flutter/material.dart';

/// Ringkasan progres dashboard: x dari y selesai + progress bar.
class ProgressSummary extends StatelessWidget {
  const ProgressSummary({super.key, required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : done / total;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$done dari $total tugas selesai'),
          const SizedBox(height: 8),
          // TODO(student) P06-3: ganti LinearProgressIndicator dengan
          // TweenAnimationBuilder<double> agar perubahan ratio animatif.
          LinearProgressIndicator(value: ratio, minHeight: 8),
        ],
      ),
    );
  }
}
