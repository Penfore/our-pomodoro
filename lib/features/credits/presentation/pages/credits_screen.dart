import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Créditos',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info
            _buildAppSection(),
            const SizedBox(height: 8),

            // Sound Assets
            _buildSoundAssetsSection(context),
            const SizedBox(height: 8),

            // Development
            _buildDevelopmentSection(),
            const SizedBox(height: 8),

            // Open Source
            _buildOpenSourceSection(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('🍅', style: TextStyle(fontSize: 24)),
                SizedBox(width: 12),
                Text(
                  'Our Pomodoro',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Aplicativo de produtividade baseado na Técnica Pomodoro, '
              'desenvolvido para ajudar você a manter o foco e alcançar seus objetivos.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Versão 0.3.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundAssetsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.volume_up, color: Colors.orange),
                SizedBox(width: 12),
                Text(
                  'Alertas Sonoros',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Os sons de alerta utilizados neste aplicativo são baseados em:',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),

            // Sound credit
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎵 "Chime 74910"',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Autor: freesound_community',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fonte: Pixabay',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Som original editado para criar diferentes variações de alertas.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(
                      'https://pixabay.com/sound-effects/chime-74910/',
                      'Link copiado para a área de transferência!',
                    ),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copiar Link'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Text(
              'Licença: Pixabay License (uso livre, incluindo comercial)',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _copyToClipboard(
                'https://pixabay.com/service/license-summary/',
                'Link da licença copiado!',
              ),
              child: Text(
                'Copiar link da licença →',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevelopmentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.code, color: Colors.blue),
                SizedBox(width: 12),
                Text(
                  'Desenvolvimento',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Desenvolvido com Flutter',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'Arquitetura Clean Architecture com BLoC pattern',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenSourceSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 12),
                Text(
                  'Código Aberto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Este aplicativo é open source. Você pode contribuir, '
              'reportar bugs ou sugerir melhorias.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bibliotecas principais utilizadas:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ..._buildLibraryList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLibraryList() {
    final libraries = [
      'flutter_bloc - Gerenciamento de estado',
      'get_it - Injeção de dependência',
      'audioplayers - Sistema de áudio',
      'flutter_local_notifications - Notificações',
      'shared_preferences - Armazenamento local',
    ];

    return libraries
        .map(
          (lib) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: Colors.grey.shade600)),
                Expanded(
                  child: Text(
                    lib,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
