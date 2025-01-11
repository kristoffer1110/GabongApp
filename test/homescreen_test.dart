import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabong_v1/screens/homescreen.dart';
import 'package:gabong_v1/widgets/menu_button.dart';

void main() {
  testWidgets('HomeScreen loads properly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(),
    ));

    // Check if AppBar is there
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // Check images (Should be 3)
    expect(find.byType(Image), findsNWidgets(3)); // Two images: background, logo and textlogo

    // Check if the 3 main buttons are there
    expect(find.widgetWithText(MenuButton, 'HOST GAME'), findsOneWidget);
    expect(find.widgetWithText(MenuButton, 'JOIN GAME'), findsOneWidget);
    expect(find.widgetWithText(MenuButton, 'PLAY LOCAL'), findsOneWidget);

    // Check button 2 buttons
    expect(find.byIcon(Icons.calculate), findsOneWidget);
    expect(find.byIcon(Icons.book), findsOneWidget);
  });
}