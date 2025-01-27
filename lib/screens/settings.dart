import 'package:flutter/material.dart';
import 'package:gabong_v1/main.dart';
import 'package:gabong_v1/widgets/scaffold.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _sound = true;
  bool _music = true;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Sound'),
            trailing: Switch(
              activeColor: secondary2,
              value: _sound,
              onChanged: (bool value) {
                setState(() {
                  _sound = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Music'),
            trailing: Switch(
              activeColor: secondary2,
              value: _music,
              onChanged: (bool value) {
                setState(() {
                  _music = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch(
              activeColor: secondary2,
              value: _notifications,
              onChanged: (bool value) {
                setState(() {
                  _notifications = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: 'English',
              onChanged: (String? newValue) {
                // Language setting handling here (When added)
              },
              items: <String>['English', 'Spanish', 'French', 'German']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}