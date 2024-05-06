import 'package:flutter/material.dart';

import '../../enums/size_enum.dart';
import '../../enums/semantic_enum.dart';
import '../../color/utils.dart';

enum TagThemeEnum { light, dark, plain }

class Tag extends StatelessWidget {
  final String text;
  final SemanticEnum? type;
  final Color? color;
  final bool closable;
  final VoidCallback? onClose;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final SizeEnum size;
  final double? borderRadius;
  final TagThemeEnum theme;
  final double? height;
  final double? width;

  const Tag(
    this.text, {
    super.key,
    this.type,
    this.color,
    this.closable = false,
    this.onClose,
    this.onTap,
    this.onLongPress,
    this.size = SizeEnum.defaultSize,
    this.borderRadius,
    this.theme = TagThemeEnum.plain,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = color ?? (type != null ? findStatusColor(type!) : null);
    final backgroundColor = _getBackgroundColor(context, borderColor);
    final textColor = _getTextColor(context, borderColor);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height:
            height != null && height! > 12 ? height : _getHeightForSize(size),
        width: width,
        padding: EdgeInsets.symmetric(horizontal: _getPaddingForSize(size)),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
          border: _getBorder(context, borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: _getFontSizeForSize(size),
              ),
            ),
            if (closable) ...[
              SizedBox(width: _getSpacingForSize(size)),
              _CloseIcon(
                color: textColor,
                size: size,
                onClose: onClose,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color? _getBackgroundColor(BuildContext context, Color? borderColor) {
    switch (theme) {
      case TagThemeEnum.dark:
        return borderColor;
      case TagThemeEnum.light:
        return borderColor?.withOpacity(0.1);
      case TagThemeEnum.plain:
        return Colors.transparent;
    }
  }

  Color _getTextColor(BuildContext context, Color? borderColor) {
    switch (theme) {
      case TagThemeEnum.dark:
        return Colors.white;
      case TagThemeEnum.light:
      case TagThemeEnum.plain:
        return borderColor ??
            (Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black);
    }
  }

  BoxBorder? _getBorder(BuildContext context, Color? borderColor) {
    if (theme == TagThemeEnum.plain) {
      return Border.all(
        color: borderColor ??
            (Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black),
        width: 1,
      );
    }
    return null;
  }

  double _getHeightForSize(SizeEnum size) => switch (size) {
        SizeEnum.small => 20,
        SizeEnum.large => 32,
        _ => 24,
      };

  double _getFontSizeForSize(SizeEnum size) => switch (size) {
        SizeEnum.small => 12,
        SizeEnum.large => 16,
        _ => 14,
      };

  double _getPaddingForSize(SizeEnum size) => switch (size) {
        SizeEnum.small => 8,
        SizeEnum.large => 12,
        _ => 10,
      };

  double _getSpacingForSize(SizeEnum size) => switch (size) {
        SizeEnum.small => 4,
        SizeEnum.large => 8,
        _ => 6,
      };
}

class _CloseIcon extends StatefulWidget {
  final Color color;
  final SizeEnum size;
  final VoidCallback? onClose;

  const _CloseIcon({
    required this.color,
    required this.size,
    this.onClose,
  });

  @override
  _CloseIconState createState() => _CloseIconState();
}

class _CloseIconState extends State<_CloseIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onClose,
        child: Container(
          width: _getCloseIconSizeForSize(widget.size) * 0.9,
          height: _getCloseIconSizeForSize(widget.size) * 0.9,
          decoration: BoxDecoration(
            color:
                _isHovered ? widget.color.withOpacity(0.7) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close,
            size: _getCloseIconSizeForSize(widget.size) * 0.9,
            color: _isHovered ? Colors.white : widget.color,
          ),
        ),
      ),
    );
  }

  double _getCloseIconSizeForSize(SizeEnum size) => switch (size) {
        SizeEnum.small => 16,
        SizeEnum.large => 24,
        _ => 20,
      };
}
