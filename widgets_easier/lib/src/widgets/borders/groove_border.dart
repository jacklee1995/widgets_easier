import 'package:flutter/material.dart';

class GrooveBorder extends ShapeBorder {
  final double width;
  final double depth;
  final Color lightColor;
  final Color darkColor;

  const GrooveBorder({
    this.width = 2.0,
    this.depth = 1.0,
    this.lightColor = const Color(0xFFE0E0E0),
    this.darkColor = const Color(0xFF808080),
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRect(Rect.fromLTWH(
        rect.left + width,
        rect.top + width,
        rect.width - width * 2,
        rect.height - width * 2,
      ));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint darkPaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final Paint lightPaint = Paint()
      ..color = lightColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    // 绘制左侧外边框
    canvas.drawLine(
      rect.topLeft + Offset(0, 0.5 * width),
      rect.bottomLeft + Offset(0, -0.5 * width),
      darkPaint,
    );

    // 绘制上侧外边框
    canvas.drawLine(
      rect.topLeft + Offset(0.5 * width, 0),
      rect.topRight + Offset(-0.5 * width, 0),
      darkPaint,
    );

    // 绘制右侧外边框
    canvas.drawLine(
      rect.topRight + Offset(0, 0.5 * width),
      rect.bottomRight + Offset(0, -0.5 * width),
      lightPaint,
    );

    // 绘制下侧外边框
    canvas.drawLine(
      rect.bottomLeft + Offset(0.5 * width, 0),
      rect.bottomRight + Offset(-0.5 * width, 0),
      lightPaint,
    );

    // 绘制右侧内边框
    canvas.drawLine(
      rect.topRight + Offset(-width, 1.5 * width),
      rect.bottomRight + Offset(-width, -0.5 * width),
      darkPaint,
    );

    // 绘制下侧内边框
    canvas.drawLine(
      rect.bottomLeft + Offset(1.5 * width, -width),
      rect.bottomRight + Offset(-width, -width),
      darkPaint,
    );

    // *****************************************************************************

    // 绘制左上角外端点
    canvas.drawRect(
      Rect.fromLTWH(
          rect.left + 0.5 * width, rect.top + 0.5 * width, -width, -width),
      darkPaint..style = PaintingStyle.fill,
    );

    // 绘制右下角外端点
    canvas.drawRect(
      Rect.fromLTWH(
          rect.right - 0.5 * width, rect.bottom - 0.5 * width, width, width),
      lightPaint..style = PaintingStyle.fill,
    );

    // 绘制左下角外端点
    final Path leftBottomPath = Path()
      ..moveTo(rect.left + 0.5 * width, rect.bottom + 0.5 * width)
      ..lineTo(rect.left - 0.5 * width, rect.bottom + 0.5 * width)
      ..lineTo(rect.left + 0.5 * width, rect.bottom - 0.5 * width)
      ..close();
    canvas.drawPath(leftBottomPath, lightPaint..style = PaintingStyle.fill);

    final Path leftBottomDarkPath = Path()
      ..moveTo(rect.left + 0.5 * width, rect.bottom - 0.5 * width)
      ..lineTo(rect.left - 0.5 * width, rect.bottom + 0.5 * width)
      ..lineTo(rect.left - 0.5 * width, rect.bottom - 0.5 * width)
      ..close();
    canvas.drawPath(leftBottomDarkPath, darkPaint..style = PaintingStyle.fill);

    // 绘制右上角外端点
    final Path rightTopPath = Path()
      ..moveTo(rect.right - 0.5 * width, rect.top - 0.5 * width)
      ..lineTo(rect.right + 0.5 * width, rect.top - 0.5 * width)
      ..lineTo(rect.right - 0.5 * width, rect.top + 0.5 * width)
      ..close();
    canvas.drawPath(rightTopPath, darkPaint..style = PaintingStyle.fill);

    final Path rightTopLightPath = Path()
      ..moveTo(rect.right - 0.5 * width, rect.top + 0.5 * width)
      ..lineTo(rect.right + 0.5 * width, rect.top - 0.5 * width)
      ..lineTo(rect.right + 0.5 * width, rect.top + 0.5 * width)
      ..close();
    canvas.drawPath(rightTopLightPath, lightPaint..style = PaintingStyle.fill);

    // *****************************************************************************

    // 绘制右上角内三角形
    final Path rightInnerTriangle = Path()
      ..moveTo(rect.right - 1.5 * width, rect.top + 1.5 * width)
      ..lineTo(rect.right - 0.5 * width, rect.top + 1.5 * width)
      ..lineTo(rect.right - 0.5 * width, rect.top + 0.5 * width)
      ..close();
    canvas.drawPath(rightInnerTriangle, darkPaint..style = PaintingStyle.fill);

    // 绘制左下角内三角形
    final Path bottomInnerTriangle = Path()
      ..moveTo(rect.left + 1.5 * width, rect.bottom - 0.5 * width)
      ..lineTo(rect.left + 1.5 * width, rect.bottom - 1.5 * width)
      ..lineTo(rect.left + 0.5 * width, rect.bottom - 0.5 * width)
      ..close();
    canvas.drawPath(bottomInnerTriangle, darkPaint..style = PaintingStyle.fill);
  }

  @override
  ShapeBorder scale(double t) {
    return GrooveBorder(
      width: width * t,
      depth: depth,
      lightColor: lightColor,
      darkColor: darkColor,
    );
  }
}
