import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'abstract_border.dart';

class OutsetBorder extends AbstractBorder {
  const OutsetBorder({
    super.top = const BorderSide(),
    super.right = const BorderSide(),
    super.bottom = const BorderSide(),
    super.left = const BorderSide(),
    super.borderRadius = BorderRadius.zero,
    required this.outsetWidth,
  });

  final double outsetWidth;

  @override
  void paintBorder(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint();
    paint.style = PaintingStyle.stroke;

    final RRect outerRRect = borderRadius.toRRect(rect);
    final RRect innerRRect = borderRadius.toRRect(rect.deflate(outsetWidth));

    if (top.width > 0) {
      paint.color = top.color;
      paint.strokeWidth = top.width;
      canvas.drawArc(
        Rect.fromPoints(
          Offset(outerRRect.left - outsetWidth, outerRRect.top - outsetWidth),
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
          Offset(outerRRect.right + outsetWidth, outerRRect.top - outsetWidth),
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
          Offset(outerRRect.right + outsetWidth, outerRRect.top - outsetWidth),
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
          Offset(
              outerRRect.right + outsetWidth, outerRRect.bottom + outsetWidth),
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
          Offset(
              outerRRect.right + outsetWidth, outerRRect.bottom + outsetWidth),
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
          Offset(
              outerRRect.left - outsetWidth, outerRRect.bottom + outsetWidth),
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
          Offset(
              outerRRect.left - outsetWidth, outerRRect.bottom + outsetWidth),
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
          Offset(outerRRect.left - outsetWidth, outerRRect.top - outsetWidth),
        ),
        math.pi,
        math.pi / 2,
        false,
        paint,
      );
    }
  }

  @override
  ShapeBorder scale(double t) {
    return OutsetBorder(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t),
      borderRadius: borderRadius * t,
      outsetWidth: outsetWidth * t,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final RRect outer = borderRadius.toRRect(rect).inflate(outsetWidth);
    return Path()..addRRect(outer);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final RRect inner = borderRadius.toRRect(rect).deflate(outsetWidth);
    return Path()..addRRect(inner);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    paintBorder(canvas, rect, textDirection: textDirection);
  }
}
