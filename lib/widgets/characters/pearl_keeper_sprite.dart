import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../config/character_config.dart';

/// Pearl Keeper character sprite with hand-drawn watercolor aesthetic
class PearlKeeperSprite extends StatefulWidget {
  final PearlKeeperState state;
  final double size;
  final VoidCallback? onAnimationComplete;
  final bool showPearl;

  const PearlKeeperSprite({
    super.key,
    this.state = PearlKeeperState.idle,
    this.size = CharacterConfig.defaultSize,
    this.onAnimationComplete,
    this.showPearl = true,
  });

  @override
  State<PearlKeeperSprite> createState() => _PearlKeeperSpriteState();
}

class _PearlKeeperSpriteState extends State<PearlKeeperSprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    final duration = _getDuration(widget.state);
    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: _getCurve(widget.state),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_shouldLoop(widget.state)) {
          _controller.repeat();
        } else {
          widget.onAnimationComplete?.call();
        }
      }
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(PearlKeeperSprite oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _controller.dispose();
      _initializeAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Duration _getDuration(PearlKeeperState state) {
    switch (state) {
      case PearlKeeperState.celebrate:
        return CharacterConfig.celebrateDuration;
      case PearlKeeperState.encourage:
        return CharacterConfig.encourageDuration;
      case PearlKeeperState.think:
        return CharacterConfig.thinkDuration;
      case PearlKeeperState.idle:
      default:
        return CharacterConfig.idleDuration;
    }
  }

  Curve _getCurve(PearlKeeperState state) {
    switch (state) {
      case PearlKeeperState.celebrate:
        return Curves.elasticOut;
      case PearlKeeperState.encourage:
        return Curves.easeInOut;
      case PearlKeeperState.think:
        return Curves.easeInOutBack;
      case PearlKeeperState.idle:
      default:
        return Curves.easeInOut;
    }
  }

  bool _shouldLoop(PearlKeeperState state) {
    return state == PearlKeeperState.idle;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: PearlKeeperPainter(
              state: widget.state,
              animationValue: _animation.value,
              showPearl: widget.showPearl,
            ),
          ),
        );
      },
    );
  }
}

/// Custom painter for hand-drawn watercolor Pearl Keeper
class PearlKeeperPainter extends CustomPainter {
  final PearlKeeperState state;
  final double animationValue;
  final bool showPearl;

