import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/chapter_providers.dart';
import '../../models/segment.dart';
import '../../models/chapter.dart';
import '../../models/progress.dart';
import '../../widgets/book/book_page.dart';
import '../gameplay/timed_challenge_screen.dart';
import '../boss_battle_screen.dart';

class ChapterReaderScreen extends ConsumerWidget {
  const ChapterReaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = ref.watch(currentChapterProvider);
    final segmentIndex = ref.watch(currentSegmentProvider);

    if (chapter == null) {
      return const Scaffold(
        body: Center(child: Text('No chapter selected')),
      );
    }

    if (segmentIndex >= chapter.segments.length) {
      // Chapter complete!
      return _buildChapterComplete(context, ref, chapter);
    }

    final segment = chapter.segments[segmentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: _buildSegmentContent(context, ref, segment),
    );
  }

  Widget _buildSegmentContent(
      BuildContext context, WidgetRef ref, Segment segment) {
    switch (segment.type) {
      case SegmentType.story:
        return _buildStorySegment(context, ref, segment);
      case SegmentType.timedChallenge:
        return _buildTimedChallengeButton(context, ref, segment);
      case SegmentType.practice:
        return _buildPracticeSegment(context, ref, segment);
      case SegmentType.bossBattle:
        return _buildBossBattleButton(context, ref, segment);
    }
  }

  Widget _buildStorySegment(
      BuildContext context, WidgetRef ref, Segment segment) {
    // For MVP, show placeholder text
    // In production, load from segment.storyFile
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: BookPage(
              text: segment.storyFile != null
                  ? 'Story content would go here from ${segment.storyFile}'
                  : 'Welcome to the Kingdom of Abacus! Your adventure begins...',
            ),
          ),
          ElevatedButton(
            onPressed: () => _advanceSegment(ref),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Continue', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimedChallengeButton(
      BuildContext context, WidgetRef ref, Segment segment) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, size: 100, color: Colors.orange),
          const SizedBox(height: 24),
          Text(
            'Timed Challenge!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            '${segment.problemCount} problems${segment.timeLimit != null ? " • ${segment.timeLimit}s each" : ""}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _startTimedChallenge(context, ref, segment),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              child: Text('Start Challenge', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBossBattleButton(
      BuildContext context, WidgetRef ref, Segment segment) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shield, size: 100, color: Colors.red),
          const SizedBox(height: 24),
          Text(
            'Boss Battle!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Face the Chaos Kraken',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _startBossBattle(context, ref, segment),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              child: Text('Enter Battle', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeSegment(
      BuildContext context, WidgetRef ref, Segment segment) {
    // Similar to timed challenge but no timer
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.school, size: 100, color: Colors.blue),
          const SizedBox(height: 24),
          Text(
            'Practice Time!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            '${segment.problemCount} problems',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _startPractice(context, ref, segment),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              child: Text('Start Practice', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterComplete(
      BuildContext context, WidgetRef ref, Chapter chapter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, size: 100, color: Colors.amber),
          const SizedBox(height: 24),
          Text(
            'Chapter Complete!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text('You completed ${chapter.title}!'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _completeChapter(context, ref, chapter),
            child: const Text('Back to Chapters'),
          ),
        ],
      ),
    );
  }

  Future<void> _completeChapter(
      BuildContext context, WidgetRef ref, Chapter chapter) async {
    // Save progress for chapter completion
    try {
      final progressService = ref.read(progressServiceProvider);
      final segmentIndex = ref.read(currentSegmentProvider);

      final progress = Progress(
        userId: 'anonymous', // TODO: Get from auth
        chapterId: chapter.id ?? '',
        currentSegment: chapter.segments.length, // All segments complete
        problemsCompleted: 0, // Will be aggregated from segments
        problemsCorrect: 0, // Will be aggregated from segments
        completed: true, // Chapter is fully complete
        lastPlayed: DateTime.now(),
      );

      await progressService.saveProgress(progress);
    } catch (e) {
      debugPrint('Failed to save progress: $e');
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _advanceSegment(WidgetRef ref) {
    final currentIndex = ref.read(currentSegmentProvider);
    ref.read(currentSegmentProvider.notifier).state = currentIndex + 1;
  }

  void _startTimedChallenge(
      BuildContext context, WidgetRef ref, Segment segment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimedChallengeScreen(segment: segment),
      ),
    ).then((_) => _advanceSegment(ref));
  }

  void _startBossBattle(BuildContext context, WidgetRef ref, Segment segment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BossBattleScreen(segment: segment),
      ),
    ).then((_) => _advanceSegment(ref));
  }

  void _startPractice(BuildContext context, WidgetRef ref, Segment segment) {
    // For MVP, practice is similar to timed challenge without strict timer
    _startTimedChallenge(context, ref, segment);
  }
}
