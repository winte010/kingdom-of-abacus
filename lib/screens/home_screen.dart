import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chapter.dart';
import '../providers/chapter_providers.dart';
import 'chapter/chapter_reader_screen.dart';

/// Home screen showing the list of available chapters
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kingdom of Abacus'),
        centerTitle: true,
      ),
      body: chaptersAsync.when(
        data: (chapters) => _buildChapterList(context, ref, chapters),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading chapters: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(chaptersProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChapterList(
      BuildContext context, WidgetRef ref, List<Chapter> chapters) {
    if (chapters.isEmpty) {
      return const Center(
        child: Text('No chapters available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return _ChapterCard(chapter: chapter);
      },
    );
  }
}

class _ChapterCard extends ConsumerWidget {
  final Chapter chapter;

  const _ChapterCard({required this.chapter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load progress for this chapter
    final userId = ref.watch(userIdProvider);
    final progressService = ref.read(progressServiceProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _onChapterTap(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      chapter.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Land: ${chapter.landId}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Math Topic: ${chapter.mathTopic}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              _buildProgressIndicator(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    // For now, show total problems
    // In the future, we can load progress and show completion percentage
    return Row(
      children: [
        Icon(
          Icons.school,
          size: 16,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 4),
        Text(
          '${chapter.totalProblems} problems',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _onChapterTap(BuildContext context, WidgetRef ref) {
    // Set as current chapter
    ref.read(currentChapterProvider.notifier).state = chapter;
    ref.read(currentSegmentIndexProvider.notifier).state = 0;

    // Navigate to chapter reader
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChapterReaderScreen(),
      ),
    );
  }
}
