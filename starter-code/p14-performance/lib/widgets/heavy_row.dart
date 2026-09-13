import 'package:flutter/material.dart';

/// Simulasi "pekerjaan berat" di dalam build — biang keladi jank.
///
/// Di app nyata: format tanggal berulang, parse JSON di build,
/// penghitungan statistik, dsb. Prinsip: hitung SEKALI, simpan
/// hasilnya — bukan berulang tiap frame.
String expensiveLabel(String seed, int n) {
  var result = seed;
  for (var i = 0; i < n; i++) {
    result = '${seed[i % seed.length]}$result'.substring(0, seed.length);
  }
  return result;
}

class HeavyRow extends StatelessWidget {
  const HeavyRow({super.key, required this.index, required this.label});

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    // TODO(student) P14-1: pindahkan expensiveLabel keluar dari build
    // (hitung saat data dibuat / cache) lalu bandingkan frame timing
    // di DevTools sebelum-sesudah.
    final heavy = expensiveLabel(label, 2000);

    return ListTile(
      dense: true,
      leading: CircleAvatar(child: Text('$index')),
      title: Text('Tugas #$index — $heavy'),
    );
  }
}
