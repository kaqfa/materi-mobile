import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/task_list_screen.dart';

void main() => runApp(const StudyTrackerApp());

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTracker P04',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
      ),
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.taskList: (_) => const TaskListScreen(),
      },
      // Route yang belum terdaftar di `routes` jatuh ke sini —
      // satu tempat untuk guard/error handling saat app membesar.
      onGenerateRoute: (settings) {
        // TODO(student) P04-3: tangani AppRoutes milikmu di sini,
        // kembalikan MaterialPageRoute + screen yang sesuai.
        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route belum terdaftar')),
          ),
        );
      },
    );
  }
}
