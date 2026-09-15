import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/environment_report.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const EnvCheckApp());
}

class EnvCheckApp extends StatelessWidget {
  const EnvCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EnvironmentReport(),
      child: MaterialApp(
        title: 'Env Check',
        debugShowCheckedModeBanner: false,
        // Bab 5: Material 3 aktif bawaan; skema dibangkitkan dari satu warna
        // benih, dan tema gelap mengikuti pengaturan sistem.
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00658F)),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00658F),
            brightness: Brightness.dark,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
