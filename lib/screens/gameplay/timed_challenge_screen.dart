import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chapter.dart';
import '../../models/segment.dart';
import '../../models/problem.dart';
import '../../models/progress.dart';
import '../../providers/game_providers.dart';
import '../../providers/chapter_providers.dart';
import '../../widgets/problems/problem_display.dart';
import '../../widgets/input/number_pad.dart';
import '../../widgets/gameplay/timer_display.dart';
import '../../widgets/gameplay/progress_indicator.dart' as game_progress;
import '../../widgets/effects/correct_animation.dart';
import '../../widgets/effects/incorrect_shake.dart';

/// Screen for timed challenges and practice segments
class TimedChallengeScreen extends ConsumerStatefulWidget {
  final Segment segment;
  final Chapter chapter;

  const TimedChallengeScreen({
    super.key,
    required this.segment,
    required this.chapter,
  });

  @override
  ConsumerState<TimedChallengeScreen> createState() =>
      _TimedChallengeScreenState();
}

class _TimedChallengeScreenState extends ConsumerState<TimedChallengeScreen> {
  bool _isInitialized = false;
  bool _showingFeedback = false;
  bool _lastAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChallenge();
    });
  }

  void _initializeChallenge() {
    if (_isInitialized) return;

    final config = widget.segment.problemConfig;
    if (config == null) {
      Navigator.of(context).pop();
      return;
    }

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
    final problemIndex = ref.watch(currentProblemIndexProvider);
    final problems = ref.watch(currentProblemsProvider);
    final score = ref.watch(currentScoreProvider);

    if (currentProblem == null || problemIndex >= problems.length) {
      return _buildCompletionScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapter.title),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress and score
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  game_progress.GameProgressIndicator(
                    current: problemIndex + 1,
                    total: problems.length,
                  ),
                  Text(
                    'Score: $score/${problems.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),

            // Timer (if timed challenge)
            if (widget.segment.timeLimit != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TimerDisplay(
                  duration: Duration(seconds: widget.segment.timeLimit!),
                  onTimerComplete: _handleTimeout,
                  key: ValueKey(problemIndex), // Reset timer for each problem
                ),
              ),

            const SizedBox(height: 32),

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

    // Update score
    ref.read(totalAttemptsProvider.notifier).state++;
    if (isCorrect) {
      ref.read(currentScoreProvider.notifier).state++;
    }

    // Show feedback
    setState(() {
      _showingFeedback = true;
      _lastAnswerCorrect = isCorrect;
    });

    // Advance to next problem after feedback
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _advanceToNextProblem();
      }
    });
  }

  void _handleTimeout() {
    // Timer expired, count as incorrect and move to next problem
    ref.read(totalAttemptsProvider.notifier).state++;

    setState(() {
      _showingFeedback = true;
      _lastAnswerCorrect = false;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _advanceToNextProblem();
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
    } else {
      // Challenge complete
      setState(() {});
    }
  }

  Widget _buildCompletionScreen() {
    final score = ref.watch(currentScoreProvider);
    final problems = ref.watch(currentProblemsProvider);
    final accuracy = problems.isEmpty ? 0.0 : (score / problems.length) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Complete'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              accuracy >= 70 ? Icons.emoji_events : Icons.sentiment_satisfied,
              size: 100,
              color: accuracy >= 70
                  ? Colors.amber
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Challenge Complete!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $score/${problems.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Accuracy: ${accuracy.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _completeChallenge(),
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

  void _completeChallenge() async {
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
