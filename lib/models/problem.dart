import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'problem.g.dart';

@JsonSerializable()
class Problem extends Equatable {
  final String id;
  final ProblemType type;
  final int operand1;
  final int operand2;
  final int answer;
  final Difficulty difficulty;

  Problem({
    String? id,
    required this.type,
    required this.operand1,
    required this.operand2,
    required this.answer,
    required this.difficulty,
  }) : id = id ?? const Uuid().v4();

  factory Problem.fromJson(Map<String, dynamic> json) =>
      _$ProblemFromJson(json);
  Map<String, dynamic> toJson() => _$ProblemToJson(this);

  /// Create an addition problem
  factory Problem.addition(int a, int b,
      {Difficulty difficulty = Difficulty.medium}) {
    return Problem(
      type: ProblemType.addition,
      operand1: a,
      operand2: b,
      answer: a + b,
      difficulty: difficulty,
    );
  }

  /// Create a subtraction problem
  factory Problem.subtraction(int a, int b,
      {Difficulty difficulty = Difficulty.medium}) {
    return Problem(
      type: ProblemType.subtraction,
      operand1: a,
      operand2: b,
      answer: a - b,
      difficulty: difficulty,
    );
  }

  /// Create a multiplication problem
  factory Problem.multiplication(int a, int b,
      {Difficulty difficulty = Difficulty.medium}) {
    return Problem(
      type: ProblemType.multiplication,
      operand1: a,
      operand2: b,
      answer: a * b,
      difficulty: difficulty,
    );
  }

  /// Create a division problem
  factory Problem.division(int dividend, int divisor,
      {Difficulty difficulty = Difficulty.medium}) {
    return Problem(
      type: ProblemType.division,
      operand1: dividend,
      operand2: divisor,
      answer: dividend ~/ divisor,
      difficulty: difficulty,
    );
  }

  /// Display as string (e.g., "7 + 8 = ?")
  String toDisplayString() {
    final operator = _operatorSymbol();
    return '$operand1 $operator $operand2 = ?';
  }

  String _operatorSymbol() {
    switch (type) {
      case ProblemType.addition:
        return '+';
      case ProblemType.subtraction:
        return '-';
      case ProblemType.multiplication:
        return '×';
      case ProblemType.division:
        return '÷';
    }
  }

  @override
  List<Object?> get props => [id, type, operand1, operand2, answer, difficulty];
}

enum ProblemType {
  @JsonValue('addition')
  addition,
  @JsonValue('subtraction')
  subtraction,
  @JsonValue('multiplication')
  multiplication,
  @JsonValue('division')
  division,
}

enum Difficulty {
  @JsonValue('very_easy')
  veryEasy,
  @JsonValue('easy')
  easy,
  @JsonValue('medium')
  medium,
  @JsonValue('hard')
  hard,
  @JsonValue('very_hard')
  veryHard,
}
