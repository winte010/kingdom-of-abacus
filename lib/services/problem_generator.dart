import 'dart:math';
import '../models/problem.dart';
import '../models/problem_config.dart';

/// Generates unique math problems based on configuration
class ProblemGenerator {
  final Random _random = Random();
  final Set<String> _generatedThisSession = {};

  /// Generate a list of unique problems
  List<Problem> generate(ProblemConfig config, int count) {
    final problems = <Problem>[];

    for (var i = 0; i < count; i++) {
      var attempts = 0;
      Problem? problem;

      // Try to generate unique problem (max 100 attempts)
      while (attempts < 100) {
        problem = generateSingle(config);
        final key =
            '${problem.operand1}${problem.type.name}${problem.operand2}';

        if (!_generatedThisSession.contains(key)) {
          _generatedThisSession.add(key);
          break;
        }

        attempts++;
      }

      if (problem != null) {
        problems.add(problem);
      }
    }

    return problems;
  }

  /// Generate a single problem
  Problem generateSingle(ProblemConfig config) {
    switch (config.type) {
      case ProblemType.addition:
        return _generateAddition(config);
      case ProblemType.subtraction:
        return _generateSubtraction(config);
      case ProblemType.multiplication:
        return _generateMultiplication(config);
      case ProblemType.division:
        return _generateDivision(config);
    }
  }

  Problem _generateAddition(ProblemConfig config) {
    final a = _random.nextInt(config.max - config.min + 1) + config.min;
    final b = _random.nextInt(config.max - config.min + 1) + config.min;

    return Problem.addition(a, b, difficulty: config.difficulty);
  }

  Problem _generateSubtraction(ProblemConfig config) {
    final a = _random.nextInt(config.max - config.min + 1) + config.min;
    final b = _random.nextInt(a + 1); // b <= a (no negative answers)

    return Problem.subtraction(a, b, difficulty: config.difficulty);
  }

  Problem _generateMultiplication(ProblemConfig config) {
    final a = _random.nextInt(config.max - config.min + 1) + config.min;
    final b = _random.nextInt(config.max - config.min + 1) + config.min;

    return Problem.multiplication(a, b, difficulty: config.difficulty);
  }

  Problem _generateDivision(ProblemConfig config) {
    // Generate answer first, then create problem
    final answer = _random.nextInt(config.max - config.min + 1) + config.min;
    final divisor = _random.nextInt(config.max - config.min + 1) + config.min;

    // Avoid division by zero
    final safeDivisor = divisor == 0 ? 1 : divisor;
    final dividend = answer * safeDivisor;

    return Problem.division(dividend, safeDivisor,
        difficulty: config.difficulty);
  }

  /// Clear session history (call when starting new chapter)
  void clearHistory() {
    _generatedThisSession.clear();
  }
}
