import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/providers/chapter_providers.dart';
import 'package:kingdom_of_abacus/models/chapter.dart';
import 'package:kingdom_of_abacus/models/progress.dart';
import '../test_helpers/mock_data.dart';

void main() {
  group('Chapter Providers', () {
    test('userIdProvider has default value', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final userId = container.read(userIdProvider);
      expect(userId, 'anonymous');
    });

    test('currentChapterProvider starts as null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final chapter = container.read(currentChapterProvider);
      expect(chapter, isNull);
    });

    test('currentChapterProvider can be set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mockChapter = MockData.createMockChapter();
      container.read(currentChapterProvider.notifier).state = mockChapter;

      final chapter = container.read(currentChapterProvider);
      expect(chapter, mockChapter);
      expect(chapter?.id, 'test_chapter');
    });

    test('currentSegmentIndexProvider starts at 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final index = container.read(currentSegmentIndexProvider);
      expect(index, 0);
    });

    test('currentSegmentIndexProvider can be updated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentSegmentIndexProvider.notifier).state = 2;

      final index = container.read(currentSegmentIndexProvider);
      expect(index, 2);
    });

    test('configServiceProvider creates ConfigService', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(configServiceProvider);
      expect(service, isNotNull);
    });

    test('progressServiceProvider creates ProgressService', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(progressServiceProvider);
      expect(service, isNotNull);
    });

    test('saveProgressProvider is callable', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final saveProgress = container.read(saveProgressProvider);
      expect(saveProgress, isA<Function>());
    });
  });

  group('Chapter Providers State Management', () {
    test('setting chapter and advancing segments', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set a chapter
      final mockChapter = MockData.createMockChapter();
      container.read(currentChapterProvider.notifier).state = mockChapter;

      // Verify chapter is set
      expect(container.read(currentChapterProvider), mockChapter);

      // Verify initial segment index
      expect(container.read(currentSegmentIndexProvider), 0);

      // Advance to next segment
      container.read(currentSegmentIndexProvider.notifier).state = 1;
      expect(container.read(currentSegmentIndexProvider), 1);

      // Advance to next segment
      container.read(currentSegmentIndexProvider.notifier).state = 2;
      expect(container.read(currentSegmentIndexProvider), 2);
    });
  });
}
