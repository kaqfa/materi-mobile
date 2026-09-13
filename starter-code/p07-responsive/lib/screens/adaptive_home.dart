import 'package:flutter/material.dart';

import '../models/task.dart';
import '../utils/breakpoints.dart';
import '../widgets/task_tile.dart';

/// Adaptive home: 1 kolom (phone) / 2 kolom (tablet) / master-detail
/// (desktop) — keputusan lewat LayoutBuilder + breakpoint terpusat.
class AdaptiveHome extends StatelessWidget {
  const AdaptiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // Dynamic padding: margin ikut lebar layar, tapi dibatasi supaya
    // tidak lebar tak terbaca di tablet.
    final horizontal = (media.size.width * 0.04).clamp(12.0, 48.0);

    return Scaffold(
      appBar: AppBar(title: const Text('StudyTracker — Responsive')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (width >= Breakpoints.desktop) {
            // TODO(student) P07-3: master-detail dua panel —
            // kiri list (SizedBox width 360), kanan detail placeholder.
            return _twoColumn(horizontal);
          }
          if (width >= Breakpoints.tablet) {
            return _twoColumn(horizontal);
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontal),
            child: ListView.builder(
              itemCount: mockTasks.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: TaskTile(task: mockTasks[i]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _twoColumn(double horizontal) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 320, // kolom otomatis menyesuaikan lebar
          childAspectRatio: 2.4, // AspectRatio: jaga proporsi kartu
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: mockTasks.length,
        itemBuilder: (context, i) => TaskTile(task: mockTasks[i]),
      ),
    );
  }
}
