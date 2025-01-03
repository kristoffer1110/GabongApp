import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gabong_v1/widgets/menu_button.dart';

class WaitingForPlayers extends StatelessWidget {
  final String gameID;
  final bool isHost;
  final String playerName;

  const WaitingForPlayers({super.key, required this.gameID, required this.isHost, required this.playerName});

  void _startGame(BuildContext context) async {
    await FirebaseFirestore.instance.collection('games').doc(gameID).update({
      'gameStarted' : true,
    });
    Navigator.pushNamed(
      context, 
      '/game', 
      arguments: {'gameID': gameID, 'isHost': isHost, 'playerName': playerName},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Waiting for Players',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      backgroundColor: theme.colorScheme.primary,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('games')
            .doc(gameID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final gameData = snapshot.data!.data() as Map<String, dynamic>;
          final players = gameData['players'] as List<dynamic>;
          final gameStarted = gameData['gameStarted'] as bool? ?? false;

          if (gameStarted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(
                context, 
                '/game', 
                arguments: {'gameID' : gameID, 'isHost' : isHost, 'playerName' : playerName},
                );
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Game ID: $gameID',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Material(
                          elevation: 4.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              border: Border.all(
                                color: theme.colorScheme.tertiary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: ListTile(
                              title: Text(
                                player,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.tertiary,
                                ),
                              ),
                              leading: Icon(
                                Icons.person,
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                MenuButton(
                  label: 'Start Game',
                  onPressed: players.isNotEmpty && isHost
                      ? () => _startGame(context)
                      : null,
                  enabled: players.isNotEmpty && isHost,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
