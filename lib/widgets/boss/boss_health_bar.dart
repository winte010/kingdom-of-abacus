import 'package:flutter/material.dart';
import '../../config/design_tokens.dart';

/// Visual health bar for boss
class BossHealthBar extends StatelessWidget {
  final double currentHealth; // 0-100
  final double maxHealth; // typically 100

  const BossHealthBar({
    super.key,
    required this.currentHealth,
    this.maxHealth = 100,
  });

  @override
  Widget build(BuildContext context) {
    final healthPercent = (currentHealth / maxHealth).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Boss Health',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${currentHealth.toInt()} / ${maxHealth.toInt()}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          child: LinearProgressIndicator(
            value: healthPercent,
            minHeight: 24,
            backgroundColor: DesignTokens.neutralLight,
            valueColor: AlwaysStoppedAnimation(_getHealthColor(healthPercent)),
          ),
        ),
      ],
    );
  }

  Color _getHealthColor(double percent) {
    if (percent > 0.5) return DesignTokens.errorCoral;
    if (percent > 0.25) return DesignTokens.accentPeach;
    return DesignTokens.warningSoftYellow;
  }
}
