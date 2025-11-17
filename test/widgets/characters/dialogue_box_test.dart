import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/characters/dialogue_box.dart';

void main() {
  group('DialogueBox', () {
    testWidgets('displays character name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DialogueBox(
              characterName: 'Pearl Keeper',
              text: 'Hello there!',
            ),
          ),
        ),
      );

      expect(find.text('Pearl Keeper'), findsOneWidget);
    });

    testWidgets('displays dialogue text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DialogueBox(
              characterName: 'Pearl Keeper',
              text: 'Welcome to the Kingdom!',
            ),
          ),
        ),
      );

      expect(find.text('Welcome to the Kingdom!'), findsOneWidget);
    });

    testWidgets('shows close button when onDismiss is provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DialogueBox(
              characterName: 'Pearl Keeper',
              text: 'Hello!',
              onDismiss: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('does not show close button when onDismiss is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DialogueBox(
              characterName: 'Pearl Keeper',
              text: 'Hello!',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('calls onDismiss when close button is tapped', (tester) async {
      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DialogueBox(
              characterName: 'Pearl Keeper',
              text: 'Hello!',
              onDismiss: () {
                dismissed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(dismissed, isTrue);
    });

    testWidgets('has box shadow for depth', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DialogueBox(
              characterName: 'Pearl Keeper',
              text: 'Hello!',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Pearl Keeper'),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.isNotEmpty, isTrue);
    });

    testWidgets('has rounded corners', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DialogueBox(
              characterName: 'Pearl Keeper',
              text: 'Hello!',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Pearl Keeper'),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(16));
    });

    testWidgets('character name is bold', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DialogueBox(
              characterName: 'Pearl Keeper',
              text: 'Hello!',
            ),
          ),
        ),
      );

      final nameText = tester.widget<Text>(find.text('Pearl Keeper'));
      expect(nameText.style?.fontWeight, FontWeight.bold);
    });
  });
}
