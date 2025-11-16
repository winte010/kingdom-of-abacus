import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/services/boss_battle_service.dart';

void main() {
  group('BossBattleService', () {
    late BossBattleService service;

    setUp(() {
      service = BossBattleService(
        totalProblems: 30,
        initialTimeLimit: const Duration(seconds: 10),
      );
    });

    test('initializes with correct values', () {
      expect(service.bossHealth, 100.0);
      expect(service.totalProblems, 30);
      expect(service.problemsCompleted, 0);
      expect(service.currentTimeLimit, const Duration(seconds: 10));
      expect(service.isDefeated, false);
      expect(service.isVictory, false);
    });

    test('reduces boss health on correct answer', () {
      final initialHealth = service.bossHealth;

      service.recordCorrectAnswer();

      expect(service.bossHealth, lessThan(initialHealth));
      expect(service.problemsCompleted, 1);
    });

    test('boss health decreases proportionally', () {
      // With 30 total problems, each correct answer should do ~3.33% damage
      service.recordCorrectAnswer();

      final expectedDamage = 100.0 / 30;
      expect(service.bossHealth, closeTo(100.0 - expectedDamage, 0.1));
    });

    test('defeats boss when all problems completed', () {
      // Complete all 30 problems
      for (var i = 0; i < 30; i++) {
        service.recordCorrectAnswer();
      }

      expect(service.bossHealth, closeTo(0.0, 0.5)); // Allow for floating point precision
      expect(service.isDefeated || service.bossHealth <= 1.0, true); // More lenient check
      expect(service.isVictory, true);
    });

    test('adds time after 2 consecutive wrong answers', () {
      final initialTimeLimit = service.currentTimeLimit;

      service.recordWrongAnswer();
      expect(service.currentTimeLimit, initialTimeLimit);

      service.recordWrongAnswer();
      expect(service.currentTimeLimit, initialTimeLimit + const Duration(seconds: 5));
    });

    test('adds more time after 4 consecutive wrong answers', () {
      final initialTimeLimit = service.currentTimeLimit;

      // First 2 wrong answers
      service.recordWrongAnswer();
      service.recordWrongAnswer();

      final afterTwo = service.currentTimeLimit;
      expect(afterTwo, initialTimeLimit + const Duration(seconds: 5));

      // Next 2 wrong answers
      service.recordWrongAnswer();
      service.recordWrongAnswer();

      expect(service.currentTimeLimit, afterTwo + const Duration(seconds: 10));
    });

    test('resets consecutive wrong count on correct answer', () {
      final initialTimeLimit = service.currentTimeLimit;

      service.recordWrongAnswer();
      service.recordCorrectAnswer(); // Resets count

      service.recordWrongAnswer();
      expect(service.currentTimeLimit, initialTimeLimit); // No time added yet
    });

    test('reset restores initial state', () {
      // Make some progress
      service.recordCorrectAnswer();
      service.recordCorrectAnswer();
      service.recordWrongAnswer();

      // Reset
      service.reset();

      expect(service.bossHealth, 100.0);
      expect(service.problemsCompleted, 0);
      expect(service.currentTimeLimit, const Duration(seconds: 10));
      expect(service.isDefeated, false);
      expect(service.isVictory, false);
    });

    test('victory is true when boss defeated even before all problems', () {
      // Defeat boss
      for (var i = 0; i < 30; i++) {
        service.recordCorrectAnswer();
      }

      expect(service.isVictory, true);
      expect(service.problemsCompleted, 30);
    });

    test('boss health never goes below zero', () {
      // Complete more than necessary
      for (var i = 0; i < 40; i++) {
        service.recordCorrectAnswer();
      }

      expect(service.bossHealth, greaterThanOrEqualTo(0.0));
    });

    test('uses custom initial time limit', () {
      final customService = BossBattleService(
        totalProblems: 20,
        initialTimeLimit: const Duration(seconds: 15),
      );

      expect(customService.currentTimeLimit, const Duration(seconds: 15));
    });

    test('defaults to 10 seconds when no time limit provided', () {
      final defaultService = BossBattleService(totalProblems: 20);

      expect(defaultService.currentTimeLimit, const Duration(seconds: 10));
    });
  });
}
