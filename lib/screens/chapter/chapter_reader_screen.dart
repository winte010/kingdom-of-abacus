import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chapter.dart';
import '../../models/segment.dart';
import '../../models/progress.dart';
import '../../providers/chapter_providers.dart';
import '../../widgets/book/book_page.dart';
import '../gameplay/timed_challenge_screen.dart';
import '../boss_battle_screen.dart';

/// Manages the flow through chapter segments (story, practice, challenges, boss battles)
class ChapterReaderScreen extends ConsumerStatefulWidget {
  const ChapterReaderScreen({super.key});

  @override
  ConsumerState<ChapterReaderScreen> createState() =>
      _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends ConsumerState<ChapterReaderScreen> {
  @override
  Widget build(BuildContext context) {
    final chapter = ref.watch(currentChapterProvider);
    final segmentIndex = ref.watch(currentSegmentIndexProvider);

    if (chapter == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No chapter selected')),
      );
    }

    if (segmentIndex >= chapter.segments.length) {
      // Chapter complete
      return _buildChapterCompleteScreen(context, chapter);
    }

    final segment = chapter.segments[segmentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.title),
        actions: [
          // Show progress indicator
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${segmentIndex + 1}/${chapter.segments.length}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: _buildSegmentContent(context, chapter, segment, segmentIndex),
    );
  }

  Widget _buildSegmentContent(
      BuildContext context, Chapter chapter, Segment segment, int index) {
    switch (segment.type) {
      case SegmentType.story:
        return _buildStorySegment(context, chapter, segment);
      case SegmentType.practice:
      case SegmentType.timedChallenge:
        return _buildChallengeButton(context, chapter, segment);
      case SegmentType.bossBattle:
        return _buildBossBattleButton(context, chapter, segment);
    }
  }

  Widget _buildStorySegment(
      BuildContext context, Chapter chapter, Segment segment) {
    return Column(
      children: [
        Expanded(
          child: BookPage(
            content: segment.storyFile ??
                'Once upon a time in the Kingdom of Abacus...',
            onPageComplete: () {
              // Story segment complete, move to next segment
              _advanceToNextSegment(chapter);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => _advanceToNextSegment(chapter),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeButton(
      BuildContext context, Chapter chapter, Segment segment) {
    final isTimedChallenge = segment.type == SegmentType.timedChallenge;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isTimedChallenge ? Icons.timer : Icons.sports_esports,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            isTimedChallenge ? 'Timed Challenge' : 'Practice',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            '${segment.problemCount} problems',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (segment.timeLimit != null) ...[
            const SizedBox(height: 8),
            Text(
              '${segment.timeLimit} seconds per problem',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _startChallenge(context, chapter, segment),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Text('Start Challenge', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBossBattleButton(
      BuildContext context, Chapter chapter, Segment segment) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield,
            size: 80,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 24),
          Text(
            'Boss Battle',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Defeat the boss to complete this chapter!',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _startBossBattle(context, chapter, segment),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Text('Enter Battle', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCompleteScreen(BuildContext context, Chapter chapter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.celebration,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Chapter Complete!',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'You completed "${chapter.title}"',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Text('Return to Chapters', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  void _advanceToNextSegment(Chapter chapter) async {
    final currentIndex = ref.read(currentSegmentIndexProvider);
    final newIndex = currentIndex + 1;

    // Save progress
    await _saveProgress(chapter, newIndex);

    // Update segment index
    ref.read(currentSegmentIndexProvider.notifier).state = newIndex;
  }

  void _startChallenge(
      BuildContext context, Chapter chapter, Segment segment) async {
    if (segment.problemConfig == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No problem config for this segment')),
      );
      return;
    }

    // Navigate to timed challenge screen
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => TimedChallengeScreen(
          segment: segment,
          chapter: chapter,
        ),
      ),
    );

    // If challenge was completed successfully, advance to next segment
    if (result == true) {
      _advanceToNextSegment(chapter);
    }
  }

  void _startBossBattle(
      BuildContext context, Chapter chapter, Segment segment) async {
    // Navigate to boss battle screen
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => BossBattleScreen(
          segment: segment,
          chapter: chapter,
        ),
      ),
    );

    // If boss battle was won, advance to next segment
    if (result == true) {
      _advanceToNextSegment(chapter);
    }
  }

  Future<void> _saveProgress(Chapter chapter, int segmentIndex) async {
    final userId = ref.read(userIdProvider);
    final saveProgress = ref.read(saveProgressProvider);

    // Load current progress or create new
    final currentProgress = await ref.read(progressServiceProvider).loadProgress(
          userId,
          chapter.id,
        );

    final progress = Progress(
      userId: userId,
      chapterId: chapter.id,
      currentSegment: segmentIndex,
      problemsCompleted: currentProgress?.problemsCompleted ?? 0,
      problemsCorrect: currentProgress?.problemsCorrect ?? 0,
      completed: segmentIndex >= chapter.segments.length,
      lastPlayed: DateTime.now(),
    );

    await saveProgress(progress);
  }
}
