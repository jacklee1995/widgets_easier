import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'abstract_border.dart';

class InsetBorder extends AbstractBorder {
  const InsetBorder({
    super.top = const BorderSide(),
    super.right = const BorderSide(),
    super.bottom = const BorderSide(),
    super.left = const BorderSide(),
    super.borderRadius = BorderRadius.zero,
    this.insetWidth = 2,
  });

  final double insetWidth;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    paintBorder(canvas, rect, textDirection: textDirection);
  }

  @override
  void paintBorder(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint();
    paint.style = PaintingStyle.stroke;

    final RRect outerRRect = borderRadius.toRRect(rect);
    final RRect innerRRect = borderRadius.toRRect(rect.deflate(insetWidth));

    if (top.width > 0) {
      paint.color = top.color;
      paint.strokeWidth = top.width;
      canvas.drawArc(
        Rect.fromPoints(
          Offset(outerRRect.left + outerRRect.tlRadiusX, outerRRect.top),
          Offset(innerRRect.left + innerRRect.tlRadiusX, innerRRect.top),
        ),
        math.pi,
        math.pi / 2,
        false,
        paint,
      );
      canvas.drawLine(
        Offset(innerRRect.left + innerRRect.tlRadiusX, innerRRect.top),
        Offset(innerRRect.right - innerRRect.trRadiusX, innerRRect.top),
        paint,
      );
      canvas.drawArc(
        Rect.fromPoints(
          Offset(innerRRect.right - innerRRect.trRadiusX, innerRRect.top),
          Offset(outerRRect.right - outerRRect.trRadiusX, outerRRect.top),
        ),
        -math.pi / 2,
        math.pi / 2,
        false,
        paint,
      );
    }
    if (right.width > 0) {
      paint.color = right.color;
      paint.strokeWidth = right.width;
      canvas.drawArc(
        Rect.fromPoints(
          Offset(outerRRect.right, outerRRect.top + outerRRect.trRadiusY),
          Offset(innerRRect.right, innerRRect.top + innerRRect.trRadiusY),
        ),
        -math.pi / 2,
        math.pi / 2,
        false,
        paint,
      );
      canvas.drawLine(
        Offset(innerRRect.right, innerRRect.top + innerRRect.trRadiusY),
        Offset(innerRRect.right, innerRRect.bottom - innerRRect.brRadiusY),
        paint,
      );
      canvas.drawArc(
        Rect.fromPoints(
          Offset(innerRRect.right, innerRRect.bottom - innerRRect.brRadiusY),
          Offset(outerRRect.right, outerRRect.bottom - outerRRect.brRadiusY),
        ),
        0,
        math.pi / 2,
        false,
        paint,
      );
    }
    if (bottom.width > 0) {
      paint.color = bottom.color;
      paint.strokeWidth = bottom.width;
      canvas.drawArc(
        Rect.fromPoints(
          Offset(outerRRect.right - outerRRect.brRadiusX, outerRRect.bottom),
          Offset(innerRRect.right - innerRRect.brRadiusX, innerRRect.bottom),
        ),
        0,
        math.pi / 2,
        false,
        paint,
      );
      canvas.drawLine(
        Offset(innerRRect.right - innerRRect.brRadiusX, innerRRect.bottom),
        Offset(innerRRect.left + innerRRect.blRadiusX, innerRRect.bottom),
        paint,
      );
      canvas.drawArc(
        Rect.fromPoints(
          Offset(innerRRect.left + innerRRect.blRadiusX, innerRRect.bottom),
          Offset(outerRRect.left + outerRRect.blRadiusX, outerRRect.bottom),
        ),
        math.pi / 2,
        math.pi / 2,
        false,
        paint,
      );
    }
    if (left.width > 0) {
      paint.color = left.color;
      paint.strokeWidth = left.width;
      canvas.drawArc(
        Rect.fromPoints(
          Offset(outerRRect.left, outerRRect.bottom - outerRRect.blRadiusY),
          Offset(innerRRect.left, innerRRect.bottom - innerRRect.blRadiusY),
        ),
        math.pi / 2,
        math.pi / 2,
        false,
        paint,
      );
      canvas.drawLine(
        Offset(innerRRect.left, innerRRect.bottom - innerRRect.blRadiusY),
        Offset(innerRRect.left, innerRRect.top + innerRRect.tlRadiusY),
        paint,
      );
      canvas.drawArc(
        Rect.fromPoints(
          Offset(innerRRect.left, innerRRect.top + innerRRect.tlRadiusY),
          Offset(outerRRect.left, outerRRect.top + outerRRect.tlRadiusY),
        ),
        math.pi,
        math.pi / 2,
        false,
        paint,
      );
    }
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect.deflate(insetWidth)));
  }

  @override
  ShapeBorder scale(double t) {
    return InsetBorder(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t),
      borderRadius: borderRadius * t,
      insetWidth: insetWidth * t,
    );
  }
}
