import 'package:flutter/material.dart';
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
import 'package:gabong_v1/widgets/text_container.dart';

class LocalAddPlayers extends StatefulWidget {
  final String gameMode;
  final int limit;

  const LocalAddPlayers({
    super.key,
    required this.gameMode,
    required this.limit,
    });

  @override
  _LocalAddPlayersState createState() => _LocalAddPlayersState();
}

class _LocalAddPlayersState extends State<LocalAddPlayers> {
  final TextEditingController _nameController = TextEditingController();
  List<String> _players = [];
  bool _isAddPlayerButtonEnabled = false;
  bool _isStartGameButtonEnabled = false;

  void _removePlayer(String player) {
    setState(() {
      _players.remove(player);
      _setStartGameButton();
    });
  }

  void _addPlayer() {
    setState(() {
      if (_nameController.text.isNotEmpty) {
        if (_players.contains(_nameController.text)) {
          _nameController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Player name is already entered'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        _players.add(_nameController.text);
        _nameController.clear();
      }
      _setStartGameButton();
    });
  }

  void _setStartGameButton() {
    setState(() {
      if (_players.length > 1) {
        _isStartGameButtonEnabled = true;
      } else {
        _isStartGameButtonEnabled = false;
      }
    });
  }

  void _startGame() {
    _players.isNotEmpty ? 
    Navigator.pushNamed(
      context, 
      '/localGame',
      arguments: {
            'gamemode': widget.gameMode,
            'limit': widget.limit,
            'players': _players
          }
    )
    : null;
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        backgroundColor: theme.colorScheme.primary,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const Text(
                  'Add Players',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _players.length,
                    itemBuilder: (context, index) {
                      final player = _players[index];
                      return Row(
                        children: [
                          TextContainer(
                            text: Text(player,
                              style: TextStyle(color: theme.colorScheme.tertiary)),
                            containerColor: theme.colorScheme.secondary,
                            icon: Icon(Icons.person, color: theme.colorScheme.tertiary),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removePlayer(player),
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
                        controller: _nameController,
                        labelText: 'Player Name...',
                        onChanged: (value) {
                          setState(() {
                            _isAddPlayerButtonEnabled = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: MenuButton(
                        label: 'Add Player',
                        onPressed:
                          _isAddPlayerButtonEnabled ? _addPlayer : null,
                        enabled: _isAddPlayerButtonEnabled,
                      )),
                  ],
                ),
                const SizedBox(height: 20),
                MenuButton(
                  label: 'Start Game',
                  onPressed: _startGame,
                  enabled: _isStartGameButtonEnabled,
                ),
              ],
        )
      )
    );
  }
}
