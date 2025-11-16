import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/models/progress.dart';

void main() {
  group('Progress', () {
    final testDate = DateTime(2025, 11, 16);

    final testProgress = Progress(
      userId: 'user123',
      chapterId: 'chapter1',
      currentSegment: 2,
      problemsCompleted: 15,
      problemsCorrect: 12,
      completed: false,
      lastPlayed: testDate,
    );

    test('creates progress with all properties', () {
      expect(testProgress.userId, 'user123');
      expect(testProgress.chapterId, 'chapter1');
      expect(testProgress.currentSegment, 2);
      expect(testProgress.problemsCompleted, 15);
      expect(testProgress.problemsCorrect, 12);
      expect(testProgress.completed, false);
      expect(testProgress.lastPlayed, testDate);
    });

    test('calculates accuracy correctly', () {
      expect(testProgress.accuracy, closeTo(0.8, 0.001));
    });

    test('accuracy is 0 when no problems completed', () {
      final noProgress = Progress(
        userId: 'user123',
        chapterId: 'chapter1',
        currentSegment: 0,
        problemsCompleted: 0,
        problemsCorrect: 0,
        completed: false,
        lastPlayed: testDate,
      );

      expect(noProgress.accuracy, 0.0);
    });

    test('accuracy is 1.0 when all problems correct', () {
      final perfectProgress = Progress(
        userId: 'user123',
        chapterId: 'chapter1',
        currentSegment: 2,
        problemsCompleted: 10,
        problemsCorrect: 10,
        completed: true,
        lastPlayed: testDate,
      );

      expect(perfectProgress.accuracy, 1.0);
    });

    test('copyWith creates new instance with updated values', () {
      final updated = testProgress.copyWith(
        currentSegment: 3,
        problemsCompleted: 20,
        problemsCorrect: 18,
      );

      expect(updated.userId, testProgress.userId);
      expect(updated.chapterId, testProgress.chapterId);
      expect(updated.currentSegment, 3);
      expect(updated.problemsCompleted, 20);
      expect(updated.problemsCorrect, 18);
    });

    test('copyWith preserves original when no changes', () {
      final copy = testProgress.copyWith();

      expect(copy.userId, testProgress.userId);
      expect(copy.currentSegment, testProgress.currentSegment);
      expect(copy.problemsCompleted, testProgress.problemsCompleted);
    });

    test('supports optional metadata', () {
      final progressWithMeta = Progress(
        userId: 'user123',
        chapterId: 'chapter1',
        currentSegment: 2,
        problemsCompleted: 15,
        problemsCorrect: 12,
        completed: false,
        lastPlayed: testDate,
        metadata: {'difficulty': 'easy', 'attempts': 3},
      );

      expect(progressWithMeta.metadata, isNotNull);
      expect(progressWithMeta.metadata!['difficulty'], 'easy');
      expect(progressWithMeta.metadata!['attempts'], 3);
    });

    test('equality works correctly', () {
      final progress1 = Progress(
        userId: 'user123',
        chapterId: 'chapter1',
        currentSegment: 2,
        problemsCompleted: 15,
        problemsCorrect: 12,
        completed: false,
        lastPlayed: testDate,
      );

      final progress2 = Progress(
        userId: 'user123',
        chapterId: 'chapter1',
        currentSegment: 2,
        problemsCompleted: 15,
        problemsCorrect: 12,
        completed: false,
        lastPlayed: testDate,
      );

      expect(progress1, equals(progress2));
    });
  });
}
