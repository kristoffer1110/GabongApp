import 'package:flutter/material.dart';
import 'package:gabong_v1/main.dart';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final bool automaticallyImplyLeading;

  const GradientScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.automaticallyImplyLeading = true, // Default to true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar != null
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: appBar!.title,
              // actions: [
              //   ...?appBar!.actions,
              //   IconButton(
              //     icon: const Icon(Icons.home),
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/home');
              //     },
              //   ),
              // ],
              leading: appBar!.leading,
              automaticallyImplyLeading: automaticallyImplyLeading, // Use the parameter
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [main1, secondary1],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(child: body),
      ),
    );
  }
}