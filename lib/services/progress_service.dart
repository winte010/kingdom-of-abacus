import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/progress.dart';
import 'supabase_service.dart';

/// Manages progress saving and loading (offline-first)
class ProgressService {
  static const _keyPrefix = 'progress_';

  /// Save progress locally (always succeeds)
  Future<void> saveProgress(Progress progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _keyPrefix + progress.chapterId;
      final json = jsonEncode(progress.toJson());

      await prefs.setString(key, json);

      // Queue for cloud sync (don't block on this)
      _queueForSync(progress);
    } catch (e) {
      throw ProgressSaveException('Failed to save progress locally: $e');
    }
  }

  /// Load progress from local storage
  Future<Progress?> loadProgress(String userId, String chapterId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _keyPrefix + chapterId;
      final json = prefs.getString(key);

      if (json == null) return null;

      final map = jsonDecode(json) as Map<String, dynamic>;
      return Progress.fromJson(map);
    } catch (e) {
      print('Warning: Failed to load progress: $e');
      return null;
    }
  }

  /// Sync to cloud (best effort)
  Future<void> _queueForSync(Progress progress) async {
    try {
      await SupabaseService.client.from('progress').upsert(progress.toJson());
      print('✅ Progress synced to cloud');
    } catch (e) {
      print('⚠️ Cloud sync failed (will retry later): $e');
      // In production, add to retry queue
    }
  }

  /// Load from cloud (when online)
  Future<Progress?> loadFromCloud(String userId, String chapterId) async {
    try {
      final response = await SupabaseService.client
          .from('progress')
          .select()
          .eq('user_id', userId)
          .eq('chapter_id', chapterId)
          .maybeSingle();

      if (response == null) return null;

      return Progress.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Warning: Failed to load from cloud: $e');
      return null;
    }
  }
}

class ProgressSaveException implements Exception {
  final String message;
  ProgressSaveException(this.message);

  @override
  String toString() => 'ProgressSaveException: $message';
}
