import '../models/problem.dart';
import '../models/problem_config.dart';
import 'weakness_detector.dart';
import 'problem_generator.dart';

/// Manages side quest triggering and execution
class SideQuestService {
  final WeaknessDetector _detector = WeaknessDetector();
  final ProblemGenerator _generator = ProblemGenerator();

  String? _pendingTopic;
  bool _isActive = false;
  int _problemsCompleted = 0;
  int _problemsCorrect = 0;

  /// Check if there's a pending side quest
  bool get hasPendingSideQuest => _pendingTopic != null && !_isActive;

  /// Check if a side quest is currently active
  bool get isSideQuestActive => _isActive;

  /// Get the current weak topic
  String? get weakTopic => _pendingTopic;

  /// Record a problem attempt
  void recordProblem(String problem, bool correct) {
    _detector.recordProblem(problem, correct);

    // Check if we should trigger a side quest
    if (_detector.shouldTriggerSideQuest() &&
        !_isActive &&
        _pendingTopic == null) {
      _pendingTopic = _detector.weakestFactFamily;
    }
  }

  /// Trigger the pending side quest
  void triggerPendingSideQuest() {
    if (_pendingTopic == null) return;

    _isActive = true;
    _problemsCompleted = 0;
    _problemsCorrect = 0;
  }

  /// Generate problems for current side quest
  List<Problem> generateSideQuestProblems({int count = 10}) {
    if (_pendingTopic == null) return [];

    // Extract the number from topic (e.g., "6" from "additions_with_6")
    final factFamily =
        int.tryParse(_pendingTopic!.replaceAll(RegExp(r'[^0-9]'), ''));
    if (factFamily == null) return [];

    // Generate problems all involving this number
    final config = ProblemConfig(
      type: ProblemType.addition,
      min: 1,
      max: 10,
      difficulty: Difficulty.easy,
    );

    final problems = <Problem>[];

    // Generate problems: factFamily + 1, factFamily + 2, etc.
    for (var i = 1; i <= 10 && problems.length < count; i++) {
      problems.add(Problem.addition(factFamily, i));
    }

    return problems;
  }

  /// Record side quest problem result
  void recordSideQuestProblem(bool correct) {
    if (!_isActive) return;

    _problemsCompleted++;
    if (correct) _problemsCorrect++;
  }

  /// Check if side quest is complete (80% accuracy)
  bool isSideQuestComplete({int requiredProblems = 10}) {
    if (_problemsCompleted < requiredProblems) return false;

    final accuracy = _problemsCorrect / _problemsCompleted;
    return accuracy >= 0.8;
  }

  /// Complete the side quest
  void completeSideQuest() {
    _isActive = false;
    _pendingTopic = null;
    _problemsCompleted = 0;
    _problemsCorrect = 0;
  }

  /// Retry the side quest
  void retrySideQuest() {
    _problemsCompleted = 0;
    _problemsCorrect = 0;
  }
}
