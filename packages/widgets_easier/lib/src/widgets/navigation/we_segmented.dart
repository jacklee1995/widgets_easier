import 'package:flutter/material.dart';

import '../../core/core.dart';

/// One choice of a [WeSegmented].
class WeSegmentedOption<T> {
  const WeSegmentedOption(
    this.value,
    this.label, {
    this.icon,
    this.disabled = false,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool disabled;
}

/// A single-select control where the options sit side by side and the active
/// one is raised, after `el-segmented`.
///
/// ```dart
/// WeSegmented<String>(
///   value: range,
///   onChanged: (v) => setState(() => range = v),
///   options: const [
///     WeSegmentedOption('d', 'Day'),
///     WeSegmentedOption('w', 'Week'),
///     WeSegmentedOption('m', 'Month'),
///   ],
/// )
/// ```
class WeSegmented<T> extends StatelessWidget {
  const WeSegmented({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.size = SizeEnum.defaultSize,
    this.block = false,
    this.type,
  });

  final List<WeSegmentedOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;
  final SizeEnum size;

  /// Stretch to the full width and share it evenly.
  final bool block;

  /// Colour the active option with a semantic colour instead of the neutral
  /// raised look.
  final SemanticEnum? type;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final metrics = we.sizes.control(size);

    final List<Widget> cells = [
      for (final o in options)
        _Cell(
          option: o,
          active: o.value == value,
          fontSize: metrics.fontSize,
          padding: metrics.horizontalPadding * 0.75,
          type: type,
          onTap: o.disabled ? null : () => onChanged(o.value),
        ),
    ];

    return Container(
      height: metrics.height,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.lightFill,
        borderRadius: BorderRadius.circular(we.radius.base + 2),
      ),
      child: Row(
        mainAxisSize: block ? MainAxisSize.max : MainAxisSize.min,
        children: block ? [for (final c in cells) Expanded(child: c)] : cells,
      ),
    );
  }
}

class _Cell<T> extends StatefulWidget {
  const _Cell({
    required this.option,
    required this.active,
    required this.fontSize,
    required this.padding,
    required this.onTap,
    this.type,
  });

  final WeSegmentedOption<T> option;
  final bool active;
  final double fontSize;
  final double padding;
  final SemanticEnum? type;
  final VoidCallback? onTap;

  @override
  State<_Cell<T>> createState() => _CellState<T>();
}

class _CellState<T> extends State<_Cell<T>> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final bool disabled = widget.option.disabled;
    final Color? accent = widget.type == null
        ? null
        : colors.semantic(widget.type!);

    final Color bg = widget.active
        ? (accent ?? colors.baseBackground)
        : _hover && !disabled
        ? colors.baseFill
        : Colors.transparent;
    final Color fg = disabled
        ? colors.disabledText
        : widget.active
        ? (accent != null ? colors.onSemantic : colors.primaryText)
        : colors.regularText;

    return MouseRegion(
      cursor: disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: widget.padding),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(we.radius.base),
            boxShadow: widget.active && accent == null
                ? we.shadows.lighter
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.option.icon != null) ...[
                Icon(widget.option.icon, size: widget.fontSize + 2, color: fg),
                const SizedBox(width: 4),
              ],
              Text(
                widget.option.label,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  height: 1,
                  fontWeight: widget.active ? FontWeight.w600 : FontWeight.w400,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
