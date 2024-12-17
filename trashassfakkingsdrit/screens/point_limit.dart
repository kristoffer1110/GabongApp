import 'package:flutter/material.dart';
import 'game_screen.dart';

class PointLimitScreen extends StatefulWidget {
  const PointLimitScreen({super.key});

  @override
  PointLimitScreenState createState() => PointLimitScreenState();
}

class PointLimitScreenState extends State<PointLimitScreen> {
  final TextEditingController _pointLimitController = TextEditingController();
  final TextEditingController _playerNameController = TextEditingController();
  int _pointLimit = 0;
  final List<String> _players = [];

  void _setPointLimit() {
    setState(() {
      _pointLimit = int.tryParse(_pointLimitController.text) ?? 0;
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
    return _pointLimit > 0 && _players.isNotEmpty;
  }

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          pointLimit: _pointLimit,
          players: _players,
          gameMode: 'Point Limit',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Point Limit Mode'),
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
                    controller: _pointLimitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Set Point Limit',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _setPointLimit,
                  child: const Text('Set'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Point Limit: $_pointLimit'),
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
              ]
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
