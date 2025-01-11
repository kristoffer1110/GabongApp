import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
import 'package:gabong_v1/widgets/text_container.dart';
import 'package:gabong_v1/widgets/scaffold.dart';



class WaitingForPlayers extends StatefulWidget {
  final String gameID;
  final bool isHost;
  final String playerName;

  const WaitingForPlayers({super.key, required this.gameID, required this.isHost, required this.playerName});

  @override
  _WaitingForPlayersState createState() => _WaitingForPlayersState();
}

class _WaitingForPlayersState extends State<WaitingForPlayers> {

  void _startGame() async {
    await FirebaseFirestore.instance.collection('games').doc(widget.gameID).update({
      'gameStarted' : true,
    });
    Navigator.pushNamed(
      context, 
      '/game', 
      arguments: {'gameID': widget.gameID, 'isHost': widget.isHost, 'playerName': widget.playerName},
    );
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

    return GradientScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Waiting for Players',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('games')
            .doc(widget.gameID)
            .snapshots(),
        builder: (context, snapshot) {

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
          final gameStarted = gameData['gameStarted'] as bool? ?? false;

          if (gameStarted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(
                context, 
                '/game', 
                arguments: {'gameID' : widget.gameID, 'isHost' : widget.isHost, 'playerName' : widget.playerName},
                );
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Game ID: ${widget.gameID}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return TextContainer(
                        text: Text(player,
                          style: TextStyle(color: theme.colorScheme.tertiary),
                        ),
                        containerColor: theme.colorScheme.secondary,
                        icon: Icon(Icons.person, color: theme.colorScheme.tertiary)
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (widget.isHost) 
                  MenuButton(
                    label: 'Start Game',
                    onPressed: players.isNotEmpty
                    ? () => _startGame()
                    : null,
                    enabled: players.isNotEmpty,
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: widget.isHost
                    ? MenuButton(label: 'End Game', onPressed: _endGame)
                    : MenuButton(label: 'Leave Game', onPressed: _leaveGame),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
