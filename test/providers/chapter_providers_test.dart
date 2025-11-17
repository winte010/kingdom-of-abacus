import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/providers/chapter_providers.dart';
import 'package:kingdom_of_abacus/services/config_service.dart';
import 'package:kingdom_of_abacus/services/progress_service.dart';
import '../test_helpers/mock_data.dart';

void main() {
  group('Chapter Providers Tests', () {
    test('configServiceProvider creates ConfigService instance', () {
      final container = ProviderContainer();
      final service = container.read(configServiceProvider);

      expect(service, isA<ConfigService>());
    });

    test('progressServiceProvider creates ProgressService instance', () {
      final container = ProviderContainer();
      final service = container.read(progressServiceProvider);

      expect(service, isA<ProgressService>());
    });

    test('currentChapterProvider starts with null', () {
      final container = ProviderContainer();
      final chapter = container.read(currentChapterProvider);

      expect(chapter, isNull);
    });

    test('currentChapterProvider can be updated', () {
      final container = ProviderContainer();
      final mockChapter = MockData.createMockChapter();

      container.read(currentChapterProvider.notifier).state = mockChapter;

      expect(container.read(currentChapterProvider), equals(mockChapter));
    });

    test('currentSegmentProvider starts at 0', () {
      final container = ProviderContainer();
      final segmentIndex = container.read(currentSegmentProvider);

      expect(segmentIndex, equals(0));
    });

    test('currentSegmentProvider can be updated', () {
      final container = ProviderContainer();

      container.read(currentSegmentProvider.notifier).state = 2;

      expect(container.read(currentSegmentProvider), equals(2));
    });

    test('currentSegmentProvider can be incremented', () {
      final container = ProviderContainer();

      // Initial value is 0
      expect(container.read(currentSegmentProvider), equals(0));

      // Increment
      final current = container.read(currentSegmentProvider);
      container.read(currentSegmentProvider.notifier).state = current + 1;

      expect(container.read(currentSegmentProvider), equals(1));
    });
  });

  group('Chapter State Management', () {
    test('can set chapter and segment together', () {
      final container = ProviderContainer();
      final mockChapter = MockData.createMockChapter(title: 'Test Chapter');

      // Set both chapter and segment
      container.read(currentChapterProvider.notifier).state = mockChapter;
      container.read(currentSegmentProvider.notifier).state = 1;

      expect(container.read(currentChapterProvider)?.title, equals('Test Chapter'));
      expect(container.read(currentSegmentProvider), equals(1));
    });

    test('segment index can advance through chapter', () {
      final container = ProviderContainer();
      final mockChapter = MockData.createMockChapter();
      container.read(currentChapterProvider.notifier).state = mockChapter;

      // Advance through all segments
      for (var i = 0; i < mockChapter.segments.length; i++) {
        container.read(currentSegmentProvider.notifier).state = i;
        expect(container.read(currentSegmentProvider), equals(i));
      }
    });
  });
}
