import 'package:flutter/material.dart';

/// Floating damage number animation
class DamageIndicator extends StatefulWidget {
  final int damage;
  final bool isPlayerDamage;

  const DamageIndicator({
    super.key,
    required this.damage,
    this.isPlayerDamage = false,
  });

  @override
  State<DamageIndicator> createState() => _DamageIndicatorState();
}

class _DamageIndicatorState extends State<DamageIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          widget.isPlayerDamage ? '-${widget.damage}' : '+${widget.damage}',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: widget.isPlayerDamage ? Colors.red : Colors.green,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
