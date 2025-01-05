import 'package:flutter/material.dart';
import 'package:gabong_v1/main.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
import 'package:gabong_v1/widgets/scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: isLoggedIn
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/default_profile_picture.jpg'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Name:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'John Doe',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Email:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'john.doe@example.com',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Phone:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '+1234567890',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  MenuButton(
                    label: 'Logout',
                    onPressed: () {
                        setState(() {
                        isLoggedIn = false;  // Change when logout functionality is added
                        });
                    },
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Oops! Looks like you are not logged in.',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    MenuButton(
                      label: 'Click here to log in now!', 
                      onPressed: () {
                        setState(() {
                          isLoggedIn = true;  // Change when login functionality is added
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    MenuButton(
                      label: 'Click here to register and make a profile!',
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      )
                  ],
                ),
              ),
      ),
    );
  }
}
