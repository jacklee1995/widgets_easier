import 'package:flutter/material.dart';

class BorderWrapper extends StatelessWidget {
  final Widget child;
  final ShapeBorder shape;

  const BorderWrapper({
    super.key,
    required this.child,
    required this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BorderPainter(shape),
      child: Padding(
        padding: shape.dimensions,
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: shape),
          child: child,
        ),
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  final ShapeBorder shape;

  _BorderPainter(this.shape);

  @override
  void paint(Canvas canvas, Size size) {
    shape.paint(canvas, Offset.zero & size);
  }

  @override
  bool shouldRepaint(_BorderPainter oldDelegate) {
    return oldDelegate.shape != shape;
  }
}
