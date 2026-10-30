import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../overlay/we_popper.dart';

/// Colour scheme of a [WeTooltip], after Element Plus's `effect`.
enum WeTooltipEffect {
  /// Dark panel, light text. The default.
  dark,

  /// Light panel with a border, like a popover.
  light,
}

/// A short hint shown while the pointer rests on [child], after Element
/// Plus's `el-tooltip`.
///
/// On touch a hover tooltip opens on long press instead and closes itself
/// after [touchDuration], as Material tooltips do; a plain tap still goes to
/// the [child].
///
/// ```dart
/// WeTooltip(
///   content: '编辑',
///   child: WeButton.icon(Icons.edit_outlined, onPressed: edit),
/// )
/// ```
///
/// Platform: desktop and web; on touch it opens on long press.
class WeTooltip extends StatefulWidget {
  const WeTooltip({
    super.key,
    required this.child,
    this.content,
    this.contentBuilder,
    this.effect = WeTooltipEffect.dark,
    this.placement = WePlacement.top,
    this.trigger = WePopperTrigger.hover,
    this.showArrow = true,
    this.showAfter = Duration.zero,
    this.hideAfter = const Duration(milliseconds: 150),
    this.maxWidth = 300,
    this.disabled = false,
    this.controller,
    this.touchDuration = const Duration(milliseconds: 1500),
  }) : assert(
         content != null || contentBuilder != null,
         'A tooltip needs content or a contentBuilder.',
       );

  final Widget child;

  /// Plain text of the hint.
  final String? content;

  /// Rich content, used instead of [content].
  final WidgetBuilder? contentBuilder;

  final WeTooltipEffect effect;
  final WePlacement placement;
  final WePopperTrigger trigger;
  final bool showArrow;
  final Duration showAfter;
  final Duration hideAfter;
  final double maxWidth;
  final bool disabled;
  final WePopperController? controller;

  /// How long a long-press tooltip stays up on touch.
  final Duration touchDuration;

  @override
  State<WeTooltip> createState() => _WeTooltipState();
}

class _WeTooltipState extends State<WeTooltip> {
  WePopperController? _own;
  Timer? _autoHide;

  WePopperController get _controller =>
      widget.controller ?? (_own ??= WePopperController());

  @override
  void dispose() {
    _autoHide?.cancel();
    _own?.dispose();
    super.dispose();
  }

  void _longPress() {
    if (widget.disabled) return;
    _controller.show();
    _autoHide?.cancel();
    _autoHide = Timer(widget.touchDuration, () {
      if (mounted) _controller.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    final WeColorScheme colors = context.weColors;
    final bool dark = widget.effect == WeTooltipEffect.dark;
    // 深色效果用正文色做底，这样暗色主题下会自然反转成浅底深字。
    final Color bg = dark ? colors.primaryText : colors.overlayBackground;
    final Color fg = dark ? colors.overlayBackground : colors.regularText;
    final bool longPress =
        widget.trigger == WePopperTrigger.hover && WePlatform.isTouch(context);

    return WePopper(
      controller: _controller,
      placement: widget.placement,
      trigger: longPress ? WePopperTrigger.manual : widget.trigger,
      showArrow: widget.showArrow,
      showAfter: widget.showAfter,
      hideAfter: widget.hideAfter,
      maxWidth: widget.maxWidth,
      disabled: widget.disabled,
      gap: 10,
      style: WePopperStyle(
        backgroundColor: bg,
        borderColor: dark ? bg : colors.lighterBorder,
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        radius: 4,
        shadow: !dark,
      ),
      popupBuilder: (context) => DefaultTextStyle.merge(
        style: TextStyle(color: fg, fontSize: 12, height: 1.5),
        child: widget.contentBuilder?.call(context) ?? Text(widget.content!),
      ),
      child: longPress
          ? GestureDetector(onLongPress: _longPress, child: widget.child)
          : widget.child,
    );
  }
}
