import 'package:flutter/material.dart';

import 'screens/leave_list_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const HrisApp());

class HrisApp extends StatelessWidget {
  const HrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRIS Mini',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const LeaveListScreen(),
    );
  }
}
