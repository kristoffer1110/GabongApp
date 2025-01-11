import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gabong_v1/widgets/circular_icon_button.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/point_table/point_table.dart';

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

  Future<int> _getCurrentRound() async {
    final gameDoc = await FirebaseFirestore.instance.collection('games').doc(widget.gameID).get();
    final gameData = gameDoc.data() as Map<String, dynamic>;
    final currentRound = gameData['currentRound'] as int;
    return currentRound;
  }


  void _addScore(scoreInputController) async {
    final playerName = widget.playerName;
    final gameDocRef = FirebaseFirestore.instance.collection('games').doc(widget.gameID);
    final scoreInput = int.tryParse(scoreInputController.text);
    final currentRound = await _getCurrentRound();
    List<dynamic> playerScores = await _getPlayerScores();

    if (scoreInput == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    if (playerScores.length == currentRound) {
      playerScores.removeLast();
    }

    int currentScore = playerScores.isNotEmpty ? playerScores.last : 0;
    playerScores.add(currentScore + scoreInput);
    currentScore = playerScores.last;

    if (currentScore % 100 == 0) {
      currentScore = currentScore ~/ 2;
      playerScores[currentRound - 1] = currentScore;
    }

    await gameDocRef.update({
      'scores.$playerName': playerScores,
    });

    scoreInputController.clear();
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
    if (!gameDoc.exists) {
      return;
    }    
    
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('games').doc(widget.gameID).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            });
            return const Center(child: Text('Game has ended.'));
          }

          final gameData = snapshot.data!.data() as Map<String, dynamic>;
          final players = gameData['players'] as List<dynamic>;
          final scores = gameData['scores'] as Map<String, dynamic>;
          final int currentRound = gameData['currentRound'] as int;
          final scoreInputController = TextEditingController();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${widget.gameID}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      _getGameModeText(gameData),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                PointTable(
                  currentRound: currentRound,
                  players: players,
                  scores: scores,
                  height: 400
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        controller: scoreInputController,
                        labelText: 'Your Score',
                      ),
                    ),
                    MenuButton(
                      label: 'Set Round Score',
                      onPressed: () {
                        _addScore(scoreInputController);
                      },
                    ),
                  ],
                ),
                if (widget.isHost)
                  MenuButton(
                    label: 'Next Round',
                    onPressed: _advanceToNextRound,
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: CircularIconButton(
                          icon: Icons.book, 
                          onPressed: () {
                            Navigator.pushNamed(context, '/rules');
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: widget.isHost
                            ? MenuButton(label: 'End Game', onPressed: _endGame)
                            : MenuButton(label: 'Leave Game', onPressed: _leaveGame),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircularIconButton(
                          icon: Icons.calculate, 
                          onPressed: () {
                            Navigator.pushNamed(context, '/calculator');
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

