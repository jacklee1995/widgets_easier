import 'package:flutter/material.dart';

class DarkShadow extends StatelessWidget {
  final Widget child;

  const DarkShadow({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
