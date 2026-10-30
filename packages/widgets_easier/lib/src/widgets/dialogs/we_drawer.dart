import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';
import '../buttons/we_button.dart';
import '../overlay/we_popper.dart';

/// Which edge a [WeDrawer] slides in from, after `el-drawer`'s `direction`.
enum WeDrawerDirection {
  /// From the right edge. The default.
  rtl,

  /// From the left edge.
  ltr,

  /// From the top edge.
  ttb,

  /// From the bottom edge.
  btt;

  bool get isHorizontal => this == rtl || this == ltr;

  Alignment get _alignment => switch (this) {
    rtl => Alignment.centerRight,
    ltr => Alignment.centerLeft,
    ttb => Alignment.topCenter,
    btt => Alignment.bottomCenter,
  };

  Offset get _hiddenOffset => switch (this) {
    rtl => const Offset(1, 0),
    ltr => const Offset(-1, 0),
    ttb => const Offset(0, -1),
    btt => const Offset(0, 1),
  };
}

/// A panel sliding in from a screen edge, after `el-drawer`. Open it with
/// [WeDrawer.show]; the widget itself is the panel, for custom routes.
///
/// ```dart
/// WeDrawer.show<void>(
///   context,
///   title: '订单详情',
///   size: 520,
///   resizable: true,
///   builder: (context) => OrderDetail(order),
///   actions: (context) => [
///     WeButton(text: '关闭', onPressed: () => Navigator.pop(context)),
///   ],
/// );
/// ```
class WeDrawer extends StatefulWidget {
  const WeDrawer({
    super.key,
    required this.child,
    this.direction = WeDrawerDirection.rtl,
    this.size = 0.3,
    this.title,
    this.titleWidget,
    this.actions = const [],
    this.withHeader = true,
    this.showClose = true,
    this.padding = const EdgeInsets.all(20),
    this.scrollable = true,
    this.resizable = false,
    this.minSize = 200,
    this.onClose,
  });

  final Widget child;
  final WeDrawerDirection direction;

  /// Width (or height for `ttb` / `btt`): a fraction of the screen when at
  /// most 1, otherwise logical pixels.
  final double size;
  final String? title;
  final Widget? titleWidget;

  /// Footer buttons, right-aligned.
  final List<Widget> actions;

  /// Hide the title bar entirely, like `with-header="false"`.
  final bool withHeader;
  final bool showClose;
  final EdgeInsets padding;
  final bool scrollable;

  /// Lets the user drag the inner edge to resize the panel.
  final bool resizable;

  /// Smallest size a resize can reach.
  final double minSize;

  /// Replaces the close button's default `Navigator.maybePop`.
  final VoidCallback? onClose;

  /// Slides a [WeDrawer] in over a mask.
  ///
  /// [beforeClose] runs before the mask, Escape, the close button or the
  /// system back gesture close the drawer; return `false` to keep it open,
  /// e.g. after asking whether to discard edits. `Navigator.pop` from your
  /// own buttons always closes it.
  static Future<T?> show<T>(
    BuildContext context, {
    WidgetBuilder? builder,
    Widget? child,
    WeDrawerDirection direction = WeDrawerDirection.rtl,
    double size = 0.3,
    String? title,
    Widget? titleWidget,
    List<Widget> Function(BuildContext context)? actions,
    bool withHeader = true,
    bool showClose = true,
    EdgeInsets padding = const EdgeInsets.all(20),
    bool scrollable = true,
    bool resizable = false,
    double minSize = 200,
    FutureOr<bool> Function()? beforeClose,
    bool modal = true,
    bool closeOnClickModal = true,
    bool closeOnEscape = true,
    Color? barrierColor,
    Duration duration = const Duration(milliseconds: 280),
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
        Widget drawer = WeDrawer(
          direction: direction,
          size: size,
          title: title,
          titleWidget: titleWidget,
          actions: actions?.call(context) ?? const [],
          withHeader: withHeader,
          showClose: showClose,
          padding: padding,
          scrollable: scrollable,
          resizable: resizable,
          minSize: minSize,
          child: builder?.call(context) ?? child!,
        );

        if (beforeClose != null) {
          drawer = _Guard<T>(beforeClose: beforeClose, child: drawer);
        }
        if (!closeOnEscape) return drawer;
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): () {
              if (!WePopper.escapeHandled) Navigator.of(context).maybePop();
            },
          },
          child: Focus(autofocus: true, child: drawer),
        );
      },
      transitionBuilder: (context, animation, secondary, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: direction._hiddenOffset,
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                  reverseCurve: Curves.easeInCubic,
                ),
              ),
          child: child,
        );
      },
    );
  }

  @override
  State<WeDrawer> createState() => _WeDrawerState();
}

