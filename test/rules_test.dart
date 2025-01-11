import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabong_v1/screens/rules.dart';

void main() {
  testWidgets('RulesScreen widget test', (WidgetTester tester) async {
    // Build the RulesScreen widget.
    await tester.pumpWidget(MaterialApp(
      home: RulesScreen(),
    ));

    // Verify the AppBar title is present.
    expect(find.text('Rules Page'), findsOneWidget);

    // Verify the ExpansionTiles are present.
    expect(find.text('Basic Rules'), findsOneWidget);
    expect(find.text('Special Cards'), findsOneWidget);
    expect(find.text('Special Rules'), findsOneWidget);
    expect(find.text('Gameplay'), findsOneWidget);
    expect(find.text('Gabong Master'), findsOneWidget);
    expect(find.text('Penalty Cards'), findsOneWidget);
    expect(find.text('Counting Points'), findsOneWidget);

    // Expand the 'Basic Rules' ExpansionTile and verify its content.
    await tester.tap(find.text('Basic Rules'));
    await tester.pumpAndSettle();
    expect(find.text('A player can place cards of the same type* on top of each other'), findsOneWidget);

    // Collapse the 'Basic Rules' ExpansionTile.
    await tester.tap(find.text('Basic Rules'));
    await tester.pumpAndSettle();
    expect(find.text('A player can place cards of the same type* on top of each other'), findsNothing);

    // Expand the 'Special Cards' ExpansionTile and verify its content.
    await tester.tap(find.text('Special Cards'));
    await tester.pumpAndSettle();
    expect(find.text('Card #2'), findsOneWidget);

    // Collapse the 'Special Cards' ExpansionTile.
    await tester.tap(find.text('Special Cards'));
    await tester.pumpAndSettle();
    expect(find.text('Card #2'), findsNothing);

    // Expand the 'Special Rules' ExpansionTile and verify its content.
    await tester.tap(find.text('Special Rules'));
    await tester.pumpAndSettle();
    expect(find.text('Gabong'), findsOneWidget);

    // Collapse the 'Special Rules' ExpansionTile.
    await tester.tap(find.text('Special Rules'));
    await tester.pumpAndSettle();
    expect(find.text('Gabong'), findsNothing);

    // Expand the 'Gameplay' ExpansionTile and verify its content.
    await tester.tap(find.text('Gameplay'));
    await tester.pumpAndSettle();
    expect(find.text('Start and End of a game'), findsOneWidget);

    // Collapse the 'Gameplay' ExpansionTile.
    await tester.tap(find.text('Gameplay'));
    await tester.pumpAndSettle();
    expect(find.text('Start and End of a game'), findsNothing);

    // Expand the 'Gabong Master' ExpansionTile and verify its content.
    await tester.tap(find.text('Gabong Master'));
    await tester.pumpAndSettle();
    expect(find.text('How to become a Gabong Master'), findsOneWidget);

    // Collapse the 'Gabong Master' ExpansionTile.
    await tester.tap(find.text('Gabong Master'));
    await tester.pumpAndSettle();
    expect(find.text('How to become a Gabong Master'), findsNothing);

    // Expand the 'Penalty Cards' ExpansionTile and verify its content.
    await tester.tap(find.text('Penalty Cards'));
    await tester.pumpAndSettle();
    expect(find.text('Gabong Master can give out penalty cards for:'), findsOneWidget);

    // Collapse the 'Penalty Cards' ExpansionTile.
    await tester.tap(find.text('Penalty Cards'));
    await tester.pumpAndSettle();
    expect(find.text('Gabong Master can give out penalty cards for:'), findsNothing);

    // Expand the 'Counting Points' ExpansionTile and verify its content.
    await tester.tap(find.text('Counting Points'));
    await tester.pumpAndSettle();
    expect(find.text('4,5,6,7,9,10 = 5 Points'), findsOneWidget);

    // Collapse the 'Counting Points' ExpansionTile.
    await tester.tap(find.text('Counting Points'));
    await tester.pumpAndSettle();
    expect(find.text('4,5,6,7,9,10 = 5 Points'), findsNothing);
  });
}