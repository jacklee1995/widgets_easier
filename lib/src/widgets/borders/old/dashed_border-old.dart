import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'abstract_border.dart';

class DashedShapeBorder extends AbstractBorder {
  const DashedShapeBorder({
    super.top = const BorderSide(),
    super.right = const BorderSide(),
    super.bottom = const BorderSide(),
    super.left = const BorderSide(),
    super.borderRadius = BorderRadius.zero,
    this.dashPattern = const <double>[3, 1],
  });

  final List<double> dashPattern;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect).deflate(top.width));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    paintBorder(canvas, rect, textDirection: textDirection);
  }

  @override
  void paintBorder(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint();
    paint.style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    final double tlX = rrect.left + rrect.tlRadiusX;
    final double tlY = rrect.top + rrect.tlRadiusY;
    final double trX = rrect.right - rrect.trRadiusX;
    final double trY = rrect.top + rrect.trRadiusY;
    final double blX = rrect.left + rrect.blRadiusX;
    final double blY = rrect.bottom - rrect.blRadiusY;
    final double brX = rrect.right - rrect.brRadiusX;
    final double brY = rrect.bottom - rrect.brRadiusY;

    if (top.width > 0) {
      paint.color = top.color;
      paint.strokeWidth = top.width;
      _drawDashedLine(canvas, Offset(tlX, rrect.top), Offset(trX, rrect.top),
          dashPattern, paint);
    }
    if (right.width > 0) {
      paint.color = right.color;
      paint.strokeWidth = right.width;
      _drawDashedLine(canvas, Offset(rrect.right, trY),
          Offset(rrect.right, brY), dashPattern, paint);
    }
    if (bottom.width > 0) {
      paint.color = bottom.color;
      paint.strokeWidth = bottom.width;
      _drawDashedLine(canvas, Offset(brX, rrect.bottom),
          Offset(blX, rrect.bottom), dashPattern, paint);
    }
    if (left.width > 0) {
      paint.color = left.color;
      paint.strokeWidth = left.width;
      _drawDashedLine(canvas, Offset(rrect.left, blY), Offset(rrect.left, tlY),
          dashPattern, paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2,
      List<double> dashPattern, Paint paint) {
    if (dashPattern.length < 2) {
      // 如果 dashPattern 不包含至少两个元素，则直接绘制一条实线
      canvas.drawLine(p1, p2, paint);
      return;
    }

    final double dx = p2.dx - p1.dx;
    final double dy = p2.dy - p1.dy;
    final double length = math.sqrt(dx * dx + dy * dy);
    double startDistance = 0.0;
    dashPattern.reduce((a, b) => a + b);
    final double cosTheta = dx / length;
    final double sinTheta = dy / length;

    int patternIndex = 0;
    while (startDistance < length) {
      double dashLength = dashPattern[patternIndex % dashPattern.length];
      double gapLength = dashPattern[(patternIndex + 1) % dashPattern.length];
      double endDistance = startDistance + dashLength;
      if (endDistance > length) {
        endDistance = length;
        dashLength = length - startDistance;
      }
      final double startX = p1.dx + startDistance * cosTheta;
      final double startY = p1.dy + startDistance * sinTheta;
      final double endX = p1.dx + endDistance * cosTheta;
      final double endY = p1.dy + endDistance * sinTheta;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      startDistance += dashLength + gapLength;
      patternIndex += 2; // Move to the next pair of dash and gap
    }
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  ShapeBorder scale(double t) {
    return DashedShapeBorder(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t),
      borderRadius: borderRadius * t,
      dashPattern: dashPattern,
    );
  }
}
