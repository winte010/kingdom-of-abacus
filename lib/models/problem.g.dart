// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Problem _$ProblemFromJson(Map<String, dynamic> json) => Problem(
      id: json['id'] as String?,
      type: $enumDecode(_$ProblemTypeEnumMap, json['type']),
      operand1: (json['operand1'] as num).toInt(),
      operand2: (json['operand2'] as num).toInt(),
      answer: (json['answer'] as num).toInt(),
      difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
    );

Map<String, dynamic> _$ProblemToJson(Problem instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$ProblemTypeEnumMap[instance.type]!,
      'operand1': instance.operand1,
      'operand2': instance.operand2,
      'answer': instance.answer,
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
