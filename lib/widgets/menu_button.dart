import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  const MenuButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: enabled ? theme.colorScheme.secondary : theme.colorScheme.secondary.withOpacity(0.5), // Use secondary color for button background
          shape: const StadiumBorder(), // Change to StadiumBorder for oval shape
          side: BorderSide(
            color: theme.colorScheme.tertiary, // Use tertiary color for outline
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: theme.colorScheme.tertiary, // Use tertiary color for text
            ),
          ),
        ),
      ),
    );
  }
}