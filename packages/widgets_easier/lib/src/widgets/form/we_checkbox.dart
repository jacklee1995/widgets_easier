import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A tick box with a label, after `el-checkbox`.
///
/// [value] `null` renders the indeterminate dash, used by a "select all" box
/// when only some rows are selected.
///
/// ```dart
/// WeCheckbox(value: agreed, label: 'I agree', onChanged: (v) => ...)
/// WeCheckbox(value: null, onChanged: selectAll)   // indeterminate
/// ```
class WeCheckbox extends StatefulWidget {
  const WeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.disabled = false,
    this.size = SizeEnum.defaultSize,
    this.type = SemanticEnum.primary,
    this.border = false,
  });

  /// `true`, `false` or `null` for indeterminate.
  final bool? value;

  /// Receives the next value; indeterminate resolves to `true`.
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool disabled;
  final SizeEnum size;
  final SemanticEnum type;

  /// Draw an outline around box and label, like `el-checkbox border`.
  final bool border;

  @override
  State<WeCheckbox> createState() => _WeCheckboxState();
}

class _WeCheckboxState extends State<WeCheckbox> {
  bool _hover = false;

  bool get _enabled => !widget.disabled && widget.onChanged != null;

  void _toggle() {
    if (_enabled) widget.onChanged!(widget.value != true);
  }

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final metrics = we.sizes.control(widget.size);
    final double box = metrics.fontSize + 2;
    final bool checked = widget.value == true;
    final bool indeterminate = widget.value == null;
    final Color accent = colors.semantic(widget.type);
    final bool on = checked || indeterminate;

    final Color fill = !_enabled
        ? colors.lightFill
        : on
        ? accent
        : colors.overlayBackground;
    final Color outline = !_enabled
        ? colors.lightBorder
        : on || _hover
        ? accent
        : colors.baseBorder;

    final Widget square = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: box,
      height: box,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(we.radius.small + 1),
        border: Border.all(color: outline),
      ),
      child: indeterminate
          ? Center(
              child: Container(
                width: box * 0.55,
                height: 2,
                color: _enabled ? colors.onSemantic : colors.disabledText,
              ),
            )
          : checked
          ? Icon(
              Icons.check_rounded,
              size: box - 3,
              color: _enabled ? colors.onSemantic : colors.disabledText,
            )
          : null,
    );

    Widget body = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        square,
        if (widget.label != null) ...[
          SizedBox(width: metrics.spacing),
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: metrics.fontSize,
              color: !_enabled
                  ? colors.disabledText
                  : checked
                  ? accent
                  : colors.regularText,
            ),
          ),
        ],
      ],
    );

    if (widget.border) {
      body = Container(
        height: metrics.height,
        padding: EdgeInsets.symmetric(
          horizontal: metrics.horizontalPadding * 0.6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(we.radius.base),
          border: Border.all(color: checked ? accent : colors.baseBorder),
        ),
        child: body,
      );
    }

    return Semantics(
      checked: checked,
      mixed: indeterminate,
      enabled: _enabled,
      child: FocusableActionDetector(
        enabled: _enabled,
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onShowHoverHighlight: (v) => setState(() => _hover = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _toggle();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: body,
        ),
      ),
    );
  }
}

/// Several [WeCheckbox]es bound to one set of values, after `el-checkbox-group`.
class WeCheckboxGroup<T> extends StatelessWidget {
  const WeCheckboxGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.disabled = false,
    this.size = SizeEnum.defaultSize,
    this.border = false,
    this.spacing = 16,
    this.runSpacing = 8,
  });

  /// Value → label.
  final Map<T, String> options;
  final Set<T> value;
  final ValueChanged<Set<T>> onChanged;

  /// Lower bound on the number of checked options.
  final int? min;

  /// Upper bound on the number of checked options.
  final int? max;
  final bool disabled;
  final SizeEnum size;
  final bool border;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final e in options.entries)
          WeCheckbox(
            label: e.value,
            size: size,
            border: border,
            value: value.contains(e.key),
            disabled:
                disabled ||
                (!value.contains(e.key) &&
                    max != null &&
                    value.length >= max!) ||
                (value.contains(e.key) && min != null && value.length <= min!),
            onChanged: (v) {
              final next = {...value};
              v ? next.add(e.key) : next.remove(e.key);
              onChanged(next);
            },
          ),
      ],
    );
  }
}
