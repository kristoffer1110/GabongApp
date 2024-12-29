import 'package:flutter/material.dart';
import '../../globals.dart' as globals;
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/menu_button.dart';


class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIDcontroller = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkInputs);
  }

  void _checkInputs() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          (_gameIDcontroller.text.length == 4);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gameIDcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      backgroundColor: theme.colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Join Game',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _nameController,
              labelText: 'Enter your name',
              onChanged: (_) => _checkInputs(),
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _gameIDcontroller,
              labelText: 'Enter Game ID',
              onChanged: (_) => _checkInputs(),
            ),
            const SizedBox(height: 20),
            MenuButton(
              label: 'Join Game',
              onPressed: _isButtonEnabled
                  ? () {
                      globals.playerName = _nameController.text;
                      globals.gameID = _gameIDcontroller.text;
                      Navigator.pushNamed(context, '/waitingJoinScreen');
                    }
                  : null,
              enabled: _isButtonEnabled,
            ),
          ],
        ),
      ),
    );
  }
}