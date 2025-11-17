import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../config/character_config.dart';

/// Pearl Keeper character sprite with hand-drawn watercolor aesthetic
class PearlKeeperSprite extends StatefulWidget {
  final PearlKeeperState state;
  final double size;
  final VoidCallback? onTap;
  final bool showParticles;

  const PearlKeeperSprite({
    super.key,
    this.state = PearlKeeperState.idle,
    this.size = CharacterConfig.defaultSize,
    this.onTap,
    this.showParticles = true,
  });

  @override
  State<PearlKeeperSprite> createState() => _PearlKeeperSpriteState();
}

class _PearlKeeperSpriteState extends State<PearlKeeperSprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  AnimationSequenceConfig? _currentSequence;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: CharacterConfig.idleDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _updateAnimation(widget.state);
  }

  @override
  void didUpdateWidget(PearlKeeperSprite oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _updateAnimation(widget.state);
    }
  }

  void _updateAnimation(PearlKeeperState state) {
    switch (state) {
      case PearlKeeperState.celebrate:
        _currentSequence = PearlKeeperAnimations.celebrate;
        break;
      case PearlKeeperState.encourage:
        _currentSequence = PearlKeeperAnimations.encourage;
        break;
      case PearlKeeperState.think:
        _currentSequence = PearlKeeperAnimations.think;
        break;
      case PearlKeeperState.idle:
      default:
        _currentSequence = PearlKeeperAnimations.idle;
        break;
    }

    _controller.duration = _currentSequence!.duration;

    if (_currentSequence!.loops) {
      _controller.repeat();
    } else {
      _controller.reset();
      _controller.forward().then((_) {
        // Return to idle after animation completes
        if (mounted && state != PearlKeeperState.idle) {
          setState(() {
            _updateAnimation(PearlKeeperState.idle);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AnimationKeyframe _getInterpolatedKeyframe() {
    if (_currentSequence == null || _currentSequence!.keyframes.isEmpty) {
      return const AnimationKeyframe(time: 0);
    }

    final keyframes = _currentSequence!.keyframes;
    final progress = _animation.value;

    // Find the two keyframes to interpolate between
    AnimationKeyframe? before;
    AnimationKeyframe? after;

    for (int i = 0; i < keyframes.length - 1; i++) {
      if (progress >= keyframes[i].time && progress <= keyframes[i + 1].time) {
        before = keyframes[i];
        after = keyframes[i + 1];
        break;
      }
    }

    // Handle edge cases
    if (before == null || after == null) {
      return keyframes.last;
    }

    // Interpolate between keyframes
    final range = after.time - before.time;
    final localProgress = range > 0 ? (progress - before.time) / range : 0;

    return AnimationKeyframe(
      time: progress,
      x: before.x + (after.x - before.x) * localProgress,
      y: before.y + (after.y - before.y) * localProgress,
      rotation: before.rotation + (after.rotation - before.rotation) * localProgress,
      scale: before.scale + (after.scale - before.scale) * localProgress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: CharacterConfig.allowTapInteraction ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final keyframe = _getInterpolatedKeyframe();

          return Transform.translate(
            offset: Offset(keyframe.x, keyframe.y),
            child: Transform.rotate(
              angle: keyframe.rotation,
              child: Transform.scale(
                scale: keyframe.scale,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Main character
                      CustomPaint(
                        size: Size(widget.size, widget.size),
                        painter: PearlKeeperPainter(
                          state: widget.state,
                          animationProgress: _animation.value,
                        ),
                      ),
                      // Celebration particles
                      if (widget.showParticles &&
                          widget.state == PearlKeeperState.celebrate)
                        CustomPaint(
                          size: Size(widget.size * 1.5, widget.size * 1.5),
                          painter: CelebrationParticlesPainter(
                            progress: _animation.value,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for Pearl Keeper character with hand-drawn aesthetic
class PearlKeeperPainter extends CustomPainter {
  final PearlKeeperState state;
  final double animationProgress;

  PearlKeeperPainter({
    required this.state,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw shadow if enabled
    if (CharacterConfig.enableShadows) {
      _drawShadow(canvas, size);
    }

    // Draw body (main otter shape)
    _drawBody(canvas, size);

    // Draw belly
    _drawBelly(canvas, size);

    // Draw arms/paws based on state
    _drawArms(canvas, size);

    // Draw head
    _drawHead(canvas, size);

    // Draw face based on state
    _drawFace(canvas, size);

    // Draw ears
    _drawEars(canvas, size);

    // Draw pearl (optional - small pearl in paws)
    if (state == PearlKeeperState.idle || state == PearlKeeperState.think) {
      _drawPearl(canvas, size);
    }
  }

  void _drawShadow(Canvas canvas, Size size) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final shadowPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.9),
        width: size.width * 0.6,
        height: size.height * 0.15,
      ));

    canvas.drawPath(shadowPath, shadowPaint);
  }

  void _drawBody(Canvas canvas, Size size) {
    final bodyPaint = Paint()
      ..color = Color(CharacterConfig.primaryBrown)
          .withOpacity(CharacterConfig.watercolorOpacity)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Color(CharacterConfig.noseBlack).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = CharacterConfig.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Organic, hand-drawn body shape
    final bodyPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.45)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.35,
        size.width * 0.3,
        size.height * 0.25,
        size.width * 0.5,
        size.height * 0.25,
      )
      ..cubicTo(
        size.width * 0.7,
        size.height * 0.25,
        size.width * 0.75,
        size.height * 0.35,
        size.width * 0.7,
        size.height * 0.45,
      )
      ..cubicTo(
        size.width * 0.75,
        size.height * 0.65,
        size.width * 0.7,
        size.height * 0.75,
        size.width * 0.5,
        size.height * 0.75,
      )
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.75,
        size.width * 0.25,
        size.height * 0.65,
        size.width * 0.3,
        size.height * 0.45,
      )
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);
    canvas.drawPath(bodyPath, outlinePaint);
  }

  void _drawBelly(Canvas canvas, Size size) {
    final bellyPaint = Paint()
      ..color = Color(CharacterConfig.bellyWhite)
          .withOpacity(CharacterConfig.watercolorOpacity)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Color(CharacterConfig.noseBlack).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = CharacterConfig.strokeWidth * 0.8;

    final bellyPath = Path()
      ..moveTo(size.width * 0.4, size.height * 0.4)
      ..cubicTo(
        size.width * 0.38,
        size.height * 0.35,
        size.width * 0.62,
        size.height * 0.35,
        size.width * 0.6,
        size.height * 0.4,
      )
      ..cubicTo(
        size.width * 0.62,
        size.height * 0.6,
        size.width * 0.38,
        size.height * 0.6,
        size.width * 0.4,
        size.height * 0.4,
      )
      ..close();

    canvas.drawPath(bellyPath, bellyPaint);
    canvas.drawPath(bellyPath, outlinePaint);
  }

  void _drawArms(Canvas canvas, Size size) {
    final armPaint = Paint()
      ..color = Color(CharacterConfig.secondaryBrown)
          .withOpacity(CharacterConfig.watercolorOpacity)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Color(CharacterConfig.noseBlack).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = CharacterConfig.strokeWidth;

    // Arm positions vary by state
    double leftArmAngle = 0;
    double rightArmAngle = 0;

    if (state == PearlKeeperState.encourage) {
      // Waving motion
      leftArmAngle = math.sin(animationProgress * math.pi * 4) * 0.3;
      rightArmAngle = -math.sin(animationProgress * math.pi * 4) * 0.3;
    } else if (state == PearlKeeperState.celebrate) {
      // Arms up!
      leftArmAngle = -0.5;
      rightArmAngle = 0.5;
    } else if (state == PearlKeeperState.think) {
      // One paw to head
      rightArmAngle = -0.8;
    }

    // Left arm
    canvas.save();
    canvas.translate(size.width * 0.35, size.height * 0.5);
    canvas.rotate(leftArmAngle);
    final leftArmPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.15,
        height: size.height * 0.25,
      ));
    canvas.drawPath(leftArmPath, armPaint);
    canvas.drawPath(leftArmPath, outlinePaint);
    canvas.restore();

    // Right arm
    canvas.save();
    canvas.translate(size.width * 0.65, size.height * 0.5);
    canvas.rotate(rightArmAngle);
    final rightArmPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.15,
        height: size.height * 0.25,
      ));
    canvas.drawPath(rightArmPath, armPaint);
    canvas.drawPath(rightArmPath, outlinePaint);
    canvas.restore();
  }

  void _drawHead(Canvas canvas, Size size) {
    final headPaint = Paint()
      ..color = Color(CharacterConfig.primaryBrown)
          .withOpacity(CharacterConfig.watercolorOpacity)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Color(CharacterConfig.noseBlack).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = CharacterConfig.strokeWidth;

    // Head tilt based on state
    double headTilt = 0;
    if (state == PearlKeeperState.think) {
      headTilt = 0.15 * math.sin(animationProgress * math.pi);
    }

    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.3);
    canvas.rotate(headTilt);

    final headPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.45,
        height: size.height * 0.4,
      ));

    canvas.drawPath(headPath, headPaint);
    canvas.drawPath(headPath, outlinePaint);
    canvas.restore();
  }

  void _drawEars(Canvas canvas, Size size) {
    final earPaint = Paint()
      ..color = Color(CharacterConfig.primaryBrown)
          .withOpacity(CharacterConfig.watercolorOpacity)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Color(CharacterConfig.noseBlack).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = CharacterConfig.strokeWidth * 0.8;

    // Left ear
    final leftEar = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.35, size.height * 0.18),
        width: size.width * 0.12,
        height: size.height * 0.12,
      ));
    canvas.drawPath(leftEar, earPaint);
    canvas.drawPath(leftEar, outlinePaint);

    // Right ear
    final rightEar = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.65, size.height * 0.18),
        width: size.width * 0.12,
        height: size.height * 0.12,
      ));
    canvas.drawPath(rightEar, earPaint);
    canvas.drawPath(rightEar, outlinePaint);
  }

  void _drawFace(Canvas canvas, Size size) {
    final eyePaint = Paint()
      ..color = Color(CharacterConfig.noseBlack)
      ..style = PaintingStyle.fill;

    // Eyes (happy when celebrating, normal otherwise)
    if (state == PearlKeeperState.celebrate) {
      // Happy closed eyes (arcs)
      final eyeArcPaint = Paint()
        ..color = Color(CharacterConfig.noseBlack)
        ..style = PaintingStyle.stroke
        ..strokeWidth = CharacterConfig.strokeWidth
        ..strokeCap = StrokeCap.round;

      // Left eye
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.4, size.height * 0.28),
          width: size.width * 0.1,
          height: size.height * 0.08,
        ),
        0,
        math.pi,
        false,
        eyeArcPaint,
      );

      // Right eye
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.6, size.height * 0.28),
          width: size.width * 0.1,
          height: size.height * 0.08,
        ),
        0,
        math.pi,
        false,
        eyeArcPaint,
      );
    } else {
      // Normal eyes
      canvas.drawCircle(
        Offset(size.width * 0.4, size.height * 0.28),
        size.width * 0.04,
        eyePaint,
      );
      canvas.drawCircle(
        Offset(size.width * 0.6, size.height * 0.28),
        size.width * 0.04,
        eyePaint,
      );

      // Eye highlights
      final highlightPaint = Paint()..color = Colors.white;
      canvas.drawCircle(
        Offset(size.width * 0.405, size.height * 0.275),
        size.width * 0.015,
        highlightPaint,
      );
      canvas.drawCircle(
        Offset(size.width * 0.605, size.height * 0.275),
        size.width * 0.015,
        highlightPaint,
      );
    }

    // Nose
    final nosePaint = Paint()
      ..color = Color(CharacterConfig.noseBlack)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.34),
        width: size.width * 0.06,
        height: size.height * 0.04,
      ),
      nosePaint,
    );

    // Mouth (smile when celebrating/encouraging)
    final mouthPaint = Paint()
      ..color = Color(CharacterConfig.noseBlack).withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = CharacterConfig.strokeWidth
      ..strokeCap = StrokeCap.round;

    if (state == PearlKeeperState.celebrate ||
        state == PearlKeeperState.encourage) {
      // Happy smile
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.36),
          width: size.width * 0.15,
          height: size.height * 0.12,
        ),
        0.2,
        math.pi * 0.8,
        false,
        mouthPaint,
      );
    } else {
      // Gentle smile
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.37),
          width: size.width * 0.12,
          height: size.height * 0.08,
        ),
        0.3,
        math.pi * 0.6,
        false,
        mouthPaint,
      );
    }

    // Blush
    final blushPaint = Paint()
      ..color = Color(CharacterConfig.blushPink).withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.32, size.height * 0.32),
      size.width * 0.05,
      blushPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.68, size.height * 0.32),
      size.width * 0.05,
      blushPaint,
    );
  }

  void _drawPearl(Canvas canvas, Size size) {
    final pearlPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final shinePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          Color(CharacterConfig.celebrationGold).withOpacity(0.6),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.6),
        radius: size.width * 0.08,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.6),
      size.width * 0.08,
      pearlPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.6),
      size.width * 0.08,
      shinePaint,
    );

    // Pearl highlight
    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.8);
    canvas.drawCircle(
      Offset(size.width * 0.48, size.height * 0.58),
      size.width * 0.025,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(PearlKeeperPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.animationProgress != animationProgress;
  }
}

