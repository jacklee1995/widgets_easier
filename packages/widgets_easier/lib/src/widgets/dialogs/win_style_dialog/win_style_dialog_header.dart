import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../we_dialog/dialog_drag.dart';

/// The title bar of a [WinStyleDialog]: icon, title, close button.
///
/// Inside a draggable dialog the bar doubles as the drag handle, so it behaves
/// like a real window title bar — drag to move, double-click to recentre.
class WinStyleDialogHeader extends StatelessWidget {
  const WinStyleDialogHeader({
    super.key,
    required this.title,
    this.icon,
    this.titleAlignment = Alignment.centerLeft,
    this.height = 34,
    this.titleStyle,
    this.backgroundColor,
    this.showClose = true,
    this.onClose,
  });

  final String title;
  final Widget? icon;
  final Alignment titleAlignment;
  final double height;
  final TextStyle? titleStyle;

  /// Defaults to the themed surface colour.
  final Color? backgroundColor;

  final bool showClose;

  /// Runs instead of `Navigator.maybePop` when the close button is tapped.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final WeColorScheme colors = context.weColors;

    return WeDialogDragHandle(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? colors.overlayBackground,
          border: Border(bottom: BorderSide(color: colors.lighterBorder)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                mainAxisAlignment: titleAlignment == Alignment.center
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  if (icon != null) ...[
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: FittedBox(child: icon!),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          titleStyle ??
                          TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.primaryText,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            if (showClose)
              WinCloseButton(
                height: height,
                onTap: onClose ?? () => Navigator.of(context).maybePop(),
              ),
          ],
        ),
      ),
    );
  }
}

/// The square close button of a window title bar, red on hover.
///
/// Named with a `Win` prefix on purpose: a plain `CloseButton` would clash
/// with the one in `package:flutter/material.dart`.
class WinCloseButton extends StatefulWidget {
  const WinCloseButton({super.key, required this.height, required this.onTap});

  final double height;
  final VoidCallback onTap;

  @override
  State<WinCloseButton> createState() => _WinCloseButtonState();
}

class _WinCloseButtonState extends State<WinCloseButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final WeColorScheme colors = context.weColors;

    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).closeButtonTooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: widget.height,
            width: 44,
            color: _hovered ? colors.danger : Colors.transparent,
            child: Icon(
              Icons.close_rounded,
              size: 16,
              color: _hovered ? Colors.white : colors.regularText,
            ),
          ),
        ),
      ),
    );
  }
}
