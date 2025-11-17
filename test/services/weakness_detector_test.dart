import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/services/weakness_detector.dart';

void main() {
  group('WeaknessDetector', () {
    late WeaknessDetector detector;

    setUp(() {
      detector = WeaknessDetector();
    });

    test('records problem attempts', () {
      detector.recordProblem('6+7', true);
      detector.recordProblem('6+8', false);

      // No direct way to verify, but should not throw
    });

    test('calculates accuracy correctly', () {
      detector.recordProblem('6+7', true);
      detector.recordProblem('6+8', true);
      detector.recordProblem('6+9', false);

      final accuracy = detector.getAccuracy('6');
      expect(accuracy, closeTo(0.667, 0.01));
    });

    test('returns 1.0 accuracy for unknown topic', () {
      final accuracy = detector.getAccuracy('unknown');
      expect(accuracy, 1.0);
    });

    test('should not trigger side quest with few attempts', () {
      detector.recordProblem('6+7', false);
      detector.recordProblem('6+8', false);

      expect(detector.shouldTriggerSideQuest(), false);
    });

    test('should trigger side quest with low accuracy', () {
      detector.recordProblem('6+7', false);
      detector.recordProblem('6+8', false);
      detector.recordProblem('6+9', false);

      expect(detector.shouldTriggerSideQuest(), true);
    });

    test('should not trigger side quest with good accuracy', () {
      detector.recordProblem('6+7', true);
      detector.recordProblem('6+8', true);
      detector.recordProblem('6+9', true);

      expect(detector.shouldTriggerSideQuest(), false);
    });

    test('identifies weakest fact family', () {
      // Record good performance on 5
      detector.recordProblem('5+7', true);
      detector.recordProblem('5+8', true);
      detector.recordProblem('5+9', true);

      // Record poor performance on 6
      detector.recordProblem('6+7', false);
      detector.recordProblem('6+8', false);
      detector.recordProblem('6+9', false);

      expect(detector.weakestFactFamily, '6');
    });

    test('returns null weakest family when no data', () {
      expect(detector.weakestFactFamily, null);
    });

    test('requires minimum attempts to identify weakness', () {
      detector.recordProblem('6+7', false);
      detector.recordProblem('6+8', false);

      // Only 2 attempts, not enough
      expect(detector.weakestFactFamily, null);
    });

    test('clear resets all data', () {
      detector.recordProblem('6+7', false);
      detector.recordProblem('6+8', false);
      detector.recordProblem('6+9', false);

      detector.clear();

      expect(detector.shouldTriggerSideQuest(), false);
      expect(detector.weakestFactFamily, null);
    });

    test('handles mixed performance correctly', () {
      // 70% accuracy on 7
      detector.recordProblem('7+1', true);
      detector.recordProblem('7+2', true);
      detector.recordProblem('7+3', false);
      detector.recordProblem('7+4', true);
      detector.recordProblem('7+5', false);
      detector.recordProblem('7+6', true);
      detector.recordProblem('7+7', true);
      detector.recordProblem('7+8', false);
      detector.recordProblem('7+9', true);
      detector.recordProblem('7+10', true);

      final accuracy = detector.getAccuracy('7');
      expect(accuracy, closeTo(0.7, 0.01));

      // Exactly 70% should not trigger (< 70% triggers)
      expect(detector.shouldTriggerSideQuest(), false);
    });

    test('triggers at exactly below 70% accuracy', () {
      // 60% accuracy on 8
      detector.recordProblem('8+1', true);
      detector.recordProblem('8+2', true);
      detector.recordProblem('8+3', false);
      detector.recordProblem('8+4', false);
      detector.recordProblem('8+5', true);

      final accuracy = detector.getAccuracy('8');
      expect(accuracy, closeTo(0.6, 0.01));
      expect(detector.shouldTriggerSideQuest(), true);
    });
  });
}
