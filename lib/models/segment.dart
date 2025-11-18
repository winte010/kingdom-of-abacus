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
  final String? characterAnimation; // path to .riv file
  final CharacterEmotion? characterEmotion; // emotion state for character

  const Segment({
    required this.id,
    required this.type,
    this.storyFile,
    required this.problemCount,
    this.problemConfig,
    this.timeLimit,
    this.characterAnimation,
    this.characterEmotion,
  });

  factory Segment.fromJson(Map<String, dynamic> json) =>
      _$SegmentFromJson(json);
  Map<String, dynamic> toJson() => _$SegmentToJson(this);

  @override
  List<Object?> get props => [
        id,
        type,
        storyFile,
        problemCount,
        problemConfig,
        timeLimit,
        characterAnimation,
        characterEmotion,
      ];
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

enum CharacterEmotion {
  @JsonValue('happy')
  happy,
  @JsonValue('excited')
  excited,
  @JsonValue('worried')
  worried,
  @JsonValue('proud')
  proud,
  @JsonValue('surprised')
  surprised,
}
