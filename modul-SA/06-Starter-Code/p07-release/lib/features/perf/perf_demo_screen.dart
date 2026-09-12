import 'package:flutter/material.dart';

/// Demo "const & rebuild basics" (P07). Menunjukkan:
/// - subtree `const` tidak dibangun ulang saat parent `setState`.
/// - pemisahan widget stateful kecil agar rebuild terbatas.
///
/// Pakai Flutter Inspector (atau `RepaintBoundary` + debug prints) untuk
/// melihat widget mana yang rebuild. Tujuan edukasi: **const menghemat
/// rebuild**, bukan sekadar gaya penulisan.
class PerfDemoScreen extends StatefulWidget {
  const PerfDemoScreen({super.key});

  @override
  State<PerfDemoScreen> createState() => _PerfDemoScreenState();
}

class _PerfDemoScreenState extends State<PerfDemoScreen> {
  int _counter = 0;

  void _bump() => setState(() => _counter += 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Const & Rebuild Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Subtree ini TIDAK bergantung _counter -> seharusnya const
          // supaya Flutter skip rebuild. Bandingkan dengan versi non-const.
          const _StaticCard(
            title: 'I am const',
            note: 'Tidak rebuild saat tombol ditekan.',
          ),
          const SizedBox(height: 12),
          Text('Counter: $_counter',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _bump,
            child: const Text('Bump (rebuild stateful)'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tips:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const _TipList(),
        ],
      ),
    );
  }
}

/// Stateless const. Saat di-instantiate sebagai `const _StaticCard(...)`,
/// instance sama dipakai ulang -> tidak rebuild walau parent setState.
class _StaticCard extends StatelessWidget {
  const _StaticCard({required this.title, required this.note});
  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(note),
          ],
        ),
      ),
    );
  }
}

class _TipList extends StatelessWidget {
  const _TipList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• Tandai widget immutable tanpa argumen dinamis sebagai const.'),
        Text('• Pisahkan state lokal ke StatefulWidget kecil.'),
        Text('• Hanya widget yang baca state yang rebuild.'),
        Text('• `prefer_const_constructors` lint menangkap banyak kasus.'),
      ],
    );
  }
}
