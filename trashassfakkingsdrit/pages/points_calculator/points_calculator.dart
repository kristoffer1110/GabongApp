import 'package:flutter/material.dart';
import 'calculator_button_array.dart';
import '../../bloc.navigation_bloc/navigation_bloc.dart';

class PointsCalculatorPage extends StatefulWidget implements NavigationStates {
  const PointsCalculatorPage({super.key});

  @override
  PointsCalculatorPageState createState() => PointsCalculatorPageState();

}

class PointsCalculatorPageState extends State<PointsCalculatorPage> {
  final TextEditingController cardSymbolsController = TextEditingController();

  final cardSymbolsToPointsMap = {
    'A': 15,
    '2': 5,
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

  int calculatePoints(String cardSymbols){
    int points = 0;
    int numberOfTwos = 0;

    for(int i = 0; i < cardSymbols.length; i++){

      bool validCardSymbol = cardSymbolsToPointsMap.containsKey(cardSymbols[i]);

      if (cardSymbols[i] == '1' && i != cardSymbols.length - 1) {
        if (cardSymbols[i + 1] == '0') {
          points += cardSymbolsToPointsMap['10'] ?? 0;
          i++;
          continue;
        }
        else {
          return -1;
        }
      }
      if (cardSymbols[i] == '2') {
        numberOfTwos++;
      }
      if(validCardSymbol){
        points += cardSymbolsToPointsMap[cardSymbols[i]] ?? 0;
      }
      else{
        return -1;
      }
    }
    for (int i = 0; i < numberOfTwos; i++) {
      points *= 2;
    }
    return points;
  }

  void showPointsDialog(BuildContext context, String cardSymbols){
    int points = calculatePoints(cardSymbols);
    if(points == -1){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid Card Symbol'),
            content: const Text('Please input valid card symbols'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    else{
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Points Calculated'),
            content: Text('Points: $points'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points Calculator'),
      ),
      backgroundColor: const Color.fromARGB(255, 33, 102, 36),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: cardSymbolsController,
                        builder: (context, value, child) {
                          return Text(
                            value.text,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    )
                  ),
                  IconButton(
                    icon: const Icon(Icons.backspace),
                    onPressed: () {
                      if (cardSymbolsController.text.isNotEmpty) {
                        cardSymbolsController.text = cardSymbolsController.text.substring(0, cardSymbolsController.text.length - 1);
                      }
                    },
                    color: Colors.grey,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      cardSymbolsController.clear();
                    },
                    color: Colors.red,
                  )
                ],
              )
            ),
            Flexible(
              flex: 2,
              child: Center(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: cardSymbolsController,
                  builder: (context, value, child) {
                    return Text(
                      '${calculatePoints(cardSymbolsController.text)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: CalculatorButtonArray(
                calculatorButtonLetters: cardSymbolsToPointsMap.keys.toList(),
                cardSymbolsController: cardSymbolsController,
                color: Colors.cyanAccent,
              ),
            ),
          ],
          // children: <Widget>[
          //   const Text(
          //     'Input your card symbols:',
          //     style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
          //     ),
          //   const SizedBox(height: 20),
          //   TextField(
          //     controller: cardSymbolsController,
          //     decoration: const InputDecoration(
          //       border: OutlineInputBorder(),
          //       labelText: 'Card Symbols',
          //       fillColor: Colors.white,
          //       filled: true,
          //     ),
          //   ),
          //   const SizedBox(height: 20),
          //   ElevatedButton(
          //     onPressed: () {
          //       showPointsDialog(context, cardSymbolsController.text
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       minimumSize: const Size(300, 60),
          //     ),
          //     child: const Text('Calculate Points'),
          //   ),
          // ] 
        ),
      )
    );
  }
}