import 'dart:async';

import 'package:flutter/material.dart';

/// Countdown timer with color-coded urgency
class TimerDisplay extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onExpired;
  final bool autoStart;

  const TimerDisplay({
    super.key,
    required this.duration,
    this.onExpired,
    this.autoStart = true,
  });

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay>
    with SingleTickerProviderStateMixin {
  late Duration _remaining;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    if (widget.autoStart) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining = Duration(seconds: _remaining.inSeconds - 1);

          // Start pulsing when low
          if (_remaining.inSeconds <= 4 && !_pulseController.isAnimating) {
            _pulseController.repeat(reverse: true);
          }
        } else {
          timer.cancel();
          widget.onExpired?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = _remaining.inSeconds;
    final color = _getColor(seconds);

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.1);

        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color, width: 3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  '${seconds}s',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  semanticsLabel: '$seconds seconds remaining',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getColor(int seconds) {
    if (seconds > 7) {
      return Colors.green;
    } else if (seconds > 4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
