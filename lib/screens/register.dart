import 'package:flutter/material.dart';
import 'package:gabong_v1/main.dart';
import 'package:gabong_v1/widgets/input_field.dart';
import 'package:gabong_v1/widgets/menu_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() {
    // Handle registration logic here
    print('Username: ${_usernameController.text}');
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      backgroundColor: main1, // Set the background color here
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center the column vertically
            children: [
              Text(
                'Join the Gabong Club Today!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              InputField(
                controller: _usernameController,
                labelText: 'Username',
              ),
              InputField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              InputField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 20),
              MenuButton(
                label: 'Register',
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}