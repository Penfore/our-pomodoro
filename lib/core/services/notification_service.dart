import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/pomodoro/domain/entities/pomodoro_session.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> requestPermission() async {
    if (await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission() ??
        true) {
      return true;
    }

    final iosPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    return await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        true;
  }

  /// Set notifications enabled/disabled
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
  }

  /// Show session complete notification
  Future<void> showSessionCompleteNotification(
    PomodoroType sessionType,
    int sessionNumber,
  ) async {
    if (!_notificationsEnabled) return;

    final (title, body) = _getNotificationContent(sessionType, sessionNumber);

    final androidDetails = AndroidNotificationDetails(
      'pomodoro_channel',
      'Notificações Pomodoro',
      channelDescription: 'Notificações para conclusões de sessões Pomodoro',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound(
        _getAndroidSoundName(sessionType),
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.show(0, title, body, notificationDetails);
    } catch (e) {
      // Silent fail - notification errors shouldn't break the app
    }
  }

  (String title, String body) _getNotificationContent(
    PomodoroType sessionType,
    int sessionNumber,
  ) {
    switch (sessionType) {
      case PomodoroType.work:
        return (
          '🍅 Sessão de Trabalho Concluída!',
          'Ótimo foco! Sessão $sessionNumber concluída. Hora de uma pausa!',
        );
      case PomodoroType.shortBreak:
        return (
          '☕ Pausa Concluída!',
          'Hora da pausa acabou. Pronto para a próxima sessão de foco?',
        );
      case PomodoroType.longBreak:
        return (
          '🎉 Pausa Longa Concluída!',
          'Excelente trabalho! Você completou um ciclo Pomodoro completo.',
        );
    }
  }

  String _getAndroidSoundName(PomodoroType sessionType) {
    switch (sessionType) {
      case PomodoroType.work:
        return 'session_complete';
      case PomodoroType.shortBreak:
      case PomodoroType.longBreak:
        return 'break_complete';
    }
  }

  /// Test notification - for debug purposes
  Future<void> testNotification() async {
    print('🧪 Testando notificação diretamente...');
    await showSessionCompleteNotification(PomodoroType.work, 1);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
