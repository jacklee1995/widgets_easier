import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../animations/animate_styles.dart';
import '../../../core/core.dart';
import '../../overlay/we_popper.dart';
import 'win_style_dialog.dart';

/// Shows [WinStyleDialog]s.
///
/// ```dart
/// WinDialogs.show<bool>(
///   context,
///   title: '删除商品',
///   icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
///   text: '删除后不可恢复，确认继续？',
///   actions: (context) => [
///     WeButton(text: '取消', variant: WeButtonVariant.plain,
///         onPressed: () => Navigator.of(context).pop(false)),
///     WeButton(text: '删除', type: SemanticEnum.danger,
///         onPressed: () => Navigator.of(context).pop(true)),
///   ],
/// );
/// ```
///
/// Platform: desktop and web (pointer + keyboard, wide screen). On phones prefer [BottomSheets] or [WeMessageBox].
class WinDialogs {
  const WinDialogs._();

  /// Fades the dialog in. Completes with whatever the dialog pops.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    Widget? icon,
    String text = '',
    Widget? contents,
    List<Widget> Function(BuildContext context)? actions,
    double maxWidth = 460,
    bool barrierDismissible = true,
    bool draggable = true,
    bool showClose = true,
    Duration duration = const Duration(milliseconds: 180),
  }) => showWinDialog<T>(
    context,
    title: title,
    icon: icon,
    text: text,
    contents: contents,
    actions: actions,
    maxWidth: maxWidth,
    barrierDismissible: barrierDismissible,
    draggable: draggable,
    showClose: showClose,
    duration: duration,
  );

  /// Grows the dialog from the centre.
  static Future<T?> zoomIn<T>(
    BuildContext context, {
    required String title,
    Widget? icon,
    String text = '',
    Widget? contents,
    List<Widget> Function(BuildContext context)? actions,
    double maxWidth = 460,
    bool barrierDismissible = true,
    bool draggable = true,
    bool showClose = true,
  }) => showWinDialog<T>(
    context,
    title: title,
    icon: icon,
    text: text,
    contents: contents,
    actions: actions,
    maxWidth: maxWidth,
    barrierDismissible: barrierDismissible,
    draggable: draggable,
    showClose: showClose,
    transitionBuilder: (context, animation, secondary, child) =>
        AnimateStyles.zoomIn(animation, child),
  );

  /// The general form, with your own [transitionBuilder].
  static Future<T?> showWinDialog<T>(
    BuildContext context, {
    required String title,
    Widget? icon,
    String text = '',
    Widget? contents,
    List<Widget> Function(BuildContext context)? actions,
    double maxWidth = 460,
    bool barrierDismissible = true,
    bool draggable = true,
    bool showClose = true,
    bool closeOnEscape = true,
    Color? barrierColor,
    Duration duration = const Duration(milliseconds: 180),
    RouteTransitionsBuilder? transitionBuilder,
  }) {
    final WeColorScheme colors = WeTheme.of(context).colors;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? colors.mask,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondary) {
        final Widget dialog = WinStyleDialog(
          title: title,
          icon: icon,
          text: text,
          contents: contents,
          actions: actions?.call(context) ?? const [],
          maxWidth: maxWidth,
          draggable: draggable,
          showClose: showClose,
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
          (context, animation, secondary, child) => FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          ),
    );
  }
}
