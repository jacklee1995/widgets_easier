import 'package:flutter/material.dart';

import '../../core/core.dart';

/// One choice of a [WeRadioGroup].
class WeRadioOption<T> {
  const WeRadioOption(this.value, this.label, {this.disabled = false});

  final T value;
  final String label;
  final bool disabled;
}

/// How a [WeRadioGroup] draws its options.
enum WeRadioStyle {
  /// Round dots with labels. The default.
  dot,

  /// Fused buttons, like `el-radio-button`.
  button,
}

/// A single-select group, after `el-radio-group`.
///
/// ```dart
/// WeRadioGroup<int>(
///   value: freight,
///   onChanged: (v) => setState(() => freight = v),
///   options: const [WeRadioOption(0, 'Free'), WeRadioOption(1, 'Flat rate')],
/// )
/// WeRadioGroup(style: WeRadioStyle.button, ...)
/// ```
class WeRadioGroup<T> extends StatelessWidget {
  const WeRadioGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.style = WeRadioStyle.dot,
    this.size = SizeEnum.defaultSize,
    this.type = SemanticEnum.primary,
    this.disabled = false,
    this.spacing = 20,
    this.runSpacing = 8,
    this.vertical = false,
  });

  final List<WeRadioOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final WeRadioStyle style;
  final SizeEnum size;
  final SemanticEnum type;
  final bool disabled;
  final double spacing;
  final double runSpacing;

  /// Stack the dots vertically. Ignored for [WeRadioStyle.button].
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    if (style == WeRadioStyle.button) {
      final double r = we.radius.base;
      final int last = options.length - 1;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < options.length; i++)
            // Overlap borders by 1px so adjacent buttons share one line.
            Transform.translate(
              offset: Offset(-i.toDouble(), 0),
              child: _RadioButton<T>(
                option: options[i],
                selected: options[i].value == value,
                size: size,
                type: type,
                disabled: disabled || options[i].disabled,
                radius: BorderRadius.horizontal(
                  left: i == 0 ? Radius.circular(r) : Radius.zero,
                  right: i == last ? Radius.circular(r) : Radius.zero,
                ),
                onTap: onChanged == null
                    ? null
                    : () => onChanged!(options[i].value),
              ),
            ),
        ],
      );
    }

    final dots = [
      for (final o in options)
        _RadioDot<T>(
          option: o,
          selected: o.value == value,
          size: size,
          type: type,
          disabled: disabled || o.disabled,
          onTap: onChanged == null ? null : () => onChanged!(o.value),
        ),
    ];
    if (vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < dots.length; i++) ...[
            dots[i],
            if (i != dots.length - 1) SizedBox(height: runSpacing),
          ],
        ],
      );
    }
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: dots,
    );
  }
}

class _RadioDot<T> extends StatefulWidget {
  const _RadioDot({
    required this.option,
    required this.selected,
    required this.size,
    required this.type,
    required this.disabled,
    required this.onTap,
  });

  final WeRadioOption<T> option;
  final bool selected;
  final SizeEnum size;
  final SemanticEnum type;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  State<_RadioDot<T>> createState() => _RadioDotState<T>();
}

class _RadioDotState<T> extends State<_RadioDot<T>> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final metrics = we.sizes.control(widget.size);
    final double d = metrics.fontSize + 2;
    final bool enabled = !widget.disabled && widget.onTap != null;
    final Color accent = colors.semantic(widget.type);
    final Color outline = !enabled
        ? colors.lightBorder
        : widget.selected || _hover
        ? accent
        : colors.baseBorder;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? widget.onTap : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: d,
              height: d,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: !enabled
                    ? colors.lightFill
                    : widget.selected
                    ? accent
                    : colors.overlayBackground,
                border: Border.all(color: outline),
              ),
              child: widget.selected
                  ? Center(
                      child: Container(
                        width: d * 0.36,
                        height: d * 0.36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: enabled
                              ? colors.onSemantic
                              : colors.disabledText,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: metrics.spacing),
            Text(
              widget.option.label,
              style: TextStyle(
                fontSize: metrics.fontSize,
                color: !enabled
                    ? colors.disabledText
                    : widget.selected
                    ? accent
                    : colors.regularText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioButton<T> extends StatefulWidget {
  const _RadioButton({
    required this.option,
    required this.selected,
    required this.size,
    required this.type,
    required this.disabled,
    required this.radius,
    required this.onTap,
  });

  final WeRadioOption<T> option;
  final bool selected;
  final SizeEnum size;
  final SemanticEnum type;
  final bool disabled;
  final BorderRadius radius;
  final VoidCallback? onTap;

  @override
  State<_RadioButton<T>> createState() => _RadioButtonState<T>();
}

class _RadioButtonState<T> extends State<_RadioButton<T>> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final metrics = we.sizes.control(widget.size);
    final bool enabled = !widget.disabled && widget.onTap != null;
    final Color accent = colors.semantic(widget.type);

    final Color bg = widget.selected
        ? (enabled ? accent : colors.lighten(accent, 5))
        : colors.overlayBackground;
    final Color fg = !enabled
        ? (widget.selected ? colors.onSemantic : colors.disabledText)
        : widget.selected
        ? colors.onSemantic
        : _hover
        ? accent
        : colors.regularText;
    final Color border = widget.selected
        ? (enabled ? accent : colors.lighten(accent, 5))
        : colors.baseBorder;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: metrics.height,
          padding: EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: widget.radius,
            border: Border.all(color: border),
          ),
          child: Text(
            widget.option.label,
            style: TextStyle(
              fontSize: metrics.fontSize,
              fontWeight: widget.selected ? FontWeight.w500 : FontWeight.w400,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
