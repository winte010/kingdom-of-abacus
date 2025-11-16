// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProblemConfig _$ProblemConfigFromJson(Map<String, dynamic> json) =>
    ProblemConfig(
      type: $enumDecode(_$ProblemTypeEnumMap, json['type']),
      min: (json['min'] as num).toInt(),
      max: (json['max'] as num).toInt(),
      difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
    );

Map<String, dynamic> _$ProblemConfigToJson(ProblemConfig instance) =>
    <String, dynamic>{
      'type': _$ProblemTypeEnumMap[instance.type]!,
      'min': instance.min,
      'max': instance.max,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
    };

const _$ProblemTypeEnumMap = {
  ProblemType.addition: 'addition',
  ProblemType.subtraction: 'subtraction',
  ProblemType.multiplication: 'multiplication',
  ProblemType.division: 'division',
};

const _$DifficultyEnumMap = {
  Difficulty.veryEasy: 'very_easy',
  Difficulty.easy: 'easy',
  Difficulty.medium: 'medium',
  Difficulty.hard: 'hard',
  Difficulty.veryHard: 'very_hard',
};
