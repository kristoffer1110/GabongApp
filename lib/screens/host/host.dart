import 'package:flutter/material.dart';
import '../../globals.dart' as globals;
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/menu_button.dart';


class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  _HostScreenState createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pointLimitController = TextEditingController();
  final TextEditingController _roundLimitController = TextEditingController();
  bool _isButtonEnabled = false;
  String _selectedOption = 'Point Limit';
  int _pointLimit = 0;
  int _roundLimit = 0;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkInputs);
  }

  void _checkInputs() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          ((_selectedOption == 'Point Limit' && _pointLimit > 0) ||
              (_selectedOption == 'Round Limit' && _roundLimit > 0));
    });
  }

  void _setPointLimit(String value) {
    setState(() {
      _pointLimit = int.tryParse(value) ?? 0;
      _checkInputs();
    });
  }

  void _setRoundLimit(String value) {
    setState(() {
      _roundLimit = int.tryParse(value) ?? 0;
      _checkInputs();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pointLimitController.dispose();
    _roundLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
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
            InputField(
              controller: _nameController,
              labelText: 'Enter your name',
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
                    activeColor: theme.colorScheme.tertiary, // Set the active color to tertiary
                    fillColor: WidgetStateProperty.all(theme.colorScheme.tertiary), // Set the fill color to tertiary
                  ),
                ),
                if (_selectedOption == 'Point Limit')
                  InputField(
                    controller: _pointLimitController,
                    labelText: 'Set Point Limit',
                    keyboardType: TextInputType.number,
                    onChanged: _setPointLimit,
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
                    activeColor: theme.colorScheme.tertiary, // Set the active color to tertiary
                    fillColor: WidgetStateProperty.all(theme.colorScheme.tertiary), // Set the fill color to tertiary
                  ),
                ),
                if (_selectedOption == 'Round Limit')
                  InputField(
                    controller: _roundLimitController,
                    labelText: 'Set Round Limit',
                    keyboardType: TextInputType.number,
                    onChanged: _setRoundLimit,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            MenuButton(
              label: 'Host Game',
              onPressed: _isButtonEnabled
                  ? () {
                      globals.playerName = _nameController.text;
                      Navigator.pushNamed(context, '/waitingHostScreen');
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