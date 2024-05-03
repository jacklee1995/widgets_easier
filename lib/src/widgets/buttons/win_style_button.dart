import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

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
    return SemanticButton(
      text: text,
      color: const Color(0xFFFDFDFD),
      isOutlined: true,
    );
  }
}
