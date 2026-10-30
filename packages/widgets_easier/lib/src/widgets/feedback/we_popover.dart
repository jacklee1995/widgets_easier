import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../overlay/we_popper.dart';

/// A floating card with an optional title, after Element Plus's
/// `el-popover`. Unlike [WeTooltip] it can hold any widget, and by default
/// opens on click.
///
/// ```dart
/// WePopover(
///   title: '库存明细',
///   width: 240,
///   contentBuilder: (context) => const StockList(),
///   child: const Text('查看'),
/// )
/// ```
///
/// For a button trigger use [WePopover.builder], so the button's own
/// `onPressed` toggles the card.
class WePopover extends StatelessWidget {
  const WePopover({
    super.key,
    required Widget this.child,
    this.title,
    this.content,
    this.contentBuilder,
    this.width = 200,
    this.placement = WePlacement.bottom,
    this.trigger = WePopperTrigger.click,
    this.showArrow = true,
    this.disabled = false,
    this.controller,
    this.onOpenChanged,
  }) : builder = null;

  const WePopover.builder({
    super.key,
    required Widget Function(BuildContext context, VoidCallback toggle)
    this.builder,
    this.title,
    this.content,
    this.contentBuilder,
    this.width = 200,
    this.placement = WePlacement.bottom,
    this.showArrow = true,
    this.disabled = false,
    this.controller,
    this.onOpenChanged,
  }) : child = null,
       trigger = WePopperTrigger.manual;

  final Widget? child;
  final Widget Function(BuildContext context, VoidCallback toggle)? builder;
  final String? title;

  /// Plain-text body.
  final String? content;

  /// Any widget as the body, shown below [content] if both are given.
  final WidgetBuilder? contentBuilder;

  /// Panel width; `null` sizes it to the content.
  final double? width;
  final WePlacement placement;
  final WePopperTrigger trigger;
  final bool showArrow;
  final bool disabled;
  final WePopperController? controller;
  final ValueChanged<bool>? onOpenChanged;

  Widget _body(BuildContext context) {
    final WeColorScheme colors = context.weColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                height: 1.3,
                color: colors.primaryText,
              ),
            ),
          ),
        if (content != null) Text(content!),
        if (contentBuilder != null) contentBuilder!(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const style = WePopperStyle(padding: EdgeInsets.all(12));
    if (builder != null) {
      return WePopper.builder(
        controller: controller,
        placement: placement,
        showArrow: showArrow,
        width: width,
        disabled: disabled,
        style: style,
        gap: 12,
        onOpenChanged: onOpenChanged,
        popupBuilder: _body,
        builder: builder!,
      );
    }
    return WePopper(
      controller: controller,
      placement: placement,
      trigger: trigger,
      showArrow: showArrow,
      width: width,
      disabled: disabled,
      style: style,
      gap: 12,
      onOpenChanged: onOpenChanged,
      popupBuilder: _body,
      child: child!,
    );
  }
}
