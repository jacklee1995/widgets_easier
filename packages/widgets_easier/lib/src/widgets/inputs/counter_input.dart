import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';
import 'counter_input_controller.dart';

/// Signature for the value callbacks of a [CounterInput].
typedef CounterInputChanged = void Function(double oldValue, double newValue);

/// A numeric field flanked by a decrement and an increment button.
///
/// The value can be changed by tapping the buttons, holding them down to
/// repeat, typing in the field, or pressing the arrow up / down keys while the
/// field has focus. It is always kept inside `[minValue, maxValue]` and
/// rounded to [decimals] fraction digits.
///
/// ```dart
/// CounterInput(
///   type: SemanticEnum.primary,
///   minValue: 0,
///   maxValue: 10,
///   step: 0.5,
///   onValueChanged: (oldValue, newValue) => debugPrint('$oldValue -> $newValue'),
/// )
/// ```
///
/// Colours and metrics come from [WeTheme]; the individual colour parameters
/// override them when set.
///
/// Platform: mobile (large tap targets).
class CounterInput extends StatefulWidget {
  /// Creates a counter input.
  const CounterInput({
    super.key,
    this.controller,
    this.focusNode,
    this.onIncrement,
    this.onDecrement,
    this.onValueChanged,
    this.onMin,
    this.onMax,
    this.onMinOverflow,
    this.onMaxOverflow,
    this.type = SemanticEnum.secondary,
    this.isOutlined = false,
    this.radius,
    this.size = SizeEnum.defaultSize,
    this.minValue = 0,
    this.maxValue = 100,
    this.step = 1,
    this.decimals,
    this.height,
    this.iconColor,
    this.backgroundColor,
    this.buttonColor,
    this.textColor,
    this.enabled = true,
    this.readOnly = false,
    this.textFieldWidth,
  }) : assert(
         minValue <= maxValue,
         'minValue ($minValue) must not be greater than maxValue ($maxValue).',
       ),
       assert(step > 0, 'step must be greater than zero, was $step.'),
       assert(decimals == null || decimals >= 0);

  /// Holds the value. When null an internal controller is created and
  /// disposed by this widget.
  final CounterInputController? controller;

  /// Focus node of the text field. When null an internal one is used.
  final FocusNode? focusNode;

  /// Called after the value grew, with the previous and the new value.
  final CounterInputChanged? onIncrement;

  /// Called after the value shrank, with the previous and the new value.
  final CounterInputChanged? onDecrement;

  /// Called after any change, with the previous and the new value.
  final CounterInputChanged? onValueChanged;

  /// Called when the value reaches [minValue].
  final VoidCallback? onMin;

  /// Called when the value reaches [maxValue].
  final VoidCallback? onMax;

  /// Called when decrementing is attempted while already at [minValue].
  final VoidCallback? onMinOverflow;

  /// Called when incrementing is attempted while already at [maxValue].
  final VoidCallback? onMaxOverflow;

  /// Semantic colour of the buttons and of the field background.
  final SemanticEnum type;

  /// Whether to draw outlined buttons instead of filled ones.
  final bool isOutlined;

  /// Corner radius of the outer edges. Defaults to `WeTheme.radius.base`.
  final double? radius;

  /// Size step; picks the metrics from `WeTheme.sizes.control`.
  final SizeEnum size;

  /// Smallest accepted value.
  final double minValue;

  /// Largest accepted value.
  final double maxValue;

  /// Amount added or removed per tap. Must be greater than zero.
  final double step;

  /// Fraction digits the value is rounded to, and the number of decimals the
  /// field accepts.
  ///
  /// Defaults to the precision implied by [step], [minValue] and [maxValue],
  /// which keeps values such as `0.1 + 0.2` from drifting. When set
  /// explicitly, the field also pads the displayed value to that many digits.
  final int? decimals;

  /// Overrides the height taken from the theme.
  final double? height;

  /// Colour of the `+` and `-` glyphs.
  final Color? iconColor;

  /// Background of the text field.
  final Color? backgroundColor;

  /// Fill of the buttons, or their outline when [isOutlined] is true.
  final Color? buttonColor;

  /// Colour of the typed value.
  final Color? textColor;

