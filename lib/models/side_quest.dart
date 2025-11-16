import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'problem.dart';

part 'side_quest.g.dart';

@JsonSerializable()
class SideQuest extends Equatable {
  final String id;
  final String chapterId;
  final String weakTopic;
  final List<Problem> problems;
  final int requiredAccuracy; // percentage (e.g., 80 for 80%)
  final bool completed;
  final DateTime? completedAt;

  const SideQuest({
    required this.id,
    required this.chapterId,
    required this.weakTopic,
    required this.problems,
    this.requiredAccuracy = 80,
    this.completed = false,
    this.completedAt,
  });

  factory SideQuest.fromJson(Map<String, dynamic> json) =>
      _$SideQuestFromJson(json);
  Map<String, dynamic> toJson() => _$SideQuestToJson(this);

  SideQuest copyWith({
    String? id,
    String? chapterId,
    String? weakTopic,
    List<Problem>? problems,
    int? requiredAccuracy,
    bool? completed,
    DateTime? completedAt,
  }) {
    return SideQuest(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      weakTopic: weakTopic ?? this.weakTopic,
      problems: problems ?? this.problems,
      requiredAccuracy: requiredAccuracy ?? this.requiredAccuracy,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        chapterId,
        weakTopic,
        problems,
        requiredAccuracy,
        completed,
        completedAt
      ];
}
