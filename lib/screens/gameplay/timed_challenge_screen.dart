import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/segment.dart';
import '../../models/problem.dart';
import '../../providers/game_providers.dart';
import '../../widgets/problems/problem_display.dart';
import '../../widgets/input/number_pad.dart';
import '../../widgets/gameplay/timer_display.dart';
import '../../widgets/gameplay/progress_indicator.dart';
import '../../widgets/effects/correct_animation.dart';
import '../../widgets/effects/incorrect_shake.dart';

class TimedChallengeScreen extends ConsumerStatefulWidget {
  final Segment segment;

  const TimedChallengeScreen({super.key, required this.segment});

  @override
  ConsumerState<TimedChallengeScreen> createState() =>
      _TimedChallengeScreenState();
}

class _TimedChallengeScreenState extends ConsumerState<TimedChallengeScreen> {
  List<Problem> _problems = [];
  int _currentIndex = 0;
  int _correct = 0;
  bool _showFeedback = false;
  bool _lastAnswerCorrect = false;

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
    });
  }

  void _onSubmit(int answer) {
    final currentProblem = _problems[_currentIndex];
    final isCorrect = answer == currentProblem.answer;

    setState(() {
      _showFeedback = true;
      _lastAnswerCorrect = isCorrect;
    });

    if (isCorrect) {
      setState(() => _correct++);
    }

    // Wait for animation, then move to next
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;

      setState(() {
        _showFeedback = false;
      });

      // Move to next problem or complete
      if (_currentIndex < _problems.length - 1) {
        setState(() => _currentIndex++);
      } else {
        _complete();
      }
    });
  }

  void _onTimerExpired() {
    // Treat as wrong answer
    _onSubmit(-1);
  }

  void _complete() {
    final accuracy = _correct / _problems.length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Challenge Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You got $_correct out of ${_problems.length} correct!'),
            const SizedBox(height: 16),
            Text(
              '${(accuracy * 100).toInt()}% accuracy',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        title: const Text('Timed Challenge'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  GameProgressIndicator(
                    current: _currentIndex + 1,
                    total: _problems.length,
                  ),
                  const SizedBox(height: 24),
                  if (widget.segment.timeLimit != null)
                    TimerDisplay(
                      key: ValueKey(_currentIndex), // Reset timer for each problem
                      duration: Duration(seconds: widget.segment.timeLimit!),
                      onExpired: _onTimerExpired,
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
