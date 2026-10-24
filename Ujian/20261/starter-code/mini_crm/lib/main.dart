import 'package:flutter/material.dart';

import 'screens/lead_list_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const MiniCrmApp());

class MiniCrmApp extends StatelessWidget {
  const MiniCrmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini CRM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const LeadListScreen(),
    );
  }
}
