import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/screens/home_screen.dart';
import 'package:kingdom_of_abacus/screens/chapter/chapter_reader_screen.dart';
import 'package:kingdom_of_abacus/providers/chapter_providers.dart';
import 'package:kingdom_of_abacus/services/config_service.dart';
import '../test_helpers/mock_data.dart';

void main() {
  group('Chapter Playthrough Integration Tests', () {
    testWidgets('HomeScreen displays and navigates to chapter',
        (tester) async {
      // Create a mock chapter
      final mockChapter = MockData.createMockChapter(
        title: 'Chapter 1: Arrival at Coastal Cove',
      );

      // Override the config service to return our mock chapter
      final container = ProviderContainer(
        overrides: [
          chaptersProvider.overrideWith((ref) async => [mockChapter]),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for chapters to load
      await tester.pumpAndSettle();

      // Should see the chapter title
      expect(find.text('Chapter 1: Arrival at Coastal Cove'), findsOneWidget);

      // Should see chapter details
      expect(find.text('55 problems • addition'), findsOneWidget);

      // Tap the chapter
      await tester.tap(find.text('Chapter 1: Arrival at Coastal Cove'));
      await tester.pumpAndSettle();

      // Should navigate to chapter reader (checking for existence of Scaffold)
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('ChapterReaderScreen displays story segment', (tester) async {
      final mockChapter = MockData.createMockChapter();

      final container = ProviderContainer(
        overrides: [
          currentChapterProvider.overrideWith((ref) => mockChapter),
          currentSegmentProvider.overrideWith((ref) => 0),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChapterReaderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show story content for first segment
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('ChapterReaderScreen advances segments', (tester) async {
      final mockChapter = MockData.createMockChapter();

      final container = ProviderContainer(
        overrides: [
          currentChapterProvider.overrideWith((ref) => mockChapter),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChapterReaderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should be on first segment (story)
      expect(find.text('Continue'), findsOneWidget);

      // Tap continue to advance to next segment
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Should now show practice segment button
      expect(find.text('Start Practice'), findsOneWidget);
    });

    testWidgets('ChapterReaderScreen shows completion when finished',
        (tester) async {
      final mockChapter = MockData.createMockChapter();

      final container = ProviderContainer(
        overrides: [
          currentChapterProvider.overrideWith((ref) => mockChapter),
          // Set to last segment + 1 to trigger completion
          currentSegmentProvider
              .overrideWith((ref) => mockChapter.segments.length),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChapterReaderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show completion message
      expect(find.text('Chapter Complete!'), findsOneWidget);
      expect(find.text('You completed Test Chapter!'), findsOneWidget);
    });

    testWidgets('HomeScreen handles loading state', (tester) async {
      final container = ProviderContainer(
        overrides: [
          chaptersProvider.overrideWith(
            (ref) => Future.delayed(
              const Duration(seconds: 2),
              () => [MockData.createMockChapter()],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for future to complete
      await tester.pumpAndSettle();

      // Should now show chapter
      expect(find.text('Test Chapter'), findsOneWidget);
    });

    testWidgets('HomeScreen handles error state', (tester) async {
      final container = ProviderContainer(
        overrides: [
          chaptersProvider.overrideWith(
            (ref) => Future.error('Failed to load chapters'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show error message
      expect(find.text('Error loading chapters: Failed to load chapters'),
          findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('ChapterReaderScreen shows different segment types',
        (tester) async {
      final mockChapter = MockData.createMockChapter();

      final container = ProviderContainer(
        overrides: [
          currentChapterProvider.overrideWith((ref) => mockChapter),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChapterReaderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Segment 0: Story
      expect(find.text('Continue'), findsOneWidget);

      // Advance to segment 1: Practice
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Start Practice'), findsOneWidget);
      expect(find.byIcon(Icons.school), findsOneWidget);
    });
  });

  group('Screen Widget Tests', () {
    testWidgets('HomeScreen shows app bar with title', (tester) async {
      final container = ProviderContainer(
        overrides: [
          chaptersProvider.overrideWith((ref) async => []),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Kingdom of Abacus'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('ChapterReaderScreen shows chapter title in app bar',
        (tester) async {
      final mockChapter =
          MockData.createMockChapter(title: 'My Custom Chapter');

      final container = ProviderContainer(
        overrides: [
          currentChapterProvider.overrideWith((ref) => mockChapter),
          currentSegmentProvider.overrideWith((ref) => 0),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChapterReaderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('My Custom Chapter'), findsOneWidget);
    });
  });
}
