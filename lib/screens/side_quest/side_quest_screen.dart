import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/side_quest.dart';
import '../../models/problem.dart';
import '../../models/progress.dart';
import '../../providers/side_quest_providers.dart';
import '../../providers/game_providers.dart';
import '../../providers/chapter_providers.dart';
import '../../widgets/side_quest/pocket_realm_overlay.dart';
import '../../widgets/problems/problem_display.dart';
import '../../widgets/input/number_pad.dart';
import '../../widgets/gameplay/progress_indicator.dart';
import '../../widgets/effects/correct_animation.dart';
import '../../widgets/effects/incorrect_shake.dart';

class SideQuestScreen extends ConsumerStatefulWidget {
  final SideQuest quest;

  const SideQuestScreen({required this.quest, super.key});

  @override
  ConsumerState<SideQuestScreen> createState() => _SideQuestScreenState();
}

class _SideQuestScreenState extends ConsumerState<SideQuestScreen> {
  int _currentIndex = 0;
  int _correct = 0;
  bool _showFeedback = false;
  bool _lastAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    // Set active quest and reset counters
    Future.microtask(() {
      ref.read(activeSideQuestProvider.notifier).state = widget.quest;
      ref.read(sideQuestProblemIndexProvider.notifier).state = 0;
      ref.read(sideQuestCorrectCountProvider.notifier).state = 0;
    });
  }

  void _onSubmit(int answer) {
    if (_currentIndex >= widget.quest.problems.length) return;

    final currentProblem = widget.quest.problems[_currentIndex];
    final isCorrect = answer == currentProblem.answer;

    setState(() {
      _showFeedback = true;
      _lastAnswerCorrect = isCorrect;
    });

    if (isCorrect) {
      setState(() => _correct++);
      ref.read(sideQuestCorrectCountProvider.notifier).state = _correct;
    }

    // Record in service
    final service = ref.read(sideQuestServiceProvider);
    service.recordSideQuestProblem(isCorrect);

    // Wait for animation, then move to next
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;

      setState(() {
        _showFeedback = false;
      });

      // Move to next problem or complete
      if (_currentIndex < widget.quest.problems.length - 1) {
        setState(() {
          _currentIndex++;
          ref.read(sideQuestProblemIndexProvider.notifier).state = _currentIndex;
        });
      } else {
        _complete();
      }
    });
  }

  Future<void> _complete() async {
    final accuracy = _correct / widget.quest.problems.length;
    final passed = accuracy >= (widget.quest.requiredAccuracy / 100);

    // Calculate reward (bonus points based on accuracy)
    final baseReward = 50;
    final reward = (baseReward * accuracy).toInt();

    // Save progress if passed
    if (passed) {
      try {
        final progressService = ref.read(progressServiceProvider);
        final currentChapter = ref.read(currentChapterProvider);

        if (currentChapter != null) {
          // Save side quest completion
          final progress = Progress(
            userId: 'anonymous', // TODO: Get from auth
            chapterId: currentChapter.id ?? '',
            currentSegment: ref.read(currentSegmentProvider),
            problemsCompleted: widget.quest.problems.length,
            problemsCorrect: _correct,
            completed: false, // Not chapter complete, just side quest
            lastPlayed: DateTime.now(),
          );

          await progressService.saveProgress(progress);
        }
      } catch (e) {
        debugPrint('Failed to save side quest progress: $e');
      }

      // Mark as completed
      final completedQuests = ref.read(completedSideQuestsProvider);
      ref.read(completedSideQuestsProvider.notifier).state = {
        ...completedQuests,
        widget.quest.id
      };

      // Complete in service
      final service = ref.read(sideQuestServiceProvider);
      service.completeSideQuest();
    }

    if (!mounted) return;

    // Show completion dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(passed ? 'Side Quest Complete!' : 'Quest Failed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.star : Icons.refresh,
              size: 64,
              color: passed ? Colors.amber : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text('You got $_correct out of ${widget.quest.problems.length} correct!'),
            const SizedBox(height: 8),
            Text(
              '${(accuracy * 100).toInt()}% accuracy',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (passed) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Reward Earned',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '+$reward bonus points',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!passed)
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                setState(() {
                  _currentIndex = 0;
                  _correct = 0;
                  _showFeedback = false;
                });
                // Retry in service
                final service = ref.read(sideQuestServiceProvider);
                service.retrySideQuest();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to chapter
            },
            child: Text(passed ? 'Continue' : 'Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quest.problems.isEmpty) {
      return Scaffold(
        body: PocketRealmOverlay(
          onClose: () => Navigator.pop(context),
          child: const Center(child: Text('No problems available')),
        ),
      );
    }

    final currentProblem = widget.quest.problems[_currentIndex];

    return Scaffold(
      body: PocketRealmOverlay(
        onClose: () {
          // Confirm exit
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit Side Quest?'),
              content: const Text(
                  'Your progress will be lost. Are you sure you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Exit side quest
                  },
                  child: const Text('Exit'),
                ),
              ],
            ),
          );
        },
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Quest title
                    Text(
                      'Pocket Realm Challenge',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Master ${widget.quest.weakTopic.replaceAll('_', ' ')}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),

                    // Progress indicator
                    GameProgressIndicator(
                      current: _currentIndex + 1,
                      total: widget.quest.problems.length,
                    ),
                    const SizedBox(height: 32),

                    // Problem display
                    _showFeedback && !_lastAnswerCorrect
                        ? IncorrectShake(
                            key: ValueKey('shake_$_currentIndex'),
                            child: ProblemDisplay(problem: currentProblem),
                          )
                        : ProblemDisplay(problem: currentProblem),
                    const SizedBox(height: 32),

                    // Number pad
                    NumberPad(
                      onSubmit: _onSubmit,
                      enabled: !_showFeedback,
                    ),
                  ],
                ),
              ),
            ),

            // Feedback overlay
            if (_showFeedback && _lastAnswerCorrect)
              Center(
                child: CorrectAnimation(
                  onComplete: () {
                    // Animation complete
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
