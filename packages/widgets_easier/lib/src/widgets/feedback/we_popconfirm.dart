import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../buttons/we_button.dart';
import '../overlay/we_popper.dart';

/// A small confirmation bubble anchored to the action it guards, after
/// Element Plus's `el-popconfirm`.
///
/// When [onConfirm] returns a `Future`, the confirm button shows a spinner
/// until it completes and the bubble closes afterwards. If the future
/// throws, the bubble stays open so the user can retry.
///
/// ```dart
/// WePopconfirm.builder(
///   title: '确定删除这件商品吗？',
///   type: SemanticEnum.danger,
///   onConfirm: () => api.delete(id),
///   builder: (context, open) =>
///       WeButton(text: '删除', type: SemanticEnum.danger, onPressed: open),
/// )
/// ```
class WePopconfirm extends StatefulWidget {
  const WePopconfirm({
    super.key,
    required Widget this.child,
    required this.title,
    this.onConfirm,
    this.onCancel,
    this.confirmText = '确定',
    this.cancelText = '取消',
    this.type = SemanticEnum.primary,
    this.icon = Icons.help_rounded,
    this.iconColor,
    this.hideIcon = false,
    this.width = 180,
    this.placement = WePlacement.top,
    this.disabled = false,
  }) : builder = null;

  /// Builds the trigger yourself; call `open` from its `onPressed`.
  const WePopconfirm.builder({
    super.key,
    required Widget Function(BuildContext context, VoidCallback open)
    this.builder,
    required this.title,
    this.onConfirm,
    this.onCancel,
    this.confirmText = '确定',
    this.cancelText = '取消',
    this.type = SemanticEnum.primary,
    this.icon = Icons.help_rounded,
    this.iconColor,
    this.hideIcon = false,
    this.width = 180,
    this.placement = WePlacement.top,
    this.disabled = false,
  }) : child = null;

  final Widget? child;
  final Widget Function(BuildContext context, VoidCallback open)? builder;
  final String title;
  final FutureOr<void> Function()? onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;

  /// Colour of the confirm button.
  final SemanticEnum type;
  final IconData icon;

  /// Defaults to the warning colour.
  final Color? iconColor;
  final bool hideIcon;
  final double? width;
  final WePlacement placement;
  final bool disabled;

  @override
  State<WePopconfirm> createState() => _WePopconfirmState();
}

class _WePopconfirmState extends State<WePopconfirm> {
  final WePopperController _controller = WePopperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cancel() {
    _controller.hide();
    widget.onCancel?.call();
  }

  Widget _panel(BuildContext context) => _ConfirmPanel(
    config: widget,
    onCancel: _cancel,
    onDone: _controller.hide,
  );

  @override
  Widget build(BuildContext context) {
    const style = WePopperStyle(padding: EdgeInsets.all(12));
    if (widget.builder != null) {
      return WePopper.builder(
        controller: _controller,
        placement: widget.placement,
        showArrow: true,
        width: widget.width,
        disabled: widget.disabled,
        style: style,
        gap: 12,
        popupBuilder: _panel,
        builder: (context, _) => widget.builder!(context, _controller.show),
      );
    }
    return WePopper(
      controller: _controller,
      placement: widget.placement,
      showArrow: true,
      width: widget.width,
      disabled: widget.disabled,
      style: style,
      gap: 12,
      popupBuilder: _panel,
      child: widget.child!,
    );
  }
}

class _ConfirmPanel extends StatefulWidget {
  const _ConfirmPanel({
    required this.config,
    required this.onCancel,
    required this.onDone,
  });

  final WePopconfirm config;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  @override
  State<_ConfirmPanel> createState() => _ConfirmPanelState();
}

class _ConfirmPanelState extends State<_ConfirmPanel> {
  bool _loading = false;

  Future<void> _confirm() async {
    final FutureOr<void> Function()? onConfirm = widget.config.onConfirm;
    final FutureOr<void> result = onConfirm?.call();
    if (result is Future<void>) {
      setState(() => _loading = true);
      try {
        await result;
      } catch (error, stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stack,
            library: 'widgets_easier',
            context: ErrorDescription('while running WePopconfirm.onConfirm'),
          ),
        );
        if (mounted) setState(() => _loading = false);
        return;
      }
      if (mounted) setState(() => _loading = false);
    }
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final WeColorScheme colors = context.weColors;
    final WePopconfirm c = widget.config;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!c.hideIcon)
              Padding(
                padding: const EdgeInsets.only(right: 6, top: 2),
                child: Icon(
                  c.icon,
                  size: 16,
                  color: c.iconColor ?? colors.warning,
                ),
              ),
            Expanded(
              child: Text(
                c.title,
                style: TextStyle(color: colors.regularText, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WeButton(
              text: c.cancelText,
              size: SizeEnum.small,
              variant: WeButtonVariant.text,
              disabled: _loading,
              onPressed: widget.onCancel,
            ),
            const SizedBox(width: 8),
            WeButton(
              text: c.confirmText,
              size: SizeEnum.small,
              type: c.type,
              loading: _loading,
              onPressed: _confirm,
            ),
          ],
        ),
      ],
    );
  }
}
