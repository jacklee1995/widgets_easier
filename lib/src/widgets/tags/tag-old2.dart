import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../enums/size_enum.dart';
import '../../enums/semantic_enum.dart';
import '../../color/utils.dart';

enum TagThemeEnum { light, dark, plain }

class Tag extends StatefulWidget {
  final String initialText;
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
  final bool editable;
  final bool shrink;
  final Function(String, String)? onTextChanged;
  final bool restoreAfterSubmitted;
  final Function(String)? onSubmitted;

  const Tag(
    this.initialText, {
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
    this.editable = false,
    this.shrink = true,
    this.onTextChanged,
    this.restoreAfterSubmitted = false,
    this.onSubmitted,
  });

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.color ??
        (widget.type != null ? findStatusColor(widget.type!) : null);
    final backgroundColor = _getBackgroundColor(context, borderColor);
    final textColor = _getTextColor(context, borderColor);

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: IntrinsicWidth(
        child: Container(
          height: widget.height != null && widget.height! > 12
              ? widget.height
              : _getHeightForSize(widget.size),
          width: widget.width ?? (widget.shrink ? null : double.infinity),
          padding:
              EdgeInsets.symmetric(horizontal: _getPaddingForSize(widget.size)),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
            border: _getBorder(context, borderColor),
          ),
          child: Row(
            mainAxisSize: widget.shrink ? MainAxisSize.min : MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.editable
                  ? _editableText(textColor)
                  : _staticText(textColor),
              if (widget.closable) ...[
                SizedBox(width: _getSpacingForSize(widget.size)),
                _CloseIcon(
                  color: textColor,
                  size: widget.size,
                  onClose: widget.onClose,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _editableText(Color textColor) {
    return Expanded(
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            if (widget.onSubmitted != null) {
              widget.onSubmitted!(_textController.text);
              if (widget.restoreAfterSubmitted) {
                _textController.text = widget.initialText;
              }
            }
          } else if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            setState(() {});
          }
        },
        child: TextField(
          controller: _textController,
          style: TextStyle(
            color: textColor,
            fontSize: _getFontSizeForSize(widget.size),
            decoration: TextDecoration.none,
          ),
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          cursorColor: textColor,
          onTap: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _staticText(Color textColor) {
    return GestureDetector(
      onTap: () {
        if (widget.editable) {
          setState(() {});
        }
      },
      child: Text(
        _textController.text,
        style: TextStyle(
          color: textColor,
          fontSize: _getFontSizeForSize(widget.size),
        ),
      ),
    );
  }

  Color? _getBackgroundColor(BuildContext context, Color? borderColor) {
    switch (widget.theme) {
      case TagThemeEnum.dark:
        return borderColor;
      case TagThemeEnum.light:
        return borderColor?.withOpacity(0.1);
      case TagThemeEnum.plain:
        return Colors.transparent;
    }
  }

  Color _getTextColor(BuildContext context, Color? borderColor) {
    switch (widget.theme) {
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
    if (widget.theme == TagThemeEnum.plain) {
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
