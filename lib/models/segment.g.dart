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
      characterAnimation: json['characterAnimation'] as String?,
      characterEmotion: $enumDecodeNullable(
          _$CharacterEmotionEnumMap, json['characterEmotion']),
    );

Map<String, dynamic> _$SegmentToJson(Segment instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$SegmentTypeEnumMap[instance.type]!,
      'storyFile': instance.storyFile,
      'problemCount': instance.problemCount,
      'problemConfig': instance.problemConfig?.toJson(),
      'timeLimit': instance.timeLimit,
      'characterAnimation': instance.characterAnimation,
      'characterEmotion': _$CharacterEmotionEnumMap[instance.characterEmotion],
    };

const _$SegmentTypeEnumMap = {
  SegmentType.story: 'story',
  SegmentType.timedChallenge: 'timed_challenge',
  SegmentType.practice: 'practice',
  SegmentType.bossBattle: 'boss_battle',
};

const _$CharacterEmotionEnumMap = {
  CharacterEmotion.happy: 'happy',
  CharacterEmotion.excited: 'excited',
  CharacterEmotion.worried: 'worried',
  CharacterEmotion.proud: 'proud',
  CharacterEmotion.surprised: 'surprised',
};
