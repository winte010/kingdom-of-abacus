import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/side_quest/pocket_realm_overlay.dart';

void main() {
  group('PocketRealmOverlay', () {
    testWidgets('displays child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: Text('Side Quest Content'),
            ),
          ),
        ),
      );

      expect(find.text('Side Quest Content'), findsOneWidget);
    });

    testWidgets('shows dimmed background', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: Text('Content'),
            ),
          ),
        ),
      );

      // Find the background container
      final containers = tester.widgetList<Container>(find.byType(Container));
      final backgroundContainer = containers.first;

      expect(backgroundContainer.color, Colors.black.withOpacity(0.7));
    });

    testWidgets('shows close button when onClose is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: const Text('Content'),
              onClose: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('does not show close button when onClose is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('calls onClose when close button is tapped', (tester) async {
      bool closed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: const Text('Content'),
              onClose: () {
                closed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(closed, isTrue);
    });

    testWidgets('content is centered', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('content has rounded corners', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: Text('Content'),
            ),
          ),
        ),
      );

      final contentContainer = tester.widget<Container>(
        find.ancestor(
          of: find.text('Content'),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = contentContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(24));
    });

    testWidgets('content has purple glow shadow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: Text('Content'),
            ),
          ),
        ),
      );

      final contentContainer = tester.widget<Container>(
        find.ancestor(
          of: find.text('Content'),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = contentContainer.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.isNotEmpty, isTrue);

      final shadow = decoration.boxShadow!.first;
      expect(shadow.color, Colors.purple.withOpacity(0.5));
    });

    testWidgets('content has proper padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: Text('Content'),
            ),
          ),
        ),
      );

      final contentContainer = tester.widget<Container>(
        find.ancestor(
          of: find.text('Content'),
          matching: find.byType(Container),
        ).first,
      );

      expect(contentContainer.padding, const EdgeInsets.all(24));
    });

    testWidgets('close button is positioned in top right', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: const Text('Content'),
              onClose: () {},
            ),
          ),
        ),
      );

      final positioned =
          tester.widget<Positioned>(find.byType(Positioned).last);
      expect(positioned.top, 40);
      expect(positioned.right, 40);
    });

    testWidgets('uses Stack to layer components', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PocketRealmOverlay(
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(Stack), findsOneWidget);
    });
  });
}
