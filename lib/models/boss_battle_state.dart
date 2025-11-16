import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'boss_battle_state.g.dart';

@JsonSerializable()
class BossBattleState extends Equatable {
  final String chapterId;
  final double bossHealth; // 0-100
  final int problemsCompleted;
  final int totalProblems;
  final int consecutiveWrong;
  final Duration currentTimeLimit;
  final bool isDefeated;

  const BossBattleState({
    required this.chapterId,
    required this.bossHealth,
    required this.problemsCompleted,
    required this.totalProblems,
    this.consecutiveWrong = 0,
    required this.currentTimeLimit,
    this.isDefeated = false,
  });

  factory BossBattleState.fromJson(Map<String, dynamic> json) =>
      _$BossBattleStateFromJson(json);
  Map<String, dynamic> toJson() => _$BossBattleStateToJson(this);

  BossBattleState copyWith({
    String? chapterId,
    double? bossHealth,
    int? problemsCompleted,
    int? totalProblems,
    int? consecutiveWrong,
    Duration? currentTimeLimit,
    bool? isDefeated,
  }) {
    return BossBattleState(
      chapterId: chapterId ?? this.chapterId,
      bossHealth: bossHealth ?? this.bossHealth,
      problemsCompleted: problemsCompleted ?? this.problemsCompleted,
      totalProblems: totalProblems ?? this.totalProblems,
      consecutiveWrong: consecutiveWrong ?? this.consecutiveWrong,
      currentTimeLimit: currentTimeLimit ?? this.currentTimeLimit,
      isDefeated: isDefeated ?? this.isDefeated,
    );
  }

  @override
  List<Object?> get props => [
        chapterId,
        bossHealth,
        problemsCompleted,
        totalProblems,
        consecutiveWrong,
        currentTimeLimit,
        isDefeated,
      ];
}
