import 'package:flutter/material.dart';
import 'package:gabong_v1/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      backgroundColor: main1, // Add background color here
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Sound'),
            trailing: Switch(
              activeColor: secondary2,
              value: true,
              onChanged: (bool value) {
                // Handle sound setting change
              },
            ),
          ),
          ListTile(
            title: const Text('Music'),
            trailing: Switch(
              activeColor: secondary2,
              value: true,
              onChanged: (bool value) {
                // Handle music setting change
              },
            ),
          ),
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch(
              activeColor: secondary2,
              value: true,
              onChanged: (bool value) {
                // Handle notifications setting change
              },
            ),
          ),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: 'English',
              onChanged: (String? newValue) {
                // Handle language setting change
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