import 'package:flutter/material.dart';

/// Displays the boss character
class BossDisplay extends StatelessWidget {
  final String bossName;
  final String? bossImage;
  final String state; // 'idle', 'attacking', 'hurt', 'defeated'

  const BossDisplay({
    super.key,
    required this.bossName,
    this.bossImage,
    this.state = 'idle',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            shape: BoxShape.circle,
          ),
          child: bossImage != null
              ? Image.asset(bossImage!, fit: BoxFit.contain)
              : Center(
                  child: Text(
                    bossName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          bossName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
