// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boss_battle_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BossBattleState _$BossBattleStateFromJson(Map<String, dynamic> json) =>
    BossBattleState(
      chapterId: json['chapterId'] as String,
      bossHealth: (json['bossHealth'] as num).toDouble(),
      problemsCompleted: (json['problemsCompleted'] as num).toInt(),
      totalProblems: (json['totalProblems'] as num).toInt(),
      consecutiveWrong: (json['consecutiveWrong'] as num?)?.toInt() ?? 0,
      currentTimeLimit:
          Duration(microseconds: (json['currentTimeLimit'] as num).toInt()),
      isDefeated: json['isDefeated'] as bool? ?? false,
    );

Map<String, dynamic> _$BossBattleStateToJson(BossBattleState instance) =>
    <String, dynamic>{
      'chapterId': instance.chapterId,
      'bossHealth': instance.bossHealth,
      'problemsCompleted': instance.problemsCompleted,
      'totalProblems': instance.totalProblems,
      'consecutiveWrong': instance.consecutiveWrong,
      'currentTimeLimit': instance.currentTimeLimit.inMicroseconds,
      'isDefeated': instance.isDefeated,
    };
