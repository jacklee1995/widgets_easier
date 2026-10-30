import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';
import 'we_form.dart';

/// A single-line text field styled like `el-input`, with prefix / suffix
/// icons, a clear button and three sizes.
///
/// ```dart
/// WeInput(hint: 'Search goods', prefixIcon: Icons.search, clearable: true, onChanged: filter)
/// WeInput(controller: c, prepend: Text('https://'), append: WeButton(text: 'Go', ...))
/// ```
class WeInput extends StatefulWidget {
  const WeInput({
    super.key,
    this.controller,
    this.initialValue,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.prepend,
    this.append,
    this.clearable = false,
    this.disabled = false,
    this.readOnly = false,
    this.obscure = false,
    this.showPasswordToggle = false,
    this.size = SizeEnum.defaultSize,
    this.width,
    this.maxLength,
    this.showWordLimit = false,
    this.keyboardType,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onSuffixTap,
    this.status,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  /// A widget fused to the left edge, like `el-input`'s `prepend` slot.
  final Widget? prepend;

  /// A widget fused to the right edge, like `el-input`'s `append` slot.
  final Widget? append;

  /// Shows a clear button when there is text.
  final bool clearable;
  final bool disabled;
  final bool readOnly;
  final bool obscure;

  /// Adds an eye icon toggling [obscure].
  final bool showPasswordToggle;
  final SizeEnum size;
  final double? width;
  final int? maxLength;

  /// Shows `n / max` at the trailing edge.
  final bool showWordLimit;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSuffixTap;

  /// Colours the border, e.g. `SemanticEnum.danger` for a validation error.
  /// A surrounding [WeFormItem] sets it on error.
  final SemanticEnum? status;

  @override
  State<WeInput> createState() => _WeInputState();
}

class _WeInputState extends State<WeInput> {
  late TextEditingController _controller;
  late FocusNode _focus;
  bool _ownsController = false;
  bool _ownsFocus = false;
  bool _hover = false;
  bool _focused = false;
  late bool _obscure = widget.obscure;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _ownsController = widget.controller == null;
    _focus = widget.focusNode ?? FocusNode();
    _ownsFocus = widget.focusNode == null;
    _focus.addListener(_onFocus);
    _controller.addListener(_onText);
  }

  @override
  void didUpdateWidget(WeInput old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      _controller.removeListener(_onText);
      if (_ownsController) _controller.dispose();
      _controller = widget.controller ?? TextEditingController();
      _ownsController = widget.controller == null;
      _controller.addListener(_onText);
    }
    if (old.focusNode != widget.focusNode) {
      _focus.removeListener(_onFocus);
      if (_ownsFocus) _focus.dispose();
      _focus = widget.focusNode ?? FocusNode();
      _ownsFocus = widget.focusNode == null;
      _focus.addListener(_onFocus);
    }
    if (old.obscure != widget.obscure) _obscure = widget.obscure;
  }

  @override
  void dispose() {
    _controller.removeListener(_onText);
    _focus.removeListener(_onFocus);
    if (_ownsController) _controller.dispose();
    if (_ownsFocus) _focus.dispose();
    super.dispose();
  }

