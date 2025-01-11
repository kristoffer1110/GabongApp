import 'package:flutter/material.dart';
import 'package:gabong_v1/screens/game.dart';
import 'package:gabong_v1/screens/homescreen.dart';
import 'package:gabong_v1/screens/host.dart';
import 'package:gabong_v1/screens/join.dart';
import 'package:gabong_v1/screens/rules.dart';
import 'package:gabong_v1/screens/points_calculator.dart';
import 'package:gabong_v1/screens/waiting_for_players.dart';
import 'package:gabong_v1/screens/local/local_select_gamemode.dart';
import 'package:gabong_v1/screens/local/local_add_players.dart';
import 'package:gabong_v1/screens/local/local_gamescreen.dart';
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
          backgroundColor: main1,
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/rules': (context) => const RulesScreen(),
        '/calculator': (context) => const PointsCalculatorScreen(),

        '/host': (context) => const HostScreen(),
        '/join': (context) => const JoinScreen(),
        '/local': (context) => const LocalSelectGamemode(),

        '/waitingForPlayers': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return WaitingForPlayers(gameID: args['gameID'], isHost: args['isHost'], playerName: args['playerName']);
        },
        '/localAddPlayers': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return LocalAddPlayers(gameMode: args['gamemode'], limit: args['limit']);
        },

        '/game': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return GameScreen(gameID: args['gameID'], isHost: args['isHost'], playerName: args['playerName']);
        },

        '/localGame': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return LocalGameScreen(gameMode: args['gamemode'], limit: args['limit'], players: args['players']);
        },
      },
    );
  }
}
