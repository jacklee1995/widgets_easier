import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../color/utils.dart';
import '../../enums/semantic_enum.dart';
import '/src/enums/size_enum.dart';

/// A button widget that can be styled semantically based on the application's design system.
class SemanticButton extends StatefulWidget {
  /// The text to display on the button.
  final String text;

  /// The callback function that is called when the button is tapped.
  final VoidCallback? onTap;

  /// The semantic type of the button which determines its color and styling.
  final SemanticEnum type;

  /// Whether the button should be outlined instead of filled.
  final bool isOutlined;

  /// The radius of the button's corners.
  final double radius;

  /// Custom border radius for the button. Overrides [radius] if provided.
  final BorderRadiusGeometry? borderRadius;

  /// The font size of the button text.
  final double fontSize;

  /// The font weight of the button text.
  final FontWeight? fontWeight;

  /// An optional widget to display before the button text.
  final Widget? prefixIcon;

  /// An optional widget to display after the button text.
  final Widget? suffixIcon;

  /// The size of the button which affects its padding and font size.
  final SizeEnum size;

  /// The fixed height of the button. If null, the height is determined by the content and size.
  final double? height;

  final double? width;

  /// Whether the button width should shrink to fit its child.
  final bool shrink;

  /// The style of the outline drawn around the button.
  final OutlineStyle outlineStyle;

  /// The width of the outline stroke.
  final double outlineWidth;

  final Color? color;
  final Gradient? gradient;

