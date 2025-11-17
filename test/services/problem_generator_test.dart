import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/models/problem.dart';
import 'package:kingdom_of_abacus/models/problem_config.dart';
import 'package:kingdom_of_abacus/services/problem_generator.dart';

void main() {
  group('ProblemGenerator', () {
    late ProblemGenerator generator;

    setUp(() {
      generator = ProblemGenerator();
    });

    test('generates correct number of problems', () {
      final config = ProblemConfig(
        type: ProblemType.addition,
        min: 1,
        max: 10,
        difficulty: Difficulty.easy,
      );

      final problems = generator.generate(config, 25);

      expect(problems.length, 25);
    });

    test('generates problems in specified range', () {
      final config = ProblemConfig(
        type: ProblemType.addition,
        min: 1,
        max: 10,
        difficulty: Difficulty.easy,
      );

      final problems = generator.generate(config, 50);

      for (final problem in problems) {
        expect(problem.operand1, greaterThanOrEqualTo(1));
        expect(problem.operand1, lessThanOrEqualTo(10));
        expect(problem.operand2, greaterThanOrEqualTo(1));
        expect(problem.operand2, lessThanOrEqualTo(10));
      }
    });

    test('generates unique problems', () {
      final config = ProblemConfig(
        type: ProblemType.addition,
        min: 1,
        max: 10,
        difficulty: Difficulty.easy,
      );

      final problems = generator.generate(config, 50);
      final signatures =
          problems.map((p) => '${p.operand1}+${p.operand2}').toSet();

      // Should have high uniqueness (allow some duplicates in large sets)
      expect(signatures.length, greaterThan(40));
    });

    test('calculates addition answers correctly', () {
      final config = ProblemConfig(
        type: ProblemType.addition,
        min: 1,
        max: 20,
        difficulty: Difficulty.easy,
      );

      final problems = generator.generate(config, 100);

      for (final problem in problems) {
        expect(problem.answer, problem.operand1 + problem.operand2);
      }
    });

    test('calculates subtraction answers correctly', () {
      final config = ProblemConfig(
        type: ProblemType.subtraction,
        min: 1,
        max: 20,
        difficulty: Difficulty.easy,
      );

      final problems = generator.generate(config, 100);

      for (final problem in problems) {
        expect(problem.answer, problem.operand1 - problem.operand2);
        expect(problem.answer, greaterThanOrEqualTo(0)); // No negative answers
      }
    });

    test('calculates multiplication answers correctly', () {
      final config = ProblemConfig(
        type: ProblemType.multiplication,
        min: 1,
        max: 10,
        difficulty: Difficulty.easy,
      );

      final problems = generator.generate(config, 50);

      for (final problem in problems) {
        expect(problem.answer, problem.operand1 * problem.operand2);
      }
    });

    test('calculates division answers correctly', () {
      final config = ProblemConfig(
        type: ProblemType.division,
        min: 1,
        max: 10,
        difficulty: Difficulty.easy,
      );

      final problems = generator.generate(config, 50);

      for (final problem in problems) {
        // Verify answer is correct
        expect(problem.operand1 ~/ problem.operand2, problem.answer);
        // Verify no division by zero
        expect(problem.operand2, greaterThan(0));
      }
    });

    test('generates single problem with correct type', () {
      final config = ProblemConfig(
        type: ProblemType.multiplication,
        min: 2,
        max: 5,
        difficulty: Difficulty.medium,
      );

      final problem = generator.generateSingle(config);

      expect(problem.type, ProblemType.multiplication);
      expect(problem.difficulty, Difficulty.medium);
      expect(problem.operand1, greaterThanOrEqualTo(2));
      expect(problem.operand1, lessThanOrEqualTo(5));
    });

    test('clearHistory resets generated problems', () {
      final config = ProblemConfig(
        type: ProblemType.addition,
        min: 1,
        max: 5,
        difficulty: Difficulty.easy,
      );

      // Generate some problems
      generator.generate(config, 10);

      // Clear history
      generator.clearHistory();

      // Should be able to generate same problems again
      final problems = generator.generate(config, 25);
      expect(problems.length, 25);
    });

    test('respects difficulty setting', () {
      final config = ProblemConfig(
        type: ProblemType.addition,
        min: 1,
        max: 10,
        difficulty: Difficulty.hard,
      );

      final problems = generator.generate(config, 10);

      for (final problem in problems) {
        expect(problem.difficulty, Difficulty.hard);
      }
    });

    test('handles edge case of min equals max', () {
      final config = ProblemConfig(
        type: ProblemType.addition,
        min: 5,
        max: 5,
        difficulty: Difficulty.easy,
      );

      final problem = generator.generateSingle(config);

      expect(problem.operand1, 5);
      expect(problem.operand2, 5);
    });
  });
}
