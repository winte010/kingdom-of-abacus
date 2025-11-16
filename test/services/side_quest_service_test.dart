import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/services/side_quest_service.dart';

void main() {
  group('SideQuestService', () {
    late SideQuestService service;

    setUp(() {
      service = SideQuestService();
    });

    test('initializes with no pending side quest', () {
      expect(service.hasPendingSideQuest, false);
      expect(service.isSideQuestActive, false);
      expect(service.weakTopic, null);
    });

    test('triggers side quest after multiple wrong answers', () {
      // Record failures on "6" problems
      service.recordProblem('6+7', false);
      service.recordProblem('6+8', false);
      service.recordProblem('6+9', false);

      expect(service.hasPendingSideQuest, true);
      expect(service.weakTopic, isNotNull);
    });

    test('does not trigger side quest with good accuracy', () {
      // Record mostly correct answers
      service.recordProblem('6+7', true);
      service.recordProblem('6+8', true);
      service.recordProblem('6+9', true);

      expect(service.hasPendingSideQuest, false);
    });

    test('activates pending side quest', () {
      // Trigger side quest
      service.recordProblem('6+7', false);
      service.recordProblem('6+8', false);
      service.recordProblem('6+9', false);

      expect(service.hasPendingSideQuest, true);

      service.triggerPendingSideQuest();

      expect(service.isSideQuestActive, true);
      expect(service.hasPendingSideQuest, false);
    });

    test('generates problems for side quest', () {
      // Trigger side quest on "6"
      service.recordProblem('6+7', false);
      service.recordProblem('6+8', false);
      service.recordProblem('6+9', false);

      service.triggerPendingSideQuest();

      final problems = service.generateSideQuestProblems(count: 10);

      expect(problems.length, 10);
      // All problems should involve the weak number (6)
      for (final problem in problems) {
        expect(problem.operand1 == 6 || problem.operand2 == 6, true);
      }
    });

    test('records side quest problem results', () {
      // Setup side quest
      service.recordProblem('6+7', false);
      service.recordProblem('6+8', false);
      service.recordProblem('6+9', false);
      service.triggerPendingSideQuest();

      service.recordSideQuestProblem(true);
      service.recordSideQuestProblem(true);
      service.recordSideQuestProblem(false);

      // Can't check internal state, but should not throw
    });

    test('completes side quest with 80% accuracy', () {
      // Setup side quest
      service.recordProblem('6+7', false);
      service.recordProblem('6+8', false);
      service.recordProblem('6+9', false);
      service.triggerPendingSideQuest();

      // Complete 10 problems with 80% accuracy
      for (var i = 0; i < 8; i++) {
        service.recordSideQuestProblem(true);
      }
      for (var i = 0; i < 2; i++) {
        service.recordSideQuestProblem(false);
      }

      expect(service.isSideQuestComplete(requiredProblems: 10), true);
    });

    test('does not complete side quest with low accuracy', () {
      // Setup side quest
      service.recordProblem('6+7', false);
      service.recordProblem('6+8', false);
      service.recordProblem('6+9', false);
      service.triggerPendingSideQuest();

      // Complete 10 problems with 60% accuracy
      for (var i = 0; i < 6; i++) {
        service.recordSideQuestProblem(true);
      }
      for (var i = 0; i < 4; i++) {
        service.recordSideQuestProblem(false);
      }

      expect(service.isSideQuestComplete(requiredProblems: 10), false);
    });

    test('completes and resets side quest', () {
      // Setup and complete side quest
      service.recordProblem('6+7', false);
      service.recordProblem('6+8', false);
      service.recordProblem('6+9', false);
      service.triggerPendingSideQuest();

      for (var i = 0; i < 8; i++) {
        service.recordSideQuestProblem(true);
      }
      for (var i = 0; i < 2; i++) {
        service.recordSideQuestProblem(false);
      }

      service.completeSideQuest();

      expect(service.isSideQuestActive, false);
      expect(service.weakTopic, null);
    });

    test('retries side quest resets progress', () {
      // Setup side quest
      service.recordProblem('6+7', false);
      service.recordProblem('6+8', false);
      service.recordProblem('6+9', false);
      service.triggerPendingSideQuest();

      // Make some progress
      service.recordSideQuestProblem(true);
      service.recordSideQuestProblem(false);

      // Retry
      service.retrySideQuest();

      // Should still be active but progress reset
      expect(service.isSideQuestActive, true);
      expect(service.isSideQuestComplete(requiredProblems: 10), false);
    });

    test('does not record problems when side quest not active', () {
      service.recordSideQuestProblem(true);
      service.recordSideQuestProblem(true);

      // Should not throw, just ignore
      expect(service.isSideQuestActive, false);
    });
  });
}
