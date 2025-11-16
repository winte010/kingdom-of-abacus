import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chapter.dart';
import '../models/progress.dart';
import '../services/config_service.dart';
import '../services/progress_service.dart';

// Config service instance
final configServiceProvider = Provider<ConfigService>((ref) {
  return ConfigService();
});

// Progress service instance
final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

// Load all available chapters
final chaptersProvider = FutureProvider<List<Chapter>>((ref) async {
  final configService = ref.watch(configServiceProvider);
  return await configService.loadAllChapters();
});

// Currently selected chapter
final currentChapterProvider = StateProvider<Chapter?>((ref) => null);

// Current segment index
final currentSegmentProvider = StateProvider<int>((ref) => 0);

// Load progress for current chapter
final currentProgressProvider = FutureProvider<Progress?>((ref) async {
  final chapter = ref.watch(currentChapterProvider);
  if (chapter == null) return null;

  final progressService = ref.watch(progressServiceProvider);
  // TODO: Get actual user ID from auth
  final userId = 'anonymous';

  return await progressService.loadProgress(userId, chapter.id);
});
