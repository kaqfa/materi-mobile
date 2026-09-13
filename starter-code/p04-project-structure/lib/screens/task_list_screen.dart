import 'package:flutter/material.dart';

/// Screen tujuan named route `/tasks` — isi masih kosong by design.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: const Center(
        // TODO(student) P04-2: setelah service & model dipindah,
        // tampilkan list tugas di sini (pola dari P03).
        child: Text('Belum ada data — isi di checkpoint P04-2'),
      ),
    );
  }
}
