import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
class LocalSelectGamemode extends StatefulWidget {
  const LocalSelectGamemode({super.key});

  @override
  _LocalSelectGamemodeState createState() => _LocalSelectGamemodeState();
}

class _LocalSelectGamemodeState extends State<LocalSelectGamemode> {
  String _selectedOption = 'Point Limit';
  int _limit = 0;
  final TextEditingController _limitController = TextEditingController();
  bool _isButtonEnabled = false;

  void _checkInputs() {
    setState(() {
      _isButtonEnabled = _limitController.text.isNotEmpty;
    });
  }

  void _setLimit(String value) {
    setState(() {
      _limit = int.tryParse(value) ?? 0;
      _checkInputs();
    });
    if (_limit > 1) {
      _isButtonEnabled = true;
    } else {
      _isButtonEnabled = false;
    }
  }

  void _continue() {
    _setLimit(_limitController.text);
    Navigator.pushNamed(
      context,
      '/localAddPlayers',
      arguments: {
        'gamemode': _selectedOption,
        'limit': _limit,
      },
    );
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
              'Select Gamemode',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
            Row(
              children: [
                Expanded(
                  child: InputField(
                    controller: _limitController, 
                    labelText: 'Enter limit',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _setLimit(value),
                  ),
                ),
                const SizedBox(width: 16),
                MenuButton (
                  label: 'Continue',
                  onPressed: () => _continue(),
                  enabled: _isButtonEnabled,
                
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
