import 'package:flutter/material.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';

class RulesPage extends StatelessWidget implements NavigationStates {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context){
    return const Center(
      child: Text(
        'Rules Page',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
      ),
    );
  }
}