/// Celebration particles painter (sparkles and stars)
class CelebrationParticlesPainter extends CustomPainter {
  final double progress;

  CelebrationParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (!CharacterConfig.enableParticles) return;

    final particlePaint = Paint()
      ..color = Color(CharacterConfig.celebrationGold)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Seed for consistent animation
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw particles
    for (int i = 0; i < CharacterConfig.maxParticles; i++) {
      final angle = (i / CharacterConfig.maxParticles) * math.pi * 2;
      final distance = progress * size.width * 0.5;
      final particleX = centerX + math.cos(angle) * distance;
      final particleY = centerY + math.sin(angle) * distance;

      // Fade out particles
      final opacity = (1 - progress).clamp(0.0, 1.0);
      particlePaint.color = Color(CharacterConfig.celebrationGold)
          .withOpacity(opacity * 0.8);

      // Star shape
      _drawStar(
        canvas,
        Offset(particleX, particleY),
        size.width * 0.03 * (1 - progress * 0.5),
        particlePaint,
      );
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 5;
    const innerRadiusRatio = 0.4;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final r = (i % 2 == 0) ? radius : radius * innerRadiusRatio;
      final x = center.dx + math.cos(angle) * r;
      final y = center.dy + math.sin(angle) * r;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CelebrationParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
