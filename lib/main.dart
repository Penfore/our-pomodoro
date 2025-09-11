import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/pomodoro/presentation/pages/timer_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Pomodoro',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const TimerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
