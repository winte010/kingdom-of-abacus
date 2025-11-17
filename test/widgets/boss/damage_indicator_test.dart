import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/boss/damage_indicator.dart';

void main() {
  group('DamageIndicator', () {
    testWidgets('displays damage amount with minus sign for player damage',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DamageIndicator(
              damage: 10,
              isPlayerDamage: true,
            ),
          ),
        ),
      );

      expect(find.text('-10'), findsOneWidget);
    });

    testWidgets('displays damage amount with plus sign for boss damage',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DamageIndicator(
              damage: 15,
              isPlayerDamage: false,
            ),
          ),
        ),
      );

      expect(find.text('+15'), findsOneWidget);
    });

    testWidgets('uses red color for player damage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DamageIndicator(
              damage: 10,
              isPlayerDamage: true,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('-10'));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('uses green color for boss damage (player hitting boss)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DamageIndicator(
              damage: 10,
              isPlayerDamage: false,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('+10'));
      expect(textWidget.style?.color, Colors.green);
    });

    testWidgets('has slide transition animation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DamageIndicator(
              damage: 10,
            ),
          ),
        ),
      );

      expect(find.byType(SlideTransition), findsOneWidget);
    });

    testWidgets('has fade transition animation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DamageIndicator(
              damage: 10,
            ),
          ),
        ),
      );

      expect(find.byType(FadeTransition), findsOneWidget);
    });

    testWidgets('text has shadow for visibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DamageIndicator(
              damage: 10,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('+10'));
      expect(textWidget.style?.shadows, isNotNull);
      expect(textWidget.style?.shadows!.isNotEmpty, isTrue);
    });

    testWidgets('has bold font weight', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DamageIndicator(
              damage: 10,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('+10'));
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('has large font size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DamageIndicator(
              damage: 10,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('+10'));
      expect(textWidget.style?.fontSize, 32);
    });
  });
}
