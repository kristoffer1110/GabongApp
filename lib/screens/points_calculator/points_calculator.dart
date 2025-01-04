import 'package:flutter/material.dart';

class PointsCalculatorScreen extends StatelessWidget {
  const PointsCalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points Calculator'),
      ),
      body: const Center(
        child: Text('Points Calculator Screen'),
      ),
    );
  }
}