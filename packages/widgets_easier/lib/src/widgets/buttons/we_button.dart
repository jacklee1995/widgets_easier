import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../feedback/we_tooltip.dart';

/// How a [WeButton] is filled, after Element Plus' `el-button` variants.
enum WeButtonVariant {
  /// Solid fill in the semantic colour with white text. The default.
  solid,

  /// Tinted background with a coloured outline and text; fills on hover.
  plain,

  /// No border and no background until hovered.
  text,

  /// Looks like inline text; no padding, no background.
  link,
}

/// A button that follows the Element Plus button model: a semantic [type],
/// a fill [variant], three sizes, and `round` / `circle` / `loading` /
/// `disabled` states, all painted from [WeTheme] tokens.
///
/// ```dart
/// WeButton(text: 'Save', type: SemanticEnum.primary, onPressed: save)
/// WeButton(text: 'Cancel', variant: WeButtonVariant.plain, onPressed: pop)
/// WeButton.icon(Icons.delete, type: SemanticEnum.danger, circle: true, onPressed: remove)
/// ```
///
/// Leave [type] `null` for the neutral "default" button: a white surface with
/// a grey outline that turns to the primary colour on hover.
class WeButton extends StatefulWidget {
  const WeButton({
    super.key,
    this.text,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.type,
    this.variant = WeButtonVariant.solid,
    this.size = SizeEnum.defaultSize,
    this.round = false,
    this.circle = false,
    this.loading = false,
    this.disabled = false,
    this.block = false,
    this.color,
    this.gradient,
    this.borderRadius,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
  }) : assert(
         text != null || icon != null,
         'A button needs at least a text or an icon.',
       );

  /// An icon-only button. Sets [circle] to `true` by default.
  const WeButton.icon(
    IconData this.icon, {
    super.key,
    this.onPressed,
    this.type,
    this.variant = WeButtonVariant.solid,
    this.size = SizeEnum.defaultSize,
    this.circle = true,
    this.loading = false,
    this.disabled = false,
    this.color,
    this.gradient,
    this.borderRadius,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
  }) : text = null,
       trailingIcon = null,
       round = false,
       block = false;

  /// The label. May be `null` for an icon-only button.
  final String? text;

  /// An icon drawn before the label.
  final IconData? icon;

  /// An icon drawn after the label.
  final IconData? trailingIcon;

  /// Called when the button is activated. `null` disables the button.
  final VoidCallback? onPressed;

  /// The semantic colour. `null` gives the neutral default button.
  final SemanticEnum? type;

  final WeButtonVariant variant;
  final SizeEnum size;

  /// Fully rounded ends.
  final bool round;

  /// A circular button as wide as it is tall; meant for a lone icon.
  final bool circle;

  /// Replaces the leading icon with a spinner and blocks input.
  final bool loading;

  /// Blocks input and dims the button. Equivalent to a `null` [onPressed].
  final bool disabled;

  /// Stretches the button to the full available width.
  final bool block;

  /// Overrides the colour derived from [type].
  final Color? color;

  /// A gradient fill; only used by [WeButtonVariant.solid].
  final Gradient? gradient;

  /// Overrides the corner radius, e.g. when the button sits in a group.
  final BorderRadius? borderRadius;

  /// Shown on hover, useful for icon-only buttons.
  final String? tooltip;

  final bool autofocus;
  final FocusNode? focusNode;

  bool get _enabled => onPressed != null && !disabled && !loading;

  @override
  State<WeButton> createState() => _WeButtonState();
}

class _WeButtonState extends State<WeButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  void _activate() {
    if (widget._enabled) widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final metrics = we.sizes.control(widget.size);
    final style = _resolve(colors);
    final bool enabled = widget._enabled;

    final BorderRadius radius =
        widget.borderRadius ??
        BorderRadius.circular(
          widget.round || widget.circle ? metrics.height / 2 : we.radius.base,
        );

    final bool isLink = widget.variant == WeButtonVariant.link;
    final double iconSize = metrics.iconSize;
    final bool iconOnly = widget.text == null;

