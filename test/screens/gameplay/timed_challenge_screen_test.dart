import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/screens/gameplay/timed_challenge_screen.dart';
import 'package:kingdom_of_abacus/models/segment.dart';
import 'package:kingdom_of_abacus/models/problem_config.dart';
import 'package:kingdom_of_abacus/models/problem.dart';
import '../../test_helpers/mock_data.dart';

void main() {
  group('TimedChallengeScreen', () {
    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'challenge_segment',
        type: SegmentType.timedChallenge,
        problemCount: 10,
        problemConfig: MockData.createMockProblemConfig(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('initializes and shows challenge UI',
        (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'challenge_segment',
        type: SegmentType.timedChallenge,
        problemCount: 5,
        problemConfig: MockData.createMockProblemConfig(),
        timeLimit: 30,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      // Wait for initialization
      await tester.pump();

      // Should show challenge UI elements
      expect(find.text('Test Chapter'), findsOneWidget);
    });

    testWidgets('shows score display', (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'challenge_segment',
        type: SegmentType.practice,
        problemCount: 5,
        problemConfig: MockData.createMockProblemConfig(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show score
      expect(find.textContaining('Score:'), findsOneWidget);
    });

    testWidgets('shows timer for timed challenges',
        (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'challenge_segment',
        type: SegmentType.timedChallenge,
        problemCount: 5,
        problemConfig: MockData.createMockProblemConfig(),
        timeLimit: 30,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show timer display
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('handles null problem config gracefully',
        (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'challenge_segment',
        type: SegmentType.practice,
        problemCount: 5,
        problemConfig: null, // No config
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show loading (won't initialize without config)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows number pad', (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'challenge_segment',
        type: SegmentType.practice,
        problemCount: 5,
        problemConfig: MockData.createMockProblemConfig(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should have number pad buttons
      expect(find.text('1'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
    });
  });

  group('TimedChallengeScreen Completion', () {
    testWidgets('completion screen elements exist',
        (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'challenge_segment',
        type: SegmentType.practice,
        problemCount: 1,
        problemConfig: MockData.createMockProblemConfig(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify challenge screen is shown
      expect(find.textContaining('Score:'), findsOneWidget);
    });
  });
}
