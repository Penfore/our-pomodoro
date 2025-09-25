import 'package:flutter/material.dart';

import 'core/services/initialization_service.dart';
import 'core/theme/app_theme.dart';
import 'features/pomodoro/presentation/pages/timer_screen.dart';
import 'injection_container.dart' as service_locator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await service_locator.init();

  await InitializationService.initializeServices();

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
