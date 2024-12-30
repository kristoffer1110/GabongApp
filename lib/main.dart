import 'package:flutter/material.dart';
import 'package:gabong_v1/screens/homescreen.dart';
import 'package:gabong_v1/screens/host/host.dart';
import 'package:gabong_v1/screens/join/join.dart';
import 'package:gabong_v1/screens/host/waiting_for_players.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const Color gabongGreen = Color(0xFF216624); // Replace with your actual color value
const Color gold = Color(0xFFFFD700);
const Color black = Colors.black;

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
          primary: gabongGreen,
          secondary: gold,
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
        '/waitingForPlayers': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return WaitingForPlayers(gameID: args['gameID'], isHost: args['isHost']);
        },
      },
    );
  }
}






  