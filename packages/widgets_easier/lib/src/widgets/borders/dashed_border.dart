import 'dart:ui';

import 'package:flutter/material.dart';

class DashedBorder extends ShapeBorder {
  final double width;
  final double radius;
  final BorderRadius borderRadius;
  final Color color;
  final double dashSize;
  final double dashSpacing;
  final Gradient? gradient;

  const DashedBorder({
    this.width = 1.0,
    this.radius = 0.0,
    this.borderRadius = BorderRadius.zero,
    this.color = Colors.black,
    this.dashSize = 10.0,
    this.dashSpacing = 5.0,
    this.gradient,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(radius + width);

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
    final Path path = getOuterPath(rect, textDirection: textDirection);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = gradient?.createShader(rect);

    if (paint.shader == null) {
      paint.color = color;
    }

    // Create the dashed effect
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final double length = dashSize;
        if (distance + length > pathMetric.length) break;
        final Path extractPath =
            pathMetric.extractPath(distance, distance + length);
        canvas.drawPath(extractPath, paint);
        distance += length + dashSpacing;
      }
      distance = 0.0; // Reset distance for next path
    }
  }

  @override
  ShapeBorder scale(double t) {
    return DashedBorder(
      width: width * t,
      radius: radius * t,
      borderRadius: borderRadius * t,
      color: color,
      dashSize: dashSize * t,
      dashSpacing: dashSpacing * t,
      gradient: gradient,
    );
  }
}
