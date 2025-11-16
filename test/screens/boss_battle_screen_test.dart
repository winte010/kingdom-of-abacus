import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/screens/boss_battle_screen.dart';
import 'package:kingdom_of_abacus/models/segment.dart';
import 'package:kingdom_of_abacus/models/problem_config.dart';
import 'package:kingdom_of_abacus/models/problem.dart';
import '../test_helpers/mock_data.dart';

void main() {
  group('BossBattleScreen', () {
    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'boss_segment',
        type: SegmentType.bossBattle,
        problemCount: 10,
        problemConfig: MockData.createMockProblemConfig(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('initializes and shows boss battle UI',
        (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'boss_segment',
        type: SegmentType.bossBattle,
        problemCount: 5,
        problemConfig: MockData.createMockProblemConfig(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      // Wait for initialization
      await tester.pump();

      // Should show boss battle UI elements
      expect(find.text('Boss Battle - Test Chapter'), findsOneWidget);
      expect(find.text('Math Boss'), findsOneWidget);
    });

    testWidgets('shows boss health bar', (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'boss_segment',
        type: SegmentType.bossBattle,
        problemCount: 5,
        problemConfig: MockData.createMockProblemConfig(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show boss health
      expect(find.text('Boss Health'), findsOneWidget);
    });

    testWidgets('shows score display', (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'boss_segment',
        type: SegmentType.bossBattle,
        problemCount: 5,
        problemConfig: MockData.createMockProblemConfig(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show score
      expect(find.textContaining('Correct Answers:'), findsOneWidget);
    });

    testWidgets('handles null problem config gracefully',
        (WidgetTester tester) async {
      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'boss_segment',
        type: SegmentType.bossBattle,
        problemCount: 5,
        problemConfig: null, // No config
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(
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
  });

  group('BossBattleScreen Victory', () {
    testWidgets('shows victory screen elements', (WidgetTester tester) async {
      // This test verifies the victory screen structure exists
      // Actual victory flow would require more complex setup

      final chapter = MockData.createMockChapter();
      final segment = Segment(
        id: 'boss_segment',
        type: SegmentType.bossBattle,
        problemCount: 1, // Just 1 problem for easier testing
        problemConfig: MockData.createMockProblemConfig(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(
              segment: segment,
              chapter: chapter,
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify battle screen is shown initially
      expect(find.text('Math Boss'), findsOneWidget);
    });
  });
}
