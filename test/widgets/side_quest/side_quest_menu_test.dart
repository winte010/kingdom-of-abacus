import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/widgets/side_quest/side_quest_menu.dart';
import 'package:kingdom_of_abacus/widgets/side_quest/pocket_realm_overlay.dart';
import 'package:kingdom_of_abacus/providers/side_quest_providers.dart';
import 'package:kingdom_of_abacus/models/side_quest.dart';
import '../../test_helpers/mock_data.dart';

void main() {
  group('SideQuestMenu', () {
    testWidgets('renders with PocketRealmOverlay', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
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

      await tester.pumpAndSettle();

      // Should be wrapped in PocketRealmOverlay
      expect(find.byType(PocketRealmOverlay), findsOneWidget);
    });

    testWidgets('displays header with title and icon', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
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

      await tester.pumpAndSettle();

      // Should show title
      expect(find.text('Pocket Realms'), findsOneWidget);

      // Should show icon
      expect(find.byIcon(Icons.auto_awesome), findsAtLeastNWidgets(1));
    });

    testWidgets('displays description text', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
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

      await tester.pumpAndSettle();

      // Should show description
      expect(
        find.text('Complete these challenges to master weak areas!'),
        findsOneWidget,
      );
    });

    testWidgets('shows no quests message when no quests available',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
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

      await tester.pump(); // Initial frame
      await tester
          .pump(); // Allow FutureProvider to resolve (will resolve to empty)
      await tester.pumpAndSettle();

      // Should show no quests message
      expect(find.text('No side quests available'), findsOneWidget);
      expect(
        find.text('Keep solving problems to unlock new challenges!'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('displays quest cards with correct info', (tester) async {
      final mockQuest = MockData.createMockSideQuest(
        id: 'quest_1',
        weakTopic: 'additions_with_6',
        problemCount: 10,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => [mockQuest]),
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

      // Should show formatted quest title
      expect(find.text('Additions With 6'), findsOneWidget);

      // Should show problem count and accuracy
      expect(find.text('10 problems • 80% accuracy required'), findsOneWidget);

      // Should show reward
      expect(find.text('+50 pts'), findsOneWidget);
    });

    testWidgets('marks completed quests with check icon', (tester) async {
      final mockQuest = MockData.createMockSideQuest(
        id: 'quest_1',
        weakTopic: 'additions_with_7',
      );

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

      // Should show verified icon for completed quest
      expect(find.byIcon(Icons.verified), findsOneWidget);
    });

    testWidgets('can tap on uncompleted quest', (tester) async {
      final mockQuest = MockData.createMockSideQuest(id: 'quest_1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            availableSideQuestsProvider('test_chapter')
                .overrideWith((ref) async => [mockQuest]),
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

      // Should find quest card
      final questCard = find.byType(Card);
      expect(questCard, findsOneWidget);

      // Card should be tappable (has InkWell)
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('calls onClose when provided', (tester) async {
      bool closeCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SideQuestMenu(
                chapterId: 'test_chapter',
                onClose: () => closeCalled = true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap close button from PocketRealmOverlay
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(closeCalled, isTrue);
    });
  });
}
