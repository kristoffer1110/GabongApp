import 'package:flutter/material.dart';
import 'package:gabong_v1/widgets/menu_button.dart';
import 'package:gabong_v1/widgets/circular_icon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
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
              ]
            )
          )
        ]
      )
    );
  }
}