import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/book/story_unlock_overlay.dart';

void main() {
  group('StoryUnlockOverlay', () {
    testWidgets('displays child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoryUnlockOverlay(
              progress: 0.5,
              child: Text('Story content'),
            ),
          ),
        ),
      );

      expect(find.text('Story content'), findsOneWidget);
    });

    testWidgets('shows lock icon when not fully unlocked', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoryUnlockOverlay(
              progress: 0.3,
              child: Text('Story'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('displays correct percentage text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoryUnlockOverlay(
              progress: 0.75,
              child: Text('Story'),
            ),
          ),
        ),
      );

      expect(find.text('75% Unlocked'), findsOneWidget);
    });

    testWidgets('overlay is fully transparent when progress is 1.0',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoryUnlockOverlay(
              progress: 1.0,
              child: Text('Story'),
            ),
          ),
        ),
      );

      // Find the AnimatedOpacity widget
      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );

      expect(animatedOpacity.opacity, 0.0);
    });

    testWidgets('overlay is fully opaque when progress is 0.0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoryUnlockOverlay(
              progress: 0.0,
              child: Text('Story'),
            ),
          ),
        ),
      );

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );

      expect(animatedOpacity.opacity, 1.0);
    });

    testWidgets('displays 0% when progress is 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoryUnlockOverlay(
              progress: 0.0,
              child: Text('Story'),
            ),
          ),
        ),
      );

      expect(find.text('0% Unlocked'), findsOneWidget);
    });

    testWidgets('displays 100% when progress is 1', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoryUnlockOverlay(
              progress: 1.0,
              child: Text('Story'),
            ),
          ),
        ),
      );

      expect(find.text('100% Unlocked'), findsOneWidget);
    });

    testWidgets('animates opacity change smoothly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoryUnlockOverlay(
              progress: 0.5,
              child: Text('Story'),
            ),
          ),
        ),
      );

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );

      expect(animatedOpacity.duration, const Duration(milliseconds: 300));
    });
  });
}
