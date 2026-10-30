import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/core.dart';
import '../../buttons/we_button.dart';
import '../../overlay/we_popper.dart';
import 'dialog_drag.dart';

/// A web-style modal after `el-dialog`.
///
/// The header carries the title and the close button, the body scrolls when it
/// runs out of room, and the footer holds the actions. Unlike Flutter's
/// [AlertDialog] the whole thing can be dragged by its header.
///
/// Show one with [WeDialog.show], which returns whatever the dialog pops:
///
/// ```dart
/// final bool? ok = await WeDialog.show<bool>(
///   context,
///   title: '发布商品',
///   builder: (context) => const ProductForm(),
///   actions: (context) => [
///     WeButton(text: '取消', variant: WeButtonVariant.plain,
///         onPressed: () => Navigator.of(context).pop(false)),
///     WeButton(text: '发布', type: SemanticEnum.primary,
///         onPressed: () => Navigator.of(context).pop(true)),
///   ],
/// );
/// ```
class WeDialog extends StatelessWidget {
  const WeDialog({
    super.key,
    this.title,
    this.titleWidget,
    this.icon,
    this.child,
    this.header,
    this.footer,
    this.actions = const [],
    this.width = 480,
    this.fullscreen = false,
    this.top,
    this.showClose = true,
    this.draggable = true,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 20),
    this.dividers = true,
    this.scrollable = true,
    this.maxHeightFactor = 0.85,
    this.onClose,
  }) : assert(
         title != null || titleWidget != null || header != null || !showClose,
         'Give a title, a titleWidget or a header.',
       );

  final String? title;

  /// Replaces the title text, keeping the close button and the drag handle.
  final Widget? titleWidget;

  /// Shown before the title.
  final IconData? icon;

  final Widget? child;

  /// Replaces the whole header row, including the close button.
  final Widget? header;

  /// Replaces the footer. Takes precedence over [actions].
  final Widget? footer;

  /// Buttons on the right of the footer. Ignored when [footer] is set.
  final List<Widget> actions;

  final double width;

  /// Fills the viewport, like `el-dialog`'s fullscreen.
  final bool fullscreen;

  /// Distance from the top of the viewport. `null` centres the dialog.
  final double? top;

  final bool showClose;

  /// Lets the user drag the dialog by its header.
  final bool draggable;

  final EdgeInsets padding;

  /// Hairlines under the header and above the footer.
  final bool dividers;

  /// Wraps the body in a scroll view once it outgrows [maxHeightFactor].
  final bool scrollable;

  /// Body height cap, as a fraction of the viewport.
  final double maxHeightFactor;

  /// Runs instead of `Navigator.pop` when the close button is tapped.
  final VoidCallback? onClose;

  /// Opens the dialog and completes with the value it pops.
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    Widget? titleWidget,
    IconData? icon,
    WidgetBuilder? builder,
    Widget? child,
    Widget? header,
    Widget? footer,
    List<Widget> Function(BuildContext context)? actions,
    double width = 480,
    bool fullscreen = false,
    double? top,
    bool showClose = true,
    bool draggable = true,
    EdgeInsets padding = const EdgeInsets.fromLTRB(20, 18, 20, 20),
    bool dividers = true,
    bool scrollable = true,
    double maxHeightFactor = 0.85,
    bool modal = true,
    bool closeOnClickModal = true,
    bool closeOnEscape = true,
    Color? barrierColor,
    Duration duration = const Duration(milliseconds: 220),
    RouteTransitionsBuilder? transitionBuilder,
  }) {
    assert(
      builder != null || child != null,
      'Give either a builder or a child.',
    );
    final WeColorScheme colors = WeTheme.of(context).colors;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: closeOnClickModal,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: modal ? (barrierColor ?? colors.mask) : Colors.transparent,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondary) {
        final Widget dialog = WeDialog(
          title: title,
          titleWidget: titleWidget,
          icon: icon,
          header: header,
          footer: footer,
          actions: actions?.call(context) ?? const [],
          width: width,
          fullscreen: fullscreen,
          top: top,
          showClose: showClose,
          draggable: draggable && !fullscreen,
          padding: padding,
          dividers: dividers,
          scrollable: scrollable,
          maxHeightFactor: maxHeightFactor,
          child: builder?.call(context) ?? child,
        );

        if (!closeOnEscape) return dialog;
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): () {
              if (!WePopper.escapeHandled) Navigator.of(context).maybePop();
            },
          },
          child: Focus(autofocus: true, child: dialog),
        );
      },
      transitionBuilder:
          transitionBuilder ??
          (context, animation, secondary, child) {
            // el-dialog 的 dialog-fade：淡入的同时轻微放大并上移。
            final CurvedAnimation curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curve,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.04),
                  end: Offset.zero,
                ).animate(curve),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1).animate(curve),
                  child: child,
                ),
              ),
            );
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    final WeTheme theme = WeTheme.of(context);
    final WeColorScheme colors = theme.colors;
    final Size viewport = MediaQuery.sizeOf(context);

    final BorderRadius radius = BorderRadius.circular(
      fullscreen ? 0 : theme.radius.base,
    );

    final Widget surface = Material(
      color: Colors.transparent,
      child: Container(
        width: fullscreen
            ? double.infinity
            : math.max(0.0, math.min(width, viewport.width - 32)),
        decoration: BoxDecoration(
          color: colors.overlayBackground,
          borderRadius: radius,
          boxShadow: fullscreen ? null : theme.shadows.dark,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(context, colors),
            _body(viewport),
            _footer(colors),
          ],
        ),
      ),
    );

    if (fullscreen) return SafeArea(child: surface);

    return WeMovableDialog(
      enabled: draggable,
      alignment: top == null ? Alignment.center : Alignment.topCenter,
      insets: EdgeInsets.fromLTRB(24, top ?? 24, 24, 24),
      child: surface,
    );
  }

  Widget _header(BuildContext context, WeColorScheme colors) {
    if (header != null) {
      return WeDialogDragHandle(child: header!);
    }

    return WeDialogDragHandle(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: dividers
              ? Border(bottom: BorderSide(color: colors.lighterBorder))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: colors.primary),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child:
                      titleWidget ??
                      Text(
                        title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.primaryText,
                        ),
                      ),
                ),
                if (showClose)
                  WeButton.icon(
                    Icons.close_rounded,
                    variant: WeButtonVariant.text,
                    size: SizeEnum.small,
                    tooltip: MaterialLocalizations.of(context).closeButtonLabel,
                    onPressed:
                        onClose ?? () => Navigator.of(context).maybePop(),
                  )
                else
                  const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(Size viewport) {
    final Widget content = Padding(
      padding: padding,
      child: child ?? const SizedBox.shrink(),
    );
    if (!scrollable) return content;

    // 不用 Flexible：弹窗也可能被直接嵌在滚动页面里做示例，那里高度是无界的。
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: fullscreen
            ? double.infinity
            : viewport.height * maxHeightFactor,
      ),
      child: SingleChildScrollView(child: content),
    );
  }

  Widget _footer(WeColorScheme colors) {
    if (footer != null) return footer!;
    if (actions.isEmpty) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        border: dividers
            ? Border(top: BorderSide(color: colors.lighterBorder))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            for (int i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              actions[i],
            ],
          ],
        ),
      ),
    );
  }
}
