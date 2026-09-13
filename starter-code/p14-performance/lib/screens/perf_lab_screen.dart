import 'package:flutter/material.dart';

import '../widgets/heavy_row.dart';

/// Badge penghitung rebuild — bukti kasat mata optimasi.
class RebuildBadge extends StatefulWidget {
  const RebuildBadge({super.key, required this.label});

  final String label;

  @override
  State<RebuildBadge> createState() => _RebuildBadgeState();
}

class _RebuildBadgeState extends State<RebuildBadge> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('${widget.label}: $_builds build'),
    );
  }
}

class PerfLabScreen extends StatefulWidget {
  const PerfLabScreen({super.key});

  @override
  State<PerfLabScreen> createState() => _PerfLabScreenState();
}

enum ListMode { naive, builder }

class _PerfLabScreenState extends State<PerfLabScreen> {
  var _mode = ListMode.builder;
  int _count = 500;
  int _rebuildTrigger = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyTracker — Perf Lab'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: RebuildBadge(label: 'AppBar'),
          ),
        ],
      ),
      body: Column(
        children: [
          SegmentedButton<ListMode>(
            segments: const [
              ButtonSegment(
                value: ListMode.naive,
                label: Text('Column (naive)'),
                icon: Icon(Icons.warning_amber),
              ),
              ButtonSegment(
                value: ListMode.builder,
                label: Text('ListView.builder'),
                icon: Icon(Icons.speed),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
          Slider(
            value: _count.toDouble(),
            min: 100,
            max: 3000,
            divisions: 29,
            label: '$_count item',
            onChanged: (v) => setState(() => _count = v.round()),
          ),
          FilledButton.tonal(
            // Memicu rebuild seluruh screen — amati badge & frame timing.
            onPressed: () => setState(() => _rebuildTrigger++),
            child: const Text('Paksa rebuild'),
          ),
          Text('rebuild #$_rebuildTrigger — buka DevTools → Performance'),
          Expanded(
            child: _mode == ListMode.builder
                ? ListView.builder(
                    // itemExtent: tinggi baris seragam -> hitung layout O(1)
                    // per item saat scroll. Hapus lalu rasakan bedanya.
                    itemExtent: 56,
                    itemCount: _count,
                    itemBuilder: (context, i) => HeavyRow(index: i, label: 'belajar'),
                  )
                // Naive: SEMUA widget dibangun sejak awal — scroll lambat,
                // memori membengkak. Untuk eksperimen saja.
                : ListView(
                    children: [
                      for (var i = 0; i < _count; i++)
                        HeavyRow(index: i, label: 'belajar'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
