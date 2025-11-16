import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/screens/gameplay/timed_challenge_screen.dart';
import 'package:kingdom_of_abacus/models/segment.dart';
import 'package:kingdom_of_abacus/widgets/problems/problem_display.dart';
import 'package:kingdom_of_abacus/widgets/input/number_pad.dart';
import 'package:kingdom_of_abacus/widgets/gameplay/timer_display.dart';
import 'package:kingdom_of_abacus/widgets/gameplay/progress_indicator.dart';
import '../../test_helpers/mock_data.dart';

void main() {
  group('TimedChallengeScreen Tests', () {
    late Segment mockSegment;

    setUp(() {
      mockSegment = MockData.createMockSegment(
        type: SegmentType.timedChallenge,
        problemCount: 5,
      );
    });

    testWidgets('renders basic UI elements', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show basic components
      expect(find.byType(ProblemDisplay), findsOneWidget);
      expect(find.byType(NumberPad), findsOneWidget);
      expect(find.byType(GameProgressIndicator), findsOneWidget);
      expect(find.text('Timed Challenge'), findsOneWidget);
    });

    testWidgets('shows timer when segment has timeLimit', (tester) async {
      final segmentWithTimer = Segment(
        id: 'test',
        type: SegmentType.timedChallenge,
        problemCount: 5,
        problemConfig: MockData.createMockProblemConfig(),
        timeLimit: 10,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(segment: segmentWithTimer),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show timer
      expect(find.byType(TimerDisplay), findsOneWidget);
    });

    testWidgets('progress indicator starts at 1/total', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show 1/5 progress
      expect(find.text('1 / 5'), findsOneWidget);
    });

    testWidgets('number pad is enabled initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should find NumberPad widget
      final numberPadFinder = find.byType(NumberPad);
      expect(numberPadFinder, findsOneWidget);

      // NumberPad should be present and interactive
      final numberPad = tester.widget<NumberPad>(numberPadFinder);
      expect(numberPad.enabled, isTrue);
    });

    testWidgets('app bar has no back button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should not have a back button (automaticallyImplyLeading: false)
      expect(find.byType(BackButton), findsNothing);
    });
  });

  group('TimedChallengeScreen Problem Generation', () {
    testWidgets('generates correct number of problems', (tester) async {
      final segment = MockData.createMockSegment(
        type: SegmentType.timedChallenge,
        problemCount: 3,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TimedChallengeScreen(segment: segment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show 1/3 indicating 3 total problems
      expect(find.text('1 / 3'), findsOneWidget);
    });
  });
}
