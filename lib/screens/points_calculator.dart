import 'package:flutter/material.dart';
import 'package:gabong_v1/main.dart';
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/normal_button.dart';
import 'package:gabong_v1/widgets/scaffold.dart';

class PointsCalculatorScreen extends StatefulWidget {
  const PointsCalculatorScreen({Key? key}) : super(key: key);

  @override
  _PointsCalculatorScreenState createState() => _PointsCalculatorScreenState();
}

class _PointsCalculatorScreenState extends State<PointsCalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  int totalPoints = 0;
  int twoCardCount = 0;

  final Map<String, int> cardPoints = {
    'A': 15,
    '2': 5, // Special case handled separately
    '3': 20,
    '4': 5,
    '5': 5,
    '6': 5,
    '7': 5,
    '8': 50,
    '9': 5,
    '10': 5,
    'J': 10,
    'Q': 10,
    'K': 20,
  };

  void _addCard(String card) {
    setState(() {
      _controller.text += card;
      if (card == '2') {
        totalPoints += 5;
        twoCardCount++;
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
          totalPoints -= 5;
          twoCardCount--;
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
      twoCardCount = 0;
    });
  }

  int _calculateFinalPoints() {
    int finalPoints = totalPoints;
    for (int i = 0; i < twoCardCount; i++) {
      finalPoints *= 2;
    }
    return finalPoints;
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Points Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InputField(
              controller: _controller,
              labelText: 'Cards',
              onChanged: (value) {},
            ),
            const SizedBox(height: 10),
            Text('Total Points: ${_calculateFinalPoints()}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'].map((card) {
                return NormalButton(
                  label: card,
                  onPressed: () => _addCard(card),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NormalButton(
                  label: 'Backspace',
                  onPressed: _backspace,
                ),
                NormalButton(
                  label: 'Delete All',
                  onPressed: _deleteAll,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}