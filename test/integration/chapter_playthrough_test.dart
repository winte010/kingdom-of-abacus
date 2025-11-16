import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/providers/chapter_providers.dart';
import 'package:kingdom_of_abacus/providers/game_providers.dart';
import 'package:kingdom_of_abacus/models/chapter.dart';
import 'package:kingdom_of_abacus/models/segment.dart';
import '../test_helpers/mock_data.dart';

void main() {
  group('Chapter Playthrough Integration', () {
    test('chapter selection flow', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initially no chapter selected
      expect(container.read(currentChapterProvider), isNull);
      expect(container.read(currentSegmentIndexProvider), 0);

      // Select a chapter
      final chapter = MockData.createMockChapter();
      container.read(currentChapterProvider.notifier).state = chapter;

      // Verify chapter is selected
      expect(container.read(currentChapterProvider), chapter);
      expect(container.read(currentSegmentIndexProvider), 0);
    });

    test('segment progression flow', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set up a chapter with 3 segments
      final chapter = MockData.createMockChapter();
      container.read(currentChapterProvider.notifier).state = chapter;

      // Start at segment 0
      expect(container.read(currentSegmentIndexProvider), 0);

      // Progress through segments
      container.read(currentSegmentIndexProvider.notifier).state = 1;
      expect(container.read(currentSegmentIndexProvider), 1);

      container.read(currentSegmentIndexProvider.notifier).state = 2;
      expect(container.read(currentSegmentIndexProvider), 2);

      // Chapter complete when index >= segments.length
      container.read(currentSegmentIndexProvider.notifier).state = 3;
      expect(container.read(currentSegmentIndexProvider), 3);
      expect(
          container.read(currentSegmentIndexProvider) >=
              chapter.segments.length,
          true);
    });

    test('game state management during challenge', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Generate problems for a challenge
      final config = MockData.createMockProblemConfig();
      final generateProblems = container.read(generateProblemsProvider);
      final problems = generateProblems(config, 5);

      // Set up game state
      container.read(currentProblemsProvider.notifier).state = problems;
      container.read(currentProblemIndexProvider.notifier).state = 0;
      container.read(currentScoreProvider.notifier).state = 0;
      container.read(totalAttemptsProvider.notifier).state = 0;

      // Simulate answering problems
      for (int i = 0; i < 3; i++) {
        // Answer correctly
        container.read(currentScoreProvider.notifier).state++;
        container.read(totalAttemptsProvider.notifier).state++;
        container.read(currentProblemIndexProvider.notifier).state++;
      }

      // Check final state
      expect(container.read(currentScoreProvider), 3);
      expect(container.read(totalAttemptsProvider), 3);
      expect(container.read(currentProblemIndexProvider), 3);
      expect(container.read(accuracyProvider), 1.0);
    });

    test('reset game state between challenges', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set up game state
      final config = MockData.createMockProblemConfig();
      final generateProblems = container.read(generateProblemsProvider);
      final problems = generateProblems(config, 5);

      container.read(currentProblemsProvider.notifier).state = problems;
      container.read(currentProblemIndexProvider.notifier).state = 3;
      container.read(currentScoreProvider.notifier).state = 4;
      container.read(totalAttemptsProvider.notifier).state = 5;

      // Verify state is set
      expect(container.read(currentProblemsProvider).length, 5);
      expect(container.read(currentProblemIndexProvider), 3);

      // Reset
      container.read(resetGameStateProvider)();

      // Verify state is reset
      expect(container.read(currentProblemsProvider), isEmpty);
      expect(container.read(currentProblemIndexProvider), 0);
      expect(container.read(currentScoreProvider), 0);
      expect(container.read(totalAttemptsProvider), 0);
    });

    test('complete chapter flow', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Select chapter
      final chapter = MockData.createMockChapter();
      container.read(currentChapterProvider.notifier).state = chapter;

      // Complete all segments
      for (int i = 0; i < chapter.segments.length; i++) {
        container.read(currentSegmentIndexProvider.notifier).state = i;

        final segment = chapter.segments[i];

        if (segment.type == SegmentType.practice ||
            segment.type == SegmentType.timedChallenge) {
          // Simulate completing a challenge
          final config = segment.problemConfig!;
          final generateProblems = container.read(generateProblemsProvider);
          final problems = generateProblems(config, segment.problemCount);

          container.read(currentProblemsProvider.notifier).state = problems;

          // Complete all problems
          for (int j = 0; j < problems.length; j++) {
            container.read(currentProblemIndexProvider.notifier).state = j;
            container.read(currentScoreProvider.notifier).state++;
            container.read(totalAttemptsProvider.notifier).state++;
          }

          // Reset for next challenge
          container.read(resetGameStateProvider)();
        }
      }

      // Advance past final segment
      container
          .read(currentSegmentIndexProvider.notifier)
          .state = chapter.segments.length;

      // Verify chapter is complete
      expect(
          container.read(currentSegmentIndexProvider) >=
              chapter.segments.length,
          true);
    });

    test('user ID is set correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Default user ID
      expect(container.read(userIdProvider), 'anonymous');

      // Can be changed
      container.read(userIdProvider.notifier).state = 'user123';
      expect(container.read(userIdProvider), 'user123');
    });
  });

  group('Provider Integration', () {
    test('services are created correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Config service
      final configService = container.read(configServiceProvider);
      expect(configService, isNotNull);

      // Progress service
      final progressService = container.read(progressServiceProvider);
      expect(progressService, isNotNull);

      // Problem generator
      final problemGenerator = container.read(problemGeneratorProvider);
      expect(problemGenerator, isNotNull);

      // Boss battle service
      final bossBattleService = container.read(bossBattleServiceProvider);
      expect(bossBattleService, isNotNull);
    });

    test('providers interact correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set chapter
      final chapter = MockData.createMockChapter();
      container.read(currentChapterProvider.notifier).state = chapter;

      // Generate problems
      final generateProblems = container.read(generateProblemsProvider);
      final config = MockData.createMockProblemConfig();
      final problems = generateProblems(config, 5);

      // Set problems
      container.read(currentProblemsProvider.notifier).state = problems;

      // Current problem should be available
      final currentProblem = container.read(currentProblemProvider);
      expect(currentProblem, isNotNull);
      expect(currentProblem, problems[0]);

      // Advance problem index
      container.read(currentProblemIndexProvider.notifier).state = 1;
      final nextProblem = container.read(currentProblemProvider);
      expect(nextProblem, problems[1]);
    });
  });
}
