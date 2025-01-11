import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final Text text;
  final Color? containerColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Icon icon;
  final bool centered;

  const TextContainer({
    super.key,
    required this.text,
    this.containerColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.icon = const Icon(null),
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = containerColor ?? theme.colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: theme.colorScheme.tertiary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: ListTile(
              title: centered == true ? Center(child: text) : text,
                leading: icon.icon == null ? null : icon,
            ),
          ),
        ),
      ),
    );
  }
}