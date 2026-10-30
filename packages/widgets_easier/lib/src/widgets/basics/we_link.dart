import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Inline hyperlink text, after `el-link`.
///
/// ```dart
/// WeLink('View all', onTap: openList)
/// WeLink('Delete', type: SemanticEnum.danger, icon: Icons.delete_outline, onTap: remove)
/// ```
class WeLink extends StatefulWidget {
  const WeLink(
    this.text, {
    super.key,
    this.onTap,
    this.type,
    this.icon,
    this.trailingIcon,
    this.underline = true,
    this.disabled = false,
    this.fontSize = 13,
  });

  final String text;
  final VoidCallback? onTap;

  /// `null` for the neutral link colour.
  final SemanticEnum? type;
  final IconData? icon;
  final IconData? trailingIcon;

  /// Underline on hover.
  final bool underline;
  final bool disabled;
  final double fontSize;

  @override
  State<WeLink> createState() => _WeLinkState();
}

class _WeLinkState extends State<WeLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final bool enabled = !widget.disabled && widget.onTap != null;
    final Color base = widget.type == null
        ? colors.regularText
        : colors.semantic(widget.type!);
    final Color fg = !enabled
        ? colors.disabledText
        : _hover
        ? (widget.type == null ? colors.primary : colors.lighten(base, 2))
        : base;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: enabled ? widget.onTap : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: widget.fontSize + 1, color: fg),
              const SizedBox(width: 4),
            ],
            Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: fg,
                decoration: widget.underline && _hover && enabled
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: fg,
              ),
            ),
            if (widget.trailingIcon != null) ...[
              const SizedBox(width: 2),
              Icon(widget.trailingIcon, size: widget.fontSize + 1, color: fg),
            ],
          ],
        ),
      ),
    );
  }
}
