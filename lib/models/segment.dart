import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'problem_config.dart';

part 'segment.g.dart';

@JsonSerializable(explicitToJson: true)
class Segment extends Equatable {
  final String id;
  final SegmentType type;
  final String? storyFile;
  final int problemCount;
  final ProblemConfig? problemConfig;
  final int? timeLimit; // seconds per problem
  final MathObjectType? mathObjectType; // Type of interactive math objects to use
  final InteractionStyle? interactionStyle; // How objects should be interacted with

  const Segment({
    required this.id,
    required this.type,
    this.storyFile,
    required this.problemCount,
    this.problemConfig,
    this.timeLimit,
    this.mathObjectType,
    this.interactionStyle,
  });

  factory Segment.fromJson(Map<String, dynamic> json) =>
      _$SegmentFromJson(json);
  Map<String, dynamic> toJson() => _$SegmentToJson(this);

  @override
  List<Object?> get props =>
      [id, type, storyFile, problemCount, problemConfig, timeLimit, mathObjectType, interactionStyle];
}

enum SegmentType {
  @JsonValue('story')
  story,
  @JsonValue('timed_challenge')
  timedChallenge,
  @JsonValue('practice')
  practice,
  @JsonValue('boss_battle')
  bossBattle,
}

enum MathObjectType {
  @JsonValue('shells')
  shells,
  @JsonValue('treasures')
  treasures,
  @JsonValue('rocks')
  rocks,
  @JsonValue('numberpad')
  numberpad,
}

enum InteractionStyle {
  @JsonValue('drag')
  drag,
  @JsonValue('tap')
  tap,
  @JsonValue('both')
  both,
}
