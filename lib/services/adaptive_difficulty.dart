import '../models/problem.dart';

/// Manages adaptive difficulty based on user performance
class AdaptiveDifficultyService {
  static const double increaseThreshold = 0.80;
  static const double decreaseThreshold = 0.70;

  /// Calculate next difficulty level based on accuracy
  Difficulty calculateNextDifficulty(Difficulty current, double accuracy) {
    if (accuracy > increaseThreshold) {
      return _increaseDifficulty(current);
    } else if (accuracy < decreaseThreshold) {
      return _decreaseDifficulty(current);
    }
    return current;
  }

  /// Increase difficulty by one level
  Difficulty _increaseDifficulty(Difficulty current) {
    switch (current) {
      case Difficulty.veryEasy:
        return Difficulty.easy;
      case Difficulty.easy:
        return Difficulty.medium;
      case Difficulty.medium:
        return Difficulty.hard;
      case Difficulty.hard:
        return Difficulty.veryHard;
      case Difficulty.veryHard:
        return Difficulty.veryHard; // Already at max
    }
  }

  /// Decrease difficulty by one level
  Difficulty _decreaseDifficulty(Difficulty current) {
    switch (current) {
      case Difficulty.veryEasy:
        return Difficulty.veryEasy; // Already at min
      case Difficulty.easy:
        return Difficulty.veryEasy;
      case Difficulty.medium:
        return Difficulty.easy;
      case Difficulty.hard:
        return Difficulty.medium;
      case Difficulty.veryHard:
        return Difficulty.hard;
    }
  }

  /// Determine if difficulty should change
  bool shouldChangeDifficulty(double accuracy, int attemptCount) {
    // Need at least 5 attempts to make a decision
    if (attemptCount < 5) return false;

    return accuracy > increaseThreshold || accuracy < decreaseThreshold;
  }
}
