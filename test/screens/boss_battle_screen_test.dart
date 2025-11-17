import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingdom_of_abacus/screens/boss_battle_screen.dart';
import 'package:kingdom_of_abacus/models/segment.dart';
import 'package:kingdom_of_abacus/widgets/boss/boss_display.dart';
import 'package:kingdom_of_abacus/widgets/boss/boss_health_bar.dart';
import 'package:kingdom_of_abacus/widgets/problems/problem_display.dart';
import 'package:kingdom_of_abacus/widgets/input/number_pad.dart';
import 'package:kingdom_of_abacus/widgets/gameplay/progress_indicator.dart';
import '../test_helpers/mock_data.dart';

void main() {
  group('BossBattleScreen Tests', () {
    late Segment mockSegment;

    setUp(() {
      mockSegment = MockData.createMockSegment(
        type: SegmentType.bossBattle,
        problemCount: 10,
      );
    });

    testWidgets('renders basic UI elements', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show boss battle components
      expect(find.byType(BossDisplay), findsOneWidget);
      expect(find.byType(BossHealthBar), findsOneWidget);
      expect(find.byType(ProblemDisplay), findsOneWidget);
      expect(find.byType(NumberPad), findsOneWidget);
      expect(find.byType(GameProgressIndicator), findsOneWidget);
    });

    testWidgets('shows boss name', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show Chaos Kraken
      expect(find.text('Chaos Kraken'), findsOneWidget);
    });

    testWidgets('shows boss battle in app bar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Boss Battle'), findsOneWidget);
    });

    testWidgets('app bar has no back button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should not have a back button (automaticallyImplyLeading: false)
      expect(find.byType(BackButton), findsNothing);
    });

    testWidgets('app bar has red background', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(Colors.red));
    });

    testWidgets('initial boss health is 100', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show full health
      expect(find.text('100 / 100'), findsOneWidget);
    });

    testWidgets('progress starts at 0/total', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(segment: mockSegment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show 0/10 progress (no problems completed yet)
      expect(find.text('0 / 10'), findsOneWidget);
    });
  });

  group('BossBattleScreen Problem Generation', () {
    testWidgets('generates correct number of problems', (tester) async {
      final segment = MockData.createMockSegment(
        type: SegmentType.bossBattle,
        problemCount: 5,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BossBattleScreen(segment: segment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show 0/5 indicating 5 total problems
      expect(find.text('0 / 5'), findsOneWidget);
    });
  });
}
