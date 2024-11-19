import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget{
  
  final IconData icon;
  final String title;
  final GestureTapCallback onTap;

  const MenuItem({
    super.key, 
    required this.icon, 
    required this.title,
    required this.onTap
  });
  
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: const Color(0xFFC0C0C0),
            size: 30,
          ),
          const SizedBox(
            width: 20
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 26,
              color: Colors.black,
            ),
          )
        ],)
      )
    );
  }
}