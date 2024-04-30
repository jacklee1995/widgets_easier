import 'package:flutter/material.dart';

class DoubleBorder extends ShapeBorder {
  final double radius;
  final BorderRadius borderRadius;
  final double outerWidth;
  final double innerWidth;
  final double spacing;
  final Color outerColor;
  final Color innerColor;
  final Gradient? outerGradient;
  final Gradient? innerGradient;

  const DoubleBorder({
    this.radius = 0.0,
    this.borderRadius = BorderRadius.zero,
    this.outerWidth = 2.0,
    this.innerWidth = 2.0,
    this.spacing = 2.0,
    this.outerColor = Colors.black,
    this.innerColor = Colors.black,
    this.outerGradient,
    this.innerGradient,
  });

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.all(radius + outerWidth + spacing + innerWidth);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(
      rect.deflate(outerWidth + spacing),
      textDirection: textDirection,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Path outerPath = getOuterPath(rect, textDirection: textDirection);
    final Path innerPath = getInnerPath(rect, textDirection: textDirection);

    final Paint outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerWidth
      ..color = outerColor;

    final Paint innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerWidth
      ..color = innerColor;

    if (outerGradient != null) {
      outerPaint.shader = outerGradient!.createShader(rect);
    }

    if (innerGradient != null) {
      innerPaint.shader = innerGradient!.createShader(rect);
    }

    canvas.drawPath(outerPath, outerPaint);
    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return DoubleBorder(
      radius: radius * t,
      borderRadius: borderRadius * t,
      outerWidth: outerWidth * t,
      innerWidth: innerWidth * t,
      spacing: spacing * t,
      outerColor: outerColor,
      innerColor: innerColor,
      outerGradient: outerGradient,
      innerGradient: innerGradient,
    );
  }
}
