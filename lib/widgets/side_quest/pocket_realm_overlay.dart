import 'package:flutter/material.dart';

/// Overlay for side quest "pocket realm"
class PocketRealmOverlay extends StatelessWidget {
  final Widget child;
  final VoidCallback? onClose;

  const PocketRealmOverlay({
    super.key,
    required this.child,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dimmed background
        Container(
          color: Colors.black.withValues(alpha: 0.7),
        ),

        // Centered content
        Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: child,
          ),
        ),

        // Close button
        if (onClose != null)
          Positioned(
            top: 40,
            right: 40,
            child: IconButton(
              icon: const Icon(Icons.close, size: 32, color: Colors.white),
              onPressed: onClose,
            ),
          ),
      ],
    );
  }
}
