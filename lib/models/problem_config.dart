import 'package:json_annotation/json_annotation.dart';
import 'problem.dart';

part 'problem_config.g.dart';

@JsonSerializable()
class ProblemConfig {
  final ProblemType type;
  final int min;
  final int max;
  final Difficulty difficulty;

  const ProblemConfig({
    required this.type,
    required this.min,
    required this.max,
    required this.difficulty,
  });

  factory ProblemConfig.fromJson(Map<String, dynamic> json) => _$ProblemConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ProblemConfigToJson(this);
}
