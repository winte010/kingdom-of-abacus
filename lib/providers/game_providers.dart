import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/problem.dart';
import '../services/problem_generator.dart';
import '../services/boss_battle_service.dart';
import '../services/side_quest_service.dart';

// Problem generator instance
final problemGeneratorProvider = Provider<ProblemGenerator>((ref) {
  return ProblemGenerator();
});

// Current problem being solved
final currentProblemProvider = StateProvider<Problem?>((ref) => null);

// Problems completed in current segment
final problemsCompletedProvider = StateProvider<int>((ref) => 0);

// Problems correct in current segment
final problemsCorrectProvider = StateProvider<int>((ref) => 0);

// Boss battle service (when in boss battle)
final bossBattleProvider = StateProvider<BossBattleService?>((ref) => null);

// Side quest service
final sideQuestServiceProvider = Provider<SideQuestService>((ref) {
  return SideQuestService();
});

// Is side quest active?
final isSideQuestActiveProvider = StateProvider<bool>((ref) => false);
