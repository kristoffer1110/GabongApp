import 'package:flutter/material.dart';
import 'package:gabong_v1/screens/homescreen.dart';
import 'package:gabong_v1/screens/host/host.dart';
import 'package:gabong_v1/screens/join/join.dart';
import 'package:gabong_v1/screens/host/waiting_for_players.dart';
import 'package:gabong_v1/globals.dart' as globals;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const Color gabongGreen = Color(0xFF216624); // Replace with your actual color value
const Color gold = Color(0xFFFFD700);
const Color black = Colors.black;
const Color main1 = Color(0xFF50C878); // Emerald Green
const Color secondary1 = Color(0xFF2E5090); // YinMin Blue
const Color secondary2 = Color(0xFFFFA500); // Web Orange
const Color background1 = Color(0xFFF64A8A); // French Rose

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
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
          primary: main1,
          secondary: secondary2,
          tertiary: black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: gabongGreen,
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/host': (context) => const HostScreen(),
        '/join': (context) => const JoinScreen(),
        '/rules': (context) => const RulesScreen(),
        '/waitingForPlayers': (context) => WaitingForPlayers(gameID: globals.gameID),
      },
    );
  }
}






  