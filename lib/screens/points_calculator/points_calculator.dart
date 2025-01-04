import 'package:flutter/material.dart';
import 'package:gabong_v1/main.dart';

class PointsCalculatorScreen extends StatefulWidget {
  const PointsCalculatorScreen({Key? key}) : super(key: key);

  @override
  _PointsCalculatorScreenState createState() => _PointsCalculatorScreenState();
}

class _PointsCalculatorScreenState extends State<PointsCalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  int totalPoints = 0;

  final Map<String, int> cardPoints = {
    '4': 5, '5': 5, '6': 5, '7': 5, '9': 5, '10': 5,
    'J': 10, 'Q': 10,
    'A': 15,
    '3': 20, 'K': 20,
    '8': 50,
    '2': 0, // Special case handled separately
  };

  void _addCard(String card) {
    setState(() {
      _controller.text += card;
      if (card == '2') {
        totalPoints *= 2;
      } else {
        totalPoints += cardPoints[card] ?? 0;
      }
    });
  }

  void _backspace() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        String lastCard = _controller.text.substring(_controller.text.length - 1);
        _controller.text = _controller.text.substring(0, _controller.text.length - 1);
        if (lastCard == '2') {
          totalPoints = (totalPoints / 2).round();
        } else {
          totalPoints -= cardPoints[lastCard] ?? 0;
        }
      }
    });
  }

  void _deleteAll() {
    setState(() {
      _controller.clear();
      totalPoints = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points Calculator'),
      ),
      body: Container(
        color: main1, // Set your desired background color here
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cards',
              ),
            ),
            const SizedBox(height: 10),
            Text('Total Points: $totalPoints', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: cardPoints.keys.map((card) {
                return ElevatedButton(
                  onPressed: () => _addCard(card),
                  child: Text(card),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _backspace,
                  child: const Text('Backspace'),
                ),
                ElevatedButton(
                  onPressed: _deleteAll,
                  child: const Text('Delete All'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}