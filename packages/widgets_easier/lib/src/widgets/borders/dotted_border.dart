import 'dart:ui';

import 'package:flutter/material.dart';

import 'border_dot_shape.dart';

class DottedBorder extends ShapeBorder {
  final double radius;
  final BorderRadius borderRadius;
  final Color color;
  final double dotSize;
  final double dotSpacing;
  final BorderDotShape dotShape;
  final Gradient? gradient;

  const DottedBorder({
    this.radius = 1.0,
    this.borderRadius = BorderRadius.zero,
    this.color = Colors.black,
    this.dotSize = 3.0,
    this.dotSpacing = 6.0,
    this.dotShape = BorderDotShape.circle,
    this.gradient,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(radius);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(
      rect.deflate(radius),
      textDirection: textDirection,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Path path = getOuterPath(rect, textDirection: textDirection);
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient?.createShader(rect);

    if (paint.shader == null) {
      paint.color = color;
    }

    // Create the dotted effect
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final double length = dotSize;
        if (distance + length > pathMetric.length) break;
        final Offset position =
            pathMetric.getTangentForOffset(distance)!.position;

        if (dotShape == BorderDotShape.circle) {
          canvas.drawCircle(position, dotSize / 2, paint);
        } else {
          final Rect dotRect = Rect.fromLTWH(
            position.dx - dotSize / 2,
            position.dy - dotSize / 2,
            dotSize,
            dotSize,
          );
          canvas.drawRect(dotRect, paint);
        }

        distance += length + dotSpacing;
      }
      distance = 0.0; // Reset distance for next path
    }
  }

  @override
  ShapeBorder scale(double t) {
    return DottedBorder(
      radius: radius * t,
      borderRadius: borderRadius * t,
      color: color,
      dotSize: dotSize * t,
      dotSpacing: dotSpacing * t,
      dotShape: dotShape,
      gradient: gradient,
    );
  }
}
