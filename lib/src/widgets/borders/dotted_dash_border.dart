import 'dart:ui';

import 'package:flutter/material.dart';

import 'border_dot_shape.dart';

class DottedDashBorder extends ShapeBorder {
  final double radius;
  final BorderRadius borderRadius;
  final double dotSize;
  final double dashWidth;
  final double dashSize;
  final double spacing;
  final BorderDotShape dotShape;
  final Color dotColor;
  final Color dashColor;
  final Gradient? gradient;

  const DottedDashBorder({
    this.radius = 0.0,
    this.borderRadius = BorderRadius.zero,
    this.dotSize = 3.0,
    this.dashWidth = 2.0,
    this.dashSize = 10.0,
    this.spacing = 5.0,
    this.dotShape = BorderDotShape.circle,
    this.dotColor = Colors.black,
    this.dashColor = Colors.black,
    this.gradient,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(radius + dotSize);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(
      rect.deflate(dotSize),
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

    final Paint dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = dotColor;

    final Paint dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = dashWidth
      ..color = dashColor;

    if (gradient != null) {
      dotPaint.shader = gradient!.createShader(rect);
      dashPaint.shader = gradient!.createShader(rect);
    }

    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final Offset dotPosition =
            pathMetric.getTangentForOffset(distance)!.position;

        if (dotShape == BorderDotShape.circle) {
          canvas.drawCircle(dotPosition, dotSize / 2, dotPaint);
        } else {
          final Rect dotRect = Rect.fromLTWH(
            dotPosition.dx - dotSize / 2,
            dotPosition.dy - dotSize / 2,
            dotSize,
            dotSize,
          );
          canvas.drawRect(dotRect, dotPaint);
        }

        distance += dotSize + spacing;

        final double dashLength = dashSize;
        if (distance + dashLength > pathMetric.length) break;
        final Path dashPath =
            pathMetric.extractPath(distance, distance + dashLength);
        canvas.drawPath(dashPath, dashPaint);

        distance += dashLength + spacing;
      }
      distance = 0.0; // Reset distance for next path
    }
  }

  @override
  ShapeBorder scale(double t) {
    return DottedDashBorder(
      radius: radius * t,
      borderRadius: borderRadius * t,
      dotSize: dotSize * t,
      dashWidth: dashWidth * t,
      dashSize: dashSize * t,
      spacing: spacing * t,
      dotShape: dotShape,
      dotColor: dotColor,
      dashColor: dashColor,
      gradient: gradient,
    );
  }
}
