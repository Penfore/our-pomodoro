import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/pomodoro/presentation/bloc/pomodoro_bloc.dart';
import 'features/pomodoro/presentation/bloc/pomodoro_event.dart';
import 'features/pomodoro/presentation/bloc/pomodoro_state.dart';
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
      home: BlocProvider(create: (_) => di.sl<PomodoroBloc>()..add(LoadCurrentSessionEvent()), child: const PomodoroHomePage()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PomodoroHomePage extends StatelessWidget {
  const PomodoroHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Our Pomodoro'), centerTitle: true),
      body: BlocBuilder<PomodoroBloc, PomodoroState>(
        builder: (context, state) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, size: 100, color: Colors.grey),
                SizedBox(height: 20),
                Text('Our Pomodoro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('App inicializado com arquitetura clean!', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
