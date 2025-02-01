import 'package:flutter/material.dart';

class ElevatedButtonGlobal extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color bgColors;
  final Color textColors;
  const ElevatedButtonGlobal(
      {super.key,
      required this.text,
      required this.onPressed,
      this.bgColors = Colors.blue,
      this.textColors = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColors,
        foregroundColor: textColors,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
