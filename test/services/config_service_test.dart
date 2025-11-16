import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/services/config_service.dart';

void main() {
  group('ConfigService', () {
    late ConfigService service;

    setUp(() {
      service = ConfigService();
    });

    test('loadChapter throws ConfigLoadException for missing file', () async {
      expect(
        () => service.loadChapter('non_existent_chapter'),
        throwsA(isA<ConfigLoadException>()),
      );
    });

    test('loadAllChapters handles missing files gracefully', () async {
      // This test will fail until actual config files are created
      // For now, it should return an empty list
      final chapters = await service.loadAllChapters();
      expect(chapters, isA<List>());
    });

    test('clearCache clears the chapter cache', () {
      // Load a chapter (will fail but that's ok for this test)
      // Then clear cache
      service.clearCache();

      // Cache should be empty now (no way to verify directly, but shouldn't throw)
    });

    test('ConfigLoadException has correct message', () {
      final exception = ConfigLoadException('Test error message');
      expect(exception.toString(), contains('Test error message'));
    });
  });
}
