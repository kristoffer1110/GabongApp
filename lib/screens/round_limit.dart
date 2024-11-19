import 'package:flutter/material.dart';
import 'game_screen.dart';

class RoundLimitScreen extends StatefulWidget {
  const RoundLimitScreen({super.key});

  @override
  RoundLimitScreenState createState() => RoundLimitScreenState();
}

class RoundLimitScreenState extends State<RoundLimitScreen> {
  final TextEditingController _roundLimitController = TextEditingController();
  final TextEditingController _playerNameController = TextEditingController();
  int _roundLimit = 0;
  final List<String> _players = [];

  void _setRoundLimit() {
    setState(() {
      _roundLimit = int.tryParse(_roundLimitController.text) ?? 0;
    });
  }

  void _addPlayer() {
    setState(() {
      if (_playerNameController.text.isNotEmpty) {
        _players.add(_playerNameController.text);
        _playerNameController.clear();
      }
    });
  }

  void _removePlayer(int index) {
    setState(() {
      _players.removeAt(index);
    });
  }

  bool _isStartButtonEnabled() {
    return _roundLimit > 0 && _players.isNotEmpty;
  }

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          roundLimit: _roundLimit,
          players: _players,
          gameMode: 'Round Limit',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Round Limit Mode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _roundLimitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Set Round Limit',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _setRoundLimit,
                  child: const Text('Set'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Round Limit: $_roundLimit'),
            const SizedBox(height: 20),
            const Text('Players', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            for (int i = 0; i < _players.length; i++)
              Row(
                children: [
                  Expanded(child: Text(_players[i])),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removePlayer(i),
                  ),
                ],
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _playerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Player Name',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addPlayer,
                  child: const Text('Add'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isStartButtonEnabled() ? _startGame : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Start Game'),
            )
          ],
        ),
      ),
    );
  }
}
