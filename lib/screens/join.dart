import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gabong_v1/widgets/scaffold.dart';
import '../widgets/input_field.dart';
import '../widgets/menu_button.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIDController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkInputs);
    _gameIDController.addListener(_checkInputs);
  }

  void _checkInputs() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty && _gameIDController.text.isNotEmpty;
    });
  }

  Future<void> _joinGame() async {
    final gameID = _gameIDController.text;
    final playerName = _nameController.text;

    final gameDoc = await FirebaseFirestore.instance.collection('games').doc(gameID).get();

    if (gameDoc.exists) {
      await FirebaseFirestore.instance.collection('games').doc(gameID).update({
        'players': FieldValue.arrayUnion([playerName]),
        'scores.$playerName': [],
      });

      Navigator.pushNamed(
        context, 
        '/waitingForPlayers', 
        arguments: {'gameID': gameID, 'isHost': false, 'playerName': playerName},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Game not found')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gameIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Join Game'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
              controller: _nameController,
              labelText: 'Enter your name',
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _gameIDController,
              labelText: 'Enter Game ID',
              onChanged: (_) => _checkInputs(),
            ),
            const SizedBox(height: 20),
            MenuButton(
              label: 'Join Game',
              onPressed: _isButtonEnabled ? _joinGame : null,
              enabled: _isButtonEnabled,
            ),
          ],
        ),
      ),
    );
  }
}