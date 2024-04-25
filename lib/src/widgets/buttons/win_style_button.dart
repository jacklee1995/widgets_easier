import 'package:flutter/material.dart';

class WinStyleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const WinStyleButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blue, // 文字颜色
      ),
      child: Text(text),
    );
  }
}
