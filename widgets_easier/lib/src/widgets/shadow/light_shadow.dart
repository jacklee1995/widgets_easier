import 'package:flutter/material.dart';

class LightShadow extends StatelessWidget {
  final Widget child;

  const LightShadow({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
