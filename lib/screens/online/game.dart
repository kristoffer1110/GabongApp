import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gabong_v1/widgets/circular_icon_button.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/text_container.dart';

class GameScreen extends StatefulWidget {
  final String gameID;
  final bool isHost;
  final String playerName;

  const GameScreen({
    super.key,
    required this.gameID,
    required this.isHost,
    required this.playerName
    });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Map<String, dynamic>? gameData; // Local cache
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenToGameData();
  }

  void _listenToGameData() {
    FirebaseFirestore.instance
        .collection('games')
        .doc(widget.gameID)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          gameData = snapshot.data();
          isLoading = false;
        });
      } else {
        // Handle document deletion (e.g., game ended)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        });
      }
    });
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

  void _submitScore(TextEditingController scoreInputController) async {
    final playerName = widget.playerName;
    final gameDocRef = FirebaseFirestore.instance.collection('games').doc(widget.gameID);
    final scoreInput = int.tryParse(scoreInputController.text);

    if (scoreInput == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    await gameDocRef.update({
      'scoreInputs.$playerName': FieldValue.arrayUnion([scoreInput]),
    });

    print('Score submitted: $scoreInput');
    
    scoreInputController.clear();
  }

  Future<bool> _isGameFinished(String gameMode, int currentRound, Map<String, dynamic> scores, int limit) async {
    if (gameMode == 'Point Limit') {
      return scores.values.any((score) => score >= limit);
    }
    return currentRound >= limit;
  }

  Future<bool> _areAllScoresEntered(Map<String, dynamic> scoreInputs) async {
    return scoreInputs.values.every((scoreList) => scoreList.isNotEmpty);
  }

  Future<bool> _isLastPlayer() async {
    final players = gameData!['players'] as List<dynamic>;
    return players.length == 1;
  }

  List<String> _findWinner(Map<String, dynamic> scores) {
    int lowestScore = scores.values.reduce((value, element) => value < element ? value : element);
    return scores.entries.where((entry) => entry.value == lowestScore).map((entry) => entry.key).toList();

  }

  void _displayWinner() {
    showDialog(context: context, builder: (context) {
      final scores = gameData!['scores'] as Map<String, dynamic>;
      final winner = _findWinner(scores);
      final contentString = winner.length == 1
        ? 'Winner is ${winner[0]}'
        : 'Winners are ${winner.join(', ')}';

        return AlertDialog(
          title: const Text('Limit Reached!'),
          content: Text(contentString),
          actions: [
            MenuButton(
              label: 'Home',
              onPressed: () {
                _isLastPlayer().then((isLast) {
                  if (isLast) {
                    _endGame();
                  } else {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  }
                });
              },
            ),
            MenuButton(
              label: 'View Results',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _advanceToNextRound() async {
    final gameDocRef = FirebaseFirestore.instance.collection('games').doc(widget.gameID);
    
    final currentRound = gameData!['currentRound'] as int;
    final players = gameData!['players'] as List<dynamic>;
    final scores = gameData!['scores'] as Map<String, dynamic>;
    final scoreInputs = gameData!['scoreInputs'] as Map<String, dynamic>;
    final gameMode = gameData!['gameMode'] as String;
    final limit = gameData!['limit'] as int;

    if (!await _areAllScoresEntered(scoreInputs)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait until all scores are entered.')),
      );
      return;
    }

    if (await _isGameFinished(gameMode, currentRound, scores, limit)) {
      _displayWinner();
      return;
    }

    for (final player in players) {
      final playerScore = scores[player] as int;
      final playerScoreInputs = scoreInputs[player] as List<dynamic>;
      var newScore = playerScore + (playerScoreInputs.isNotEmpty ? playerScoreInputs.last : 0) as int;

      if (newScore % 100 == 0){
        newScore = newScore ~/ 2;
      }

      await gameDocRef.update({
        'scores.$player': newScore,
        'scoreInputs.$player': [],
        'currentRound': currentRound + 1,

      });

      print('Player: $player, Score: $newScore');
    }
  }

  _getGameStream() {
    return FirebaseFirestore.instance.collection('games').doc(widget.gameID).snapshots();
  }

  _buildLoadingView() {
    return const Center(child: CircularProgressIndicator());
  }

  _buildGameEndedView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    });
    return const Center(child: Text('Game has ended.'));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      _buildLoadingView();
    }
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      backgroundColor: theme.colorScheme.primary,
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getGameStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingView();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return _buildLoadingView();
          }

          if (!snapshot.data!.exists) {
           return  _buildGameEndedView();
          }

          final players = gameData!['players'] as List<dynamic>;
          final scores = gameData!['scores'] as Map<String, dynamic>;
          final currentRound = gameData!['currentRound'] as int;
          final gameMode = gameData!['gameMode'] as String;
          final limit = gameData!['limit'] as int;
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
                      '$gameMode $limit',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text('Round: $currentRound',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      Color textColor = theme.colorScheme.tertiary;
                    
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextContainer(
                              text: Text(
                                player,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor
                                ),
                              ),
                              icon: Icon(Icons.person, color: theme.colorScheme.tertiary),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextContainer(
                              text: Text('${scores[player]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor
                                ),
                              ),
                              centered: true,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InputField(
                        controller: scoreInputController,
                        labelText: 'Enter your score for this round',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    MenuButton(
                      label: 'Submit Score',
                      onPressed: () => _submitScore(scoreInputController),
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

