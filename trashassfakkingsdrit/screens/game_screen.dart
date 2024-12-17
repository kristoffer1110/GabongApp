import 'package:flutter/material.dart';
import '../pages/play_gabong.dart';


class GameScreen extends StatefulWidget {
  final int? pointLimit;
  final int? roundLimit;
  final List<String> players;
  final String gameMode;

  const GameScreen({super.key, 
    this.pointLimit, 
    this.roundLimit, 
    required this.players,
    required this.gameMode,
  });

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late List<int> _scores;
  late List<TextEditingController> _scoreControllers;
  late List<List<int>> _lastFiveScores;
  late int _currentRound;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _scores = List<int>.filled(widget.players.length, 0);
    _scoreControllers = List<TextEditingController>.generate(
      widget.players.length,
      (index) => TextEditingController(),
    );
    _lastFiveScores = List<List<int>>.generate(
      widget.players.length,
      (index) => [],
    );
    _currentRound = 1;
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  bool _areAllFieldsFilled() {
    for (var controller in _scoreControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  void _handleScores(){
    int scoreInput;
      for (int i = 0; i < _scores.length; i++) {
        scoreInput = int.tryParse(_scoreControllers[i].text) ?? 0;
        _scores[i] += scoreInput;
        if ((scoreInput != 0) && (isDivisibleBy100(_scores[i]))){
          halfScore(i);
        }
        _scoreControllers[i].clear();
      }
      _updateScoreHistory();
  }

  void _advanceRound() {
    setState(() {
      _handleScores();
      if (isGameOver()){
        _showGameOverDialog();
        return;
      }
      _currentRound++;
    });
  }

  bool isDivisibleBy100(int number) {
    return number % 100 == 0;
  }

  void halfScore(int index){
    _scores[index] = _scores[index] ~/ 2;
  }
  
  void _updateScoreHistory(){
    for (int i = 0; i < _scores.length; i++) {
      _lastFiveScores[i].add(_scores[i]);
      if (_lastFiveScores[i].length > 5) {
        _lastFiveScores[i].removeAt(0);
      } 
    }
  }

  bool isGameOver(){
    if (widget.pointLimit != null){
      for (int i = 0; i < _scores.length; i++) {
        if (_scores[i] >= (widget.pointLimit ?? 0)){
          return true;
        }
      }
    } else {
      if ((_currentRound + 1) > (widget.roundLimit ?? 0)){
        return true;
      }
    }
    return false;
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Summary of the round:'),
                for (int i = 0; i < widget.players.length; i++)
                  Text('${widget.players[i]}: ${_scores[i]}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('New Game'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
            TextButton(
              child: const Text('Back to Game Mode Selection'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PlayGabong()),
                );
              },
            ),
          ],
        );
      },
    );
  }
  
  void newGame(){
    setState((){
      initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pointLimit != null
            ? 'Gabong: Point Limit ${widget.pointLimit}'
            : 'Gabong: Round Limit ${widget.roundLimit}'
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('$_currentRound', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            for (int i = 0; i < widget.players.length; i++)
              Column(
                children: [
                  Row(
                    children: [
                      Text('${widget.players[i]}: ', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      for (int j = 0; j < _lastFiveScores[i].length; j++)
                        Text(
                          j == _lastFiveScores[i].length - 1 ? '${_lastFiveScores[i][j]}' : '${_lastFiveScores[i][j]} - ',
                          style: TextStyle(
                            fontWeight: j == _lastFiveScores[i].length - 1 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _scoreControllers[i],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Round Score',
                          ),
                          onChanged: (value) {
                            setState(() {});
                          }
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _areAllFieldsFilled() ? _advanceRound : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Advance'),
            ),
          ],
        ),
      ),
    );
  }
}