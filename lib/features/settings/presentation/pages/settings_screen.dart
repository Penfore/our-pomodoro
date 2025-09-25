import 'package:flutter/material.dart';

import '../../../../core/services/audio_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../injection_container.dart' as service_locator;
import '../../../credits/presentation/pages/credits_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AudioService _audioService = service_locator.sl<AudioService>();
  final NotificationService _notificationService = service_locator
      .sl<NotificationService>();

  late bool _soundEnabled;
  late bool _notificationsEnabled;
  late double _volume;

  @override
  void initState() {
    super.initState();
    _soundEnabled = _audioService.soundEnabled;
    _notificationsEnabled = _notificationService.notificationsEnabled;
    _volume = _audioService.volume;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Áudio e Notificações',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Alertas Sonoros'),
                        subtitle: const Text(
                          'Tocar som quando as sessões terminarem',
                        ),
                        value: _soundEnabled,
                        onChanged: (value) {
                          setState(() {
                            _soundEnabled = value;
                          });
                          _audioService.setSoundEnabled(value);
                        },
                        secondary: const Icon(Icons.volume_up),
                      ),
                      if (_soundEnabled) ...[
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.volume_down),
                          title: const Text('Volume'),
                          subtitle: Slider(
                            value: _volume,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: '${(_volume * 100).round()}%',
                            onChanged: (value) {
                              setState(() {
                                _volume = value;
                              });
                              _audioService.setVolume(value);
                            },
                          ),
                          trailing: const Icon(Icons.volume_up),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.play_circle_outline),
                          title: const Text('Testar Som'),
                          subtitle: const Text(
                            'Ouvir som de conclusão de sessão',
                          ),
                          onTap: () async {
                            await _audioService.playSound(
                              SoundType.sessionComplete,
                            );
                          },
                          trailing: const Icon(Icons.chevron_right),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.notification_add),
                          title: const Text('Testar Notificação'),
                          subtitle: const Text('Mostrar notificação de teste'),
                          onTap: () async {
                            await _notificationService.testNotification();
                          },
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ],
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Notificações'),
                        subtitle: const Text(
                          'Mostrar notificações quando as sessões terminarem',
                        ),
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                          _notificationService.setNotificationsEnabled(value);
                        },
                        secondary: const Icon(Icons.notifications),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Credits Button
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blue),
                  title: const Text('Créditos'),
                  subtitle: const Text(
                    'Informações sobre o app e recursos utilizados',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const CreditsScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    const Text(
                      'Sobre os Alertas Sonoros',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Os alertas sonoros ajudam você a manter o foco fornecendo feedback de áudio quando as sessões terminam. Sons diferentes tocam para sessões de trabalho, pausas e conclusões de ciclo completo.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
