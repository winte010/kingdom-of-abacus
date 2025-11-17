import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/side_quest_providers.dart';
import 'side_quest_menu.dart';

/// A badge indicator showing available side quests
class SideQuestIndicator extends ConsumerStatefulWidget {
  final String chapterId;

  const SideQuestIndicator({
    required this.chapterId,
    super.key,
  });

  @override
  ConsumerState<SideQuestIndicator> createState() =>
      _SideQuestIndicatorState();
}

class _SideQuestIndicatorState extends ConsumerState<SideQuestIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSideQuestMenu() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SideQuestMenu(
          chapterId: widget.chapterId,
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableQuestsAsync =
        ref.watch(availableSideQuestsProvider(widget.chapterId));
    final completedQuests = ref.watch(completedSideQuestsProvider);

    return availableQuestsAsync.when(
      data: (quests) {
        if (quests.isEmpty) {
          return const SizedBox.shrink();
        }

        // Filter out completed quests
        final uncompletedQuests =
            quests.where((q) => !completedQuests.contains(q.id)).toList();

        if (uncompletedQuests.isEmpty) {
          return const SizedBox.shrink();
        }

        // Show indicator with count
        return ScaleTransition(
          scale: _pulseAnimation,
          child: GestureDetector(
            onTap: _showSideQuestMenu,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade400,
                    Colors.purple.shade600,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 24,
                  ),
                  if (uncompletedQuests.length > 1) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${uncompletedQuests.length}',
                        style: const TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