/// Holds the route open until [beforeClose] agrees.
class _Guard<T> extends StatefulWidget {
  const _Guard({required this.beforeClose, required this.child});

  final FutureOr<bool> Function() beforeClose;
  final Widget child;

  @override
  State<_Guard<T>> createState() => _GuardState<T>();
}

class _GuardState<T> extends State<_Guard<T>> {
  bool _asking = false;

  Future<void> _ask(T? result) async {
    if (_asking) return;
    _asking = true;
    try {
      final bool ok = await widget.beforeClose();
      if (ok && mounted) Navigator.of(context).pop(result);
    } finally {
      _asking = false;
    }
  }

  @override
  Widget build(BuildContext context) => PopScope<T>(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) _ask(result);
    },
    child: widget.child,
  );
}

class _WeDrawerState extends State<WeDrawer> {
  double? _dragged;

  double _resolve(double extent) {
    final double base = widget.size <= 1 ? extent * widget.size : widget.size;
    final double value = _dragged ?? base;
    return value.clamp(math.min(widget.minSize, extent), extent);
  }

  void _resize(double delta, double extent) {
    final double current = _resolve(extent);
    // 拖的是内侧边：右侧抽屉往左拖是变宽。
    final double signed = switch (widget.direction) {
      WeDrawerDirection.rtl || WeDrawerDirection.btt => -delta,
      WeDrawerDirection.ltr || WeDrawerDirection.ttb => delta,
    };
    setState(
      () => _dragged = (current + signed).clamp(
        math.min(widget.minSize, extent),
        extent - 40,
      ),
    );
  }

  Widget _header(WeColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
      child: Row(
        children: [
          Expanded(
            child:
                widget.titleWidget ??
                Text(
                  widget.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.primaryText,
                  ),
                ),
          ),
          if (widget.showClose)
            WeButton.icon(
              Icons.close_rounded,
              variant: WeButtonVariant.text,
              size: SizeEnum.small,
              tooltip: MaterialLocalizations.of(context).closeButtonLabel,
              onPressed:
                  widget.onClose ?? () => Navigator.of(context).maybePop(),
            ),
        ],
      ),
    );
  }

  Widget _handle(WeColorScheme colors, double extent) {
    final bool horizontal = widget.direction.isHorizontal;
    return MouseRegion(
      cursor: horizontal
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: horizontal
            ? (d) => _resize(d.delta.dx, extent)
            : null,
        onVerticalDragUpdate: horizontal
            ? null
            : (d) => _resize(d.delta.dy, extent),
        child: SizedBox(
          width: horizontal ? 8 : double.infinity,
          height: horizontal ? double.infinity : 8,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WeTheme we = WeTheme.of(context);
    final WeColorScheme colors = we.colors;
    final WeDrawerDirection dir = widget.direction;
    final Size screen = MediaQuery.sizeOf(context);
    final double extent = dir.isHorizontal ? screen.width : screen.height;
    final double size = _resolve(extent);

    Widget body = Padding(padding: widget.padding, child: widget.child);
    if (widget.scrollable) body = SingleChildScrollView(child: body);

    Widget panel = Material(
      color: colors.overlayBackground,
      child: DefaultTextStyle.merge(
        style: TextStyle(fontSize: 14, color: colors.regularText),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.withHeader) _header(colors),
            Expanded(child: body),
            if (widget.actions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 12,
                  runSpacing: 8,
                  children: widget.actions,
                ),
              ),
          ],
        ),
      ),
    );

    if (widget.resizable) {
      final Widget handle = _handle(colors, extent);
      panel = Stack(
        children: [
          Positioned.fill(child: panel),
          switch (dir) {
            WeDrawerDirection.rtl => Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: handle,
            ),
            WeDrawerDirection.ltr => Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: handle,
            ),
            WeDrawerDirection.ttb => Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: handle,
            ),
            WeDrawerDirection.btt => Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: handle,
            ),
          },
        ],
      );
    }

    return Align(
      alignment: dir._alignment,
      child: Container(
        width: dir.isHorizontal ? size : double.infinity,
        height: dir.isHorizontal ? double.infinity : size,
        decoration: BoxDecoration(boxShadow: we.shadows.dark),
        child: panel,
      ),
    );
  }
}
