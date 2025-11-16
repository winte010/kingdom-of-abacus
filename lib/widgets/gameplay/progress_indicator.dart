import 'package:flutter/material.dart';

/// Shows progress through problems (e.g., "15/25")
class GameProgressIndicator extends StatelessWidget {
  final int current;
  final int total;

  const GameProgressIndicator({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? current / total : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$current / $total',
          style: Theme.of(context).textTheme.titleMedium,
          semanticsLabel: '$current of $total problems completed',
        ),
      ],
    );
  }
}
