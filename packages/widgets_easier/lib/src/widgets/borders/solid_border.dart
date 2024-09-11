import 'package:flutter/material.dart';

class SolidBorder extends ShapeBorder {
  final double width;
  final BorderRadius borderRadius;
  final Color? color;
  final Gradient? gradient;

  const SolidBorder({
    this.width = 1.0,
    this.borderRadius = BorderRadius.zero,
    this.color,
    this.gradient,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(
      rect.deflate(width),
      textDirection: textDirection,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    if (gradient != null) {
      paint.shader = gradient!.createShader(rect);
    } else if (color != null) {
      paint.color = color!;
    }

    final RRect rrect = borderRadius.toRRect(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return SolidBorder(
      width: width * t,
      borderRadius: borderRadius * t,
      color: color,
      gradient: gradient,
    );
  }
}
