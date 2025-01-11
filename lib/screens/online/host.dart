import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
import 'dart:math';
import 'package:gabong_v1/widgets/scaffold.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  _HostScreenState createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  bool _isButtonEnabled = false;
  String _selectedOption = 'Point Limit';
  int _limit = 0;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkInputs);
    _limitController.addListener(_checkInputs);
  }

  void _checkInputs() {
    setState(() {
      _isButtonEnabled = 
      _nameController.text.isNotEmpty && _limitController.text.isNotEmpty;
    });
  }

  void _setLimit(String value) {
    setState(() {
      _limit = int.tryParse(value) ?? 0;
      _checkInputs();
    });
  }

  String _generateGameID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  Future<void> _hostGame() async {
    final pin = _generateGameID();
    final playerName = _nameController.text;

    await FirebaseFirestore.instance.collection('games').doc(pin).set({
      'host': playerName,
      'players': [playerName],
      'scores': {playerName: 0},
      'scoreInputs': {playerName: []},

      'gameMode' : _selectedOption,
      'limit': _limit,
  
      'currentRound': 1,
      'gameStarted': false,
    });

    Navigator.pushNamed(
      context,
      '/waitingForPlayers',
      arguments: {'gameID': pin, 'isHost': true, 'playerName': playerName},
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GradientScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Host Game',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text('Enter your name:',
              style: TextStyle(
                color: theme.colorScheme.tertiary,
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),
            InputField(
              controller: _nameController,
              labelText: 'Name of Host',
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                ListTile(
                  title: const Text('Point Limit'),
                  leading: Radio<String>(
                    value: 'Point Limit',
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value!;
                        _checkInputs();
                      });
                    },
                    activeColor: theme.colorScheme.tertiary,
                    fillColor: WidgetStateProperty.all(theme.colorScheme.tertiary),
                  ),
                ),
                ListTile(
                  title: const Text('Round Limit'),
                  leading: Radio<String>(
                    value: 'Round Limit',
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value!;
                        _checkInputs();
                      });
                    },
                    activeColor: theme.colorScheme.tertiary,
                    fillColor: WidgetStateProperty.all(theme.colorScheme.tertiary),
                  ),
                ),
                const SizedBox(height: 16),
                InputField(
                  controller: _limitController,
                  labelText: 'Enter Limit',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _setLimit(value),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MenuButton(
              label: 'Host Game',
              onPressed: _isButtonEnabled ? _hostGame : null,
              enabled: _isButtonEnabled,
            ),
          ],
        ),
      ),
    );
  }
}