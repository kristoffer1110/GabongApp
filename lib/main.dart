import 'package:flutter/material.dart';
import 'package:gabong_v1/screens/homescreen.dart';
import 'package:gabong_v1/screens/host.dart';


const Color gabongGreen = Color(0xFF216624); // Replace with your actual color value
const Color gold = Color(0xFFFFD700);
const Color black = Colors.black;

void main() {
  runApp(const MyApp());
}


ThemeData get theme {
  final theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: gabongGreen,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
  return theme;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gabong Calc',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: gabongGreen,
          secondary: gold,
          tertiary: black,
        )
      ),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/host': (context) => const HostScreen(),
      },
    );
  }
}






  