import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/widgets/side_quest/side_quest_indicator.dart';
import 'package:kingdom_of_abacus/providers/side_quest_providers.dart';
import '../../test_helpers/mock_data.dart';

void main() {
  group('SideQuestIndicator', () {
    testWidgets('shows nothing when no quests available', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => []),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SideQuestIndicator(chapterId: 'test_chapter'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should not display anything
      expect(find.byType(SideQuestIndicator), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsNothing);
    });

    testWidgets('shows indicator when uncompleted quests available',
        (tester) async {
      final mockQuest = MockData.createMockSideQuest(id: 'quest_1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => [mockQuest]),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SideQuestIndicator(chapterId: 'test_chapter'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should display indicator with icon
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('hides indicator when all quests completed', (tester) async {
      final mockQuest = MockData.createMockSideQuest(id: 'quest_1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => [mockQuest]),
            completedSideQuestsProvider.overrideWith((ref) => {'quest_1'}),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SideQuestIndicator(chapterId: 'test_chapter'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should not display indicator when all quests completed
      expect(find.byIcon(Icons.auto_awesome), findsNothing);
    });

    testWidgets('shows count badge for multiple quests', (tester) async {
      final quest1 = MockData.createMockSideQuest(id: 'quest_1');
      final quest2 = MockData.createMockSideQuest(id: 'quest_2');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => [quest1, quest2]),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SideQuestIndicator(chapterId: 'test_chapter'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should show count badge
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('no count badge for single quest', (tester) async {
      final mockQuest = MockData.createMockSideQuest(id: 'quest_1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => [mockQuest]),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SideQuestIndicator(chapterId: 'test_chapter'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should show icon but no count badge for single quest
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('is tappable and opens menu', (tester) async {
      final mockQuest = MockData.createMockSideQuest(id: 'quest_1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => [mockQuest]),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SideQuestIndicator(chapterId: 'test_chapter'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should find GestureDetector
      expect(find.byType(GestureDetector), findsOneWidget);

      // Tap the indicator
      await tester.tap(find.byIcon(Icons.auto_awesome));
      await tester.pumpAndSettle();

      // Should open dialog with menu
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('has purple gradient styling', (tester) async {
      final mockQuest = MockData.createMockSideQuest(id: 'quest_1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => [mockQuest]),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SideQuestIndicator(chapterId: 'test_chapter'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should find container with decoration
      final containerFinder = find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsWidgets);

      // Verify at least one container has decoration
      final containers =
          tester.widgetList<Container>(containerFinder);
      final hasGradient = containers.any((c) =>
          c.decoration is BoxDecoration &&
          (c.decoration as BoxDecoration).gradient is LinearGradient);
      expect(hasGradient, isTrue);
    });

    testWidgets('handles loading state gracefully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(
            home: Scaffold(
              body: SideQuestIndicator(chapterId: 'test_chapter'),
            ),
          ),
        ),
      );

      // During loading, should not show indicator
      await tester.pump();
      expect(find.byIcon(Icons.auto_awesome), findsNothing);
    });

    testWidgets('handles error state gracefully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter').overrideWith(
                (ref) async => throw Exception('Test error')),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SideQuestIndicator(chapterId: 'test_chapter'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should not show indicator on error
      expect(find.byIcon(Icons.auto_awesome), findsNothing);
    });
  });
}
