import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final IconData iconDisabled;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final bool isEnabled; // Added boolean property

  const ControlButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.white24,
    this.size = 50,
    this.iconSize = 30,
    required this.iconDisabled,
    this.isEnabled = true, // Default value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white30 : Colors.red,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          isEnabled ? icon : iconDisabled,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}
