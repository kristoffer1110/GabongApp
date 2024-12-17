import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 8.0,
        shape: const CircleBorder(),
        color: theme.colorScheme.secondary,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: theme.colorScheme.tertiary,
          iconSize: 24.0,
          padding: const EdgeInsets.all(12.0),
          splashRadius: 28.0,
        ),
      ),
    );
  }
}