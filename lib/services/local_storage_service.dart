import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Manages local storage operations (offline-first)
class LocalStorageService {
  /// Save a value to local storage
  Future<void> save(String key, Map<String, dynamic> value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(value);
      await prefs.setString(key, json);
    } catch (e) {
      throw StorageException('Failed to save to local storage: $e');
    }
  }

  /// Load a value from local storage
  Future<Map<String, dynamic>?> load(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(key);

      if (json == null) return null;

      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      print('Warning: Failed to load from storage: $e');
      return null;
    }
  }

  /// Delete a value from local storage
  Future<void> delete(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      print('Warning: Failed to delete from storage: $e');
    }
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Warning: Failed to clear storage: $e');
    }
  }
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
