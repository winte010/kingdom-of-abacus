import 'package:flutter_test/flutter_test.dart';

/// Utility functions for testing
class TestUtils {
  /// Helper to test that a value is within a range
  static Matcher inRange(num min, num max) {
    return allOf([
      greaterThanOrEqualTo(min),
      lessThanOrEqualTo(max),
    ]);
  }

  /// Helper to test that a list contains unique items
  static bool hasUniqueItems<T>(List<T> list) {
    return list.toSet().length == list.length;
  }

  /// Helper to calculate accuracy
  static double calculateAccuracy(int correct, int total) {
    if (total == 0) return 0.0;
    return correct / total;
  }

  /// Helper to generate a test ID
  static String generateTestId(String prefix) {
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