  /// Whether the counter reacts to input at all.
  final bool enabled;

  /// Whether typing is disabled while the buttons stay usable.
  final bool readOnly;

  /// Fixed width of the text field. When null it grows with its content.
  final double? textFieldWidth;

  @override
  State<CounterInput> createState() => _CounterInputState();
}

class _CounterInputState extends State<CounterInput> {
  /// Delay between two automatic steps while a button is held down.
  static const Duration _repeatInterval = Duration(milliseconds: 100);

  /// Floor for [CounterInput.height]; below this nothing is legible anyway.
  static const double _minHeight = 12;

  CounterInputController? _ownedController;
  FocusNode? _ownedFocusNode;
  Timer? _repeatTimer;
  late int _decimals;

  CounterInputController get _controller =>
      widget.controller ?? _ownedController!;

  FocusNode get _focusNode => widget.focusNode ?? _ownedFocusNode!;

  double get _min => math.min(widget.minValue, widget.maxValue);

  double get _max => math.max(widget.minValue, widget.maxValue);

  @override
  void initState() {
    super.initState();
    _ownedController = widget.controller == null
        ? CounterInputController()
        : null;
    _ownedFocusNode = widget.focusNode == null ? FocusNode() : null;
    _applyPrecision();
    _clampToRange();
    // Attached after the initial clamp: setState is not allowed from
    // initState.
    _controller.addListener(_handleControllerChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(CounterInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _ownedController)?.removeListener(
        _handleControllerChanged,
      );
      if (widget.controller != null) {
        _ownedController?.dispose();
        _ownedController = null;
      } else {
        _ownedController ??= CounterInputController(
          initialValue: oldWidget.controller?.value ?? 0,
        );
      }
      _controller.addListener(_handleControllerChanged);
    }

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _ownedFocusNode)?.removeListener(
        _handleFocusChanged,
      );
      if (widget.focusNode != null) {
        _ownedFocusNode?.dispose();
        _ownedFocusNode = null;
      } else {
        _ownedFocusNode ??= FocusNode();
      }
      _focusNode.addListener(_handleFocusChanged);
    }

    if (widget.controller != oldWidget.controller ||
        widget.decimals != oldWidget.decimals ||
        widget.step != oldWidget.step ||
        widget.minValue != oldWidget.minValue ||
        widget.maxValue != oldWidget.maxValue) {
      _applyPrecision();
      _clampToRange();
    }

    if (!widget.enabled) _stopRepeat();
  }

  @override
  void dispose() {
    _stopRepeat();
    _controller.removeListener(_handleControllerChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  /// Resolves how many fraction digits the value carries.
  void _applyPrecision() {
    _decimals =
        widget.decimals ??
        math.max(
          _countFractionDigits(widget.step),
          math.max(
            _countFractionDigits(widget.minValue),
            _countFractionDigits(widget.maxValue),
          ),
        );
    _decimals = _decimals.clamp(0, 15);
    // Only pad the display when a precision was asked for; a derived one is
    // just there to stop binary floating point drift.
    _controller.decimals = widget.decimals;
  }

  void _clampToRange() {
    final double normalized = _normalize(_controller.value);
    if (normalized != _controller.value) {
      _controller.setValue(normalized);
    }
    _controller.syncText(force: true);
  }

  void _handleControllerChanged() {
    // Rebuild so the buttons can dim once a bound is reached.
    if (mounted) setState(() {});
  }

  void _handleFocusChanged() {
    if (!_focusNode.hasFocus) _submitText();
  }

  /// Clamps [raw] into range and rounds it to [_decimals] digits.
  double _normalize(double raw) {
    if (raw.isNaN) return _controller.value;
    return double.parse(raw.clamp(_min, _max).toStringAsFixed(_decimals));
  }

  /// Applies [raw] and fires the callbacks describing the transition.
  void _commit(double raw) {
    final double previous = _controller.value;
    final double next = _normalize(raw);
    if (next == previous) return;

    _controller.setValue(next);
    widget.onValueChanged?.call(previous, next);
    if (next > previous) {
      widget.onIncrement?.call(previous, next);
    } else {
      widget.onDecrement?.call(previous, next);
    }
    if (next >= _max) widget.onMax?.call();
    if (next <= _min) widget.onMin?.call();
  }

  void _nudge({required bool increment}) {
    if (!widget.enabled) return;
    final double previous = _controller.value;
    final double target = increment
        ? previous + widget.step
        : previous - widget.step;

    if (_normalize(target) == previous) {
      // Already parked against the bound; holding the button any longer is
      // pointless.
      _stopRepeat();
      (increment ? widget.onMaxOverflow : widget.onMinOverflow)?.call();
      return;
    }
    _commit(target);
  }

  void _startRepeat({required bool increment}) {
    _stopRepeat();
    if (!widget.enabled) return;
    _repeatTimer = Timer.periodic(
      _repeatInterval,
      (_) => _nudge(increment: increment),
    );
  }

  void _stopRepeat() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  /// Takes whatever is typed in the field literally, then normalises it.
  void _submitText() {
    final double? parsed = double.tryParse(_controller.textController.text);
    if (parsed != null) _commit(parsed);
    _controller.syncText(force: true);
  }

  void _handleTextChanged(String text) {
    final double? parsed = double.tryParse(text);
    // Out-of-range and half-typed input is left alone until the field is
    // submitted: clamping on every keystroke rewrites the text under the
    // caret, which makes values such as "15" unreachable when the minimum
    // is 10.
    if (parsed == null || parsed < _min || parsed > _max) return;
    _commit(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final WeTheme weTheme = WeTheme.of(context);
    final WeColorScheme colors = weTheme.colors;
    final WeControlSize metrics = weTheme.sizes.control(widget.size);

    final double height = math.max(widget.height ?? metrics.height, _minHeight);
    final double scale = height / metrics.height;
    final double radius = widget.radius ?? weTheme.radius.base;
    final bool enabled = widget.enabled;

    final Color accent = colors.semantic(widget.type);
    final Color buttonFill = widget.buttonColor ?? accent;
    final Color iconColor =
        widget.iconColor ?? (widget.isOutlined ? accent : colors.onSemantic);

    final double value = _controller.value;
    final bool atMin = value <= _min;
    final bool atMax = value >= _max;

    Color resolveIcon(bool atBound) {
      if (!enabled) return colors.disabledText;
      return atBound ? iconColor.withValues(alpha: 0.45) : iconColor;
    }

    Widget button({required bool increment}) {
      return _CounterButton(
        icon: increment ? Icons.add : Icons.remove,
        semanticLabel: increment ? 'Increment' : 'Decrement',
        extent: height,
        iconSize: metrics.iconSize * scale,
        fill: widget.isOutlined
            ? Colors.transparent
            : (enabled ? buttonFill : colors.baseFill),
        outlineColor: widget.isOutlined
            ? (enabled ? buttonFill : colors.baseBorder)
            : null,
        iconColor: resolveIcon(increment ? atMax : atMin),
        borderRadius: BorderRadius.horizontal(
          left: increment ? Radius.zero : Radius.circular(radius),
          right: increment ? Radius.circular(radius) : Radius.zero,
        ),
        onTap: enabled ? () => _nudge(increment: increment) : null,
        onRepeatStart: () => _startRepeat(increment: increment),
        onRepeatEnd: _stopRepeat,
      );
    }

    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowUp): _IncrementIntent(),
        SingleActivator(LogicalKeyboardKey.arrowDown): _DecrementIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _IncrementIntent: CallbackAction<_IncrementIntent>(
            onInvoke: (_) {
              _nudge(increment: true);
              return null;
            },
          ),
          _DecrementIntent: CallbackAction<_DecrementIntent>(
            onInvoke: (_) {
              _nudge(increment: false);
              return null;
            },
          ),
        },
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              button(increment: false),
              _buildField(colors, metrics, height, scale, accent),
              button(increment: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    WeColorScheme colors,
    WeControlSize metrics,
    double height,
    double scale,
    Color accent,
  ) {
    final bool enabled = widget.enabled;
    final Color fill = widget.isOutlined
        ? Colors.transparent
        : (widget.backgroundColor ?? accent.withValues(alpha: 0.1));

    Widget field = TextField(
      controller: _controller.textController,
      focusNode: _focusNode,
      enabled: enabled,
      readOnly: widget.readOnly,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.numberWithOptions(
        decimal: _decimals > 0,
        signed: _min < 0,
      ),
      inputFormatters: <TextInputFormatter>[
        DecimalTextInputFormatter(signed: _min < 0, decimals: _decimals),
      ],
      style: TextStyle(
        color: enabled
            ? (widget.textColor ?? colors.primaryText)
            : colors.disabledText,
        fontSize: metrics.fontSize * scale,
      ),
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
      onChanged: _handleTextChanged,
      onSubmitted: (_) => _submitText(),
      onTapOutside: (_) => _focusNode.unfocus(),
    );

    field = widget.textFieldWidth != null
        ? SizedBox(width: widget.textFieldWidth, child: field)
        : ConstrainedBox(
            constraints: BoxConstraints(minWidth: height),
            child: IntrinsicWidth(child: field),
          );

    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: enabled ? fill : colors.baseFill,
        border: widget.isOutlined
            ? Border.symmetric(
                vertical: BorderSide(
                  color: enabled ? accent : colors.baseBorder,
                ),
              )
            : null,
      ),
      child: field,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('value', _controller.value))
      ..add(DoubleProperty('minValue', widget.minValue))
      ..add(DoubleProperty('maxValue', widget.maxValue))
      ..add(DoubleProperty('step', widget.step))
      ..add(IntProperty('decimals', _decimals))
      ..add(EnumProperty<SemanticEnum>('type', widget.type))
      ..add(EnumProperty<SizeEnum>('size', widget.size))
      ..add(
        FlagProperty(
          'enabled',
          value: widget.enabled,
          ifFalse: 'disabled',
          defaultValue: true,
        ),
      )
      ..add(
        FlagProperty(
          'isOutlined',
          value: widget.isOutlined,
          ifTrue: 'outlined',
          defaultValue: false,
        ),
      );
  }
}

