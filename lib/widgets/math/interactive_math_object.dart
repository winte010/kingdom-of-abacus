import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Callback for when a math object interaction is complete
typedef OnInteractionCallback = void Function(int value);

/// Base widget for interactive math objects
/// Provides draggable/tappable functionality with animations and feedback
class InteractiveMathObject extends StatefulWidget {
  final Widget child;
  final int value;
  final OnInteractionCallback? onTap;
  final OnInteractionCallback? onDragComplete;
  final bool enabled;
  final String? assetPath;
  final double size;
  final InteractionStyle interactionStyle;

  const InteractiveMathObject({
    super.key,
    required this.child,
    required this.value,
    this.onTap,
    this.onDragComplete,
    this.enabled = true,
    this.assetPath,
    this.size = 80,
    this.interactionStyle = InteractionStyle.both,
  });

  @override
  State<InteractiveMathObject> createState() => _InteractiveMathObjectState();
}

class _InteractiveMathObjectState extends State<InteractiveMathObject>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled || widget.interactionStyle == InteractionStyle.drag) {
      return;
    }

    // Bounce animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Sound effect trigger point (hook for future audio implementation)
    _triggerSoundEffect('tap');

    // Notify parent
    widget.onTap?.call(widget.value);
  }

  void _handleDragStart(DragStartDetails details) {
    if (!widget.enabled || widget.interactionStyle == InteractionStyle.tap) {
      return;
    }

    setState(() {
      _isPressed = true;
    });

    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleDragEnd(DraggableDetails details) {
    setState(() {
      _isPressed = false;
    });

    _animationController.reverse();
    HapticFeedback.mediumImpact();

    // Sound effect trigger point
    _triggerSoundEffect('drop');

    // Notify parent
    widget.onDragComplete?.call(widget.value);
  }

  void _handleDragCancel() {
    setState(() {
      _isPressed = false;
    });

    _animationController.reverse();
  }

  // Sound effect hook (no actual audio implementation yet)
  void _triggerSoundEffect(String effectType) {
    // TODO: Implement audio when ready
    debugPrint('Sound effect: $effectType');
  }

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isPressed || _isHovering
                  ? [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                // Main content
                widget.child,

                // Glow effect when interacting
                if (_isPressed || _isHovering)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                // Particle effect placeholder
                if (_isPressed)
                  Positioned.fill(
                    child: _ParticleEffect(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );

    // Wrap in gesture detector for tapping
    if (widget.interactionStyle == InteractionStyle.tap ||
        widget.interactionStyle == InteractionStyle.both) {
      content = GestureDetector(
        onTap: _handleTap,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: content,
        ),
      );
    }

    // Wrap in draggable for drag and drop
    if (widget.interactionStyle == InteractionStyle.drag ||
        widget.interactionStyle == InteractionStyle.both) {
      content = Draggable<int>(
        data: widget.value,
        onDragStarted: () => _handleDragStart(
          DragStartDetails(
            globalPosition: Offset.zero,
          ),
        ),
        onDragEnd: _handleDragEnd,
        onDraggableCanceled: (_, __) => _handleDragCancel(),
        feedback: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.7,
            child: Transform.scale(
              scale: 1.2,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: widget.child,
              ),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: content,
        ),
        child: content,
      );
    }

    return content;
  }
}

/// Simple particle effect for visual feedback
class _ParticleEffect extends StatefulWidget {
  final Color color;

  const _ParticleEffect({required this.color});

  @override
  State<_ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<_ParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ParticlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(1 - progress)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = progress * size.width / 2;

    // Draw expanding circle
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Interaction style for math objects
enum InteractionStyle {
  tap,
  drag,
  both,
}
