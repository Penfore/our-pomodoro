import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../injection_container.dart' as service_locator;
import 'audio_service.dart';
import 'notification_service.dart';

class InitializationService {
  static final InitializationService _instance =
      InitializationService._internal();
  factory InitializationService() => _instance;
  InitializationService._internal();

  static Future<void> initializeServices() async {
    _initializeTimezone();
    await _initializeAudioService();
    await _initializeNotificationService();
  }

  static void _initializeTimezone() {
    try {
      tz.initializeTimeZones();

      final String timezoneName = DateTime.now().timeZoneName;

      try {
        final location = tz.getLocation(timezoneName);
        tz.setLocalLocation(location);
      } catch (e) {
        final now = DateTime.now();
        final offset = now.timeZoneOffset;

        final matchingLocation = tz.timeZoneDatabase.locations.values
            .firstWhere((location) {
              final locationTime = tz.TZDateTime.now(location);
              return locationTime.timeZoneOffset == offset;
            }, orElse: () => tz.getLocation('UTC'));

        tz.setLocalLocation(matchingLocation);
        debugPrint('Timezone definido para: ${matchingLocation.name}');
      }
    } catch (e) {
      debugPrint('Erro ao inicializar timezone: $e');
      // Fallback to UTC if all else fails
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}
    }
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
