import 'package:flutter/material.dart';
import '../../globals.dart' as globals;

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  _RulesScreenState createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final List<bool> _isExpanded = [false, false, false];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Rules Page'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildExpansionTile(
            title: 'Basic Rules',
            index: 0,
            children: const [
              Text('- A player can place cards of the same type* on top of each other', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('- A player can place cards of the same value** on top of each other.', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('- An eight can be used to change to other types of cards', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('- The goal of the game is to get the least amount of points', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('* Card of the same suit (Diamonds, Hearts, Clubs, Spades)', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('** Card of the same number (A(1), 2, 3, 4, 5, 6, 7, 8, 9, 10, J(11), Q(12), K(13))', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Basic Rules',
            index: 0,
            children: const [
              Text('- A player can place cards of the same type* on top of each other', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('- A player can place cards of the same value** on top of each other.', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('- An eight can be used to change to other types of cards', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('- The goal of the game is to get the least amount of points', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('* Card of the same suit (Diamonds, Hearts, Clubs, Spades)', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('** Card of the same number (A(1), 2, 3, 4, 5, 6, 7, 8, 9, 10, J(11), Q(12), K(13))', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({required String title, required int index, required List<Widget> children}) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      initiallyExpanded: _isExpanded[index],
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded[index] = expanded;
        });
      },
      children: children,
    );
  }
}
