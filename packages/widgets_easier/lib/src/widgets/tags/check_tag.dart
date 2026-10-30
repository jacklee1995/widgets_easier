part of 'tag.dart';

/// A tag that behaves like a checkbox.
///
/// Sometimes a form needs a checkbox, but the button-style checkbox does not
/// fit the design. A `CheckTag` fills that gap: it is a [Tag] that toggles
/// between a *checked* and an *unchecked* state when tapped.
///
/// When checked it looks like a normal [Tag] of the given [type] and [theme].
/// When unchecked it flattens to a light grey fill with grey text and no
/// visible border, so the eye is drawn to the selected items.
///
/// The widget works in two modes:
///
/// * **Uncontrolled** – leave [checked] `null`. The tag keeps its own state,
///   starting from [initialChecked], and reports every change through the
///   callbacks.
/// * **Controlled** – pass [checked]. The tag renders exactly that value and
///   never changes it by itself; update your state in [onChanged] and rebuild.
///
/// ```dart
/// CheckTag(
///   'Flutter',
///   checked: _selected,
///   onChanged: (value) => setState(() => _selected = value),
/// )
/// ```
///
/// Three callbacks are available. [onChanged] receives the new value on every
/// toggle, while [onChecked] and [onUnchecked] fire only for the matching
/// transition, which reads better when the two directions do different work.
///
/// The tag is focusable; <kbd>Space</kbd> and <kbd>Enter</kbd> toggle it.
class CheckTag extends StatefulWidget {
  /// The label of the tag.
  final String text;

  /// The current value in controlled mode.
  ///
  /// When `null` the tag manages its own state, starting at [initialChecked].
  final bool? checked;

  /// The starting value in uncontrolled mode. Ignored when [checked] is set.
  final bool initialChecked;

  /// Called with the new value every time the tag is toggled.
  final ValueChanged<bool>? onChanged;

  /// Called when the tag goes from unchecked to checked.
  final VoidCallback? onChecked;

  /// Called when the tag goes from checked to unchecked.
  final VoidCallback? onUnchecked;

  /// Whether the tag ignores input. A disabled tag is drawn dimmed.
  final bool disabled;

  /// The semantic colour used while checked.
  final SemanticEnum type;

  /// A custom accent colour used while checked. Takes precedence over [type].
  final Color? color;

  /// The appearance of the checked state: `plain`, `light` or `dark`.
  ///
  /// Defaults to [TagThemeEnum.light], which is the Element Plus look.
  final TagThemeEnum theme;

  /// The size of the tag.
  final SizeEnum size;

  /// The corner radius. Falls back to the theme's base radius.
  final double? radius;

  /// An explicit height, overriding [size].
  final double? height;

  /// An explicit width. When `null` the tag is as wide as its content.
  final double? width;

  /// Whether the tag hugs its content. Set to `false` to fill the parent.
  final bool shrink;

  /// Whether to draw a check mark before the label while checked.
  final bool showCheckIcon;

  /// Whether the tag requests focus when first built.
  final bool autofocus;

  /// An optional focus node to control keyboard focus from outside.
  final FocusNode? focusNode;

