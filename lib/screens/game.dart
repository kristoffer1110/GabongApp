import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
import 'package:gabong_v1/widgets/circular_icon_button.dart';



class GameScreen extends StatefulWidget {
  final String gameID;
  final bool isHost;
  final String playerName;

  const GameScreen({super.key, required this.gameID, required this.isHost, required this.playerName});
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  String _getGameModeText(Map<String, dynamic> gameData) {
    final gameMode = gameData['gameMode'];
    if (gameMode == 'Point Limit') {
      return 'Point Limit ${gameData['pointLimit']}';
    } else if (gameMode == 'Round Limit') {
      return 'Round Limit ${gameData['roundLimit']}';
    } else {
      return 'Unknown Game Mode';
    }
  }

  Future<void> _endGame() async {
    await FirebaseFirestore.instance.collection('games').doc(widget.gameID).delete();
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  Future<void> _leaveGame() async {
    final playerName = widget.playerName;
    final gameDocRef = FirebaseFirestore.instance.collection('games').doc(widget.gameID);

    await gameDocRef.update({
      'players': FieldValue.arrayRemove([playerName]),
      'scores.$playerName': FieldValue.delete(),
    });

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      backgroundColor: theme.colorScheme.primary,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Round ${gameData['currentRound']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Align (
                    alignment: Alignment.topCenter,
                    child: Text(
                      _getGameModeText(gameData),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'ID: ${widget.gameID}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
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
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircularIconButton(
                          icon: Icons.calculate, 
                          onPressed: () {
                            Navigator.pushNamed(context, '/calculator');
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: MenuButton(
                          label: widget.isHost ? 'End Game' : 'Leave Game',
                          onPressed: widget.isHost ? _endGame : _leaveGame,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: CircularIconButton(
                          icon: Icons.book, 
                          onPressed: () {
                            Navigator.pushNamed(context, '/rules');
                          },
                        ),
                      ),
                    ]
                  )
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

