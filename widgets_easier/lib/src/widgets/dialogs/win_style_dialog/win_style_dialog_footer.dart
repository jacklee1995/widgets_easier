import 'package:flutter/material.dart';

class WinStyleInfoDialogFooter extends StatelessWidget {
  final List<Widget> actions;
  final double borderRadius;
  final Color backgroundColor;

  const WinStyleInfoDialogFooter({
    super.key,
    required this.actions,
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
        children: actions,
      ),
    );
  }
}
