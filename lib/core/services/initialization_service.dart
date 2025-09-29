import 'package:flutter/material.dart';

import '../../injection_container.dart' as service_locator;
import 'audio_service.dart';
import 'notification_service.dart';

class InitializationService {
  static final InitializationService _instance =
      InitializationService._internal();
  factory InitializationService() => _instance;
  InitializationService._internal();

  static Future<void> initializeServices() async {
    await _initializeAudioService();
    await _initializeNotificationService();
  }

  static Future<void> _initializeAudioService() async {
    try {
      await service_locator.sl<AudioService>().initialize();
    } catch (e) {
      debugPrint('Erro ao inicializar AudioService: $e');
    }
  }

  static Future<void> _initializeNotificationService() async {
    try {
      final notificationService = service_locator.sl<NotificationService>();
      await notificationService.initialize();
      try {
        await notificationService.ensurePermissions();
      } catch (e) {
        debugPrint('Erro ao solicitar permissões de notificação: $e');
      }
    } catch (e) {
      debugPrint('Erro ao inicializar NotificationService: $e');
    }
  }
}
