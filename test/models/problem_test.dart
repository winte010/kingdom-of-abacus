import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/models/problem.dart';

void main() {
  group('Problem', () {
    test('addition problem calculates answer correctly', () {
      final problem = Problem.addition(7, 8);

      expect(problem.type, ProblemType.addition);
      expect(problem.operand1, 7);
      expect(problem.operand2, 8);
      expect(problem.answer, 15);
    });

    test('subtraction problem calculates answer correctly', () {
      final problem = Problem.subtraction(10, 4);

      expect(problem.type, ProblemType.subtraction);
      expect(problem.operand1, 10);
      expect(problem.operand2, 4);
      expect(problem.answer, 6);
    });

    test('multiplication problem calculates answer correctly', () {
      final problem = Problem.multiplication(6, 7);

      expect(problem.type, ProblemType.multiplication);
      expect(problem.operand1, 6);
      expect(problem.operand2, 7);
      expect(problem.answer, 42);
    });

    test('division problem calculates answer correctly', () {
      final problem = Problem.division(20, 4);

      expect(problem.type, ProblemType.division);
      expect(problem.operand1, 20);
      expect(problem.operand2, 4);
      expect(problem.answer, 5);
    });

    test('toDisplayString formats addition correctly', () {
      final problem = Problem.addition(5, 3);

      expect(problem.toDisplayString(), '5 + 3 = ?');
    });

    test('toDisplayString formats subtraction correctly', () {
      final problem = Problem.subtraction(10, 3);

      expect(problem.toDisplayString(), '10 - 3 = ?');
    });

    test('toDisplayString formats multiplication correctly', () {
      final problem = Problem.multiplication(4, 5);

      expect(problem.toDisplayString(), '4 × 5 = ?');
    });

    test('toDisplayString formats division correctly', () {
      final problem = Problem.division(15, 3);

      expect(problem.toDisplayString(), '15 ÷ 3 = ?');
    });

    test('generates unique ID when not provided', () {
      final problem1 = Problem.addition(5, 3);
      final problem2 = Problem.addition(5, 3);

      expect(problem1.id, isNotEmpty);
      expect(problem2.id, isNotEmpty);
      expect(problem1.id, isNot(equals(problem2.id)));
    });

    test('uses provided ID when given', () {
      const customId = 'test-id-123';
      final problem = Problem(
        id: customId,
        type: ProblemType.addition,
        operand1: 5,
        operand2: 3,
        answer: 8,
        difficulty: Difficulty.easy,
      );

      expect(problem.id, customId);
    });

    test('sets default difficulty to medium', () {
      final problem = Problem.addition(5, 3);

      expect(problem.difficulty, Difficulty.medium);
    });

    test('accepts custom difficulty', () {
      final problem = Problem.addition(5, 3, difficulty: Difficulty.hard);

      expect(problem.difficulty, Difficulty.hard);
    });

    test('equality works correctly', () {
      final problem1 = Problem(
        id: 'same-id',
        type: ProblemType.addition,
        operand1: 5,
        operand2: 3,
        answer: 8,
        difficulty: Difficulty.easy,
      );

      final problem2 = Problem(
        id: 'same-id',
        type: ProblemType.addition,
        operand1: 5,
        operand2: 3,
        answer: 8,
        difficulty: Difficulty.easy,
      );

      expect(problem1, equals(problem2));
    });
  });
}
