import 'package:flutter/material.dart';
import '../../config/character_config.dart';
import '../../services/character_animation_service.dart';
import 'pearl_keeper_sprite.dart';

/// Positioned Pearl Keeper character widget with animation service integration
class PearlKeeperCharacter extends StatefulWidget {
  final CharacterAnimationService animationService;
  final double? size;
  final double? bottomOffset;
  final double? rightOffset;
  final bool showPearl;

  const PearlKeeperCharacter({
    super.key,
    required this.animationService,
    this.size,
    this.bottomOffset,
    this.rightOffset,
    this.showPearl = true,
  });

  @override
  State<PearlKeeperCharacter> createState() => _PearlKeeperCharacterState();
}

class _PearlKeeperCharacterState extends State<PearlKeeperCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _visibilityController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeVisibilityAnimation();
    widget.animationService.addListener(_onServiceStateChanged);
  }

  void _initializeVisibilityAnimation() {
    _visibilityController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _visibilityController,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _visibilityController,
        curve: Curves.easeIn,
      ),
    );

    // Start visible if service says so
    if (widget.animationService.isVisible) {
      _visibilityController.value = 1.0;
    }
  }

  void _onServiceStateChanged() {
    if (mounted) {
      if (widget.animationService.isVisible) {
        _visibilityController.forward();
      } else {
        _visibilityController.reverse();
      }
      setState(() {}); // Rebuild to reflect state changes
    }
  }

  @override
  void dispose() {
    widget.animationService.removeListener(_onServiceStateChanged);
    _visibilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animationService.isVisible) {
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.of(context).size;
    final characterSize = widget.size ?? CharacterConfig.defaultSize;
    final bottomOffset = widget.bottomOffset ??
        (screenSize.height * CharacterConfig.defaultBottomOffset);
    final rightOffset = widget.rightOffset ??
        (screenSize.width * CharacterConfig.defaultRightOffset);

    return Positioned(
      bottom: bottomOffset,
      right: rightOffset,
      child: AnimatedBuilder(
        animation: _visibilityController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          );
        },
        child: PearlKeeperSprite(
          state: widget.animationService.currentState,
          size: characterSize,
          showPearl: widget.showPearl,
        ),
      ),
    );
  }
}

/// Overlay version that can be added to a stack
class PearlKeeperOverlay extends StatelessWidget {
  final CharacterAnimationService animationService;
  final double? size;
  final double? bottomOffset;
  final double? rightOffset;
  final bool showPearl;

  const PearlKeeperOverlay({
    super.key,
    required this.animationService,
    this.size,
    this.bottomOffset,
    this.rightOffset,
    this.showPearl = true,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !CharacterConfig.respondToTaps,
      child: PearlKeeperCharacter(
        animationService: animationService,
        size: size,
        bottomOffset: bottomOffset,
        rightOffset: rightOffset,
        showPearl: showPearl,
      ),
    );
  }
}
