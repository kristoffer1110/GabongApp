import 'package:flutter/material.dart';

class ScoreColumn extends StatelessWidget{
  final List<dynamic> players;
  final Map<String, dynamic> scores;
  final int currentRound;

  const ScoreColumn({
    super.key,
    required this.players,
    required this.scores,
    required this.currentRound,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50 * players.length.toDouble(),
      width: 50,
      child: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                scores[players[index]][currentRound].toString(),
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}