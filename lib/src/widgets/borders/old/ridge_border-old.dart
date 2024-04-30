import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'abstract_border.dart';

class RidgeBorder extends AbstractBorder {
  const RidgeBorder({
    super.top = const BorderSide(),
    super.right = const BorderSide(),
    super.bottom = const BorderSide(),
    super.left = const BorderSide(),
    super.borderRadius = BorderRadius.zero,
    this.ridgeWidth = 2,
    this.gap = 2,
  });

  final double ridgeWidth;
  final double gap;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    paintBorder(canvas, rect, textDirection: textDirection);
  }

  @override
  void paintBorder(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint();
    paint.style = PaintingStyle.stroke;

    final RRect outerRRect = borderRadius.toRRect(rect);
    final RRect innerRRect =
        borderRadius.toRRect(rect.deflate(ridgeWidth + gap));

    if (top.width > 0) {
      paint.color = top.color;
      paint.strokeWidth = top.width;
      canvas.drawLine(
        Offset(outerRRect.left + outerRRect.tlRadiusX, outerRRect.top),
        Offset(outerRRect.right - outerRRect.trRadiusX, outerRRect.top),
        paint,
      );
      paint.strokeWidth = ridgeWidth;
      final double startX = outerRRect.left + outerRRect.tlRadiusX;
      final double endX = outerRRect.right - outerRRect.trRadiusX;
      final double y = innerRRect.top + ridgeWidth / 2;
      canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
    }
    if (right.width > 0) {
      paint.color = right.color;
      paint.strokeWidth = right.width;
      canvas.drawLine(
        Offset(outerRRect.right, outerRRect.top + outerRRect.trRadiusY),
        Offset(outerRRect.right, outerRRect.bottom - outerRRect.brRadiusY),
        paint,
      );
      paint.strokeWidth = ridgeWidth;
      final double startY = outerRRect.top + outerRRect.trRadiusY;
      final double endY = outerRRect.bottom - outerRRect.brRadiusY;
      final double x = innerRRect.right - ridgeWidth / 2;
      canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
    }
    if (bottom.width > 0) {
      paint.color = bottom.color;
      paint.strokeWidth = bottom.width;
      canvas.drawLine(
        Offset(outerRRect.right - outerRRect.brRadiusX, outerRRect.bottom),
        Offset(outerRRect.left + outerRRect.blRadiusX, outerRRect.bottom),
        paint,
      );
      paint.strokeWidth = ridgeWidth;
      final double startX = outerRRect.right - outerRRect.brRadiusX;
      final double endX = outerRRect.left + outerRRect.blRadiusX;
      final double y = innerRRect.bottom - ridgeWidth / 2;
      canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
    }
    if (left.width > 0) {
      paint.color = left.color;
      paint.strokeWidth = left.width;
      canvas.drawLine(
        Offset(outerRRect.left, outerRRect.bottom - outerRRect.blRadiusY),
        Offset(outerRRect.left, outerRRect.top + outerRRect.tlRadiusY),
        paint,
      );
      paint.strokeWidth = ridgeWidth;
      final double startY = outerRRect.bottom - outerRRect.blRadiusY;
      final double endY = outerRRect.top + outerRRect.tlRadiusY;
      final double x = innerRRect.left + ridgeWidth / 2;
      canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
    }
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius.toRRect(rect).deflate(ridgeWidth + gap));
  }

  @override
  ShapeBorder scale(double t) {
    return RidgeBorder(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t),
      borderRadius: borderRadius * t,
      ridgeWidth: ridgeWidth * t,
      gap: gap * t,
    );
  }
}
