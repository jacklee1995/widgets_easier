import 'package:flutter/material.dart';

import '../../color/utils.dart';
import '../../enums/semantic_enum.dart';
import '/src/enums/size_enum.dart';

class SemanticButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final SemanticEnum dialogType;
  final bool isOutlined;
  final double? height;
  final double radius;
  final double fontSize;
  final FontWeight? fontWeight;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final SizeEnum size;
  final bool shrink;

  const SemanticButton({
    super.key,
    required this.text,
    this.onTap,
    required this.dialogType,
    this.isOutlined = false,
    this.height,
    this.radius = 4,
    this.fontSize = 18,
    this.fontWeight,
    this.prefixIcon,
    this.suffixIcon,
    this.size = SizeEnum.defaultSize,
    this.shrink = false,
  });

  @override
  State<SemanticButton> createState() => _SemanticButtonState();
}

class _SemanticButtonState extends State<SemanticButton> {
  bool _isHovered = false;
  double _elevation = 0; // 初始海拔为0

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Color bgColor = findStatusColor(widget.dialogType);
    Color hoverColor = bgColor.withOpacity(0.6); // 更明显的 hover 颜色

    final double effectiveHeight =
        widget.height ?? _getHeightForSize(widget.size);

    Widget buttonContent = Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: widget.onTap != null && _isHovered
            ? hoverColor
            : bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(widget.radius),
        border: widget.isOutlined ? Border.all(color: bgColor) : null,
        boxShadow: widget.onTap != null
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  spreadRadius: 0, // 不扩散
                  blurRadius: 4, // 减少模糊半径以使阴影更集中
                  offset: const Offset(0, 2), // 较小的垂直偏移
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
                color: widget.isOutlined && _isHovered
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
            _elevation = 6; // 增加海拔高度以增强阴影效果
          });
        }
      },
      onExit: (_) {
        if (widget.onTap != null) {
          setState(() {
            _isHovered = false;
            _elevation = 0; // 恢复海拔高度
          });
        }
      },
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Material(
          color: widget.isOutlined
              ? theme.buttonTheme.colorScheme?.background
              : bgColor,
          borderRadius: BorderRadius.circular(widget.radius),
          elevation: widget.onTap != null ? _elevation : 0, // 动态设置海拔值
          child: widget.shrink
              ? IntrinsicWidth(child: buttonContent)
              : buttonContent,
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
        return 16; // defaultSize
    }
  }
}
