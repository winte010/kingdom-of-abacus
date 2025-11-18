import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chapter_providers.dart';
import '../models/chapter.dart';
import 'chapter/chapter_reader_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kingdom of Abacus'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: chaptersAsync.when(
        data: (chapters) => _buildChapterList(context, ref, chapters),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              chapter.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${chapter.totalProblems} problems • ${chapter.mathTopic}',
              style: const TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _onChapterTap(context, ref, chapter),
          ),
        );
      },
    );
  }

  void _onChapterTap(BuildContext context, WidgetRef ref, Chapter chapter) {
    ref.read(currentChapterProvider.notifier).state = chapter;
    ref.read(currentSegmentProvider.notifier).state = 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChapterReaderScreen(),
      ),
    );
  }
}