/// A square `+` / `-` button that repeats while held down.
class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.semanticLabel,
    required this.extent,
    required this.iconSize,
    required this.fill,
    required this.outlineColor,
    required this.iconColor,
    required this.borderRadius,
    required this.onTap,
    required this.onRepeatStart,
    required this.onRepeatEnd,
  });

  final IconData icon;
  final String semanticLabel;
  final double extent;
  final double iconSize;
  final Color fill;
  final Color? outlineColor;
  final Color iconColor;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final VoidCallback onRepeatStart;
  final VoidCallback onRepeatEnd;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      excludeSemantics: true,
      child: MouseRegion(
        cursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: GestureDetector(
          // onLongPressCancel matters: without it an interrupted press leaves
          // the repeat timer running.
          onLongPressStart: enabled ? (_) => onRepeatStart() : null,
          onLongPressEnd: enabled ? (_) => onRepeatEnd() : null,
          onLongPressCancel: enabled ? onRepeatEnd : null,
          child: Material(
            color: fill,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: outlineColor == null
                  ? BorderSide.none
                  : BorderSide(color: outlineColor!),
            ),
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: extent,
                height: extent,
                child: Center(
                  child: Icon(icon, size: iconSize, color: iconColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Number of fraction digits [value] needs to be written exactly.
///
/// Used to keep `0.1 + 0.1 + 0.1` from drifting to `0.30000000000000004`.
int _countFractionDigits(double value) {
  if (!value.isFinite) return 0;
  final String text = value.abs().toString();
  final int exponentIndex = text.indexOf('e');
  if (exponentIndex < 0) {
    final int dot = text.indexOf('.');
    if (dot < 0) return 0;
    final String fraction = text.substring(dot + 1);
    return fraction == '0' ? 0 : fraction.length;
  }
  final String mantissa = text.substring(0, exponentIndex);
  final int exponent = int.tryParse(text.substring(exponentIndex + 1)) ?? 0;
  final int dot = mantissa.indexOf('.');
  final int digits = dot < 0 ? 0 : mantissa.length - dot - 1;
  return math.max(0, digits - exponent);
}

class _IncrementIntent extends Intent {
  const _IncrementIntent();
}

class _DecrementIntent extends Intent {
  const _DecrementIntent();
}
