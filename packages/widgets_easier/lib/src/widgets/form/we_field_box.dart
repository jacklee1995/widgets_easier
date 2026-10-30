import 'package:flutter/material.dart';

import '../../core/core.dart';
import 'we_form.dart';

/// The outlined box behind dropdown fields such as `WeSelect`,
/// `WeCascader` and `WeTreeSelect`: border, hover, focus glow, a clear
/// button that replaces the arrow on hover, and the error state and size of
/// a surrounding [WeFormItem].
///
/// It owns the [Focus] and the tap; the caller supplies the content and
/// opens its panel from [onTap].
///
/// ```dart
/// WeFieldBox(
///   focusNode: _focus,
///   open: _open,
///   focused: _focused,
///   enabled: _enabled,
///   onTap: _toggle,
///   onClear: hasValue ? _clear : null,
///   child: Text(label),
/// )
/// ```
class WeFieldBox extends StatefulWidget {
  const WeFieldBox({
    super.key,
    required this.child,
    required this.onTap,
    this.focusNode,
    this.onKeyEvent,
    this.open = false,
    this.focused = false,
    this.enabled = true,
    this.size = SizeEnum.defaultSize,
    this.status,
    this.onClear,
    this.prefixIcon,
    this.multiline = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final FocusNode? focusNode;
  final FocusOnKeyEventCallback? onKeyEvent;

  /// Turns the arrow up.
  final bool open;

  /// Draws the focus border and glow; usually `open || hasFocus`.
  final bool focused;
  final bool enabled;
  final SizeEnum size;

  /// Colours the border; falls back to the [WeFormItem] status.
  final SemanticEnum? status;

  /// Shows a clear button on hover in place of the arrow. `null` hides it.
  final VoidCallback? onClear;
  final IconData? prefixIcon;

  /// Grows with wrapped content, such as tags, instead of a fixed height.
  final bool multiline;

  /// [size] with a default size replaced by the [WeFormItem]'s.
  static SizeEnum resolveSize(BuildContext context, SizeEnum size) {
    if (size != SizeEnum.defaultSize) return size;
    return WeFormItem.maybeOf(context)?.size ?? size;
  }

  @override
  State<WeFieldBox> createState() => _WeFieldBoxState();
}

class _WeFieldBoxState extends State<WeFieldBox> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final WeFormItemState? item = WeFormItem.maybeOf(context);
    final metrics = we.sizes.control(
      WeFieldBox.resolveSize(context, widget.size),
    );
    final bool enabled = widget.enabled;
    final SemanticEnum? status = widget.status ?? item?.status;
    final Color accent = status != null
        ? colors.semantic(status)
        : colors.primary;
    final bool active = widget.open || widget.focused;
    final Color border = !enabled
        ? colors.lightBorder
        : active || status != null
        ? accent
        : _hover
        ? colors.darkBorder
        : colors.baseBorder;
    final bool showClear = widget.onClear != null && _hover && enabled;

    final Widget suffix = showClear
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onClear,
            child: Icon(
              Icons.cancel_rounded,
              size: metrics.iconSize,
              color: colors.placeholderText,
            ),
          )
        : AnimatedRotation(
            turns: widget.open ? 0.5 : 0,
            duration: const Duration(milliseconds: 160),
            child: Icon(
              Icons.expand_more_rounded,
              size: metrics.iconSize + 2,
              color: colors.placeholderText,
            ),
          );

    final Widget box = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      constraints: BoxConstraints(minHeight: metrics.height),
      height: widget.multiline ? null : metrics.height,
      padding: EdgeInsets.symmetric(
        horizontal: metrics.horizontalPadding * 0.7,
        vertical: widget.multiline ? 3 : 0,
      ),
      decoration: BoxDecoration(
        color: enabled ? colors.overlayBackground : colors.lightFill,
        borderRadius: BorderRadius.circular(we.radius.base),
        border: Border.all(color: border),
        boxShadow: active && enabled
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.18),
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          if (widget.prefixIcon != null) ...[
            Icon(
              widget.prefixIcon,
              size: metrics.iconSize,
              color: colors.placeholderText,
            ),
            SizedBox(width: metrics.spacing),
          ],
          Expanded(child: widget.child),
          SizedBox(width: metrics.spacing),
          suffix,
        ],
      ),
    );

    return Focus(
      focusNode: widget.focusNode,
      canRequestFocus: enabled,
      onKeyEvent: widget.onKeyEvent,
      child: MouseRegion(
        cursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? widget.onTap : null,
          child: box,
        ),
      ),
    );
  }
}
