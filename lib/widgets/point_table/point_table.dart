import 'package:flutter/material.dart';
import 'package:gabong_v1/widgets/point_table/player_list.dart';
import 'package:gabong_v1/widgets/point_table/score_grid.dart';

class PointTable extends StatelessWidget {
  final List<dynamic> players;
  final Map<String, dynamic> scores;
  final int currentRound;
  final int height;

  const PointTable({
    Key? key,
    required this.players,
    required this.scores,
    required this.height,
    required this.currentRound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          PlayerList(players: players,
          ),
          ScoreGrid(
            players: players,
            scores: scores,
            currentRound: currentRound,
          ),
        ]
      ),
    );
  }
}



