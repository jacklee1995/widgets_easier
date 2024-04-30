import 'package:flutter/material.dart';

abstract class AbstractBorder extends ShapeBorder {
  final BorderSide top;
  final BorderSide right;
  final BorderSide bottom;
  final BorderSide left;
  final BorderRadius borderRadius;

  const AbstractBorder({
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
    required this.borderRadius,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(
        top: top.width,
        right: right.width,
        bottom: bottom.width,
        left: left.width,
      );

  @override
  ShapeBorder scale(double t);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection});

  void paintBorder(Canvas canvas, Rect rect, {TextDirection? textDirection});
}
