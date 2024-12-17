import 'package:flutter/material.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import '../screens/point_limit.dart';
import '../screens/round_limit.dart';

class PlayGabong extends StatelessWidget implements NavigationStates {
  const PlayGabong({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Game Mode'),
      ),
      backgroundColor: const Color.fromARGB(255, 33, 102, 36),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PointLimitScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 60),
              ),
              child: const Text('Point Limit'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RoundLimitScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 60),
              ),
              child: const Text('Round Limit'),
            ),
          ],
        ),
      ),
    );
  }
}