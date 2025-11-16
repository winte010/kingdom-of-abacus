// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'side_quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SideQuest _$SideQuestFromJson(Map<String, dynamic> json) => SideQuest(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      weakTopic: json['weakTopic'] as String,
      problems: (json['problems'] as List<dynamic>)
          .map((e) => Problem.fromJson(e as Map<String, dynamic>))
          .toList(),
      requiredAccuracy: (json['requiredAccuracy'] as num?)?.toInt() ?? 80,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$SideQuestToJson(SideQuest instance) => <String, dynamic>{
      'id': instance.id,
      'chapterId': instance.chapterId,
      'weakTopic': instance.weakTopic,
      'problems': instance.problems,
      'requiredAccuracy': instance.requiredAccuracy,
      'completed': instance.completed,
      'completedAt': instance.completedAt?.toIso8601String(),
    };
