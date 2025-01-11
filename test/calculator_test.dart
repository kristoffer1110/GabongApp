import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/normal_button.dart';
import 'package:gabong_v1/widgets/scaffold.dart';
import 'package:gabong_v1/main.dart';
import 'package:gabong_v1/screens/points_calculator.dart';

void main() {
  testWidgets('PointsCalculatorScreen test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PointsCalculatorScreen(),),);

    // That is loads in correctly
    expect(find.text('Total Points: 0'), findsOneWidget);
    expect(find.byType(InputField), findsOneWidget);
    // Find all buttons (13 numbers + backspace + delete all)
    expect(find.byType(NormalButton), findsNWidgets(15)); 

    // Adds Ace card
    await tester.tap(find.widgetWithText(NormalButton, 'A'));
    await tester.pump();
    expect(find.text('Total Points: 15'), findsOneWidget);

    // Adds 2 and calculates points correctly
    await tester.tap(find.widgetWithText(NormalButton, '2'));
    await tester.pump();
    expect(find.text('Total Points: 40'), findsOneWidget); 

    // Backspace works
    await tester.tap(find.widgetWithText(NormalButton, 'BACKSPACE'));
    await tester.pump();
    expect(find.text('Total Points: 15'), findsOneWidget);

    // Delete all works
    await tester.tap(find.widgetWithText(NormalButton, 'DELETE ALL'));
    await tester.pump();
    expect(find.text('Total Points: 0'), findsOneWidget);
  });
}