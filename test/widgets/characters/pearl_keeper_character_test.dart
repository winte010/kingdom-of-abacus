import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/characters/pearl_keeper_character.dart';
import 'package:kingdom_of_abacus/models/segment.dart';

void main() {
  group('PearlKeeperCharacter', () {
    testWidgets('displays placeholder when .riv file is missing',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.happy,
            ),
          ),
        ),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Should show placeholder with "Pearl Keeper" text
      expect(find.text('Pearl Keeper'), findsOneWidget);
    });

    testWidgets('respects width parameter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.happy,
              width: 300,
              height: 200,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.text('Pearl Keeper'),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(sizedBox.width, 300);
    });

    testWidgets('respects height parameter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.happy,
              width: 300,
              height: 250,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.text('Pearl Keeper'),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(sizedBox.height, 250);
    });

    testWidgets('shows happy icon for happy emotion', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.happy,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.sentiment_satisfied), findsOneWidget);
    });

    testWidgets('shows excited icon for excited emotion', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.excited,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.sentiment_very_satisfied), findsOneWidget);
    });

    testWidgets('shows worried icon for worried emotion', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.worried,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.sentiment_dissatisfied), findsOneWidget);
    });

    testWidgets('shows proud icon for proud emotion', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.proud,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('shows surprised icon for surprised emotion', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.surprised,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.sentiment_neutral), findsOneWidget);
    });

    testWidgets('placeholder has rounded corners', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.happy,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Pearl Keeper'),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(16));
    });

    testWidgets('placeholder has border', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.happy,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Pearl Keeper'),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.happy,
            ),
          ),
        ),
      );

      // Before pumpAndSettle, should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('does not crash with invalid animation path', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              animationPath: 'assets/nonexistent/file.riv',
              emotion: CharacterEmotion.happy,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should gracefully fallback to placeholder
      expect(find.text('Pearl Keeper'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('uses default animation path when not specified',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(
              emotion: CharacterEmotion.happy,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should attempt to load default path and fallback gracefully
      expect(find.text('Pearl Keeper'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('default emotion is happy', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show happy emotion by default
      expect(find.byIcon(Icons.sentiment_satisfied), findsOneWidget);
    });

    testWidgets('default size is 200x200', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PearlKeeperCharacter(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.text('Pearl Keeper'),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(sizedBox.width, 200);
      expect(sizedBox.height, 200);
    });
  });
}
