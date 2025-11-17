import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/chapter.dart';

/// Loads and caches chapter configurations from JSON files
class ConfigService {
  final Map<String, Chapter> _cache = {};

  /// Load a chapter configuration by ID
  Future<Chapter> loadChapter(String chapterId) async {
    // Check cache first
    if (_cache.containsKey(chapterId)) {
      return _cache[chapterId]!;
    }

    try {
      // Load JSON from assets
      final jsonString = await rootBundle.loadString(
        'assets/config/chapters/$chapterId.json',
      );

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final chapter = Chapter.fromJson(json);

      // Cache it
      _cache[chapterId] = chapter;

      return chapter;
    } catch (e) {
      throw ConfigLoadException('Failed to load chapter $chapterId: $e');
    }
  }

  /// Load all available chapters
  Future<List<Chapter>> loadAllChapters() async {
    // For MVP, we know the chapter IDs
    final chapterIds = [
      'coastal_cove_1',
      'coastal_cove_2',
      'coastal_cove_3',
    ];

    final chapters = <Chapter>[];
    for (final id in chapterIds) {
      try {
        chapters.add(await loadChapter(id));
      } catch (e) {
        print('Warning: Failed to load chapter $id: $e');
      }
    }

    return chapters;
  }

  /// Clear the cache
  void clearCache() {
    _cache.clear();
  }
}

class ConfigLoadException implements Exception {
  final String message;
  ConfigLoadException(this.message);

  @override
  String toString() => 'ConfigLoadException: $message';
}
