import 'package:flutter/material.dart';

class LighterShadow extends StatelessWidget {
  final Widget child;

  const LighterShadow({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
