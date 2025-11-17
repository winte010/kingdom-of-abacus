import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/segment.dart';
import '../models/problem.dart';
import '../models/progress.dart';
import '../providers/game_providers.dart';
import '../providers/chapter_providers.dart';
import '../services/boss_battle_service.dart';
import '../widgets/boss/boss_display.dart';
import '../widgets/boss/boss_health_bar.dart';
import '../widgets/problems/problem_display.dart';
import '../widgets/input/number_pad.dart';
import '../widgets/gameplay/progress_indicator.dart';
import '../widgets/effects/correct_animation.dart';
import '../widgets/effects/incorrect_shake.dart';

class BossBattleScreen extends ConsumerStatefulWidget {
  final Segment segment;

  const BossBattleScreen({super.key, required this.segment});

  @override
  ConsumerState<BossBattleScreen> createState() => _BossBattleScreenState();
}

class _BossBattleScreenState extends ConsumerState<BossBattleScreen> {
  late BossBattleService _battleService;
  List<Problem> _problems = [];
  int _currentIndex = 0;
  bool _showFeedback = false;
  bool _lastAnswerCorrect = false;

  @override
  void initState() {
    super.initState();

    _battleService = BossBattleService(
      totalProblems: widget.segment.problemCount,
    );

    _generateProblems();
  }

  void _generateProblems() {
    final generator = ref.read(problemGeneratorProvider);
    final config = widget.segment.problemConfig!;

    setState(() {
      _problems = generator.generate(config, widget.segment.problemCount);
    });
  }

  void _onSubmit(int answer) {
    final currentProblem = _problems[_currentIndex];
    final isCorrect = answer == currentProblem.answer;

    setState(() {
      _showFeedback = true;
      _lastAnswerCorrect = isCorrect;

      if (isCorrect) {
        _battleService.recordCorrectAnswer();
      } else {
        _battleService.recordWrongAnswer();
      }
    });

    // Wait for animation, then move to next
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;

      setState(() {
        _showFeedback = false;
      });

      if (_battleService.isVictory) {
        _showVictory();
      } else if (_currentIndex < _problems.length - 1) {
        setState(() => _currentIndex++);
      }
    });
  }

  Future<void> _showVictory() async {
    // Save progress for boss victory
    try {
      final progressService = ref.read(progressServiceProvider);
      final currentChapter = ref.read(currentChapterProvider);
      final segmentIndex = ref.read(currentSegmentProvider);

      if (currentChapter != null) {
        final progress = Progress(
          userId: 'anonymous', // TODO: Get from auth
          chapterId: currentChapter.id ?? '',
          currentSegment: segmentIndex + 1,
          problemsCompleted: _battleService.problemsCompleted,
          problemsCorrect: _battleService.problemsCompleted, // Victory means 100%
          completed: false, // Not chapter complete, just boss
          lastPlayed: DateTime.now(),
        );

        await progressService.saveProgress(progress);
      }
    } catch (e) {
      debugPrint('Failed to save progress: $e');
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Victory!'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'You defeated the Chaos Kraken!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Continue Adventure'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_problems.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentProblem = _problems[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boss Battle'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const BossDisplay(
                    bossName: 'Chaos Kraken',
                    state: 'idle',
                  ),
                  const SizedBox(height: 16),
                  BossHealthBar(
                    currentHealth: _battleService.bossHealth,
                  ),
                  const SizedBox(height: 24),
                  GameProgressIndicator(
                    current: _battleService.problemsCompleted,
                    total: widget.segment.problemCount,
                  ),
                  const Spacer(),
                  _showFeedback && !_lastAnswerCorrect
                      ? IncorrectShake(
                          key: ValueKey('shake_$_currentIndex'),
                          child: ProblemDisplay(problem: currentProblem),
                        )
                      : ProblemDisplay(problem: currentProblem),
                  const Spacer(),
                  NumberPad(
                    onSubmit: _onSubmit,
                    enabled: !_showFeedback,
                  ),
                ],
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
