import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
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
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() async {
    if (widget.enabled && widget.onPressed != null) {
      setState(() {
        _isLoading = true;
      });
      _controller.forward().then((_) => _controller.reverse());
      await Future.delayed(const Duration(seconds: 1)); // Simulate a delay
      widget.onPressed!();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ScaleTransition(
        scale: _animation,
        child: OutlinedButton(
          onPressed: _handlePress,
          style: OutlinedButton.styleFrom(
            backgroundColor: widget.enabled ? theme.colorScheme.secondary : theme.colorScheme.secondary.withOpacity(0.5),
            shape: const StadiumBorder(),
            side: BorderSide(
              color: theme.colorScheme.tertiary,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    widget.label.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}