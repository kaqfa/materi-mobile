import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/env_check/presentation/providers/env_check_provider.dart';
import 'features/env_check/presentation/screens/env_check_screen.dart';

class EnvCheckApp extends StatelessWidget {
  const EnvCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EnvCheckProvider(),
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const EnvCheckScreen(),
      ),
    );
  }
}
