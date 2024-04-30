import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'abstract_border.dart';

class GrooveBorder extends AbstractBorder {
  const GrooveBorder({
    super.top = const BorderSide(),
    super.right = const BorderSide(),
    super.bottom = const BorderSide(),
    super.left = const BorderSide(),
    super.borderRadius = BorderRadius.zero,
    this.grooveWidth = 2,
  });

  final double grooveWidth;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    paintBorder(canvas, rect, textDirection: textDirection);
  }

  @override
  void paintBorder(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint();
    paint.style = PaintingStyle.stroke;

    final RRect outerRRect = borderRadius.toRRect(rect);
    final RRect innerRRect = borderRadius.toRRect(rect.deflate(grooveWidth));

    final Path path = Path();

    if (top.width > 0) {
      paint.color = top.color;
      paint.strokeWidth = top.width;
      path.reset();
      path.moveTo(outerRRect.left + outerRRect.tlRadiusX, outerRRect.top);
      path.lineTo(innerRRect.left + innerRRect.tlRadiusX, innerRRect.top);
      path.lineTo(innerRRect.right - innerRRect.trRadiusX, innerRRect.top);
      path.lineTo(outerRRect.right - outerRRect.trRadiusX, outerRRect.top);
      canvas.drawPath(path, paint);
    }

    if (right.width > 0) {
      paint.color = right.color;
      paint.strokeWidth = right.width;
      path.reset();
      path.moveTo(outerRRect.right, outerRRect.top + outerRRect.trRadiusY);
      path.lineTo(innerRRect.right, innerRRect.top + innerRRect.trRadiusY);
      path.lineTo(innerRRect.right, innerRRect.bottom - innerRRect.brRadiusY);
      path.lineTo(outerRRect.right, outerRRect.bottom - outerRRect.brRadiusY);
      canvas.drawPath(path, paint);
    }

    if (bottom.width > 0) {
      paint.color = bottom.color;
      paint.strokeWidth = bottom.width;
      path.reset();
      path.moveTo(outerRRect.right - outerRRect.brRadiusX, outerRRect.bottom);
      path.lineTo(innerRRect.right - innerRRect.brRadiusX, innerRRect.bottom);
      path.lineTo(innerRRect.left + innerRRect.blRadiusX, innerRRect.bottom);
      path.lineTo(outerRRect.left + outerRRect.blRadiusX, outerRRect.bottom);
      canvas.drawPath(path, paint);
    }

    if (left.width > 0) {
      paint.color = left.color;
      paint.strokeWidth = left.width;
      path.reset();
      path.moveTo(outerRRect.left, outerRRect.bottom - outerRRect.blRadiusY);
      path.lineTo(innerRRect.left, innerRRect.bottom - innerRRect.blRadiusY);
      path.lineTo(innerRRect.left, innerRRect.top + innerRRect.tlRadiusY);
      path.lineTo(outerRRect.left, outerRRect.top + outerRRect.tlRadiusY);
      canvas.drawPath(path, paint);
    }
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius.toRRect(rect).deflate(math.max(top.width,
              math.max(right.width, math.max(bottom.width, left.width))) +
          grooveWidth));
  }

  @override
  ShapeBorder scale(double t) {
    return GrooveBorder(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t),
      borderRadius: borderRadius * t,
      grooveWidth: grooveWidth * t,
    );
  }
}
