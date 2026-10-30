import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Fill style of a [WeAlert], after `el-alert` `effect`.
enum WeAlertEffect {
  /// Tinted background with coloured text. The default.
  light,

  /// Solid semantic background with white text.
  dark,
}

/// A persistent inline notice, after `el-alert`.
///
/// ```dart
/// WeAlert(title: 'Stock low', description: '3 SKUs under safety stock.', type: SemanticEnum.warning)
/// WeAlert(title: 'Saved', type: SemanticEnum.success, closable: true, onClose: hide)
/// ```
class WeAlert extends StatefulWidget {
  const WeAlert({
    super.key,
    required this.title,
    this.description,
    this.type = SemanticEnum.info,
    this.effect = WeAlertEffect.light,
    this.showIcon = true,
    this.icon,
    this.closable = false,
    this.closeText,
    this.onClose,
    this.action,
    this.center = false,
  });

  final String title;
  final String? description;
  final SemanticEnum type;
  final WeAlertEffect effect;
  final bool showIcon;

  /// Overrides the icon derived from [type].
  final IconData? icon;
  final bool closable;

  /// Text instead of the close icon.
  final String? closeText;
  final VoidCallback? onClose;

  /// Trailing widget, e.g. a link or a small button.
  final Widget? action;

  /// Centre the title when there is no description.
  final bool center;

  static IconData iconFor(SemanticEnum type) => switch (type) {
    SemanticEnum.success => Icons.check_circle_rounded,
    SemanticEnum.warning => Icons.warning_rounded,
    SemanticEnum.danger || SemanticEnum.fatal => Icons.error_rounded,
    _ => Icons.info_rounded,
  };

  @override
  State<WeAlert> createState() => _WeAlertState();
}

class _WeAlertState extends State<WeAlert> {
  bool _closed = false;

  void _close() {
    setState(() => _closed = true);
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_closed) return const SizedBox.shrink();
    final we = WeTheme.of(context);
    final colors = we.colors;
    final Color accent = colors.semantic(widget.type);
    final bool dark = widget.effect == WeAlertEffect.dark;
    final Color bg = dark ? accent : colors.light(widget.type, 9);
    final Color fg = dark ? colors.onSemantic : accent;
    final Color body = dark
        ? colors.onSemantic.withValues(alpha: 0.9)
        : colors.regularText;
    final bool hasDesc = widget.description != null;

    return AnimatedSize(
      duration: const Duration(milliseconds: 160),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: hasDesc ? 12 : 9,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(we.radius.base),
          border: dark ? null : Border.all(color: colors.light(widget.type, 8)),
        ),
        child: Row(
          crossAxisAlignment: hasDesc
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisAlignment: widget.center && !hasDesc
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            if (widget.showIcon) ...[
              Padding(
                padding: EdgeInsets.only(top: hasDesc ? 1 : 0),
                child: Icon(
                  widget.icon ?? WeAlert.iconFor(widget.type),
                  size: hasDesc ? 20 : 16,
                  color: fg,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Flexible(
              fit: widget.center && !hasDesc ? FlexFit.loose : FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: hasDesc ? FontWeight.w600 : FontWeight.w500,
                      color: fg,
                    ),
                  ),
                  if (hasDesc) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.description!,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.5,
                        color: body,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.action != null) ...[
              const SizedBox(width: 12),
              widget.action!,
            ],
            if (widget.closable) ...[
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _close,
                  child: widget.closeText != null
                      ? Text(
                          widget.closeText!,
                          style: TextStyle(fontSize: 12.5, color: fg),
                        )
                      : Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: dark
                              ? colors.onSemantic
                              : colors.placeholderText,
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
