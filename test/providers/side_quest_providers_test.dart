import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/providers/side_quest_providers.dart';
import 'package:kingdom_of_abacus/models/side_quest.dart';
import '../test_helpers/mock_data.dart';

void main() {
  group('SideQuestProviders', () {
    test('activeSideQuestProvider starts as null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final activeQuest = container.read(activeSideQuestProvider);
      expect(activeQuest, isNull);
    });

    test('activeSideQuestProvider can be set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mockQuest = MockData.createMockSideQuest();
      container.read(activeSideQuestProvider.notifier).state = mockQuest;

      final activeQuest = container.read(activeSideQuestProvider);
      expect(activeQuest, equals(mockQuest));
      expect(activeQuest?.id, equals('test_side_quest'));
    });

    test('completedSideQuestsProvider starts as empty set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final completed = container.read(completedSideQuestsProvider);
      expect(completed, isEmpty);
    });

    test('completedSideQuestsProvider can track completed quests', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(completedSideQuestsProvider.notifier).state = {
        'quest_1',
        'quest_2'
      };

      final completed = container.read(completedSideQuestsProvider);
      expect(completed.length, equals(2));
      expect(completed.contains('quest_1'), isTrue);
      expect(completed.contains('quest_2'), isTrue);
    });

    test('sideQuestProblemIndexProvider starts at 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final index = container.read(sideQuestProblemIndexProvider);
      expect(index, equals(0));
    });

    test('sideQuestProblemIndexProvider can be updated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(sideQuestProblemIndexProvider.notifier).state = 5;

      final index = container.read(sideQuestProblemIndexProvider);
      expect(index, equals(5));
    });

    test('sideQuestCorrectCountProvider starts at 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final count = container.read(sideQuestCorrectCountProvider);
      expect(count, equals(0));
    });

    test('sideQuestCorrectCountProvider can track correct answers', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(sideQuestCorrectCountProvider.notifier).state = 7;

      final count = container.read(sideQuestCorrectCountProvider);
      expect(count, equals(7));
    });

    test('showSideQuestDiscoveryProvider starts as false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final show = container.read(showSideQuestDiscoveryProvider);
      expect(show, isFalse);
    });

    test('showSideQuestDiscoveryProvider can be toggled', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(showSideQuestDiscoveryProvider.notifier).state = true;

      final show = container.read(showSideQuestDiscoveryProvider);
      expect(show, isTrue);
    });
  });
}
