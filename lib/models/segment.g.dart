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
    );

Map<String, dynamic> _$SegmentToJson(Segment instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$SegmentTypeEnumMap[instance.type]!,
      'storyFile': instance.storyFile,
      'problemCount': instance.problemCount,
      'problemConfig': instance.problemConfig?.toJson(),
      'timeLimit': instance.timeLimit,
    };

const _$SegmentTypeEnumMap = {
  SegmentType.story: 'story',
  SegmentType.timedChallenge: 'timed_challenge',
  SegmentType.practice: 'practice',
  SegmentType.bossBattle: 'boss_battle',
};
