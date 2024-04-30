import 'dart:ui';

import 'package:flutter/material.dart';

import '../../color/utils.dart';
import '../../enums/semantic_enum.dart';
import '/src/enums/size_enum.dart';

class SemanticButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final SemanticEnum type;
  final bool isOutlined;
  final double? height;
  final double radius;
  final double fontSize;
  final FontWeight? fontWeight;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final SizeEnum size;
  final bool shrink;
  final OutlineStyle outlineStyle; // 使用自定义的轮廓线型枚举
  final double outlineWidth; // 新增属性：轮廓粗细

  const SemanticButton({
    super.key,
    required this.text,
    this.onTap,
    this.type = SemanticEnum.primary,
    this.isOutlined = false,
    this.height,
    this.radius = 4,
    this.fontSize = 18,
    this.fontWeight,
    this.prefixIcon,
    this.suffixIcon,
    this.size = SizeEnum.defaultSize,
    this.shrink = false,
    this.outlineStyle = OutlineStyle.solid, // 默认为实线轮廓
    this.outlineWidth = 1.0, // 默认轮廓粗细为1.0
  });

  @override
  State<SemanticButton> createState() => _SemanticButtonState();
}

class _SemanticButtonState extends State<SemanticButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  double _elevation = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Color bgColor = findStatusColor(widget.type);
    Color hoverColor = bgColor.withOpacity(0.6);
    Color pressedColor = bgColor.withOpacity(0.8); // 新增按下时的背景颜色

    final double effectiveHeight =
        widget.height ?? _getHeightForSize(widget.size);

    Widget buttonContent = Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: widget.onTap != null
            ? (_isPressed
                ? pressedColor
                : (_isHovered ? hoverColor : bgColor.withOpacity(0.1)))
            : bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: widget.onTap != null
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: _isPressed
                      ? const Offset(0, 1)
                      : const Offset(0, 2), // 按下时降低阴影高度
                ),
              ]
            : [],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.prefixIcon != null) ...[
            widget.prefixIcon!,
            const SizedBox(width: 8),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: _getFontSizeForSize(widget.size),
                fontWeight: widget.fontWeight ?? FontWeight.w600,
                color: widget.isOutlined && (_isHovered || _isPressed)
                    ? Colors.white
                    : (widget.isOutlined ? bgColor : Colors.white),
              ),
            ),
          ),
          if (widget.suffixIcon != null) ...[
            const SizedBox(width: 8),
            widget.suffixIcon!,
          ],
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) {
        if (widget.onTap != null) {
          setState(() {
            _isHovered = true;
            _elevation = 6;
          });
        }
      },
      onExit: (_) {
        if (widget.onTap != null) {
          setState(() {
            _isHovered = false;
            _elevation = 0;
          });
        }
      },
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.onTap != null) {
            setState(() {
              _isPressed = true;
            });
          }
        },
        onTapUp: (_) {
          if (widget.onTap != null) {
            setState(() {
              _isPressed = false;
            });
          }
        },
        onTapCancel: () {
          if (widget.onTap != null) {
            setState(() {
              _isPressed = false;
            });
          }
        },
        onTap: widget.onTap,
        child: CustomPaint(
          painter: OutlinePainter(
            style: widget.outlineStyle,
            color: bgColor,
            width: widget.outlineWidth,
            radius: widget.radius,
          ),
          child: Material(
            color: widget.isOutlined
                ? theme.buttonTheme.colorScheme?.background
                : bgColor,
            borderRadius: BorderRadius.circular(widget.radius),
            elevation: widget.onTap != null ? _elevation : 0,
            child: widget.shrink
                ? IntrinsicWidth(child: buttonContent)
                : buttonContent,
          ),
        ),
      ),
    );
  }

  double _getHeightForSize(SizeEnum size) {
    switch (size) {
      case SizeEnum.small:
        return 20;
      case SizeEnum.large:
        return 40;
      default:
        return 30;
    }
  }

  double _getFontSizeForSize(SizeEnum size) {
    switch (size) {
      case SizeEnum.small:
        return 13;
      case SizeEnum.large:
        return 19;
      default:
        return 16;
    }
  }
}

// 自定义的轮廓线型枚举
enum OutlineStyle {
  none,
  solid,
  dashed,
  dotted,
}

class OutlinePainter extends CustomPainter {
  final OutlineStyle style;
  final Color color;
  final double width;
  final double radius;

  OutlinePainter({
    required this.style,
    required this.color,
    required this.width,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (style == OutlineStyle.none) return;

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    switch (style) {
      case OutlineStyle.solid:
        canvas.drawRRect(rrect, paint);
        break;
      case OutlineStyle.dashed:
        _drawDashedLine(canvas, rrect, paint);
        break;
      case OutlineStyle.dotted:
        _drawDottedLine(canvas, rrect, paint);
        break;
      default:
        break;
    }
  }

  void _drawDashedLine(Canvas canvas, RRect rrect, Paint paint) {
    const double dashWidth = 5.0;
    const double dashSpace = 5.0;
    final Path path = Path()..addRRect(rrect);
    final PathMetric pathMetric = path.computeMetrics().first;
    double distance = 0.0;
    while (distance < pathMetric.length) {
      canvas.drawPath(
        pathMetric.extractPath(distance, distance + dashWidth),
        paint,
      );
      distance += dashWidth + dashSpace;
    }
  }

  void _drawDottedLine(Canvas canvas, RRect rrect, Paint paint) {
    const double dotWidth = 1.0;
    const double dotSpace = 4.0;
    final Path path = Path()..addRRect(rrect);
    final PathMetric pathMetric = path.computeMetrics().first;
    double distance = 0.0;
    while (distance < pathMetric.length) {
      canvas.drawPath(
        pathMetric.extractPath(distance, distance + dotWidth),
        paint,
      );
      distance += dotWidth + dotSpace;
    }
  }

  @override
  bool shouldRepaint(OutlinePainter oldDelegate) {
    return style != oldDelegate.style ||
        color != oldDelegate.color ||
        width != oldDelegate.width ||
        radius != oldDelegate.radius;
  }
}
