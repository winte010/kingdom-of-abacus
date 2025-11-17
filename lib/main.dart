import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/supabase_service.dart';
import 'utils/logger.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Supabase
    await SupabaseService.initialize();
    Logger.info('Supabase initialized');

    // Test connection
    await SupabaseService.testConnection();

    runApp(const ProviderScope(child: MyApp()));
  } catch (e, stackTrace) {
    Logger.error('Failed to initialize app', e, stackTrace);
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdom of Abacus',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
