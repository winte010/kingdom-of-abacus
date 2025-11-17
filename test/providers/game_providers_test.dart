import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/providers/game_providers.dart';
import 'package:kingdom_of_abacus/services/problem_generator.dart';
import 'package:kingdom_of_abacus/services/side_quest_service.dart';
import '../test_helpers/mock_data.dart';

void main() {
  group('Game Providers Tests', () {
    test('problemGeneratorProvider creates ProblemGenerator instance', () {
      final container = ProviderContainer();
      final service = container.read(problemGeneratorProvider);

      expect(service, isA<ProblemGenerator>());
    });

    test('sideQuestServiceProvider creates SideQuestService instance', () {
      final container = ProviderContainer();
      final service = container.read(sideQuestServiceProvider);

      expect(service, isA<SideQuestService>());
    });

    test('currentProblemProvider starts with null', () {
      final container = ProviderContainer();
      final problem = container.read(currentProblemProvider);

      expect(problem, isNull);
    });

    test('currentProblemProvider can be updated', () {
      final container = ProviderContainer();
      final mockProblem = MockData.createMockProblem();

      container.read(currentProblemProvider.notifier).state = mockProblem;

      expect(container.read(currentProblemProvider), equals(mockProblem));
    });

    test('problemsCompletedProvider starts at 0', () {
      final container = ProviderContainer();
      final completed = container.read(problemsCompletedProvider);

      expect(completed, equals(0));
    });

    test('problemsCompletedProvider can be incremented', () {
      final container = ProviderContainer();

      container.read(problemsCompletedProvider.notifier).state = 5;

      expect(container.read(problemsCompletedProvider), equals(5));
    });

    test('problemsCorrectProvider starts at 0', () {
      final container = ProviderContainer();
      final correct = container.read(problemsCorrectProvider);

      expect(correct, equals(0));
    });

    test('problemsCorrectProvider can be incremented', () {
      final container = ProviderContainer();

      container.read(problemsCorrectProvider.notifier).state = 3;

      expect(container.read(problemsCorrectProvider), equals(3));
    });

    test('bossBattleProvider starts with null', () {
      final container = ProviderContainer();
      final battle = container.read(bossBattleProvider);

      expect(battle, isNull);
    });

    test('isSideQuestActiveProvider starts as false', () {
      final container = ProviderContainer();
      final isActive = container.read(isSideQuestActiveProvider);

      expect(isActive, isFalse);
    });

    test('isSideQuestActiveProvider can be toggled', () {
      final container = ProviderContainer();

      container.read(isSideQuestActiveProvider.notifier).state = true;

      expect(container.read(isSideQuestActiveProvider), isTrue);
    });
  });

  group('Game State Management', () {
    test('can track problem solving progress', () {
      final container = ProviderContainer();

      // Start solving problems
      container.read(problemsCompletedProvider.notifier).state = 1;
      container.read(problemsCorrectProvider.notifier).state = 1;

      expect(container.read(problemsCompletedProvider), equals(1));
      expect(container.read(problemsCorrectProvider), equals(1));

      // Solve more problems
      container.read(problemsCompletedProvider.notifier).state = 5;
      container.read(problemsCorrectProvider.notifier).state = 4;

      expect(container.read(problemsCompletedProvider), equals(5));
      expect(container.read(problemsCorrectProvider), equals(4));
    });

    test('can calculate accuracy from providers', () {
      final container = ProviderContainer();

      container.read(problemsCompletedProvider.notifier).state = 10;
      container.read(problemsCorrectProvider.notifier).state = 8;

      final completed = container.read(problemsCompletedProvider);
      final correct = container.read(problemsCorrectProvider);
      final accuracy = correct / completed;

      expect(accuracy, equals(0.8));
    });
  });
}
