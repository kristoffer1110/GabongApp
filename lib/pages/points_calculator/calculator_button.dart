import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget{

  final String buttonLetter;
  final TextEditingController cardSymbolsController;
  final Color color;

  const CalculatorButton({
    super.key, 
    required this.buttonLetter, 
    required this.cardSymbolsController,
    required this.color
  });

  @override
  CalculatorButtonState createState() => CalculatorButtonState();
}

class CalculatorButtonState extends State<CalculatorButton>{

  @override
  void initState(){
    super.initState();
  }

  void updateCardSymbols(){
    setState(() {
      widget.cardSymbolsController.text += widget.buttonLetter;
    });
  }

  @override
  Widget build(BuildContext context){
    
    return GestureDetector(
      onTap: (){
        updateCardSymbols();
      },

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          color: widget.color,
          child: Center(
            child: Text(
              widget.buttonLetter,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 26,
                color: Colors.black,
              )
            ),
          )
        )  
      )
    );
  }
}