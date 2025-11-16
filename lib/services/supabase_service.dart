import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Manages Supabase connection and provides client access
class SupabaseService {
  static SupabaseClient? _client;

  /// Initialize Supabase with environment variables
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');

    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (url == null || anonKey == null) {
      throw Exception('SUPABASE_URL and SUPABASE_ANON_KEY must be set in .env');
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );

    _client = Supabase.instance.client;
  }

  /// Get the Supabase client
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
          'SupabaseService not initialized. Call initialize() first.');
    }
    return _client!;
  }

  /// Test connection by querying users table
  static Future<bool> testConnection() async {
    try {
      await client.from('users').select('id').limit(1);
      print('✅ Supabase connection successful');
      return true;
    } catch (e) {
      print('❌ Supabase connection failed: $e');
      return false;
    }
  }
}
