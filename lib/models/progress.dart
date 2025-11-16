import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'progress.g.dart';

@JsonSerializable()
class Progress extends Equatable {
  final String userId;
  final String chapterId;
  final int currentSegment;
  final int problemsCompleted;
  final int problemsCorrect;
  final bool completed;
  final DateTime lastPlayed;
  final Map<String, dynamic>? metadata;

  const Progress({
    required this.userId,
    required this.chapterId,
    required this.currentSegment,
    required this.problemsCompleted,
    required this.problemsCorrect,
    required this.completed,
    required this.lastPlayed,
    this.metadata,
  });

  factory Progress.fromJson(Map<String, dynamic> json) => _$ProgressFromJson(json);
  Map<String, dynamic> toJson() => _$ProgressToJson(this);

  double get accuracy {
    if (problemsCompleted == 0) return 0.0;
    return problemsCorrect / problemsCompleted;
  }

  Progress copyWith({
    String? userId,
    String? chapterId,
    int? currentSegment,
    int? problemsCompleted,
    int? problemsCorrect,
    bool? completed,
    DateTime? lastPlayed,
    Map<String, dynamic>? metadata,
  }) {
    return Progress(
      userId: userId ?? this.userId,
      chapterId: chapterId ?? this.chapterId,
      currentSegment: currentSegment ?? this.currentSegment,
      problemsCompleted: problemsCompleted ?? this.problemsCompleted,
      problemsCorrect: problemsCorrect ?? this.problemsCorrect,
      completed: completed ?? this.completed,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    chapterId,
    currentSegment,
    problemsCompleted,
    problemsCorrect,
    completed,
    lastPlayed,
    metadata,
  ];
}
