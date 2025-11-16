import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/problem.dart';
import '../models/problem_config.dart';
import '../services/problem_generator.dart';
import '../services/boss_battle_service.dart';

// Problem generator service
final problemGeneratorProvider = Provider<ProblemGenerator>((ref) {
  return ProblemGenerator();
});

// Boss battle service
final bossBattleServiceProvider = Provider<BossBattleService>((ref) {
  return BossBattleService();
});

// Current problems for a challenge
final currentProblemsProvider = StateProvider<List<Problem>>((ref) => []);

// Current problem index
final currentProblemIndexProvider = StateProvider<int>((ref) => 0);

// Get current problem
final currentProblemProvider = Provider<Problem?>((ref) {
  final problems = ref.watch(currentProblemsProvider);
  final index = ref.watch(currentProblemIndexProvider);

  if (index < 0 || index >= problems.length) return null;
  return problems[index];
});

// Score tracking
final currentScoreProvider = StateProvider<int>((ref) => 0);
final totalAttemptsProvider = StateProvider<int>((ref) => 0);

// Accuracy calculation
final accuracyProvider = Provider<double>((ref) {
  final score = ref.watch(currentScoreProvider);
  final attempts = ref.watch(totalAttemptsProvider);

  if (attempts == 0) return 0.0;
  return score / attempts;
});

// Helper to generate problems for a segment
final generateProblemsProvider =
    Provider<List<Problem> Function(ProblemConfig, int)>((ref) {
  final generator = ref.read(problemGeneratorProvider);
  return (config, count) {
    return generator.generate(config, count);
  };
});

// Helper to reset game state
final resetGameStateProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(currentProblemsProvider.notifier).state = [];
    ref.read(currentProblemIndexProvider.notifier).state = 0;
    ref.read(currentScoreProvider.notifier).state = 0;
    ref.read(totalAttemptsProvider.notifier).state = 0;
  };
});
