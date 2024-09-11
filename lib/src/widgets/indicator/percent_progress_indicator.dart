import 'package:flutter/material.dart';

import '../../color/utils.dart';
import '../../enums/semantic_enum.dart';
import '../../enums/size_enum.dart';

const _kIndeterminateLinearDuration = 300;

class PercentIndicator extends StatefulWidget {
  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final SemanticEnum type;
  final SizeEnum size;
  final bool isReversed;
  final double startRadius;
  final double endRadius;
  final String? valueIndicator;
  final Color valueIndicatorColor;
  final bool showBaseLine; // 控制是否显示底座
  final Color baseColor; // 底座颜色

  const PercentIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.height = 15.0,
    this.borderRadius = BorderRadius.zero,
    this.type = SemanticEnum.primary,
    this.size = SizeEnum.defaultSize,
    this.isReversed = false,
    this.startRadius = 5.0,
    this.endRadius = 15.0,
    this.valueIndicator,
    this.valueIndicatorColor = Colors.white,
    this.showBaseLine = true, // 默认显示底座
    this.baseColor = const Color(0xFFE0E0E0), // 默认浅灰色
  });

  @override
  State<PercentIndicator> createState() => _PercentIndicatorState();
}

class _PercentIndicatorState extends State<PercentIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(PercentIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final Color effectiveBackgroundColor =
        widget.backgroundColor ?? findStatusColor(widget.type);
    final double effectiveHeight = widget.height;

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: _PercentIndicatorPainter(
            backgroundColor: effectiveBackgroundColor,
            valueColor: widget.color ?? Theme.of(context).colorScheme.primary,
            value: widget.value,
            animationValue: _controller.value,
            textDirection: textDirection,
            indicatorBorderRadius: widget.borderRadius,
            isReversed: widget.isReversed,
            startRadius: widget.startRadius,
            endRadius: widget.endRadius,
            valueIndicator: widget.valueIndicator,
            valueIndicatorColor: widget.valueIndicatorColor,
            showBaseLine: widget.showBaseLine,
            baseColor: widget.baseColor,
          ),
          child: SizedBox(
            width: double.infinity,
            height: effectiveHeight,
          ),
        );
      },
    );
  }
}

class _PercentIndicatorPainter extends CustomPainter {
  final Color backgroundColor;
  final Color valueColor;
  final double? value;
  final double animationValue;
  final TextDirection textDirection;
  final BorderRadiusGeometry indicatorBorderRadius;
  final bool isReversed;
  final double startRadius;
  final double endRadius;
  final String? valueIndicator;
  final Color valueIndicatorColor;
  final bool showBaseLine;
  final Color baseColor;

  const _PercentIndicatorPainter({
    required this.backgroundColor,
    required this.valueColor,
    this.value,
    required this.animationValue,
    required this.textDirection,
    required this.indicatorBorderRadius,
    required this.isReversed,
    required this.startRadius,
    required this.endRadius,
    this.valueIndicator,
    this.valueIndicatorColor = Colors.white,
    required this.showBaseLine,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showBaseLine) {
      // 绘制底座
      final Paint basePaint = Paint()
        ..color = baseColor
        ..style = PaintingStyle.fill;

      final RRect baseRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: Radius.circular(startRadius),
        topRight: Radius.circular(endRadius),
        bottomLeft: Radius.circular(startRadius),
        bottomRight: Radius.circular(endRadius),
      );

      canvas.drawRRect(baseRect, basePaint);
    }

    // 绘制进度
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    double width = (value ?? animationValue) * size.width;
    if (isReversed) {
      width = size.width - width;
    }

    final Rect rect = isReversed
        ? Offset(size.width - width, 0) & Size(width, size.height)
        : Offset.zero & Size(width, size.height);

    final RRect rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: isReversed
          ? Radius.circular(endRadius)
          : Radius.circular(startRadius),
      topRight: isReversed
          ? Radius.circular(startRadius)
          : Radius.circular(endRadius),
      bottomLeft: isReversed
          ? Radius.circular(endRadius)
          : Radius.circular(startRadius),
      bottomRight: isReversed
          ? Radius.circular(startRadius)
          : Radius.circular(endRadius),
    );

    canvas.drawRRect(rrect, paint);

    // 绘制标题
    if (valueIndicator != null && value != null) {
      final String displayTitle =
          valueIndicator!.replaceAll('@P', (value! * 100).toStringAsFixed(0));
      final TextSpan span = TextSpan(
          style: TextStyle(color: valueIndicatorColor, fontSize: 12),
          text: displayTitle);
      final TextPainter tp = TextPainter(
          text: span,
          textDirection: textDirection,
          textAlign: TextAlign.center);
      tp.layout();
      final Offset textPosition =
          Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2);
      tp.paint(canvas, textPosition);
    }
  }

  @override
  bool shouldRepaint(_PercentIndicatorPainter oldPainter) {
    return oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.animationValue != animationValue ||
        oldPainter.textDirection != textDirection ||
        oldPainter.indicatorBorderRadius != indicatorBorderRadius ||
        oldPainter.isReversed != isReversed ||
        oldPainter.startRadius != startRadius ||
        oldPainter.endRadius != endRadius ||
        oldPainter.valueIndicator != valueIndicator ||
        oldPainter.valueIndicatorColor != valueIndicatorColor ||
        oldPainter.showBaseLine != showBaseLine ||
        oldPainter.baseColor != baseColor;
  }
}
