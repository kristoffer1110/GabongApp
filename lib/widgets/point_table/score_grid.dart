import 'package:flutter/material.dart';
import 'package:gabong_v1/widgets/point_table/score_column.dart';
class ScoreGrid extends StatelessWidget {
  final List<dynamic> players;
  final Map<String, dynamic> scores;
  final int currentRound;
  final int height = 400;

  const ScoreGrid({
    super.key,
    required this.players,
    required this.scores,
    required this.currentRound,
  });

  @override
  Widget build(BuildContext context) {
    for (var player in players) {
      if (scores[player].length != currentRound) {
        scores[player].add('-');
      }
    }

    return Container(
      height: height.toDouble(),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: currentRound,
        itemBuilder: (context, index) {
          return ScoreColumn(
            players: players, 
            scores: scores, 
            currentRound: index,
          ); 
        },
      )
    );
  }
}