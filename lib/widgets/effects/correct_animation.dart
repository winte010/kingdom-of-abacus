import 'package:flutter/material.dart';

/// Green sparkle animation for correct answers
class CorrectAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const CorrectAnimation({super.key, this.onComplete});

  @override
  State<CorrectAnimation> createState() => _CorrectAnimationState();
}

class _CorrectAnimationState extends State<CorrectAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(_controller);

    _controller.forward().then((_) => widget.onComplete?.call());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle,
          size: 100,
          color: Colors.green,
        ),
      ),
    );
  }
}