  /// Constructs a [SemanticButton].
  const SemanticButton({
    super.key,
    required this.text,
    this.onTap,
    this.type = SemanticEnum.primary,
    this.isOutlined = false,
    this.radius = 4,
    this.borderRadius,
    this.fontSize = 18,
    this.fontWeight,
    this.prefixIcon,
    this.suffixIcon,
    this.size = SizeEnum.defaultSize,
    this.height,
    this.width,
    this.shrink = false,
    this.outlineStyle = OutlineStyle.solid,
    this.outlineWidth = 1.0,
    this.gradient,
    this.color,
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
    Color finalBgColor;
    if (widget.gradient != null) {
      finalBgColor = Colors.transparent;
    } else if (widget.color != null) {
      finalBgColor = widget.color!;
    } else {
      finalBgColor = findStatusColor(widget.type);
    }
    Color hoverColor = widget.isOutlined
        ? finalBgColor.withOpacity(0.6)
        : finalBgColor.withOpacity(0.8);
    Color pressedColor = widget.isOutlined
        ? finalBgColor.withOpacity(0.8)
        : finalBgColor.withOpacity(0.6);

    final double effectiveHeight =
        widget.height ?? _getHeightForSize(widget.size);

    Widget buttonContent = Container(
      height: effectiveHeight,
      width: widget.width,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        color: widget.gradient == null
            ? widget.onTap != null
                ? (_isPressed
                    ? pressedColor
                    : (_isHovered
                        ? hoverColor
                        : finalBgColor.withOpacity(
                            0.1,
                          )))
                : finalBgColor.withOpacity(0.1)
            : null,
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(widget.radius),
        boxShadow: widget.onTap != null
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: _isPressed ? const Offset(0, 1) : const Offset(0, 2),
                ),
              ]
            : [],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 5),
          if (widget.prefixIcon != null) ...[
            widget.prefixIcon!,
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
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
                    : (widget.isOutlined ? finalBgColor : Colors.white),
              ),
            ),
          ),
          if (widget.suffixIcon != null) ...[
            widget.suffixIcon!,
          ],
          const SizedBox(width: 5),
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
            color: finalBgColor,
            width: widget.outlineWidth,
            borderRadius:
                widget.borderRadius ?? BorderRadius.circular(widget.radius),
            textDirection: Directionality.of(context),
          ),
          child: Material(
            color: widget.gradient != null
                ? Colors.transparent
                : (widget.isOutlined
                    ? theme.buttonTheme.colorScheme?.background
                    : _isPressed
                        ? finalBgColor.withOpacity(0.5)
                        : finalBgColor),
            borderRadius:
                widget.borderRadius ?? BorderRadius.circular(widget.radius),
            elevation: widget.onTap != null ? _elevation : 0,
            child: widget.shrink
                ? IntrinsicWidth(child: buttonContent)
                : buttonContent,
          ),
        ),
      ),
    );
  }

  /// Calculates the appropriate height for the button based on its size enum.
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

  /// Determines the font size for the button text based on its size enum.
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // 添加按钮文本属性
    properties.add(StringProperty('text', widget.text));
    // 添加按钮点击回调属性
    properties.add(DiagnosticsProperty<VoidCallback>('onTap', widget.onTap));
    // 添加按钮语义类型属性
    properties.add(EnumProperty<SemanticEnum>('type', widget.type));
    // 添加按钮是否为轮廓样式属性
    properties.add(FlagProperty('isOutlined',
        value: widget.isOutlined, ifTrue: 'outlined', ifFalse: 'filled'));
    // 添加按钮高度属性
    properties.add(DoubleProperty('height', widget.height));
    // 添加按钮圆角半径属性
    properties.add(DoubleProperty('radius', widget.radius));
    // 添加按钮自定义边框半径属性
    properties.add(DiagnosticsProperty<BorderRadiusGeometry>(
        'borderRadius', widget.borderRadius));
    // 添加按钮文本字体大小属性
    properties.add(DoubleProperty('fontSize', widget.fontSize));
    // 添加按钮文本字重属性
    properties
        .add(DiagnosticsProperty<FontWeight>('fontWeight', widget.fontWeight));
    // 添加按钮前缀图标属性
    properties
        .add(DiagnosticsProperty<Widget>('prefixIcon', widget.prefixIcon));
    // 添加按钮后缀图标属性
    properties
        .add(DiagnosticsProperty<Widget>('suffixIcon', widget.suffixIcon));
    // 添加按钮尺寸属性
    properties.add(EnumProperty<SizeEnum>('size', widget.size));
    // 添加按钮是否收缩属性
    properties.add(FlagProperty('shrink',
        value: widget.shrink, ifTrue: 'shrink-to-fit', ifFalse: 'fixed-width'));
    // 添加按钮轮廓样式属性
    properties
        .add(EnumProperty<OutlineStyle>('outlineStyle', widget.outlineStyle));
    // 添加按钮轮廓宽度属性
    properties.add(DoubleProperty('outlineWidth', widget.outlineWidth));
    // 添加按钮背景颜色属性
    properties.add(ColorProperty(
        'backgroundColor', findStatusColor(widget.type),
        defaultValue: null));
    properties.add(DiagnosticsProperty<Gradient>('gradient', widget.gradient));
    properties.add(ColorProperty('color', widget.color));
  }
}

/// An enumeration representing different styles for outlining a shape.
enum OutlineStyle {
  /// No outline style.
  none,

  /// Solid line outline style.
  solid,

  /// Dashed line outline style.
  dashed,

  /// Dotted line outline style.
  dotted,
}

/// Painter class used to draw the outline of the button based on the specified style.
class OutlinePainter extends CustomPainter {
  final OutlineStyle style;
  final Color color;
  final double width;
  final BorderRadiusGeometry borderRadius;
  final TextDirection textDirection;

  OutlinePainter({
    required this.style,
    required this.color,
    required this.width,
    required this.borderRadius,
    required this.textDirection,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if (style == OutlineStyle.none) return;

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final BorderRadius resolvedRadius = borderRadius.resolve(textDirection);

    final RRect rrect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: resolvedRadius.topLeft,
      topRight: resolvedRadius.topRight,
      bottomLeft: resolvedRadius.bottomLeft,
      bottomRight: resolvedRadius.bottomRight,
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
        borderRadius != oldDelegate.borderRadius;
  }
}
