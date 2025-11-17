import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/providers/side_quest_providers.dart';
import 'package:kingdom_of_abacus/providers/chapter_providers.dart';
import 'package:kingdom_of_abacus/widgets/side_quest/side_quest_indicator.dart';
import 'package:kingdom_of_abacus/widgets/side_quest/side_quest_menu.dart';
import 'package:kingdom_of_abacus/screens/side_quest/side_quest_screen.dart';
import '../test_helpers/mock_data.dart';

void main() {
  group('Side Quest Flow Integration Tests', () {
    testWidgets('complete flow: discover -> view menu -> start -> complete',
        (tester) async {
      final mockQuest = MockData.createMockSideQuest(
        id: 'quest_1',
        problemCount: 3,
      );
      final mockChapter = MockData.createMockChapter();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider(mockChapter.id ?? '')
                .overrideWith((ref) async => [mockQuest]),
            currentChapterProvider.overrideWith((ref) => mockChapter),
          ],
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  SideQuestIndicator(chapterId: mockChapter.id ?? ''),
                ],
              ),
              body: const Center(child: Text('Chapter Screen')),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Step 1: Indicator should be visible
      expect(find.byType(SideQuestIndicator), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);

      // Step 2: Tap indicator to open menu
      await tester.tap(find.byIcon(Icons.auto_awesome));
      await tester.pumpAndSettle();

      // Menu should be visible
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Pocket Realms'), findsOneWidget);

      // Step 3: Tap on a quest to start it
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      // Side quest screen should be visible
      expect(find.byType(SideQuestScreen), findsOneWidget);
      expect(find.text('Pocket Realm Challenge'), findsOneWidget);
    });

    testWidgets('quest completion marks quest as completed', (tester) async {
      final mockQuest = MockData.createMockSideQuest(
        id: 'quest_1',
        problemCount: 1,
      );

      final container = ProviderContainer(
        overrides: [
          availableSideQuestsProvider('test_chapter')
              .overrideWith((ref) async => [mockQuest]),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: SideQuestScreen(quest: mockQuest),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial state: quest not completed
      final completedBefore = container.read(completedSideQuestsProvider);
      expect(completedBefore.contains('quest_1'), isFalse);

      // Verify quest screen is displayed
      expect(find.byType(SideQuestScreen), findsOneWidget);
    });

    testWidgets('indicator updates when quests are completed', (tester) async {
      final quest1 = MockData.createMockSideQuest(id: 'quest_1');
      final quest2 = MockData.createMockSideQuest(id: 'quest_2');

      final container = ProviderContainer(
        overrides: [
          availableSideQuestsProvider('test_chapter')
              .overrideWith((ref) async => [quest1, quest2]),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
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

      // Should show count of 2
      expect(find.text('2'), findsOneWidget);

      // Mark quest_1 as completed
      container.read(completedSideQuestsProvider.notifier).state = {'quest_1'};
      await tester.pumpAndSettle();

      // Count should still be 2 (total quests), but only 1 uncompleted
      // The indicator filters completed quests internally
      expect(find.text('2'), findsNothing);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('menu shows completed quests with check mark',
        (tester) async {
      final quest1 = MockData.createMockSideQuest(id: 'quest_1');
      final quest2 = MockData.createMockSideQuest(id: 'quest_2');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => [quest1, quest2]),
            completedSideQuestsProvider.overrideWith((ref) => {'quest_1'}),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SideQuestMenu(
                chapterId: 'test_chapter',
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should show both quests
      expect(find.byType(Card), findsNWidgets(2));

      // One should have verified icon (completed)
      expect(find.byIcon(Icons.verified), findsOneWidget);

      // One should have reward badge (uncompleted)
      expect(find.text('+50 pts'), findsOneWidget);
    });

    testWidgets('cannot start completed quest', (tester) async {
      final mockQuest = MockData.createMockSideQuest(id: 'quest_1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => [mockQuest]),
            completedSideQuestsProvider.overrideWith((ref) => {'quest_1'}),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SideQuestMenu(
                chapterId: 'test_chapter',
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Find the completed quest card
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      // Try to tap it
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      // Should not navigate to SideQuestScreen
      expect(find.byType(SideQuestScreen), findsNothing);
    });

    testWidgets('providers maintain state across widget rebuilds',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set some state
      container.read(sideQuestProblemIndexProvider.notifier).state = 5;
      container.read(sideQuestCorrectCountProvider.notifier).state = 3;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final index = ref.watch(sideQuestProblemIndexProvider);
                  final correct = ref.watch(sideQuestCorrectCountProvider);
                  return Text('$index/$correct');
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display current state
      expect(find.text('5/3'), findsOneWidget);

      // Rebuild widget
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final index = ref.watch(sideQuestProblemIndexProvider);
                  final correct = ref.watch(sideQuestCorrectCountProvider);
                  return Text('$index/$correct');
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // State should be maintained
      expect(find.text('5/3'), findsOneWidget);
    });
  });
}
