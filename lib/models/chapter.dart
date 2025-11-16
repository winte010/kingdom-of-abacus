import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'segment.dart';

part 'chapter.g.dart';

/// Represents a complete chapter in the game
@JsonSerializable(explicitToJson: true)
class Chapter extends Equatable {
  final String id;
  final String title;
  final String landId;
  final String mathTopic;
  final List<Segment> segments;
  final int totalProblems;

  const Chapter({
    required this.id,
    required this.title,
    required this.landId,
    required this.mathTopic,
    required this.segments,
    required this.totalProblems,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterToJson(this);

  Chapter copyWith({
    String? id,
    String? title,
    String? landId,
    String? mathTopic,
    List<Segment>? segments,
    int? totalProblems,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      landId: landId ?? this.landId,
      mathTopic: mathTopic ?? this.mathTopic,
      segments: segments ?? this.segments,
      totalProblems: totalProblems ?? this.totalProblems,
    );
  }

  @override
  List<Object?> get props => [id, title, landId, mathTopic, segments, totalProblems];
}
