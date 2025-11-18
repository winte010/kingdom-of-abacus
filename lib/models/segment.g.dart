// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Segment _$SegmentFromJson(Map<String, dynamic> json) => Segment(
      id: json['id'] as String,
      type: $enumDecode(_$SegmentTypeEnumMap, json['type']),
      storyFile: json['storyFile'] as String?,
      problemCount: (json['problemCount'] as num).toInt(),
      problemConfig: json['problemConfig'] == null
          ? null
          : ProblemConfig.fromJson(
              json['problemConfig'] as Map<String, dynamic>),
      timeLimit: (json['timeLimit'] as num?)?.toInt(),
      mathObjectType: $enumDecodeNullable(
          _$MathObjectTypeEnumMap, json['mathObjectType']),
      interactionStyle: $enumDecodeNullable(
          _$InteractionStyleEnumMap, json['interactionStyle']),
    );

Map<String, dynamic> _$SegmentToJson(Segment instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$SegmentTypeEnumMap[instance.type]!,
      'storyFile': instance.storyFile,
      'problemCount': instance.problemCount,
      'problemConfig': instance.problemConfig?.toJson(),
      'timeLimit': instance.timeLimit,
      'mathObjectType': _$MathObjectTypeEnumMap[instance.mathObjectType],
      'interactionStyle': _$InteractionStyleEnumMap[instance.interactionStyle],
    };

const _$SegmentTypeEnumMap = {
  SegmentType.story: 'story',
  SegmentType.timedChallenge: 'timed_challenge',
  SegmentType.practice: 'practice',
  SegmentType.bossBattle: 'boss_battle',
};

const _$MathObjectTypeEnumMap = {
  MathObjectType.shells: 'shells',
  MathObjectType.treasures: 'treasures',
  MathObjectType.rocks: 'rocks',
  MathObjectType.numberpad: 'numberpad',
};

const _$InteractionStyleEnumMap = {
  InteractionStyle.drag: 'drag',
  InteractionStyle.tap: 'tap',
  InteractionStyle.both: 'both',
};
