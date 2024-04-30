import 'package:flutter/material.dart';
import '../../buttons/win_style_button.dart';

class WinStyleInfoDialogFooter extends StatelessWidget {
  final String buttonText;
  final VoidCallback onButtonPressed;
  final double borderRadius;
  final Color backgroundColor;

  const WinStyleInfoDialogFooter({
    super.key,
    required this.buttonText,
    required this.onButtonPressed,
    this.borderRadius = 0, // 默认圆角为0
    this.backgroundColor = const Color(0xFFF0F0F0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          WinStyleButton(
            text: buttonText,
            onPressed: onButtonPressed,
          ),
        ],
      ),
    );
  }
}
