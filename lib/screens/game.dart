import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatefulWidget {
  final String gameID;

  const GameScreen({super.key, required this.gameID});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder<DocumentSnapshot> (
        stream: FirebaseFirestore.instance
            .collection('games')
            .doc(widget.gameID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final gameData = snapshot.data!.data() as Map<String, dynamic>;
          final players = gameData['players'] as List<dynamic>;
          final scores = gameData['scores'] as Map<String, dynamic>;

          return Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Players and Scores:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                  Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      final playerScores = scores[player] as List<dynamic>;

                        return Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ListTile(
                              title: Text(player),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: List.generate(playerScores.length, (scoreIndex) {
                                return Expanded(
                                  child: Text(
                                    playerScores[scoreIndex].toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

