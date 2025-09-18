import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/pomodoro_session.dart';
import '../bloc/pomodoro_bloc.dart';
import '../bloc/pomodoro_state.dart';

class PomodoroTimerWidget extends StatelessWidget {
  const PomodoroTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, state) {
        return Center(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimerCircle(context, state),
                  const SizedBox(height: 24),
                  _buildTimerText(state),
                  const SizedBox(height: 20),
                  _buildStatusText(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimerCircle(BuildContext context, PomodoroState state) {
    final screenWidth = MediaQuery.of(context).size.width;

    final size = (screenWidth * 0.45).clamp(160.0, 200.0);

    double progress = 0.0;
    Color circleColor = Theme.of(context).primaryColor;

    if (state is PomodoroRunning || state is PomodoroPaused) {
      final session = (state as dynamic).session as PomodoroSession;
      progress = session.progress;
      circleColor = _getColorForType(session.type);
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor.withValues(alpha: 0.1),
              border: Border.all(
                color: circleColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
          ),
          // Progress circle
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: progress,
              color: circleColor,
              strokeWidth: 6,
            ),
          ),
          // Timer display
          Center(child: _buildTimerDisplay(state)),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay(PomodoroState state) {
    if (state is PomodoroLoading) {
      return const CircularProgressIndicator();
    }

    if (state is PomodoroRunning || state is PomodoroPaused) {
      final session = (state as dynamic).session as PomodoroSession;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            session.formattedTime,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getColorForType(session.type).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getTypeLabel(session.type),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getColorForType(session.type),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '25:00',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Pronto para começar',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildTimerText(PomodoroState state) {
    if (state is PomodoroCompleted) {
      final session = state.session;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          '🎉 ${_getTypeLabel(session.type)} Concluído!',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildStatusText(PomodoroState state) {
    String statusText = '';
    Color statusColor = Colors.grey;

    if (state is PomodoroRunning) {
      statusText = 'Em andamento...';
      statusColor = Colors.green;
    } else if (state is PomodoroPaused) {
      statusText = 'Pausado';
      statusColor = Colors.orange;
    } else if (state is PomodoroCompleted) {
      statusText = 'Concluído';
      statusColor = Colors.blue;
    } else if (state is PomodoroError) {
      statusText = state.message;
      statusColor = Colors.red;
    }

    if (statusText.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: statusColor,
        ),
      ),
    );
  }

  Color _getColorForType(PomodoroType type) {
    switch (type) {
      case PomodoroType.work:
        return Colors.red.shade400;
      case PomodoroType.shortBreak:
        return Colors.green.shade400;
      case PomodoroType.longBreak:
        return Colors.blue.shade400;
    }
  }

  String _getTypeLabel(PomodoroType type) {
    switch (type) {
      case PomodoroType.work:
        return 'Trabalho';
      case PomodoroType.shortBreak:
        return 'Pausa Curta';
      case PomodoroType.longBreak:
        return 'Pausa Longa';
    }
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -pi / 2; // Start from top
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) {
    return other is _CircularProgressPainter &&
        other.progress == progress &&
        other.color == color &&
        other.strokeWidth == strokeWidth;
  }

  @override
  int get hashCode => Object.hash(progress, color, strokeWidth);
}
