// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Progress _$ProgressFromJson(Map<String, dynamic> json) => Progress(
      userId: json['userId'] as String,
      chapterId: json['chapterId'] as String,
      currentSegment: (json['currentSegment'] as num).toInt(),
      problemsCompleted: (json['problemsCompleted'] as num).toInt(),
      problemsCorrect: (json['problemsCorrect'] as num).toInt(),
      completed: json['completed'] as bool,
      lastPlayed: DateTime.parse(json['lastPlayed'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProgressToJson(Progress instance) => <String, dynamic>{
      'userId': instance.userId,
      'chapterId': instance.chapterId,
      'currentSegment': instance.currentSegment,
      'problemsCompleted': instance.problemsCompleted,
      'problemsCorrect': instance.problemsCorrect,
      'completed': instance.completed,
      'lastPlayed': instance.lastPlayed.toIso8601String(),
      'metadata': instance.metadata,
    };
