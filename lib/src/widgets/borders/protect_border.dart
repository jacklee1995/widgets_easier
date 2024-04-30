import 'dart:ui';

import 'package:flutter/material.dart';

class ProtectBorder extends ShapeBorder {
  final double strokeWidth;
  final Color strokeColor;
  final Gradient? gradient;

  const ProtectBorder({
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.black,
    this.gradient,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(strokeWidth);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final double width = rect.width;
    final double height = rect.height;
    final double centerX = rect.center.dx;
    final double centerY = rect.center.dy;
    final double scaleX = width / 1024.0;
    final double scaleY = height / 1024.0;

    path.moveTo(centerX + 958.18 * scaleX, centerY + 514.73 * scaleY);

    path.cubicTo(
      centerX + 958.21 * scaleX,
      centerY + 515.45 * scaleY,
      centerX + 958.22 * scaleX,
      centerY + 516.19 * scaleY,
      centerX + 958.19 * scaleX,
      centerY + 516.93 * scaleY,
    );
    path.cubicTo(
      centerX + 956.09 * scaleX,
      centerY + 570.12 * scaleY,
      centerX + 946.97 * scaleX,
      centerY + 616.96 * scaleY,
      centerX + 930.68 * scaleX,
      centerY + 657.37 * scaleY,
    );
    path.cubicTo(
      centerX + 929.72 * scaleX,
      centerY + 659.74 * scaleY,
      centerX + 924.96 * scaleX,
      centerY + 671.88 * scaleY,
      centerX + 923.47 * scaleX,
      centerY + 675.59 * scaleY,
    );
    path.cubicTo(
      centerX + 920.02 * scaleX,
      centerY + 684.19 * scaleY,
      centerX + 916.78 * scaleX,
      centerY + 691.86 * scaleY,
      centerX + 913.18 * scaleX,
      centerY + 699.77 * scaleY,
    );
    path.cubicTo(
      centerX + 903.70 * scaleX,
      centerY + 720.64 * scaleY,
      centerX + 892.79 * scaleX,
      centerY + 740.79 * scaleY,
      centerX + 879.33 * scaleX,
      centerY + 761.32 * scaleY,
    );
    path.cubicTo(
      centerX + 844.29 * scaleX,
      centerY + 814.81 * scaleY,
      centerX + 795.47 * scaleX,
      centerY + 865.37 * scaleY,
      centerX + 728.47 * scaleX,
      centerY + 912.62 * scaleY,
    );
    path.cubicTo(
      centerX + 670.73 * scaleX,
      centerY + 953.35 * scaleY,
      centerX + 601.01 * scaleX,
      centerY + 990.39 * scaleY,
      centerX + 517.95 * scaleX,
      centerY + 1023.18 * scaleY,
    );
    path.cubicTo(
      centerX + 515.16 * scaleX,
      centerY + 1024.29 * scaleY,
      centerX + 512.19 * scaleX,
      centerY + 1024.86 * scaleY,
      centerX + 509.19 * scaleX,
      centerY + 1024.87 * scaleY,
    );
    path.cubicTo(
      centerX + 506.13 * scaleX,
      centerY + 1024.88 * scaleY,
      centerX + 503.09 * scaleX,
      centerY + 1024.31 * scaleY,
      centerX + 500.25 * scaleX,
      centerY + 1023.18 * scaleY,
    );
    path.cubicTo(
      centerX + 417.19 * scaleX,
      centerY + 990.39 * scaleY,
      centerX + 347.46 * scaleX,
      centerY + 953.35 * scaleY,
      centerX + 289.72 * scaleX,
      centerY + 912.62 * scaleY,
    );
    path.cubicTo(
      centerX + 222.73 * scaleX,
      centerY + 865.37 * scaleY,
      centerX + 173.91 * scaleX,
      centerY + 814.81 * scaleY,
      centerX + 138.86 * scaleX,
      centerY + 761.33 * scaleY,
    );
    path.cubicTo(
      centerX + 125.41 * scaleX,
      centerY + 740.79 * scaleY,
      centerX + 114.50 * scaleX,
      centerY + 720.64 * scaleY,
      centerX + 105.01 * scaleX,
      centerY + 699.77 * scaleY,
    );
    path.cubicTo(
      centerX + 101.42 * scaleX,
      centerY + 691.86 * scaleY,
      centerX + 98.18 * scaleX,
      centerY + 684.19 * scaleY,
      centerX + 94.73 * scaleX,
      centerY + 675.59 * scaleY,
    );
    path.cubicTo(
      centerX + 93.24 * scaleX,
      centerY + 671.88 * scaleY,
      centerX + 88.47 * scaleX,
      centerY + 659.74 * scaleY,
      centerX + 87.52 * scaleX,
      centerY + 657.37 * scaleY,
    );
    path.cubicTo(
      centerX + 71.27 * scaleX,
      centerY + 617.07 * scaleY,
      centerX + 62.15 * scaleX,
      centerY + 570.39 * scaleY,
      centerX + 60.02 * scaleX,
      centerY + 517.38 * scaleY,
    );
    path.cubicTo(
      centerX + 59.62 * scaleX,
      centerY + 515.61 * scaleY,
      centerX + 59.41 * scaleX,
      centerY + 513.80 * scaleY,
      centerX + 59.42 * scaleX,
      centerY + 511.98 * scaleY,
    );
    path.lineTo(centerX + 59.42 * scaleX, centerY + 111.98 * scaleY);
    path.cubicTo(
      centerX + 59.42 * scaleX,
      centerY + 108.96 * scaleY,
      centerX + 59.97 * scaleX,
      centerY + 106.08 * scaleY,
      centerX + 60.99 * scaleX,
      centerY + 103.41 * scaleY,
    );
    path.cubicTo(
      centerX + 62.81 * scaleX,
      centerY + 94.03 * scaleY,
      centerX + 70.18 * scaleX,
      centerY + 86.25 * scaleY,
      centerX + 80.15 * scaleX,
      centerY + 84.39 * scaleY,
    );
    path.lineTo(centerX + 485.43 * scaleX, centerY + 8.72 * scaleY);
    path.cubicTo(
      centerX + 501.09 * scaleX,
      centerY + 5.79 * scaleY,
      centerX + 517.17 * scaleX,
      centerY + 5.79 * scaleY,
      centerX + 532.83 * scaleX,
      centerY + 8.72 * scaleY,
    );
    path.lineTo(centerX + 938.11 * scaleX, centerY + 84.39 * scaleY);
    path.cubicTo(
      centerX + 949.43 * scaleX,
      centerY + 86.51 * scaleY,
      centerX + 957.40 * scaleX,
      centerY + 96.24 * scaleY,
      centerX + 957.70 * scaleX,
      centerY + 107.30 * scaleY,
    );
    path.cubicTo(
      centerX + 958.07 * scaleX,
      centerY + 109.00 * scaleY,
      centerX + 958.27 * scaleX,
      centerY + 110.75 * scaleY,
      centerX + 958.27 * scaleX,
      centerY + 112.56 * scaleY,
    );
    path.lineTo(centerX + 958.27 * scaleX, centerY + 512.56 * scaleY);
    path.cubicTo(
      centerX + 958.27 * scaleX,
      centerY + 513.29 * scaleY,
      centerX + 958.24 * scaleX,
      centerY + 514.01 * scaleY,
      centerX + 958.18 * scaleX,
      centerY + 514.73 * scaleY,
    );
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (gradient != null) {
      final Rect gradientRect = rect.deflate(strokeWidth / 2);
      paint.shader = gradient!.createShader(gradientRect);
    } else {
      paint.color = strokeColor;
    }

    canvas.drawPath(getOuterPath(rect), paint);
  }

  @override
  ShapeBorder scale(double t) {
    return ProtectBorder(
      strokeWidth: strokeWidth * t,
      strokeColor: strokeColor,
      gradient: gradient,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is ProtectBorder) {
      return ProtectBorder(
        strokeWidth: lerpDouble(a.strokeWidth, strokeWidth, t)!,
        strokeColor: Color.lerp(a.strokeColor, strokeColor, t)!,
        gradient: Gradient.lerp(a.gradient, gradient, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is ProtectBorder) {
      return ProtectBorder(
        strokeWidth: lerpDouble(strokeWidth, b.strokeWidth, t)!,
        strokeColor: Color.lerp(strokeColor, b.strokeColor, t)!,
        gradient: Gradient.lerp(gradient, b.gradient, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ProtectBorder &&
        other.strokeWidth == strokeWidth &&
        other.strokeColor == strokeColor &&
        other.gradient == gradient;
  }

  @override
  int get hashCode => hashValues(strokeWidth, strokeColor, gradient);

  @override
  String toString() {
    return 'ProtectBorder(strokeWidth: $strokeWidth, strokeColor: $strokeColor, gradient: $gradient)';
  }
}
