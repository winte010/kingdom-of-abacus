import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/models/chapter.dart';
import 'package:kingdom_of_abacus/models/segment.dart';

void main() {
  group('Chapter', () {
    final testSegment = Segment(
      id: 'segment_1',
      type: SegmentType.story,
      problemCount: 0,
      storyFile: 'test_story.md',
    );

    final testChapter = Chapter(
      id: 'test_chapter_1',
      title: 'Test Chapter',
      landId: 'test_land',
      mathTopic: 'addition',
      segments: [testSegment],
      totalProblems: 10,
    );

    test('creates chapter with all properties', () {
      expect(testChapter.id, 'test_chapter_1');
      expect(testChapter.title, 'Test Chapter');
      expect(testChapter.landId, 'test_land');
      expect(testChapter.mathTopic, 'addition');
      expect(testChapter.segments.length, 1);
      expect(testChapter.totalProblems, 10);
    });

    test('copyWith creates new instance with updated values', () {
      final updated = testChapter.copyWith(
        title: 'Updated Chapter',
        totalProblems: 20,
      );

      expect(updated.id, testChapter.id);
      expect(updated.title, 'Updated Chapter');
      expect(updated.totalProblems, 20);
      expect(updated.landId, testChapter.landId);
    });

    test('copyWith preserves original when no changes', () {
      final copy = testChapter.copyWith();

      expect(copy.id, testChapter.id);
      expect(copy.title, testChapter.title);
      expect(copy.totalProblems, testChapter.totalProblems);
    });

    test('equality works correctly', () {
      final chapter1 = Chapter(
        id: 'ch1',
        title: 'Chapter 1',
        landId: 'land1',
        mathTopic: 'addition',
        segments: [],
        totalProblems: 10,
      );

      final chapter2 = Chapter(
        id: 'ch1',
        title: 'Chapter 1',
        landId: 'land1',
        mathTopic: 'addition',
        segments: [],
        totalProblems: 10,
      );

      expect(chapter1, equals(chapter2));
    });

    test('different chapters are not equal', () {
      final chapter1 = Chapter(
        id: 'ch1',
        title: 'Chapter 1',
        landId: 'land1',
        mathTopic: 'addition',
        segments: [],
        totalProblems: 10,
      );

      final chapter2 = Chapter(
        id: 'ch2',
        title: 'Chapter 2',
        landId: 'land1',
        mathTopic: 'addition',
        segments: [],
        totalProblems: 10,
      );

      expect(chapter1, isNot(equals(chapter2)));
    });
  });
}
