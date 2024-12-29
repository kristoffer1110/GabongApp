import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WaitingForPlayers extends StatelessWidget {
  final String gameID;

  const WaitingForPlayers({super.key, required this.gameID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting for Players'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('games')
            .doc(gameID)
            .collection('players')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final players = snapshot.data!.docs;

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return ListTile(
                title: Text(player['name']),
              );
            },
          );
        },
      ),
    );
  }
}


