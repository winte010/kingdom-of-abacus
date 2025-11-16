import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chapter.dart';
import '../models/segment.dart';
import '../models/problem.dart';
import '../models/progress.dart';
import '../providers/game_providers.dart';
import '../providers/chapter_providers.dart';
import '../services/boss_battle_service.dart';
import '../widgets/boss/boss_display.dart';
import '../widgets/boss/boss_health_bar.dart';
import '../widgets/boss/damage_indicator.dart';
import '../widgets/problems/problem_display.dart';
import '../widgets/input/number_pad.dart';
import '../widgets/effects/correct_animation.dart';
import '../widgets/effects/incorrect_shake.dart';

/// Boss battle screen
class BossBattleScreen extends ConsumerStatefulWidget {
  final Segment segment;
  final Chapter chapter;

  const BossBattleScreen({
    super.key,
    required this.segment,
    required this.chapter,
  });

  @override
  ConsumerState<BossBattleScreen> createState() => _BossBattleScreenState();
}

class _BossBattleScreenState extends ConsumerState<BossBattleScreen> {
  late BossBattleService _bossBattleService;
  bool _isInitialized = false;
  bool _showingFeedback = false;
  bool _lastAnswerCorrect = false;
  bool _showDamage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBattle();
    });
  }

  void _initializeBattle() {
    if (_isInitialized) return;

    final config = widget.segment.problemConfig;
    if (config == null) {
      Navigator.of(context).pop();
      return;
    }

    // Initialize boss battle service
    _bossBattleService = BossBattleService(
      totalProblems: widget.segment.problemCount,
      initialTimeLimit: widget.segment.timeLimit != null
          ? Duration(seconds: widget.segment.timeLimit!)
          : const Duration(seconds: 10),
    );

    // Generate problems
    final generateProblems = ref.read(generateProblemsProvider);
    final problems = generateProblems(config, widget.segment.problemCount);

    // Set up game state
    ref.read(currentProblemsProvider.notifier).state = problems;
    ref.read(currentProblemIndexProvider.notifier).state = 0;
    ref.read(currentScoreProvider.notifier).state = 0;
    ref.read(totalAttemptsProvider.notifier).state = 0;

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentProblem = ref.watch(currentProblemProvider);
    final score = ref.watch(currentScoreProvider);

    // Check for victory
    if (_bossBattleService.isVictory) {
      return _buildVictoryScreen();
    }

    if (currentProblem == null) {
      return _buildVictoryScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Boss Battle - ${widget.chapter.title}'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Boss health bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: BossHealthBar(
                currentHealth: _bossBattleService.bossHealth,
                maxHealth: _bossBattleService.bossMaxHealth.toDouble(),
              ),
            ),

            const SizedBox(height: 16),

            // Boss display
            Stack(
              alignment: Alignment.center,
              children: [
                BossDisplay(
                  bossName: 'Math Boss',
                  state: _bossBattleService.isDefeated ? 'defeated' : 'idle',
                ),
                if (_showDamage)
                  const Positioned(
                    top: 50,
                    child: DamageIndicator(damage: 10),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // Score display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Correct Answers: $score/${widget.segment.problemCount}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            const SizedBox(height: 24),

            // Problem display with feedback animations
            Expanded(
              child: Center(
                child: _buildProblemWithFeedback(currentProblem),
              ),
            ),

            // Number pad
            Padding(
              padding: const EdgeInsets.all(16),
              child: NumberPad(
                onSubmit: _handleAnswer,
                allowNegative: widget.segment.problemConfig?.type ==
                    ProblemType.subtraction,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemWithFeedback(Problem problem) {
    final problemDisplay = ProblemDisplay(problem: problem);

    if (!_showingFeedback) {
      return problemDisplay;
    }

    if (_lastAnswerCorrect) {
      return CorrectAnimation(
        child: problemDisplay,
        onComplete: () {
          setState(() {
            _showingFeedback = false;
          });
        },
      );
    } else {
      return IncorrectShake(
        child: problemDisplay,
        onComplete: () {
          setState(() {
            _showingFeedback = false;
          });
        },
      );
    }
  }

  void _handleAnswer(int userAnswer) {
    if (_showingFeedback) return; // Prevent multiple submissions

    final currentProblem = ref.read(currentProblemProvider);
    if (currentProblem == null) return;

    final isCorrect = currentProblem.answer == userAnswer;

    // Update attempts
    ref.read(totalAttemptsProvider.notifier).state++;

    if (isCorrect) {
      // Update score
      ref.read(currentScoreProvider.notifier).state++;

      // Record correct answer with boss battle service
      _bossBattleService.recordCorrectAnswer();

      // Show damage indicator
      setState(() {
        _showDamage = true;
      });

      // Hide damage after animation
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _showDamage = false;
          });
        }
      });
    } else {
      // Record wrong answer
      _bossBattleService.recordWrongAnswer();
    }

    // Show feedback
    setState(() {
      _showingFeedback = true;
      _lastAnswerCorrect = isCorrect;
    });

    // Advance to next problem or check victory
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        if (_bossBattleService.isVictory) {
          setState(() {});
        } else {
          _advanceToNextProblem();
        }
      }
    });
  }

  void _advanceToNextProblem() {
    final currentIndex = ref.read(currentProblemIndexProvider);
    final problems = ref.read(currentProblemsProvider);

    if (currentIndex + 1 < problems.length) {
      ref.read(currentProblemIndexProvider.notifier).state = currentIndex + 1;
      setState(() {
        _showingFeedback = false;
      });
    }
  }

  Widget _buildVictoryScreen() {
    final score = ref.watch(currentScoreProvider);
    final attempts = ref.watch(totalAttemptsProvider);
    final accuracy =
        attempts > 0 ? (score / attempts) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Victory!'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 120,
              color: Colors.amber,
            ),
            const SizedBox(height: 24),
            Text(
              'Boss Defeated!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'You have conquered the boss!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Score: $score/${widget.segment.problemCount}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Accuracy: ${accuracy.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _completeBattle(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Text('Continue', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeBattle() async {
    // Save progress
    await _saveProgress();

    // Reset game state
    ref.read(resetGameStateProvider)();

    // Return to chapter reader with success
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _saveProgress() async {
    final userId = ref.read(userIdProvider);
    final score = ref.read(currentScoreProvider);
    final attempts = ref.read(totalAttemptsProvider);
    final saveProgress = ref.read(saveProgressProvider);

    // Load current progress
    final currentProgress = await ref.read(progressServiceProvider).loadProgress(
          userId,
          widget.chapter.id,
        );

    final progress = Progress(
      userId: userId,
      chapterId: widget.chapter.id,
      currentSegment: currentProgress?.currentSegment ?? 0,
      problemsCompleted:
          (currentProgress?.problemsCompleted ?? 0) + attempts,
      problemsCorrect: (currentProgress?.problemsCorrect ?? 0) + score,
      completed: currentProgress?.completed ?? false,
      lastPlayed: DateTime.now(),
    );

    await saveProgress(progress);
  }

  @override
  void dispose() {
    // Clean up game state when leaving
    ref.read(resetGameStateProvider)();
    super.dispose();
  }
}