  WeFormItemState? _formItem;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formItem = WeFormItem.maybeOf(context);
  }

  void _onFocus() {
    final bool had = _focused;
    setState(() => _focused = _focus.hasFocus);
    if (had && !_focus.hasFocus) _formItem?.onBlur();
  }

  void _onText() => setState(() {});

  void _changed(String value) {
    widget.onChanged?.call(value);
    _formItem?.onChange();
  }

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final SizeEnum size = widget.size == SizeEnum.defaultSize
        ? _formItem?.size ?? widget.size
        : widget.size;
    final metrics = we.sizes.control(size);
    final bool enabled = !widget.disabled && !(_formItem?.disabled ?? false);
    final SemanticEnum? status = widget.status ?? _formItem?.status;
    final Color accent = status != null
        ? colors.semantic(status)
        : colors.primary;

    final Color borderColor = !enabled
        ? colors.lightBorder
        : _focused
        ? accent
        : status != null
        ? accent
        : _hover
        ? colors.darkBorder
        : colors.baseBorder;

    final bool hasText = _controller.text.isNotEmpty;
    final double iconSize = metrics.iconSize;
    final Color iconColor = colors.placeholderText;

    final List<Widget> trailing = [
      if (widget.clearable && hasText && enabled && !widget.readOnly)
        _IconButton(
          icon: Icons.cancel_rounded,
          size: iconSize,
          color: iconColor,
          onTap: () {
            _controller.clear();
            _changed('');
          },
        ),
      if (widget.showPasswordToggle)
        _IconButton(
          icon: _obscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: iconSize,
          color: iconColor,
          onTap: () => setState(() => _obscure = !_obscure),
        ),
      if (widget.showWordLimit && widget.maxLength != null)
        Text(
          '${_controller.text.characters.length} / ${widget.maxLength}',
          style: TextStyle(fontSize: 11.5, color: iconColor),
        ),
      if (widget.suffixIcon != null)
        _IconButton(
          icon: widget.suffixIcon!,
          size: iconSize,
          color: iconColor,
          onTap: widget.onSuffixTap,
        ),
    ];

    final BorderRadius radius = BorderRadius.horizontal(
      left: widget.prepend == null
          ? Radius.circular(we.radius.base)
          : Radius.zero,
      right: widget.append == null
          ? Radius.circular(we.radius.base)
          : Radius.zero,
    );

    Widget field = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: metrics.height,
      padding: EdgeInsets.symmetric(
        horizontal: metrics.horizontalPadding * 0.7,
      ),
      decoration: BoxDecoration(
        color: enabled ? colors.overlayBackground : colors.lightFill,
        borderRadius: radius,
        border: Border.all(color: borderColor),
        boxShadow: _focused && enabled
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.18),
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          if (widget.prefixIcon != null) ...[
            Icon(widget.prefixIcon, size: iconSize, color: iconColor),
            SizedBox(width: metrics.spacing),
          ],
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              enabled: enabled,
              readOnly: widget.readOnly,
              obscureText: _obscure,
              autofocus: widget.autofocus,
              maxLength: widget.maxLength,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              textAlign: widget.textAlign,
              textAlignVertical: TextAlignVertical.center,
              onChanged: _changed,
              onSubmitted: widget.onSubmitted,
              cursorColor: accent,
              cursorHeight: metrics.fontSize + 2,
              style: TextStyle(
                fontSize: metrics.fontSize,
                color: enabled ? colors.primaryText : colors.disabledText,
              ),
              decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                counterText: '',
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: TextStyle(
                  fontSize: metrics.fontSize,
                  color: colors.placeholderText,
                ),
              ),
            ),
          ),
          for (final t in trailing) ...[SizedBox(width: metrics.spacing), t],
        ],
      ),
    );

    field = MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: field,
    );

    if (widget.prepend != null || widget.append != null) {
      // Addons overlap the field by 1px so the shared edge is a single line.
      final double shift = widget.prepend != null ? 1 : 0;
      field = Row(
        children: [
          if (widget.prepend != null)
            _Addon(
              height: metrics.height,
              left: true,
              borderColor: colors.baseBorder,
              child: widget.prepend!,
            ),
          Expanded(
            child: Transform.translate(offset: Offset(-shift, 0), child: field),
          ),
          if (widget.append != null)
            Transform.translate(
              offset: Offset(-shift - 1, 0),
              child: _Addon(
                height: metrics.height,
                left: false,
                borderColor: colors.baseBorder,
                child: widget.append!,
              ),
            ),
        ],
      );
    }

    return widget.width != null
        ? SizedBox(width: widget.width, child: field)
        : field;
  }
}

class _Addon extends StatelessWidget {
  const _Addon({
    required this.height,
    required this.left,
    required this.borderColor,
    required this.child,
  });

  final double height;
  final bool left;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final r = Radius.circular(we.radius.base);
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.lightFill,
        borderRadius: BorderRadius.horizontal(
          left: left ? r : Radius.zero,
          right: left ? Radius.zero : r,
        ),
        border: Border.all(color: borderColor),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(fontSize: 13, color: colors.regularText),
        child: child,
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.size,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget i = Icon(icon, size: size, color: color);
    if (onTap == null) return i;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: i,
      ),
    );
  }
}
