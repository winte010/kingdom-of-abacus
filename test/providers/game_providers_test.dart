import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/providers/game_providers.dart';
import 'package:kingdom_of_abacus/models/problem.dart';
import 'package:kingdom_of_abacus/models/problem_config.dart';
import '../test_helpers/mock_data.dart';

void main() {
  group('Game Providers', () {
    test('problemGeneratorProvider creates ProblemGenerator', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final generator = container.read(problemGeneratorProvider);
      expect(generator, isNotNull);
    });

    test('bossBattleServiceProvider creates BossBattleService', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(bossBattleServiceProvider);
      expect(service, isNotNull);
    });

    test('currentProblemsProvider starts empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final problems = container.read(currentProblemsProvider);
      expect(problems, isEmpty);
    });

    test('currentProblemsProvider can be set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mockProblems = [
        MockData.createMockProblem(),
        MockData.createMockProblem(operand1: 7, operand2: 4),
      ];

      container.read(currentProblemsProvider.notifier).state = mockProblems;

      final problems = container.read(currentProblemsProvider);
      expect(problems.length, 2);
    });

    test('currentProblemIndexProvider starts at 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final index = container.read(currentProblemIndexProvider);
      expect(index, 0);
    });

    test('currentProblemProvider returns null when no problems', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final problem = container.read(currentProblemProvider);
      expect(problem, isNull);
    });

    test('currentProblemProvider returns current problem', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mockProblems = [
        MockData.createMockProblem(operand1: 5, operand2: 3),
        MockData.createMockProblem(operand1: 7, operand2: 4),
      ];

      container.read(currentProblemsProvider.notifier).state = mockProblems;

      final problem = container.read(currentProblemProvider);
      expect(problem, isNotNull);
      expect(problem?.operand1, 5);
      expect(problem?.operand2, 3);
    });

    test('currentScoreProvider starts at 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final score = container.read(currentScoreProvider);
      expect(score, 0);
    });

    test('totalAttemptsProvider starts at 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final attempts = container.read(totalAttemptsProvider);
      expect(attempts, 0);
    });

    test('accuracyProvider calculates accuracy correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initially 0
      expect(container.read(accuracyProvider), 0.0);

      // Set score and attempts
      container.read(currentScoreProvider.notifier).state = 7;
      container.read(totalAttemptsProvider.notifier).state = 10;

      final accuracy = container.read(accuracyProvider);
      expect(accuracy, 0.7);
    });

    test('generateProblemsProvider generates problems', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final generateProblems = container.read(generateProblemsProvider);
      final config = MockData.createMockProblemConfig();

      final problems = generateProblems(config, 5);

      expect(problems.length, 5);
      expect(problems.every((p) => p.type == ProblemType.addition), true);
    });

    test('resetGameStateProvider resets all game state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set some state
      container.read(currentProblemsProvider.notifier).state = [
        MockData.createMockProblem(),
      ];
      container.read(currentProblemIndexProvider.notifier).state = 2;
      container.read(currentScoreProvider.notifier).state = 5;
      container.read(totalAttemptsProvider.notifier).state = 10;

      // Reset
      container.read(resetGameStateProvider)();

      // Verify all reset
      expect(container.read(currentProblemsProvider), isEmpty);
      expect(container.read(currentProblemIndexProvider), 0);
      expect(container.read(currentScoreProvider), 0);
      expect(container.read(totalAttemptsProvider), 0);
    });
  });

  group('Game Providers Flow', () {
    test('simulating a game flow', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Generate problems
      final generateProblems = container.read(generateProblemsProvider);
      final config = MockData.createMockProblemConfig();
      final problems = generateProblems(config, 3);

      container.read(currentProblemsProvider.notifier).state = problems;

      // Check first problem
      expect(container.read(currentProblemIndexProvider), 0);
      expect(container.read(currentProblemProvider), problems[0]);

      // Answer correctly
      container.read(currentScoreProvider.notifier).state++;
      container.read(totalAttemptsProvider.notifier).state++;

      // Move to next problem
      container.read(currentProblemIndexProvider.notifier).state++;
      expect(container.read(currentProblemProvider), problems[1]);

      // Answer incorrectly
      container.read(totalAttemptsProvider.notifier).state++;

      // Move to next problem
      container.read(currentProblemIndexProvider.notifier).state++;
      expect(container.read(currentProblemProvider), problems[2]);

      // Check final score
      expect(container.read(currentScoreProvider), 1);
      expect(container.read(totalAttemptsProvider), 2);
      expect(container.read(accuracyProvider), 0.5);
    });
  });
}
