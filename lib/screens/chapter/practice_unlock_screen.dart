import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/segment.dart';
import '../../models/problem.dart';
import '../../models/progress.dart';
import '../../providers/game_providers.dart';
import '../../providers/chapter_providers.dart';
import '../../widgets/problems/problem_display.dart';
import '../../widgets/input/number_pad.dart';
import '../../widgets/math/shell_counter.dart';
import '../../widgets/math/treasure_chest.dart';
import '../../widgets/math/rock_stack.dart';
import '../../widgets/math/interactive_math_object.dart' as math_objects;
import '../../widgets/gameplay/progress_indicator.dart';
import '../../widgets/effects/correct_animation.dart';
import '../../widgets/effects/incorrect_shake.dart';

/// Practice screen with optional interactive math objects
/// Supports traditional number pad or visual math objects (shells, treasures, rocks)
class PracticeUnlockScreen extends ConsumerStatefulWidget {
  final Segment segment;

  const PracticeUnlockScreen({super.key, required this.segment});

  @override
  ConsumerState<PracticeUnlockScreen> createState() =>
      _PracticeUnlockScreenState();
}

class _PracticeUnlockScreenState extends ConsumerState<PracticeUnlockScreen> {
  List<Problem> _problems = [];
  int _currentIndex = 0;
  int _correct = 0;
  int _currentAnswer = 0;
  bool _showFeedback = false;
  bool _lastAnswerCorrect = false;
  bool _hasSubmittedAnswer = false;

  @override
  void initState() {
    super.initState();
    _generateProblems();
  }

  void _generateProblems() {
    final generator = ref.read(problemGeneratorProvider);
    final config = widget.segment.problemConfig!;

    setState(() {
      _problems = generator.generate(config, widget.segment.problemCount);
      _currentIndex = 0;
      _correct = 0;
      _currentAnswer = 0;
      _hasSubmittedAnswer = false;
    });
  }

  void _onAnswerChange(int answer) {
    setState(() {
      _currentAnswer = answer;
      _hasSubmittedAnswer = false;
    });
  }

  void _onSubmit(int answer) {
    if (_hasSubmittedAnswer) return;

    final currentProblem = _problems[_currentIndex];
    final isCorrect = answer == currentProblem.answer;

    setState(() {
      _showFeedback = true;
      _lastAnswerCorrect = isCorrect;
      _hasSubmittedAnswer = true;
    });

    if (isCorrect) {
      setState(() => _correct++);
    }

    // Wait for animation, then move to next
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      setState(() {
        _showFeedback = false;
        _hasSubmittedAnswer = false;
      });

      // Move to next problem or complete
      if (_currentIndex < _problems.length - 1) {
        setState(() {
          _currentIndex++;
          _currentAnswer = 0;
        });
      } else {
        _complete();
      }
    });
  }

  Future<void> _complete() async {
    final accuracy = _correct / _problems.length;

    // Save progress
    try {
      final progressService = ref.read(progressServiceProvider);
      final currentChapter = ref.read(currentChapterProvider);
      final segmentIndex = ref.read(currentSegmentProvider);

      if (currentChapter != null) {
        final progress = Progress(
          userId: 'anonymous', // TODO: Get from auth
          chapterId: currentChapter.id ?? '',
          currentSegment: segmentIndex + 1,
          problemsCompleted: _problems.length,
          problemsCorrect: _correct,
          completed: false,
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
        title: const Text('Practice Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You got $_correct out of ${_problems.length} correct!'),
            const SizedBox(height: 16),
            Text(
              '${(accuracy * 100).toInt()}% accuracy',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (accuracy >= 0.8)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  '🎉 Great job!',
                  style: TextStyle(fontSize: 20),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to chapter
            },
            child: const Text('Continue'),
          ),
          if (accuracy < 0.8)
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _generateProblems(); // Retry
              },
              child: const Text('Try Again'),
            ),
        ],
      ),
    );
  }

  Widget _buildInputWidget() {
    final mathObjectType = widget.segment.mathObjectType ?? MathObjectType.numberpad;
    final interactionStyle = widget.segment.interactionStyle ?? InteractionStyle.tap;

    // Convert segment InteractionStyle to widget InteractionStyle
    final widgetInteractionStyle = _convertInteractionStyle(interactionStyle);

    switch (mathObjectType) {
      case MathObjectType.shells:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShellCounter(
              maxShells: 20,
              onCountChange: _onAnswerChange,
              enabled: !_showFeedback,
              interactionStyle: widgetInteractionStyle,
            ),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        );

      case MathObjectType.treasures:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TreasureChest(
              targetCount: 20,
              onCountChange: _onAnswerChange,
              enabled: !_showFeedback,
              interactionStyle: widgetInteractionStyle,
            ),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        );

      case MathObjectType.rocks:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RockStack(
              maxRocks: 20,
              onCountChange: _onAnswerChange,
              enabled: !_showFeedback,
              interactionStyle: widgetInteractionStyle,
            ),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        );

      case MathObjectType.numberpad:
      default:
        return NumberPad(
          onSubmit: _onSubmit,
          enabled: !_showFeedback,
        );
    }
  }

  math_objects.InteractionStyle _convertInteractionStyle(InteractionStyle style) {
    switch (style) {
      case InteractionStyle.tap:
        return math_objects.InteractionStyle.tap;
      case InteractionStyle.drag:
        return math_objects.InteractionStyle.drag;
      case InteractionStyle.both:
        return math_objects.InteractionStyle.both;
    }
  }

  Widget _buildSubmitButton() {
    final canSubmit = _currentAnswer > 0 && !_showFeedback;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: canSubmit ? () => _onSubmit(_currentAnswer) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Submit Answer: $_currentAnswer',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
        title: const Text('Practice Mode'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GameProgressIndicator(
                      current: _currentIndex + 1,
                      total: _problems.length,
                    ),
                    const SizedBox(height: 24),

                    // Problem display
                    _showFeedback && !_lastAnswerCorrect
                        ? IncorrectShake(
                            key: ValueKey('shake_$_currentIndex'),
                            child: ProblemDisplay(problem: currentProblem),
                          )
                        : ProblemDisplay(problem: currentProblem),

                    const SizedBox(height: 32),

                    // Input widget (number pad or interactive objects)
                    _buildInputWidget(),

                    const SizedBox(height: 16),
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