  const CheckTag(
    this.text, {
    super.key,
    this.checked,
    this.initialChecked = false,
    this.onChanged,
    this.onChecked,
    this.onUnchecked,
    this.disabled = false,
    this.type = SemanticEnum.primary,
    this.color,
    this.theme = TagThemeEnum.light,
    this.size = SizeEnum.defaultSize,
    this.radius,
    this.height,
    this.width,
    this.shrink = true,
    this.showCheckIcon = false,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<CheckTag> createState() => _CheckTagState();
}

class _CheckTagState extends State<CheckTag> {
  static const Duration _animationDuration = Duration(milliseconds: 150);

  late bool _checked;
  bool _hovered = false;
  bool _focused = false;

  bool get _isControlled => widget.checked != null;

  /// The value currently rendered, whichever mode the tag is in.
  bool get _value => widget.checked ?? _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.checked ?? widget.initialChecked;
  }

  @override
  void didUpdateWidget(CheckTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the internal copy in step so a tag that stops being controlled
    // carries on from the last value it showed rather than jumping back.
    if (widget.checked != null && widget.checked != oldWidget.checked) {
      _checked = widget.checked!;
    }
  }

  void _toggle() {
    if (widget.disabled) return;
    final next = !_value;
    if (!_isControlled) {
      setState(() => _checked = next);
    }
    widget.onChanged?.call(next);
    if (next) {
      widget.onChecked?.call();
    } else {
      widget.onUnchecked?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final WeTheme weTheme = WeTheme.of(context);
    final WeColorScheme colors = weTheme.colors;
    final WeControlSize metrics = weTheme.sizes.compact(widget.size);
    final Color accent = widget.color ?? colors.semantic(widget.type);

    final paint = _value
        ? _TagPaint.themed(colors, widget.theme, accent)
        : _TagPaint(
            background: colors.lightFill,
            foreground: colors.secondaryText,
            border: null,
          );

    final Color? background = _resolveBackground(colors, paint, accent);
    final Color foreground = _resolveForeground(colors, paint);

    // Always reserve the 1 px outline so toggling never shifts the layout;
    // states without an outline draw it transparent.
    final Color borderColor = switch (paint.border) {
      null => Colors.transparent,
      final outline when widget.disabled => outline.withValues(alpha: 0.5),
      final outline => outline,
    };

    final double height = widget.height != null && widget.height! > 12
        ? widget.height!
        : metrics.height;

    final Widget tag = FocusableActionDetector(
      enabled: !widget.disabled,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      mouseCursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onShowHoverHighlight: (value) => setState(() => _hovered = value),
      onShowFocusHighlight: (value) => setState(() => _focused = value),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _toggle();
            return null;
          },
        ),
      },
      child: Semantics(
        button: true,
        enabled: !widget.disabled,
        checked: _value,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.disabled ? null : _toggle,
          child: AnimatedContainer(
            duration: _animationDuration,
            curve: Curves.easeOut,
            height: height,
            width: widget.width,
            padding: EdgeInsets.symmetric(
              horizontal: metrics.horizontalPadding,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(
                widget.radius ?? weTheme.radius.base,
              ),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: _focused && !widget.disabled
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.35),
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.showCheckIcon && _value) ...[
                  Icon(Icons.check, size: metrics.iconSize, color: foreground),
                  SizedBox(width: metrics.spacing),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: foreground,
                    fontSize: metrics.fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return widget.shrink ? IntrinsicWidth(child: tag) : tag;
  }

  /// The fill, taking the disabled and hover states into account.
  Color? _resolveBackground(
    WeColorScheme colors,
    _TagPaint paint,
    Color accent,
  ) {
    if (widget.disabled) {
      if (!_value) return colors.lightFill;
      return switch (widget.theme) {
        TagThemeEnum.dark => accent.withValues(alpha: 0.5),
        TagThemeEnum.light => accent.withValues(alpha: 0.05),
        TagThemeEnum.plain => Colors.transparent,
      };
    }
    if (!_hovered) return paint.background;
    if (!_value) return colors.darkFill;
    return switch (widget.theme) {
      TagThemeEnum.dark => accent.withValues(alpha: 0.85),
      TagThemeEnum.light => accent.withValues(alpha: 0.2),
      TagThemeEnum.plain => accent.withValues(alpha: 0.1),
    };
  }

  /// The text and icon colour, dimmed while disabled.
  Color _resolveForeground(WeColorScheme colors, _TagPaint paint) {
    if (!widget.disabled) return paint.foreground;
    if (!_value) return colors.disabledText;
    return paint.foreground.withValues(alpha: 0.5);
  }
}
