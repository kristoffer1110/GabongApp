import 'package:flutter/material.dart';

class PlayerList extends StatelessWidget {
  final List<dynamic> players;
  final height = 400;

  const PlayerList({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.toDouble(),
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
                players[index],
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