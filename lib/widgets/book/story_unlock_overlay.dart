import 'package:flutter/material.dart';

/// Progressive reveal overlay for story unlocking
class StoryUnlockOverlay extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Widget child;

  const StoryUnlockOverlay({
    super.key,
    required this.progress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1.0 - progress,
          child: Container(
            color: Colors.grey.withOpacity(0.7),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    '${(progress * 100).toInt()}% Unlocked',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
