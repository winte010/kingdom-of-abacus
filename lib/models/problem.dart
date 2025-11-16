/// Represents a math problem for the game
class Problem {
  final int operand1;
  final int operand2;
  final int answer;
  final ProblemType type;

  Problem({
    required this.operand1,
    required this.operand2,
    required this.answer,
    required this.type,
  });

  /// Factory constructor for addition problems
  factory Problem.addition(int a, int b) {
    return Problem(
      operand1: a,
      operand2: b,
      answer: a + b,
      type: ProblemType.addition,
    );
  }

  /// Factory constructor for subtraction problems
  factory Problem.subtraction(int a, int b) {
    return Problem(
      operand1: a,
      operand2: b,
      answer: a - b,
      type: ProblemType.subtraction,
    );
  }

  /// Factory constructor for multiplication problems
  factory Problem.multiplication(int a, int b) {
    return Problem(
      operand1: a,
      operand2: b,
      answer: a * b,
      type: ProblemType.multiplication,
    );
  }

  /// Factory constructor for division problems
  factory Problem.division(int a, int b) {
    assert(b != 0, 'Cannot divide by zero');
    return Problem(
      operand1: a,
      operand2: b,
      answer: a ~/ b,
      type: ProblemType.division,
    );
  }

  /// Returns the problem as a display string
  String toDisplayString() {
    final operator = switch (type) {
      ProblemType.addition => '+',
      ProblemType.subtraction => '-',
      ProblemType.multiplication => '×',
      ProblemType.division => '÷',
    };

    return '$operand1 $operator $operand2 = ?';
  }

  /// Checks if the given answer is correct
  bool isCorrect(int userAnswer) {
    return userAnswer == answer;
  }
}

/// Types of math problems
enum ProblemType {
  addition,
  subtraction,
  multiplication,
  division,
}
