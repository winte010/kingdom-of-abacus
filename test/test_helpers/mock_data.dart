import 'package:kingdom_of_abacus/models/chapter.dart';
import 'package:kingdom_of_abacus/models/segment.dart';
import 'package:kingdom_of_abacus/models/problem.dart';
import 'package:kingdom_of_abacus/models/problem_config.dart';
import 'package:kingdom_of_abacus/models/progress.dart';
import 'package:kingdom_of_abacus/models/side_quest.dart';

/// Mock data for testing
class MockData {
  /// Create a mock problem config for testing
  static ProblemConfig createMockProblemConfig({
    ProblemType type = ProblemType.addition,
    int min = 1,
    int max = 10,
    Difficulty difficulty = Difficulty.easy,
  }) {
    return ProblemConfig(
      type: type,
      min: min,
      max: max,
      difficulty: difficulty,
    );
  }

  /// Create a mock segment for testing
  static Segment createMockSegment({
    String id = 'test_segment',
    SegmentType type = SegmentType.practice,
    int problemCount = 10,
    String? storyFile,
  }) {
    return Segment(
      id: id,
      type: type,
      problemCount: problemCount,
      storyFile: storyFile,
      problemConfig: createMockProblemConfig(),
    );
  }

  /// Create a mock chapter for testing
  static Chapter createMockChapter({
    String id = 'test_chapter',
    String title = 'Test Chapter',
    String landId = 'test_land',
    String mathTopic = 'addition',
    int totalProblems = 55,
  }) {
    return Chapter(
      id: id,
      title: title,
      landId: landId,
      mathTopic: mathTopic,
      segments: [
        createMockSegment(
            id: 'segment_1', type: SegmentType.story, problemCount: 0),
        createMockSegment(
            id: 'segment_2', type: SegmentType.practice, problemCount: 25),
        createMockSegment(
            id: 'segment_3',
            type: SegmentType.timedChallenge,
            problemCount: 30),
      ],
      totalProblems: totalProblems,
    );
  }

  /// Create a mock progress for testing
  static Progress createMockProgress({
    String userId = 'test_user',
    String chapterId = 'test_chapter',
    int currentSegment = 0,
    int problemsCompleted = 0,
    int problemsCorrect = 0,
    bool completed = false,
  }) {
    return Progress(
      userId: userId,
      chapterId: chapterId,
      currentSegment: currentSegment,
      problemsCompleted: problemsCompleted,
      problemsCorrect: problemsCorrect,
      completed: completed,
      lastPlayed: DateTime.now(),
    );
  }

  /// Create a mock problem for testing
  static Problem createMockProblem({
    ProblemType type = ProblemType.addition,
    int operand1 = 5,
    int operand2 = 3,
    Difficulty difficulty = Difficulty.easy,
  }) {
    int answer;
    switch (type) {
      case ProblemType.addition:
        answer = operand1 + operand2;
        break;
      case ProblemType.subtraction:
        answer = operand1 - operand2;
        break;
      case ProblemType.multiplication:
        answer = operand1 * operand2;
        break;
      case ProblemType.division:
        answer = operand1 ~/ operand2;
        break;
    }

    return Problem(
      type: type,
      operand1: operand1,
      operand2: operand2,
      answer: answer,
      difficulty: difficulty,
    );
  }

  /// Create a mock side quest for testing
  static SideQuest createMockSideQuest({
    String id = 'test_side_quest',
    String chapterId = 'test_chapter',
    String weakTopic = 'additions_with_6',
    int problemCount = 10,
    int requiredAccuracy = 80,
    bool completed = false,
  }) {
    // Generate problems for the side quest
    final problems = List.generate(
      problemCount,
      (index) => createMockProblem(
        type: ProblemType.addition,
        operand1: 6,
        operand2: index + 1,
      ),
    );

    return SideQuest(
      id: id,
      chapterId: chapterId,
      weakTopic: weakTopic,
      problems: problems,
      requiredAccuracy: requiredAccuracy,
      completed: completed,
      completedAt: completed ? DateTime.now() : null,
    );
  }
}
