/// Utility functions for validating user input and data
class Validators {
  /// Validate user answer input
  static int? parseUserAnswer(String input) {
    // Remove whitespace
    input = input.trim();

    // Check length
    if (input.length > 10) {
      return null;
    }

    // Parse safely
    final answer = int.tryParse(input);
    if (answer == null) {
      return null;
    }

    // Range check
    if (answer < 0 || answer > 999) {
      return null;
    }

    return answer;
  }

  /// Validate chapter ID format
  static bool isValidChapterId(String chapterId) {
    if (chapterId.isEmpty) return false;

    // Check format: land_name_number (e.g., coastal_cove_1)
    final regex = RegExp(r'^[a-z_]+_\d+$');
    return regex.hasMatch(chapterId);
  }

  /// Validate problem config
  static bool isValidProblemConfig(int min, int max) {
    if (min < 0 || max < 0) return false;
    if (min > max) return false;
    if (max > 1000) return false; // Reasonable upper limit
    return true;
  }
}
