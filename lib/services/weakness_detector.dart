/// Detects weak areas based on problem-solving performance
class WeaknessDetector {
  final Map<String, List<bool>> _attempts = {};

  /// Record a problem attempt
  void recordProblem(String problem, bool correct) {
    // Extract fact family (e.g., "6+7" → "6" or "7")
    final factFamily = _extractFactFamily(problem);

    if (!_attempts.containsKey(factFamily)) {
      _attempts[factFamily] = [];
    }

    _attempts[factFamily]!.add(correct);
  }

  /// Should trigger a side quest?
  bool shouldTriggerSideQuest() {
    for (final entry in _attempts.entries) {
      final accuracy = getAccuracy(entry.key);
      final attemptCount = entry.value.length;

      // Trigger if <70% accuracy with 3+ attempts
      if (attemptCount >= 3 && accuracy < 0.7) {
        return true;
      }
    }

    return false;
  }

  /// Get accuracy for a specific fact family
  double getAccuracy(String topic) {
    if (!_attempts.containsKey(topic)) return 1.0;

    final attempts = _attempts[topic]!;
    if (attempts.isEmpty) return 1.0;

    final correct = attempts.where((a) => a).length;
    return correct / attempts.length;
  }

  /// Get the weakest fact family
  String? get weakestFactFamily {
    if (_attempts.isEmpty) return null;

    String? weakest;
    double lowestAccuracy = 1.0;

    for (final entry in _attempts.entries) {
      final accuracy = getAccuracy(entry.key);
      if (accuracy < lowestAccuracy && entry.value.length >= 3) {
        lowestAccuracy = accuracy;
        weakest = entry.key;
      }
    }

    return weakest;
  }

  String _extractFactFamily(String problem) {
    // Simple extraction: get first number
    final numbers = RegExp(r'\d+').allMatches(problem);
    if (numbers.isEmpty) return 'unknown';

    return numbers.first.group(0) ?? 'unknown';
  }

  /// Clear history
  void clear() {
    _attempts.clear();
  }
}
