import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged, // Pass the onChanged callback
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.colorScheme.secondary, // Use secondary color for background
          labelText: labelText,
          labelStyle: TextStyle(
            color: theme.colorScheme.tertiary, // Use tertiary color for label text
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(30.0)), // Change to oval shape
            borderSide: BorderSide(
              color: theme.colorScheme.tertiary, // Use tertiary color for border
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(30.0)), // Change to oval shape
            borderSide: BorderSide(
              color: theme.colorScheme.tertiary, // Use tertiary color for enabled border
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(30.0)), // Change to oval shape
            borderSide: BorderSide(
              color: theme.colorScheme.tertiary, // Use tertiary color for focused border
              width: 2,
            ),
          ),
        ),
        style: TextStyle(
          color: theme.colorScheme.tertiary, // Use tertiary color for input text
        ),
      ),
    );
  }
}