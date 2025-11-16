import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/services/progress_service.dart';
import 'package:kingdom_of_abacus/models/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProgressService', () {
    late ProgressService service;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      service = ProgressService();
    });

    test('saves progress locally', () async {
      final progress = Progress(
        userId: 'user123',
        chapterId: 'chapter1',
        currentSegment: 2,
        problemsCompleted: 15,
        problemsCorrect: 12,
        completed: false,
        lastPlayed: DateTime.now(),
      );

      // Should not throw
      await service.saveProgress(progress);
    });

    test('loads progress from local storage', () async {
      final testDate = DateTime.now();
      final progress = Progress(
        userId: 'user123',
        chapterId: 'chapter1',
        currentSegment: 2,
        problemsCompleted: 15,
        problemsCorrect: 12,
        completed: false,
        lastPlayed: testDate,
      );

      await service.saveProgress(progress);
      final loaded = await service.loadProgress('user123', 'chapter1');

      expect(loaded, isNotNull);
      expect(loaded!.userId, 'user123');
      expect(loaded.chapterId, 'chapter1');
      expect(loaded.currentSegment, 2);
      expect(loaded.problemsCompleted, 15);
      expect(loaded.problemsCorrect, 12);
    });

    test('returns null when no progress saved', () async {
      final loaded = await service.loadProgress('user123', 'chapter_not_saved');
      expect(loaded, null);
    });

    test('ProgressSaveException has correct message', () {
      final exception = ProgressSaveException('Test error');
      expect(exception.toString(), contains('Test error'));
    });
  });
}
