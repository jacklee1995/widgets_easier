import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../enums/size_enum.dart';
import '../../enums/semantic_enum.dart';
import '../../color/utils.dart';

enum TagThemeEnum { light, dark, plain }

class Tag extends StatefulWidget {
  /// The initial text content of the tag.
  final String initialText;

  /// The semantic type of the tag, which may affect its styling.
  final SemanticEnum? type;

  /// The color of the tag, used primarily for text or background.
  final Color? color;

  /// Determines whether the tag is closable (i.e., can be dismissed).
  final bool closable;

  /// Callback function that is called when the tag is closed.
  final Function(String?)? onClose;

  /// Callback function that is called when the tag is tapped.
  final VoidCallback? onTap;

  /// Callback function that is called when a long press is detected on the tag.
  final VoidCallback? onLongPress;

  /// The size of the tag, affecting its dimensions.
  final SizeEnum size;

  /// The border radius of the tag, affecting the curvature of its corners.
  final double? radius;

  /// The theme of the tag, which can be light, dark, or plain.
  final TagThemeEnum theme;

  /// The height of the tag, overriding the default height.
  final double? height;

  /// The width of the tag, overriding the default width.
  final double? width;

  /// Determines whether the tag's text is editable.
  final bool editable;

  /// If true, the tag will shrink to fit its content.
  final bool shrink;

  /// Callback function that is called when the text in the tag is changed.
  final Function(String, String)? onTextChanged;

  /// If true, restores the initial text after the text is submitted.
  final bool restoreAfterSubmitted;

  /// Callback function that is called when the text is submitted (e.g., via Enter key).
  final Function(String)? onSubmitted;

  final String? id;

  /// Constructs a Tag widget.
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
    this.radius,
    this.theme = TagThemeEnum.plain,
    this.height,
    this.width,
    this.editable = false,
    this.shrink = true,
    this.onTextChanged,
    this.restoreAfterSubmitted = false,
    this.onSubmitted,
    this.id,
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
    /// 根据 `type` 获取边框颜色，如果未指定 `type` 或 `color`，则默认为 `null`。
    final borderColor = widget.color ??
        (widget.type != null ? findStatusColor(widget.type!) : null);

    /// 获取背景颜色，根据主题和边框颜色确定。
    final backgroundColor = _getBackgroundColor(context, borderColor);

    /// 获取文本颜色，根据主题和边框颜色确定。
    final textColor = _getTextColor(context, borderColor);

    /// 构建标签内容，包括文本和关闭图标（如果可关闭）。
    Widget tagContent = GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        /// 根据 `size` 或指定的 `height` 确定容器高度。
        height: widget.height != null && widget.height! > 12
            ? widget.height
            : _getHeightForSize(widget.size),

        /// 宽度直接使用 `width` 属性，如果未指定，则由内容和内边距决定。
        width: widget.width,

        /// 根据 `size` 设置水平内边距。
        padding:
            EdgeInsets.symmetric(horizontal: _getPaddingForSize(widget.size)),
        decoration: BoxDecoration(
          color: backgroundColor,

          /// 设置边框圆角，如果未指定 `radius`，默认为 4。
          borderRadius: BorderRadius.circular(widget.radius ?? 4),

          /// 设置边框样式。
          border: _getBorder(context, borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 如果标签可编辑，则显示可编辑文本框，否则显示静态文本。
            widget.editable ? _editableText(textColor) : _staticText(textColor),

            /// 如果标签可关闭，添加关闭图标。
            if (widget.closable) ...[
              SizedBox(width: _getSpacingForSize(widget.size)),
              _CloseIcon(
                color: textColor,
                size: widget.size,
                id: widget.id,
                onClose: widget.onClose,
              ),
            ],
          ],
        ),
      ),
    );

    /// 如果 `shrink` 属性为真，则使用 `IntrinsicWidth` 包裹内容以适应内容宽度，否则直接返回内容。
    return widget.shrink ? IntrinsicWidth(child: tagContent) : tagContent;
  }

  // 编辑状态文本。
  Widget _editableText(Color textColor) {
    return Expanded(
      // 监听键盘事件
      child: KeyboardListener(
        focusNode: FocusNode(), // 创建一个焦点节点
        onKeyEvent: (KeyEvent event) {
          /// 如果按下回车键，并且定义了 `onSubmitted` 回调
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

          /// 文本字段的样式
          decoration: const InputDecoration(
            isDense: true, //  使得输入装饰更紧凑，减少垂直空间的占用
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          // 设置光标颜色
          cursorColor: textColor,
          // 当文本字段被点击时，更新状态
          onTap: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  // 静态状态文本。
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

  // 根据主题和边框颜色获取背景颜色，
  // 主要是plain时的才有边框
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

  // 根据主题和边框颜色获取文本颜色
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

  /// 根据尺寸枚举获取高度
  double _getHeightForSize(SizeEnum size) => switch (size) {
        SizeEnum.small => 20,
        SizeEnum.large => 32,
        _ => 24,
      };

  /// 根据尺寸枚举获取高度
  double _getFontSizeForSize(SizeEnum size) => switch (size) {
        SizeEnum.small => 12,
        SizeEnum.large => 16,
        _ => 14,
      };

  /// 根据尺寸枚举获取水平内边距
  double _getPaddingForSize(SizeEnum size) => switch (size) {
        SizeEnum.small => 8,
        SizeEnum.large => 12,
        _ => 10,
      };

  /// 根据尺寸枚举获取组件间隔
  double _getSpacingForSize(SizeEnum size) => switch (size) {
        SizeEnum.small => 4,
        SizeEnum.large => 8,
        _ => 6,
      };
}

class _CloseIcon extends StatefulWidget {
  final Color color;
  final SizeEnum size;
  final String? id;
  final Function(String?)? onClose;

  const _CloseIcon({
    required this.color,
    required this.size,
    this.id,
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
        onTap: () {
          if (widget.onClose != null) {
            if (widget.id != null) {
              widget.onClose!(widget.id!);
            } else {
              widget.onClose!(null);
            }
          }
        },
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