  PearlKeeperPainter({
    required this.state,
    required this.animationValue,
    required this.showPearl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 100; // Base scale for drawing

    // Apply state-specific transformations
    canvas.save();
    _applyStateTransform(canvas, center, scale);

    // Draw Pearl Keeper from back to front
    _drawShadow(canvas, center, scale);
    _drawBody(canvas, center, scale);
    _drawArms(canvas, center, scale);
    _drawFace(canvas, center, scale);
    if (showPearl) {
      _drawPearl(canvas, center, scale);
    }
    _drawWaterEffects(canvas, center, scale);

    canvas.restore();
  }

  void _applyStateTransform(Canvas canvas, Offset center, double scale) {
    switch (state) {
      case PearlKeeperState.celebrate:
        // Jump and spin animation
        final jump = math.sin(animationValue * math.pi) * 15 * scale;
        final rotation = animationValue * math.pi * 2;
        canvas.translate(0, -jump);
        canvas.translate(center.dx, center.dy);
        canvas.rotate(rotation * 0.3); // Partial rotation for playfulness
        canvas.translate(-center.dx, -center.dy);
        break;

      case PearlKeeperState.encourage:
        // Wave animation - gentle side-to-side
        final wave = math.sin(animationValue * math.pi * 4) * 3 * scale;
        canvas.translate(wave, 0);
        break;

      case PearlKeeperState.think:
        // Head tilt animation
        final tilt = math.sin(animationValue * math.pi) * 0.15;
        canvas.translate(center.dx, center.dy);
        canvas.rotate(tilt);
        canvas.translate(-center.dx, -center.dy);
        break;

      case PearlKeeperState.idle:
        // Gentle breathing animation
        final breathe = math.sin(animationValue * math.pi * 2) * 0.02;
        final scaleValue = 1.0 + breathe;
        canvas.translate(center.dx, center.dy);
        canvas.scale(scaleValue, scaleValue);
        canvas.translate(-center.dx, -center.dy);
        break;

      default:
        break;
    }
  }

  void _drawShadow(Canvas canvas, Offset center, double scale) {
    final shadowPaint = Paint()
      ..color = Color(CharacterConfig.shadowColor).withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 40 * scale),
        width: 50 * scale,
        height: 15 * scale,
      ),
      shadowPaint,
    );
  }

  void _drawBody(Canvas canvas, Offset center, double scale) {
    // Main body - rounded otter shape
    final bodyPaint = Paint()
      ..color = Color(CharacterConfig.primaryColor)
          .withOpacity(CharacterConfig.watercolorOpacity)
      ..style = PaintingStyle.fill;

    final bodyPath = Path();
    bodyPath.addOval(Rect.fromCenter(
      center: center,
      width: 45 * scale,
      height: 55 * scale,
    ));
    canvas.drawPath(bodyPath, bodyPaint);

    // Body outline - hand-drawn style
    final outlinePaint = Paint()
      ..color = Color(CharacterConfig.shadowColor)
      ..style = PaintingStyle.stroke
      ..strokeWidth = CharacterConfig.strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(bodyPath, outlinePaint);

    // Belly patch - lighter color
    final bellyPaint = Paint()
      ..color = Color(CharacterConfig.accentColor)
          .withOpacity(CharacterConfig.watercolorOpacity);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 8 * scale),
        width: 28 * scale,
        height: 35 * scale,
      ),
      bellyPaint,
    );
  }

  void _drawArms(Canvas canvas, Offset center, double scale) {
    final armPaint = Paint()
      ..color = Color(CharacterConfig.secondaryColor)
          .withOpacity(CharacterConfig.watercolorOpacity)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Color(CharacterConfig.shadowColor)
      ..style = PaintingStyle.stroke
      ..strokeWidth = CharacterConfig.strokeWidth
      ..strokeCap = StrokeCap.round;

    // Arm animation based on state
    double leftArmAngle = 0;
    double rightArmAngle = 0;

    if (state == PearlKeeperState.encourage) {
      // Waving paws
      rightArmAngle = math.sin(animationValue * math.pi * 4) * 0.5;
    } else if (state == PearlKeeperState.celebrate) {
      // Both arms up in celebration
      leftArmAngle = -0.3;
      rightArmAngle = -0.3;
    }

    // Left arm
    final leftArmPath = Path()
      ..moveTo(center.dx - 15 * scale, center.dy)
      ..quadraticBezierTo(
        center.dx - 25 * scale,
        center.dy + 5 * scale,
        center.dx - 22 * scale + math.sin(leftArmAngle) * 8 * scale,
        center.dy + 15 * scale + math.cos(leftArmAngle) * 8 * scale,
      );
    canvas.drawPath(leftArmPath, armPaint);
    canvas.drawPath(leftArmPath, outlinePaint);

    // Right arm
    final rightArmPath = Path()
      ..moveTo(center.dx + 15 * scale, center.dy)
      ..quadraticBezierTo(
        center.dx + 25 * scale,
        center.dy + 5 * scale,
        center.dx + 22 * scale + math.sin(rightArmAngle) * 8 * scale,
        center.dy + 15 * scale + math.cos(rightArmAngle) * 8 * scale,
      );
    canvas.drawPath(rightArmPath, armPaint);
    canvas.drawPath(rightArmPath, outlinePaint);

    // Paws
    _drawPaw(canvas, center.dx - 22 * scale, center.dy + 15 * scale, scale);
    _drawPaw(canvas, center.dx + 22 * scale, center.dy + 15 * scale, scale);
  }

  void _drawPaw(Canvas canvas, double x, double y, double scale) {
    final pawPaint = Paint()
      ..color = Color(CharacterConfig.shadowColor)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), 4 * scale, pawPaint);
  }

  void _drawFace(Canvas canvas, Offset center, double scale) {
    final facePaint = Paint()
      ..color = Color(CharacterConfig.shadowColor)
      ..style = PaintingStyle.fill;

    // Eyes
    double eyeSize = 3.5 * scale;
    double eyeY = center.dy - 8 * scale;

    // Thinking state - eyes look up
    if (state == PearlKeeperState.think) {
      eyeY -= 2 * scale;
    }

    // Left eye
    canvas.drawCircle(
      Offset(center.dx - 10 * scale, eyeY),
      eyeSize,
      facePaint,
    );

    // Right eye
    canvas.drawCircle(
      Offset(center.dx + 10 * scale, eyeY),
      eyeSize,
      facePaint,
    );

    // Eye highlights
    final highlightPaint = Paint()
      ..color = Color(CharacterConfig.highlightColor);

    canvas.drawCircle(
      Offset(center.dx - 9 * scale, eyeY - 1 * scale),
      1.2 * scale,
      highlightPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + 11 * scale, eyeY - 1 * scale),
      1.2 * scale,
      highlightPaint,
    );

    // Nose
    final nosePath = Path();
    nosePath.moveTo(center.dx, center.dy);
    nosePath.lineTo(center.dx - 2 * scale, center.dy + 2 * scale);
    nosePath.lineTo(center.dx + 2 * scale, center.dy + 2 * scale);
    nosePath.close();
    canvas.drawPath(nosePath, facePaint);

    // Mouth - changes based on state
    final mouthPaint = Paint()
      ..color = Color(CharacterConfig.shadowColor)
      ..style = PaintingStyle.stroke
      ..strokeWidth = CharacterConfig.strokeWidth
      ..strokeCap = StrokeCap.round;

    if (state == PearlKeeperState.celebrate) {
      // Big smile
      final smilePath = Path()
        ..moveTo(center.dx - 8 * scale, center.dy + 5 * scale)
        ..quadraticBezierTo(
          center.dx,
          center.dy + 10 * scale,
          center.dx + 8 * scale,
          center.dy + 5 * scale,
        );
      canvas.drawPath(smilePath, mouthPaint);
    } else {
      // Small content smile
      final smilePath = Path()
        ..moveTo(center.dx - 6 * scale, center.dy + 5 * scale)
        ..quadraticBezierTo(
          center.dx,
          center.dy + 7 * scale,
          center.dx + 6 * scale,
          center.dy + 5 * scale,
        );
      canvas.drawPath(smilePath, mouthPaint);
    }

    // Whiskers
    final whiskerPaint = Paint()
      ..color = Color(CharacterConfig.shadowColor).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Left whiskers
    canvas.drawLine(
      Offset(center.dx - 18 * scale, center.dy - 2 * scale),
      Offset(center.dx - 28 * scale, center.dy - 4 * scale),
      whiskerPaint,
    );
    canvas.drawLine(
      Offset(center.dx - 18 * scale, center.dy + 1 * scale),
      Offset(center.dx - 28 * scale, center.dy + 1 * scale),
      whiskerPaint,
    );

    // Right whiskers
    canvas.drawLine(
      Offset(center.dx + 18 * scale, center.dy - 2 * scale),
      Offset(center.dx + 28 * scale, center.dy - 4 * scale),
      whiskerPaint,
    );
    canvas.drawLine(
      Offset(center.dx + 18 * scale, center.dy + 1 * scale),
      Offset(center.dx + 28 * scale, center.dy + 1 * scale),
      whiskerPaint,
    );
  }

  void _drawPearl(Canvas canvas, Offset center, double scale) {
    // Pearl in paws or floating nearby
    Offset pearlPosition = Offset(center.dx, center.dy + 18 * scale);

    if (state == PearlKeeperState.celebrate) {
      // Pearl floating above during celebration
      pearlPosition = Offset(
        center.dx,
        center.dy - 25 * scale + math.sin(animationValue * math.pi * 2) * 5 * scale,
      );
    }

    // Pearl glow
    final glowPaint = Paint()
      ..color = Color(CharacterConfig.pearlColor).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(pearlPosition, 8 * scale, glowPaint);

    // Pearl body
    final pearlPaint = Paint()
      ..color = Color(CharacterConfig.pearlColor)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(pearlPosition, 5 * scale, pearlPaint);

    // Pearl highlight
    final highlightPaint = Paint()
      ..color = Color(CharacterConfig.highlightColor).withOpacity(0.8);

    canvas.drawCircle(
      Offset(pearlPosition.dx - 2 * scale, pearlPosition.dy - 2 * scale),
      2 * scale,
      highlightPaint,
    );

    // Pearl outline
    final outlinePaint = Paint()
      ..color = Color(CharacterConfig.shadowColor).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(pearlPosition, 5 * scale, outlinePaint);
  }

  void _drawWaterEffects(Canvas canvas, Offset center, double scale) {
    // Subtle water droplets or sparkles
    if (state == PearlKeeperState.celebrate) {
      final sparklesPaint = Paint()
        ..color = Color(CharacterConfig.waterColor).withOpacity(0.6)
        ..style = PaintingStyle.fill;

      // Draw sparkles around character
      for (int i = 0; i < 5; i++) {
        final angle = (animationValue * math.pi * 2) + (i * math.pi * 2 / 5);
        final distance = 35 * scale;
        final sparkleX = center.dx + math.cos(angle) * distance;
        final sparkleY = center.dy + math.sin(angle) * distance;

        _drawSparkle(canvas, Offset(sparkleX, sparkleY), scale * 0.6, sparklesPaint);
      }
    }
  }

  void _drawSparkle(Canvas canvas, Offset position, double scale, Paint paint) {
    final path = Path();
    path.moveTo(position.dx, position.dy - 4 * scale);
    path.lineTo(position.dx + 1 * scale, position.dy - 1 * scale);
    path.lineTo(position.dx + 4 * scale, position.dy);
    path.lineTo(position.dx + 1 * scale, position.dy + 1 * scale);
    path.lineTo(position.dx, position.dy + 4 * scale);
    path.lineTo(position.dx - 1 * scale, position.dy + 1 * scale);
    path.lineTo(position.dx - 4 * scale, position.dy);
    path.lineTo(position.dx - 1 * scale, position.dy - 1 * scale);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PearlKeeperPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.showPearl != showPearl;
  }
}
