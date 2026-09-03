import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/app_shell.dart';

class NihongoQuestApp extends StatelessWidget {
  const NihongoQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nihongo Quest',
      theme: AppTheme.dark(),
      home: const AppShell(),
    );
  }
}
