import 'package:flutter/material.dart';
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
import 'package:gabong_v1/widgets/text_container.dart';
import 'package:gabong_v1/widgets/circular_icon_button.dart';

class LocalGameScreen extends StatefulWidget {
  final String gameMode;
  final int limit;
  final List<String> players;
  const LocalGameScreen({
    super.key,
    required this.gameMode,
    required this.limit,
    required this.players,
    });

  @override
  _LocalGameScreenState createState() => _LocalGameScreenState();
}

class _LocalGameScreenState extends State<LocalGameScreen> {
  late List<TextEditingController> _scoreControllers;
  late Map<String, int> _scores;
  late int _currentRound;
  late String _gabongMaster;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _scoreControllers = List<TextEditingController>.generate(
      widget.players.length,
      (index) => TextEditingController(),
    );
    _scores = {for (var player in widget.players) player : 0 };
    _currentRound = 1;
    _gabongMaster = widget.players[0];

    for (var controller in _scoreControllers) {
      controller.addListener(() {
        setState(() {});
      });
    }
  }

  int _calculateScore(currentScore, roundScore) {
    int newScore = currentScore + roundScore;
    if (_isDivisableByHundred(newScore)) {
      newScore = ((currentScore + roundScore) / 2).toInt();
    }
    return newScore;
  }

  bool _checkNewGabongMaster(TextEditingController controller) {
    if (controller.text == 'G') {
      _gabongMaster = widget.players[_scoreControllers.indexOf(controller)];
      return true;
    }
    return false;
  }

  void _applyScores() {
    for (var i = 0; i < widget.players.length; i++) {
      late int roundScore;
      if (_checkNewGabongMaster(_scoreControllers[i])) {
        roundScore = 0;
      } else {
        roundScore = int.tryParse(_scoreControllers[i].text) ?? 0;
      }
      final currentScore = _scores[widget.players[i]] ?? 0;
      final newScore = _calculateScore(currentScore, roundScore);
      _scores[widget.players[i]] = newScore;
    }
  }

  bool _isDivisableByHundred(int number){
    return number % 100 == 0;
  }
  void _nextRound() {
    setState(() {
      _applyScores();
      if (_isGameOver()) {
        _displayWinner();
        return;
      } else{
        for (var controller in _scoreControllers) {
          controller.clear();
        }
        _currentRound++;
      }
    });
  }

  bool _isGameOver() {
    if (widget.gameMode == 'Point Limit') {
      return _scores.values.any((score) => score >= widget.limit);
    }
    return _currentRound >= widget.limit;
  }

  void _endGameWarning() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('End Game?'),
        content: const Text('Are you sure you want to end the game?'),
        actions: [
          MenuButton(
            label: 'Yes',
            onPressed: () {
              Navigator.of(context).pop();
              _displayWinner();
            },
          ),
          MenuButton(
            label: 'No',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  List<String> _findWinner() {
    int lowestScore = _scores.values.reduce((a, b) => a < b ? a : b);
    return _scores.entries.where((entry) => entry.value == lowestScore).map((entry) => entry.key).toList();
  }

  void _displayWinner() {
    showDialog(context: context, builder: (context) {
      final List<String> winners = _findWinner();
      final content = winners.length == 1 ? 
        'The winner is: ${winners[0]}' : 
        'The winners are: ${winners.join(', ')}';

      return AlertDialog(
      title: Text('${widget.gameMode} reached!'),
      content: Text(content),
      actions: [
        MenuButton(
        label: 'Play Again',
        onPressed: () {
          _resetGame();
          Navigator.of(context).pop();
        },
        ),
        MenuButton(
        label: 'Home',
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        ),
        MenuButton(label: 'View Results', onPressed: () {
          Navigator.of(context).pop();
        }),
      ],
      );
    });
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isNextButtonEnabled = _scoreControllers.every((controller) => controller.text.isNotEmpty) && !_isGameOver();

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      backgroundColor: theme.colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(child: Text('${widget.gameMode} ${widget.limit}')),
                Expanded(child: Text('Round $_currentRound')),
              ],
            ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: widget.players.length,
                itemBuilder: (context, index) {
                  final player = widget.players[index];
                  Color textColor = theme.colorScheme.tertiary;
                  if (player == _gabongMaster) {
                    textColor = Colors.blue;
                  }
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextContainer(
                          text: Text(player,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                                color: textColor
                            )
                          ),
                          icon: Icon(Icons.person, color: theme.colorScheme.tertiary),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextContainer(
                          text: Text('${_scores[player]}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.tertiary
                            )
                          ),
                          centered: true,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InputField(
                          labelText: 'Enter score',
                          controller: _scoreControllers[index],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  );
                }, 
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: MenuButton(
                label: 'Next Round',
                onPressed: () {
                  _nextRound();
                },
                enabled: isNextButtonEnabled,
              ),
            ),
            Expanded(
              flex: 1,
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
                      child: MenuButton(
                        label: 'End Game',
                        onPressed: () {
                          _endGameWarning();
                        },
                      )
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
                ],
              ),
            )
          ],
        )
      )
    );
  }
}