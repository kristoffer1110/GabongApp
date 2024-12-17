import 'package:flutter/material.dart';
import 'calculator_button.dart';

class CalculatorButtonArray extends StatelessWidget {
  final List<String> calculatorButtonLetters;
  final TextEditingController cardSymbolsController;
  final Color color;
  
  const CalculatorButtonArray({
    super.key,
    required this.calculatorButtonLetters,
    required this.cardSymbolsController,
    required this.color
  });

  List<CalculatorButton> getCalculatorButtons(){
    List<CalculatorButton> calculatorButtons = [];
    for (int i = 0; i < calculatorButtonLetters.length; i++) {
      calculatorButtons.add(
        CalculatorButton(
          buttonLetter: calculatorButtonLetters[i],
          cardSymbolsController: cardSymbolsController,
          color: color,
        )
      );
    }
    return calculatorButtons;
  }
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      crossAxisCount: 4,
      children:  getCalculatorButtons(),
    );
  }
}