import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
import 'package:gabong_v1/widgets/circular_icon_button.dart';
import 'package:gabong_v1/widgets/input_field.dart';


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

  Future<List<dynamic>> _getPlayerScores() async{
    final gameDoc = await FirebaseFirestore.instance.collection('games').doc(widget.gameID).get();
    final gameData = gameDoc.data() as Map<String, dynamic>;
    final scores = gameData['scores'] as Map<String, dynamic>;
    final playerScores = scores[widget.playerName] as List<dynamic>;
    return playerScores;
  }
  
  void _addScore(scoreInputController) async {
    List<dynamic> playerScores = await _getPlayerScores();
    final roundScore = int.tryParse(scoreInputController.text);

    int? currentScore;
    if (playerScores.isEmpty){
      currentScore = roundScore;
    }
    else{
      currentScore = playerScores[playerScores.length - 1] + roundScore;
    }

    if (currentScore != null && currentScore % 100 == 0){
      currentScore = currentScore ~/ 2;
    }

    if (currentScore != null) {
      final playerName = widget.playerName;
      final gameDocRef = FirebaseFirestore.instance.collection('games').doc(widget.gameID);
      gameDocRef.update({
        'scores.$playerName': FieldValue.arrayUnion([currentScore]),
      });
      scoreInputController.clear();
    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
    }
  }

  Future<bool> _isGameFinished() async {
    final gameDocRef = FirebaseFirestore.instance.collection('games').doc(widget.gameID);
    final gameDoc = await gameDocRef.get();
    final gameData = gameDoc.data() as Map<String, dynamic>;
    final gameMode = gameData['gameMode'] as String;
    final currentRound = gameData['currentRound'] as int;
    final scores = gameData['scores'] as Map<String, dynamic>;

    if (gameMode == 'Point Limit') {
      final pointLimit = gameData['pointLimit'] as int;
      return scores.values.any((playerScores) => playerScores.isNotEmpty && playerScores.last >= pointLimit);
    } else if (gameMode == 'Round Limit') {
      final roundLimit = gameData['roundLimit'] as int;
      return currentRound >= roundLimit;
    } else {
      return false;
    }
  }

  Future<bool> _areAllScoresEntered() async {
    final gameDocRef = FirebaseFirestore.instance.collection('games').doc(widget.gameID);
    final gameDoc = await gameDocRef.get();
    final gameData = gameDoc.data() as Map<String, dynamic>;
    final currentRound = gameData['currentRound'] as int;
    final scores = gameData['scores'] as Map<String, dynamic>;

    return scores.values.every((playerScores) => playerScores.length >= currentRound);
  }

  Future<bool> _isLastPlayer() async {
    final gameDocRef = FirebaseFirestore.instance.collection('games').doc(widget.gameID);
    final gameDoc = await gameDocRef.get();
    final gameData = gameDoc.data() as Map<String, dynamic>;
    final players = gameData['players'] as List<dynamic>;
    
    if (players.length == 1){
      return true;
    }

    return false;
  }

  void _displayWinner() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('games').doc(widget.gameID).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final gameData = snapshot.data!.data() as Map<String, dynamic>;
              final scores = gameData['scores'] as Map<String, dynamic>;
              final gameMode = gameData['gameMode'] as String;
              final playerScores = scores.map((player, playerScores) {
                final totalScore = playerScores[playerScores.length - 1];
                return MapEntry(player, totalScore);
              });

              final winner = playerScores.entries.reduce((prev, next) => prev.value < next.value ? prev : next).key;
              return Text('$gameMode reached\nWinner is $winner');
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _isLastPlayer().then((isLast) {
                  if (isLast) {
                    _endGame();
                  } else {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  }
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _advanceToNextRound() async {
    final gameDocRef = FirebaseFirestore.instance.collection('games').doc(widget.gameID);
    final gameDoc = await gameDocRef.get();
    final gameData = gameDoc.data() as Map<String, dynamic>;
    final currentRound = gameData['currentRound'] as int;

    if (!await _areAllScoresEntered()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter scores for all players')),
      );
      return;
    }

    if (await _isGameFinished()) {
      _displayWinner();
      return;
    }

    await gameDocRef.update({
      'currentRound': currentRound + 1,
    });
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

          if (!snapshot.hasData || !snapshot.data!.exists) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            });
            return const Center(child: CircularProgressIndicator());
          }

          final gameData = snapshot.data!.data() as Map<String, dynamic>;
          final players = gameData['players'] as List<dynamic>;
          final scores = gameData['scores'] as Map<String, dynamic>;
          final int maxRounds = scores.values.map((e) => e.length).fold(0, (prev, next) => next > prev ? next : prev);
          final scoreInputController = TextEditingController();

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
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Player',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: List.generate(maxRounds, (index) {
                          return Expanded(
                            child: Text(
                              'Round ${index + 1}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          );
                        }),
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
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        controller: scoreInputController, 
                        labelText: 'Your Score',
                        ),
                    ),
                    Expanded(
                      child: MenuButton(
                        label: 'Set Round Score', 
                        onPressed: () { 
                          _addScore(scoreInputController);
                         },  
                      ),
                    )
                  ]
                ),
                
                Expanded(
                  child: MenuButton(
                    label: 'Next Round',
                    onPressed: _advanceToNextRound,
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
