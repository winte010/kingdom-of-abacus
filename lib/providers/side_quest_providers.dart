import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/side_quest.dart';
import '../models/problem.dart';
import '../models/problem_config.dart';
import '../services/side_quest_service.dart';
import '../services/problem_generator.dart';
import 'game_providers.dart';

// Side quest service instance from game_providers is used directly
// No need to re-export it here

// Available side quests for current chapter
// In this implementation, side quests are generated on-demand based on detected weaknesses
final availableSideQuestsProvider =
    FutureProvider.family<List<SideQuest>, String>((ref, chapterId) async {
  final service = ref.watch(sideQuestServiceProvider);
  final problemGenerator = ref.watch(problemGeneratorProvider);

  // Check if there's a pending side quest
  if (service.hasPendingSideQuest && service.weakTopic != null) {
    // Generate problems for the weak topic
    final problems = service.generateSideQuestProblems(count: 10);

    // Create a side quest from the weak topic
    final sideQuest = SideQuest(
      id: 'sq_${DateTime.now().millisecondsSinceEpoch}',
      chapterId: chapterId,
      weakTopic: service.weakTopic!,
      problems: problems,
      requiredAccuracy: 80,
      completed: false,
    );

    return [sideQuest];
  }

  return [];
});

// Current active side quest
final activeSideQuestProvider = StateProvider<SideQuest?>((ref) => null);

// Side quest completion status
final completedSideQuestsProvider = StateProvider<Set<String>>((ref) => {});

// Current problem index in active side quest
final sideQuestProblemIndexProvider = StateProvider<int>((ref) => 0);

// Correct answers count in active side quest
final sideQuestCorrectCountProvider = StateProvider<int>((ref) => 0);

// Show side quest discovery notification
final showSideQuestDiscoveryProvider = StateProvider<bool>((ref) => false);
