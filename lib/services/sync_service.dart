import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'supabase_service.dart';

/// Manages cloud sync operations with retry logic
class SyncService {
  static const _syncQueueKey = 'sync_queue';
  static const _maxRetries = 3;
  static const _retryDelay = Duration(seconds: 30);

  final List<Map<String, dynamic>> _pendingSync = [];
  Timer? _retryTimer;

  /// Queue an item for cloud sync
  Future<void> queueForSync(String table, Map<String, dynamic> data) async {
    _pendingSync.add({
      'table': table,
      'data': data,
      'retries': 0,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Try to sync immediately
    await _processSyncQueue();

    // Save queue to persistent storage
    await _saveSyncQueue();
  }

  /// Process the sync queue
  Future<void> _processSyncQueue() async {
    if (_pendingSync.isEmpty) return;

    final itemsToRemove = <Map<String, dynamic>>[];

    for (final item in _pendingSync) {
      try {
        final table = item['table'] as String;
        final data = item['data'] as Map<String, dynamic>;

        await SupabaseService.client.from(table).upsert(data);

        // Success - mark for removal
        itemsToRemove.add(item);
        print('✅ Synced to cloud: $table');
      } catch (e) {
        // Increment retry count
        item['retries'] = (item['retries'] as int) + 1;

        if (item['retries'] >= _maxRetries) {
          // Max retries exceeded - remove from queue
          itemsToRemove.add(item);
          print('❌ Max retries exceeded for sync: ${item['table']}');
        } else {
          print('⚠️ Sync failed (retry ${item['retries']}/$_maxRetries): $e');
        }
      }
    }

    // Remove successfully synced or failed items
    _pendingSync.removeWhere((item) => itemsToRemove.contains(item));

    // Schedule retry if there are pending items
    if (_pendingSync.isNotEmpty) {
      _scheduleRetry();
    }
  }

  /// Schedule a retry attempt
  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(_retryDelay, () {
      _processSyncQueue();
    });
  }

  /// Save sync queue to persistent storage
  Future<void> _saveSyncQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_pendingSync);
      await prefs.setString(_syncQueueKey, json);
    } catch (e) {
      print('Warning: Failed to save sync queue: $e');
    }
  }

  /// Load sync queue from persistent storage
  Future<void> loadSyncQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_syncQueueKey);

      if (json != null) {
        final list = jsonDecode(json) as List<dynamic>;
        _pendingSync.addAll(list.cast<Map<String, dynamic>>());

        // Try to process loaded queue
        await _processSyncQueue();
      }
    } catch (e) {
      print('Warning: Failed to load sync queue: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _retryTimer?.cancel();
  }
}
