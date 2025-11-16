import 'package:flutter/material.dart';
import '../../models/problem.dart';

/// Displays a math problem clearly and beautifully
class ProblemDisplay extends StatelessWidget {
  final Problem problem;
  final TextStyle? style;

  const ProblemDisplay({
    super.key,
    required this.problem,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        problem.toDisplayString(),
        style: style ?? defaultStyle,
        textAlign: TextAlign.center,
        semanticsLabel: _semanticLabel(),
      ),
    );
  }

  String _semanticLabel() {
    final operator = switch (problem.type) {
      ProblemType.addition => 'plus',
      ProblemType.subtraction => 'minus',
      ProblemType.multiplication => 'times',
      ProblemType.division => 'divided by',
    };

    return '${problem.operand1} $operator ${problem.operand2} equals what?';
  }
}