    final children = <Widget>[
      if (widget.loading)
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: style.foreground,
          ),
        )
      else if (widget.icon != null)
        Icon(widget.icon, size: iconSize, color: style.foreground),
      if (widget.text != null) ...[
        if (widget.icon != null || widget.loading)
          SizedBox(width: metrics.spacing),
        Text(
          widget.text!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: metrics.fontSize,
            fontWeight: FontWeight.w500,
            height: 1,
            color: style.foreground,
            decoration: isLink && _hovered && enabled
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: style.foreground,
          ),
        ),
      ],
      if (widget.trailingIcon != null) ...[
        SizedBox(width: metrics.spacing),
        Icon(widget.trailingIcon, size: iconSize, color: style.foreground),
      ],
    ];

    Widget body = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      height: isLink ? null : metrics.height,
      width: widget.circle
          ? metrics.height
          : (widget.block ? double.infinity : null),
      padding: isLink || widget.circle
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(
              horizontal: iconOnly
                  ? metrics.horizontalPadding / 2
                  : metrics.horizontalPadding,
            ),
      decoration: BoxDecoration(
        color: widget.gradient != null ? null : style.background,
        gradient: widget.variant == WeButtonVariant.solid && enabled
            ? widget.gradient
            : null,
        borderRadius: radius,
        border: isLink
            ? null
            : Border.all(color: style.border ?? Colors.transparent),
        boxShadow: _focused && enabled
            ? [
                BoxShadow(
                  color: style.accent.withValues(alpha: 0.3),
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );

    if (widget.block && !widget.circle) {
      body = SizedBox(width: double.infinity, child: body);
    }

    body = FocusableActionDetector(
      enabled: enabled,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      mouseCursor: enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onShowHoverHighlight: (v) => setState(() => _hovered = v),
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _activate();
            return null;
          },
        ),
      },
      child: Semantics(
        button: true,
        enabled: enabled,
        label: widget.text,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
          onTap: enabled ? _activate : null,
          child: body,
        ),
      ),
    );

    if (widget.tooltip != null) {
      body = WeTooltip(content: widget.tooltip!, child: body);
    }
    return body;
  }

  _ButtonStyle _resolve(WeColorScheme colors) {
    final bool enabled = widget._enabled;
    final bool neutral = widget.type == null && widget.color == null;
    final Color accent =
        widget.color ??
        (widget.type == null ? colors.primary : colors.semantic(widget.type!));
    final bool active = _pressed;
    final bool hover = _hovered && !active;

    switch (widget.variant) {
      case WeButtonVariant.solid:
        if (neutral) {
          if (!enabled) {
            return _ButtonStyle(
              background: colors.baseBackground,
              foreground: colors.disabledText,
              border: colors.lightBorder,
              accent: accent,
            );
          }
          if (hover || active) {
            return _ButtonStyle(
              background: colors.light(SemanticEnum.primary, 9),
              foreground: active ? colors.dark(SemanticEnum.primary) : accent,
              border: colors.light(SemanticEnum.primary, active ? 3 : 7),
              accent: accent,
            );
          }
          return _ButtonStyle(
            background: colors.baseBackground,
            foreground: colors.regularText,
            border: colors.baseBorder,
            accent: accent,
          );
        }
        if (!enabled) {
          final Color faded = colors.lighten(accent, 5);
          return _ButtonStyle(
            background: faded,
            foreground: colors.onSemantic,
            border: faded,
            accent: accent,
          );
        }
        final Color bg = active
            ? colors.darken(accent)
            : hover
            ? colors.lighten(accent, 3)
            : accent;
        return _ButtonStyle(
          background: bg,
          foreground: colors.onSemantic,
          border: bg,
          accent: accent,
        );

      case WeButtonVariant.plain:
        final Color tone = neutral ? colors.regularText : accent;
        if (!enabled) {
          return _ButtonStyle(
            background: neutral
                ? colors.baseBackground
                : colors.lighten(accent, 9),
            foreground: neutral
                ? colors.disabledText
                : colors.lighten(accent, 5),
            border: neutral ? colors.lightBorder : colors.lighten(accent, 8),
            accent: accent,
          );
        }
        if (hover || active) {
          final Color fill = active ? colors.darken(accent) : accent;
          return _ButtonStyle(
            background: fill,
            foreground: colors.onSemantic,
            border: fill,
            accent: accent,
          );
        }
        return _ButtonStyle(
          background: neutral
              ? colors.baseBackground
              : colors.lighten(accent, 9),
          foreground: tone,
          border: neutral ? colors.baseBorder : colors.lighten(accent, 5),
          accent: accent,
        );

      case WeButtonVariant.text:
        final Color tone = neutral ? colors.regularText : accent;
        if (!enabled) {
          return _ButtonStyle(
            background: null,
            foreground: colors.disabledText,
            border: null,
            accent: accent,
          );
        }
        return _ButtonStyle(
          background: active
              ? colors.darkFill
              : hover
              ? colors.lightFill
              : null,
          foreground: tone,
          border: null,
          accent: accent,
        );

      case WeButtonVariant.link:
        final Color tone = neutral ? colors.regularText : accent;
        if (!enabled) {
          return _ButtonStyle(
            background: null,
            foreground: colors.disabledText,
            border: null,
            accent: accent,
          );
        }
        return _ButtonStyle(
          background: null,
          foreground: hover || active ? colors.lighten(tone, 3) : tone,
          border: null,
          accent: accent,
        );
    }
  }
}

class _ButtonStyle {
  const _ButtonStyle({
    required this.background,
    required this.foreground,
    required this.border,
    required this.accent,
  });

  final Color? background;
  final Color foreground;
  final Color? border;
  final Color accent;
}

/// A row of [WeButton]s fused into one control, after `el-button-group`.
///
/// The outer corners are rounded and the inner ones squared; [type], [size]
/// and [variant] given here override those of the children so the group
/// reads as a unit.
class WeButtonGroup extends StatelessWidget {
  const WeButtonGroup({
    super.key,
    required this.children,
    this.type,
    this.variant,
    this.size,
  });

  final List<WeButton> children;
  final SemanticEnum? type;
  final WeButtonVariant? variant;
  final SizeEnum? size;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final double r = we.radius.base;
    final int last = children.length - 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < children.length; i++)
          // Overlap borders by 1px so adjacent buttons share one line.
          Transform.translate(
            offset: Offset(-i.toDouble(), 0),
            child: _rebuild(
              children[i],
              BorderRadius.horizontal(
                left: i == 0 ? Radius.circular(r) : Radius.zero,
                right: i == last ? Radius.circular(r) : Radius.zero,
              ),
            ),
          ),
      ],
    );
  }

  WeButton _rebuild(WeButton b, BorderRadius radius) => WeButton(
    key: b.key,
    text: b.text,
    icon: b.icon,
    trailingIcon: b.trailingIcon,
    onPressed: b.onPressed,
    type: type ?? b.type,
    variant: variant ?? b.variant,
    size: size ?? b.size,
    loading: b.loading,
    disabled: b.disabled,
    color: b.color,
    gradient: b.gradient,
    borderRadius: radius,
    tooltip: b.tooltip,
  );
}
