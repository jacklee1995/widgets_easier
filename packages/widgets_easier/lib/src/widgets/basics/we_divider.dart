import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Where the caption of a horizontal [WeDivider] sits.
enum WeDividerAlign { start, center, end }

/// A separator line with an optional caption, after `el-divider`.
///
/// ```dart
/// WeDivider()
/// WeDivider(text: 'Shipping')
/// WeDivider(text: 'More', align: WeDividerAlign.start, dashed: true)
/// WeDivider.vertical()   // for use inside a Row
/// ```
class WeDivider extends StatelessWidget {
  const WeDivider({
    super.key,
    this.text,
    this.child,
    this.align = WeDividerAlign.center,
    this.dashed = false,
    this.color,
    this.thickness = 1,
    this.margin = const EdgeInsets.symmetric(vertical: 16),
  }) : vertical = false;

  /// A vertical rule for separating items in a row.
  const WeDivider.vertical({
    super.key,
    this.color,
    this.thickness = 1,
    this.margin = const EdgeInsets.symmetric(horizontal: 8),
  }) : text = null,
       child = null,
       align = WeDividerAlign.center,
       dashed = false,
       vertical = true;

  final String? text;

  /// Custom caption; takes precedence over [text].
  final Widget? child;
  final WeDividerAlign align;
  final bool dashed;
  final Color? color;
  final double thickness;
  final EdgeInsetsGeometry margin;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Color c = color ?? colors.lightBorder;

    if (vertical) {
      return Padding(
        padding: margin,
        child: SizedBox(
          width: thickness,
          height: double.infinity,
          child: ColoredBox(color: c),
        ),
      );
    }

    final Widget line = CustomPaint(
      painter: _LinePainter(color: c, thickness: thickness, dashed: dashed),
      child: SizedBox(height: thickness),
    );

    final Widget? caption =
        child ??
        (text == null
            ? null
            : Text(
                text!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: colors.primaryText,
                ),
              ));

    if (caption == null) return Padding(padding: margin, child: line);

    final int leftFlex = switch (align) {
      WeDividerAlign.start => 1,
      WeDividerAlign.center => 5,
      WeDividerAlign.end => 12,
    };
    final int rightFlex = switch (align) {
      WeDividerAlign.start => 12,
      WeDividerAlign.center => 5,
      WeDividerAlign.end => 1,
    };

    return Padding(
      padding: margin,
      child: Row(
        children: [
          Expanded(flex: leftFlex, child: line),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: caption,
          ),
          Expanded(flex: rightFlex, child: line),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  const _LinePainter({
    required this.color,
    required this.thickness,
    required this.dashed,
  });

  final Color color;
  final double thickness;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;
    final double y = size.height / 2;
    if (!dashed) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      return;
    }
    const double dash = 5, gap = 4;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, y),
        Offset((x + dash).clamp(0, size.width), y),
        paint,
      );
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.color != color || old.thickness != thickness || old.dashed != dashed;
}
