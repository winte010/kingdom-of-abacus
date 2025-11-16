import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chapter.dart';
import '../models/progress.dart';
import '../services/config_service.dart';
import '../services/progress_service.dart';

// Services
final configServiceProvider = Provider<ConfigService>((ref) {
  return ConfigService();
});

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

// Load all chapters from config
final chaptersProvider = FutureProvider<List<Chapter>>((ref) async {
  final configService = ref.read(configServiceProvider);
  return configService.loadAllChapters();
});

// Currently selected chapter
final currentChapterProvider = StateProvider<Chapter?>((ref) => null);

// Current segment index within chapter
final currentSegmentIndexProvider = StateProvider<int>((ref) => 0);

// User ID (for MVP, using 'anonymous', will be replaced with auth later)
final userIdProvider = StateProvider<String>((ref) => 'anonymous');

// Load progress for current chapter
final currentChapterProgressProvider = FutureProvider<Progress?>((ref) async {
  final chapter = ref.watch(currentChapterProvider);
  if (chapter == null) return null;

  final userId = ref.read(userIdProvider);
  final progressService = ref.read(progressServiceProvider);

  return progressService.loadProgress(userId, chapter.id);
});

// Provider to save progress
final saveProgressProvider = Provider<Future<void> Function(Progress)>((ref) {
  final progressService = ref.read(progressServiceProvider);
  return (progress) async {
    await progressService.saveProgress(progress);
    // Invalidate the current chapter progress to reload
    ref.invalidate(currentChapterProgressProvider);
  };
});
