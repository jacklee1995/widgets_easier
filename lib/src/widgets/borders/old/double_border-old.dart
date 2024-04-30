import 'package:flutter/material.dart';
import 'abstract_border.dart';

class DoubleBorder extends AbstractBorder {
  const DoubleBorder({
    super.top = const BorderSide(),
    super.right = const BorderSide(),
    super.bottom = const BorderSide(),
    super.left = const BorderSide(),
    super.borderRadius = BorderRadius.zero,
    this.innerBorderWidth = 1,
    this.gap = 2,
  });

  final double innerBorderWidth;
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
        borderRadius.toRRect(rect.deflate(top.width + gap));

    if (top.width > 0) {
      paint.color = top.color;
      paint.strokeWidth = top.width;
      canvas.drawLine(
        Offset(outerRRect.left + outerRRect.tlRadiusX, outerRRect.top),
        Offset(outerRRect.right - outerRRect.trRadiusX, outerRRect.top),
        paint,
      );
      paint.strokeWidth = innerBorderWidth;
      canvas.drawLine(
        Offset(innerRRect.left + innerRRect.tlRadiusX, innerRRect.top),
        Offset(innerRRect.right - innerRRect.trRadiusX, innerRRect.top),
        paint,
      );
    }
    if (right.width > 0) {
      paint.color = right.color;
      paint.strokeWidth = right.width;
      canvas.drawLine(
        Offset(outerRRect.right, outerRRect.top + outerRRect.trRadiusY),
        Offset(outerRRect.right, outerRRect.bottom - outerRRect.brRadiusY),
        paint,
      );
      paint.strokeWidth = innerBorderWidth;
      canvas.drawLine(
        Offset(innerRRect.right, innerRRect.top + innerRRect.trRadiusY),
        Offset(innerRRect.right, innerRRect.bottom - innerRRect.brRadiusY),
        paint,
      );
    }
    if (bottom.width > 0) {
      paint.color = bottom.color;
      paint.strokeWidth = bottom.width;
      canvas.drawLine(
        Offset(outerRRect.right - outerRRect.brRadiusX, outerRRect.bottom),
        Offset(outerRRect.left + outerRRect.blRadiusX, outerRRect.bottom),
        paint,
      );
      paint.strokeWidth = innerBorderWidth;
      canvas.drawLine(
        Offset(innerRRect.right - innerRRect.brRadiusX, innerRRect.bottom),
        Offset(innerRRect.left + innerRRect.blRadiusX, innerRRect.bottom),
        paint,
      );
    }
    if (left.width > 0) {
      paint.color = left.color;
      paint.strokeWidth = left.width;
      canvas.drawLine(
        Offset(outerRRect.left, outerRRect.bottom - outerRRect.blRadiusY),
        Offset(outerRRect.left, outerRRect.top + outerRRect.tlRadiusY),
        paint,
      );
      paint.strokeWidth = innerBorderWidth;
      canvas.drawLine(
        Offset(innerRRect.left, innerRRect.bottom - innerRRect.blRadiusY),
        Offset(innerRRect.left, innerRRect.top + innerRRect.tlRadiusY),
        paint,
      );
    }
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  ShapeBorder scale(double t) {
    return DoubleBorder(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t),
      borderRadius: borderRadius * t,
      innerBorderWidth: innerBorderWidth * t,
      gap: gap * t,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius.toRRect(rect).deflate(top.width + gap));
  }
}
