import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

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

    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'pomodoro_channel',
      'Notificações Pomodoro',
      description: 'Notificações para conclusões de sessões Pomodoro',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      await android.createNotificationChannel(channel);
    }
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

  Future<bool> areNotificationsEnabled() async {
    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }

    return true; // Assume enabled for iOS
  }

  Future<bool> ensurePermissions() async {
    if (await areNotificationsEnabled()) {
      return true;
    }

    return await requestPermission();
  }

  /// Show session complete notification
  Future<void> showSessionCompleteNotification(
    PomodoroType sessionType,
    int sessionNumber,
  ) async {
    if (!_notificationsEnabled) return;

    if (!await ensurePermissions()) {
      return;
    }

    final (title, body) = _getNotificationContent(sessionType, sessionNumber);

    final androidDetails = AndroidNotificationDetails(
      'pomodoro_channel',
      'Notificações Pomodoro',
      channelDescription: 'Notificações para conclusões de sessões Pomodoro',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      autoCancel: false,
      ongoing: false,
      showProgress: false,
      maxProgress: 0,
      channelShowBadge: true,
      onlyAlertOnce: false,
      sound: RawResourceAndroidNotificationSound(
        _getAndroidSoundName(sessionType),
      ),
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
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

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> scheduleSessionCompletionNotification({
    required PomodoroType sessionType,
    required int sessionNumber,
    required DateTime scheduledTime,
  }) async {
    if (!_notificationsEnabled) return;

    if (!await ensurePermissions()) {
      return;
    }

    final (title, body) = _getNotificationContent(sessionType, sessionNumber);

    final androidDetails = AndroidNotificationDetails(
      'pomodoro_channel',
      'Notificações Pomodoro',
      channelDescription: 'Notificações para conclusões de sessões Pomodoro',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showWhen: true,
      when: scheduledTime.millisecondsSinceEpoch,
      autoCancel: false,
      ongoing: false,
      showProgress: false,
      maxProgress: 0,
      channelShowBadge: true,
      onlyAlertOnce: false,
      sound: RawResourceAndroidNotificationSound(
        _getAndroidSoundName(sessionType),
      ),
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        1,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      // Silent fail - notification errors shouldn't break the app
    }
  }

  Future<void> cancelScheduledNotification() async {
    try {
      await _notificationsPlugin.cancel(1);
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> sendTestNotification() async {
    if (!_notificationsEnabled) return;

    if (!await ensurePermissions()) {
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'pomodoro_channel',
      'Notificações Pomodoro',
      channelDescription: 'Notificações para conclusões de sessões Pomodoro',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      autoCancel: true,
      category: AndroidNotificationCategory.message,
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
      await _notificationsPlugin.show(
        999,
        '🔔 Teste de Notificação',
        'Se você está vendo isso, as notificações estão funcionando!',
        notificationDetails,
      );
    } catch (e) {
      // Silent fail
    }
  }
}
