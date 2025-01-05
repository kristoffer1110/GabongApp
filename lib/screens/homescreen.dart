import 'package:flutter/material.dart';
import 'package:gabong_v1/main.dart';

import 'package:gabong_v1/widgets/menu_button.dart';
import 'package:gabong_v1/widgets/circular_icon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Transform.rotate(
          angle: 3.14159, // 180 degrees in radians
          child: Image.asset(
            'assets/background_image.gif',
            fit: BoxFit.cover,
          ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  // main1, secondary1
                  main1.withOpacity(0.9),
                  secondary1.withOpacity(0.9),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/gabong_logo.png', height: 250),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'GABONG!',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 50,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: MenuButton(
                          label: 'Host Game',
                          onPressed: () {
                            Navigator.pushNamed(context, '/host');
                          },
                        ),
                      ),
                      Expanded(
                        child: MenuButton(
                          label: 'Join Game',
                          onPressed: () {
                            Navigator.pushNamed(context, '/join');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                MenuButton(
                  label: 'Play Local',
                  onPressed: () {
                    Navigator.pushNamed(context, '/play');
                  },
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircularIconButton(
                          icon: Icons.calculate,
                          onPressed: () {
                            Navigator.pushNamed(context, '/calculator');
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: CircularIconButton(
                          icon: Icons.book,
                          onPressed: () {
                            Navigator.pushNamed(context, '/rules');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
