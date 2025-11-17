// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
      id: json['id'] as String,
      title: json['title'] as String,
      landId: json['landId'] as String,
      mathTopic: json['mathTopic'] as String,
      segments: (json['segments'] as List<dynamic>)
          .map((e) => Segment.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalProblems: (json['totalProblems'] as num).toInt(),
    );

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'landId': instance.landId,
      'mathTopic': instance.mathTopic,
      'segments': instance.segments.map((e) => e.toJson()).toList(),
      'totalProblems': instance.totalProblems,
    };
