import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HeartBorder extends ShapeBorder {
  final double size;
  final double strokeWidth;
  final Color strokeColor;

  HeartBorder({
    required this.size,
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.black,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(strokeWidth);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final double width = rect.width;
    final double height = rect.height;
    final double centerX = rect.center.dx;
    final double centerY = rect.center.dy;
    final double scale = size / 883.15;

    path.moveTo(centerX + 510.68 * scale, centerY + 883.15 * scale);
    path.cubicTo(
      centerX + 495.48 * scale,
      centerY + 883.15 * scale,
      centerX + 480.31 * scale,
      centerY + 874.66 * scale,
      centerX + 462.58 * scale,
      centerY + 857.68 * scale,
    );
    path.cubicTo(
      centerX + 437.23 * scale,
      centerY + 833.38 * scale,
      centerX + 411.77 * scale,
      centerY + 809.20 * scale,
      centerX + 386.31 * scale,
      centerY + 785.04 * scale,
    );
    path.cubicTo(
      centerX + 324.71 * scale,
      centerY + 726.55 * scale,
      centerX + 261.03 * scale,
      centerY + 666.08 * scale,
      centerX + 199.93 * scale,
      centerY + 604.79 * scale,
    );
    path.cubicTo(
      centerX + 131.54 * scale,
      centerY + 536.19 * scale,
      centerX + 100.67 * scale,
      centerY + 463.56 * scale,
      centerX + 105.54 * scale,
      centerY + 382.72 * scale,
    );
    path.cubicTo(
      centerX + 109.63 * scale,
      centerY + 314.93 * scale,
      centerX + 136.62 * scale,
      centerY + 260.07 * scale,
      centerX + 183.60 * scale,
      centerY + 224.06 * scale,
    );
    path.cubicTo(
      centerX + 234.22 * scale,
      centerY + 185.27 * scale,
      centerX + 306.90 * scale,
      centerY + 170.83 * scale,
      centerX + 378.06 * scale,
      centerY + 185.46 * scale,
    );
    path.cubicTo(
      centerX + 429.77 * scale,
      centerY + 196.09 * scale,
      centerX + 468.06 * scale,
      centerY + 226.64 * scale,
      centerX + 505.09 * scale,
      centerY + 256.18 * scale,
    );
    path.lineTo(centerX + 506.63 * scale, centerY + 257.41 * scale);
    path.cubicTo(
      centerX + 507.10 * scale,
      centerY + 257.79 * scale,
      centerX + 507.57 * scale,
      centerY + 258.17 * scale,
      centerX + 508.04 * scale,
      centerY + 258.54 * scale,
    );
    path.cubicTo(
      centerX + 516.09 * scale,
      centerY + 253.49 * scale,
      centerX + 523.98 * scale,
      centerY + 248.39 * scale,
      centerX + 531.72 * scale,
      centerY + 243.41 * scale,
    );
    path.cubicTo(
      centerX + 561.73 * scale,
      centerY + 224.06 * scale,
      centerX + 590.06 * scale,
      centerY + 205.78 * scale,
      centerX + 622.10 * scale,
      centerY + 192.87 * scale,
    );
    path.cubicTo(
      centerX + 706.36 * scale,
      centerY + 158.97 * scale,
      centerX + 811.44 * scale,
      centerY + 184.76 * scale,
      centerX + 866.61 * scale,
      centerY + 252.94 * scale,
    );
    path.cubicTo(
      centerX + 924.69 * scale,
      centerY + 324.73 * scale,
      centerX + 934.84 * scale,
      centerY + 410.39 * scale,
      centerX + 895.18 * scale,
      centerY + 494.16 * scale,
    );
    path.cubicTo(
      centerX + 875.18 * scale,
      centerY + 536.38 * scale,
      centerX + 844.51 * scale,
      centerY + 578.84 * scale,
      centerX + 804.02 * scale,
      centerY + 620.38 * scale,
    );
    path.cubicTo(
      centerX + 746.11 * scale,
      centerY + 679.79 * scale,
      centerX + 685.08 * scale,
      centerY + 737.70 * scale,
      centerX + 626.06 * scale,
      centerY + 793.71 * scale,
    );
    path.cubicTo(
      centerX + 603.76 * scale,
      centerY + 814.87 * scale,
      centerX + 581.47 * scale,
      centerY + 836.03 * scale,
      centerX + 559.29 * scale,
      centerY + 857.30 * scale,
    );
    path.cubicTo(
      centerX + 541.31 * scale,
      centerY + 874.52 * scale,
      centerX + 525.98 * scale,
      centerY + 883.15 * scale,
      centerX + 510.68 * scale,
      centerY + 883.15 * scale,
    );
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = strokeColor;

    canvas.drawPath(getOuterPath(rect), paint);
  }

  @override
  ShapeBorder scale(double t) {
    return HeartBorder(
      size: size * t,
      strokeWidth: strokeWidth * t,
      strokeColor: strokeColor,
    );
  }
}
