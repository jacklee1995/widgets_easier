import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Shape of a [WeProgress].
enum WeProgressType {
  /// A horizontal bar. The default.
  line,

  /// A full ring.
  circle,

  /// A ring with a gap at the bottom, like a gauge.
  dashboard,
}

/// A progress indicator with Element Plus' three shapes and status colours,
/// after `el-progress`.
///
/// ```dart
/// WeProgress(percentage: 70)
/// WeProgress(percentage: 100, status: SemanticEnum.success)
/// WeProgress(percentage: 42, type: WeProgressType.circle, width: 96)
/// WeProgress(percentage: 80, type: WeProgressType.dashboard, colorStops: {50: c1, 80: c2, 100: c3})
/// ```
class WeProgress extends StatelessWidget {
  const WeProgress({
    super.key,
    required this.percentage,
    this.type = WeProgressType.line,
    this.status,
    this.color,
    this.colorStops,
    this.strokeWidth,
    this.width = 126,
    this.showText = true,
    this.textInside = false,
    this.striped = false,
    this.format,
    this.indeterminate = false,
  }) : assert(percentage >= 0 && percentage <= 100);

  /// 0–100.
  final double percentage;
  final WeProgressType type;

  /// Colours the bar and, for lines with [showText], swaps the text for an
  /// icon. `success` also happens automatically at 100 % when unset.
  final SemanticEnum? status;

  /// Fixed colour, wins over [status].
  final Color? color;

  /// Colour by threshold: the colour of the first key ≥ [percentage] is used.
  final Map<double, Color>? colorStops;

  /// Bar thickness; defaults to 6 for lines and `width / 16` for rings.
  final double? strokeWidth;

  /// Ring diameter for circle and dashboard.
  final double width;
  final bool showText;

  /// Draw the text inside the bar (lines only).
  final bool textInside;

  /// Diagonal stripes on the filled part (lines only).
  final bool striped;

  /// Custom text, e.g. `(p) => '$p 天'`.
  final String Function(double percentage)? format;

  /// Loop an animation instead of showing a value (lines only).
  final bool indeterminate;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final SemanticEnum? effective =
        status ?? (percentage >= 100 ? SemanticEnum.success : null);
    Color fill = color ?? colors.semantic(effective ?? SemanticEnum.primary);
    if (colorStops != null && color == null) {
      final keys = colorStops!.keys.toList()..sort();
      for (final k in keys) {
        if (percentage <= k) {
          fill = colorStops![k]!;
          break;
        }
      }
    }
    final String text = format?.call(percentage) ?? '${percentage.round()}%';

    Widget? textWidget;
    if (showText) {
      final IconData? icon = switch (effective) {
        SemanticEnum.success => Icons.check_circle_rounded,
        SemanticEnum.warning => Icons.warning_rounded,
        SemanticEnum.danger || SemanticEnum.fatal => Icons.cancel_rounded,
        _ => null,
      };
      textWidget = icon != null && type == WeProgressType.line && !textInside
          ? Icon(icon, size: 16, color: fill)
          : Text(
              text,
              style: TextStyle(
                fontSize: type == WeProgressType.line ? 13 : width / 6.5,
                fontWeight: type == WeProgressType.line
                    ? FontWeight.w500
                    : FontWeight.w600,
                color: colors.regularText,
              ),
            );
    }

    if (type == WeProgressType.line) {
      final double h = strokeWidth ?? (textInside ? 18 : 6);
      final Widget bar = ClipRRect(
        borderRadius: BorderRadius.circular(h / 2),
        child: SizedBox(
          height: h,
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: colors.baseFill)),
              if (indeterminate)
                _Indeterminate(color: fill, radius: h / 2)
              else
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage / 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(h / 2),
                    ),
                    child: striped
                        ? CustomPaint(painter: _StripePainter())
                        : null,
                  ),
                ),
              if (textInside && showText && !indeterminate)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: h * 0.6,
                        fontWeight: FontWeight.w600,
                        color: colors.onSemantic,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
      if (!showText || textInside) return bar;
      return Row(
        children: [
          Expanded(child: bar),
          const SizedBox(width: 8),
          SizedBox(width: 40, child: textWidget),
        ],
      );
    }

    final double stroke = strokeWidth ?? width / 16;
    return SizedBox(
      width: width,
      height: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(end: percentage / 100),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (_, v, _) => CustomPaint(
              size: Size.square(width),
              painter: _RingPainter(
                value: v,
                color: fill,
                track: colors.baseFill,
                stroke: stroke,
                dashboard: type == WeProgressType.dashboard,
              ),
            ),
          ),
          if (showText)
            Padding(
              padding: EdgeInsets.only(
                top: type == WeProgressType.dashboard ? width * 0.05 : 0,
              ),
              child: textWidget,
            ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.color,
    required this.track,
    required this.stroke,
    required this.dashboard,
  });

  final double value;
  final Color color;
  final Color track;
  final double stroke;
  final bool dashboard;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = rect.deflate(stroke / 2);
    final double start = dashboard ? math.pi * 0.75 : -math.pi / 2;
    final double sweepTotal = dashboard ? math.pi * 1.5 : math.pi * 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(r, start, sweepTotal, false, paint..color = track);
    if (value > 0) {
      canvas.drawArc(r, start, sweepTotal * value, false, paint..color = color);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value ||
      old.color != color ||
      old.track != track ||
      old.stroke != stroke ||
      old.dashboard != dashboard;
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x33FFFFFF);
    const double w = 8;
    for (double x = -size.height; x < size.width + size.height; x += w * 2) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + size.height, 0)
        ..lineTo(x + size.height + w, 0)
        ..lineTo(x + w, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => false;
}

class _Indeterminate extends StatefulWidget {
  const _Indeterminate({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  State<_Indeterminate> createState() => _IndeterminateState();
}

class _IndeterminateState extends State<_Indeterminate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => Align(
        alignment: Alignment(-1.6 + 3.2 * _c.value, 0),
        child: FractionallySizedBox(
          widthFactor: 0.3,
          heightFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
        ),
      ),
    );
  }
}
