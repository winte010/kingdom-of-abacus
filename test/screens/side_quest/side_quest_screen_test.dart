import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/screens/side_quest/side_quest_screen.dart';
import 'package:kingdom_of_abacus/models/side_quest.dart';
import 'package:kingdom_of_abacus/widgets/side_quest/pocket_realm_overlay.dart';
import 'package:kingdom_of_abacus/widgets/problems/problem_display.dart';
import 'package:kingdom_of_abacus/widgets/input/number_pad.dart';
import 'package:kingdom_of_abacus/widgets/gameplay/progress_indicator.dart';
import '../../test_helpers/mock_data.dart';

void main() {
  group('SideQuestScreen Tests', () {
    late SideQuest mockQuest;

    setUp(() {
      mockQuest = MockData.createMockSideQuest(problemCount: 5);
    });

    testWidgets('renders basic UI elements', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SideQuestScreen(quest: mockQuest),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show pocket realm overlay
      expect(find.byType(PocketRealmOverlay), findsOneWidget);

      // Should show basic components
      expect(find.byType(ProblemDisplay), findsOneWidget);
      expect(find.byType(NumberPad), findsOneWidget);
      expect(find.byType(GameProgressIndicator), findsOneWidget);

      // Should show quest title
      expect(find.text('Pocket Realm Challenge'), findsOneWidget);
    });

    testWidgets('shows weak topic in description', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SideQuestScreen(quest: mockQuest),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show formatted weak topic
      expect(find.textContaining('additions with 6'), findsOneWidget);
    });

    testWidgets('progress indicator starts at 1/total', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SideQuestScreen(quest: mockQuest),
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
            home: SideQuestScreen(quest: mockQuest),
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

    testWidgets('has close button via PocketRealmOverlay', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SideQuestScreen(quest: mockQuest),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have a close button from PocketRealmOverlay
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows exit confirmation dialog when close button tapped',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SideQuestScreen(quest: mockQuest),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Should show confirmation dialog
      expect(find.text('Exit Side Quest?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Exit'), findsOneWidget);
    });

    testWidgets('shows empty state for quest with no problems',
        (tester) async {
      final emptyQuest = MockData.createMockSideQuest(problemCount: 0);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SideQuestScreen(quest: emptyQuest),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show no problems message
      expect(find.text('No problems available'), findsOneWidget);
    });
  });

  group('SideQuestScreen Problem Generation', () {
    testWidgets('displays correct number of problems', (tester) async {
      final quest = MockData.createMockSideQuest(problemCount: 3);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SideQuestScreen(quest: quest),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show 1/3 indicating 3 total problems
      expect(find.text('1 / 3'), findsOneWidget);
    });

    testWidgets('quest has correct required accuracy', (tester) async {
      final quest =
          MockData.createMockSideQuest(requiredAccuracy: 90);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SideQuestScreen(quest: quest),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Quest should have 90% required accuracy
      expect(quest.requiredAccuracy, equals(90));
    });
  });
}
