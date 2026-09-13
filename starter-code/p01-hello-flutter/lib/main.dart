import 'package:flutter/material.dart';

/// P01 — StudyTracker hello world.
///
/// Checkpoint ada di README.md. Penanda `TODO(student)` = tugas kamu.
void main() => runApp(const StudyTrackerApp());

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTracker',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(student) P01-2: simpan judul app di variabel `appTitle`
    // lalu pakai variabel itu di AppBar dan di Text sambutan di bawah.
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyTracker'),
      ),
      floatingActionButton: FloatingActionButton(
        // TODO(student) P01-3: isi `onPressed` dengan SnackBar
        // "Fitur tambah tugas dibuat di pertemuan berikutnya".
        onPressed: () {},
        tooltip: 'Tambah tugas',
        child: const Icon(Icons.add),
      ),
      body: const WelcomeBody(),
    );
  }
}

/// Isi [Column] ini dibaca dari atas ke bawah oleh Flutter —
/// itulah "widget tree": Column punya anak Text, Card, dan SizedBox.
class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Selamat datang di StudyTracker!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Tugas pertamamu:'),
                  const SizedBox(height: 8),
                  Text(
                    'Setup environment Flutter selesai 🎉',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          // TODO(student) P01-4: tambahkan widget Text kedua di bawah Card
          // berisi nama mata kuliah & semester, dibungkus Padding.
        ],
      ),
    );
  }
}
