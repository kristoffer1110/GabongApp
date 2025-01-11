import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final String text;
  final Color? containerColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const TextContainer({
    super.key,
    required this.text,
    this.containerColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contColor = containerColor ?? theme.colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9, // Set a finite width constraint
          ),
          child: Container(
            decoration: BoxDecoration(
              color: contColor,
              border: Border.all(
                color: theme.colorScheme.tertiary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: ListTile(
              title: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: color,
                ),
              ),
              leading: Icon(
                Icons.person,
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}