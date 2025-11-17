import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/side_quest.dart';
import '../../providers/side_quest_providers.dart';
import '../../screens/side_quest/side_quest_screen.dart';
import 'pocket_realm_overlay.dart';

/// A menu widget that displays available side quests
class SideQuestMenu extends ConsumerWidget {
  final String chapterId;
  final VoidCallback? onClose;

  const SideQuestMenu({
    required this.chapterId,
    this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableQuestsAsync = ref.watch(availableSideQuestsProvider(chapterId));
    final completedQuests = ref.watch(completedSideQuestsProvider);

    return PocketRealmOverlay(
      onClose: onClose,
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.purple, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Pocket Realms',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete these challenges to master weak areas!',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Quest list
            availableQuestsAsync.when(
              data: (quests) {
                if (quests.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, size: 64, color: Colors.green),
                        SizedBox(height: 16),
                        Text(
                          'No side quests available',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Keep solving problems to unlock new challenges!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: quests.map((quest) {
                    final isCompleted = completedQuests.contains(quest.id);
                    return _buildQuestCard(context, ref, quest, isCompleted);
                  }).toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestCard(
    BuildContext context,
    WidgetRef ref,
    SideQuest quest,
    bool isCompleted,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isCompleted ? 1 : 4,
      child: InkWell(
        onTap: isCompleted
            ? null
            : () {
                // Close menu and start quest
                if (onClose != null) onClose!();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SideQuestScreen(quest: quest),
                  ),
                );
              },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.auto_awesome,
                  color: isCompleted ? Colors.green : Colors.purple,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatWeakTopic(quest.weakTopic),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.grey : null,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${quest.problems.length} problems • ${quest.requiredAccuracy}% accuracy required',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Reward or status
              if (isCompleted)
                const Icon(Icons.verified, color: Colors.green)
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: const Text(
                    '+50 pts',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatWeakTopic(String topic) {
    // Convert "additions_with_6" to "Additions with 6"
    return topic
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
