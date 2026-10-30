import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Holds the numeric value of a [CounterInput] and keeps the text shown in its
/// field in sync with that value.
///
/// The controller is the single source of truth: [value] is the number, and
/// [textController] merely renders it. Assigning [value] (or calling
/// [setValue]) refreshes the text, but only when the text does not already
/// spell the same number — otherwise the caret would jump to the end of the
/// field on every keystroke.
///
/// Dispose it when you own it; [CounterInput] only disposes controllers it
/// created itself.
class CounterInputController extends ValueNotifier<double> {
  /// Creates a controller starting at [initialValue].
  ///
  /// [decimals] fixes how many fraction digits are displayed. When it is
  /// `null` the value is rendered with as few digits as possible, so `3.0`
  /// shows up as `3` and `3.5` as `3.5`. [CounterInput] overrides this with
  /// the precision it derives from its `step`, `minValue` and `maxValue`.
  CounterInputController({double initialValue = 0, int? decimals})
    : _decimals = decimals,
      super(initialValue) {
    _writeText(format(initialValue));
  }

  /// Controls the text rendered inside the counter's field.
  ///
  /// Prefer reading [value]; this is exposed so callers can attach their own
  /// listeners or manage selection. It is disposed together with `this`.
  final TextEditingController textController = TextEditingController();

  int? _decimals;

  /// Number of fraction digits used when rendering [value], or `null` to use
  /// the shortest representation.
  int? get decimals => _decimals;

  set decimals(int? newDecimals) {
    if (_decimals == newDecimals) return;
    _decimals = newDecimals;
    syncText(force: true);
  }

  /// Renders [value] the way it would appear in the field.
  String format(double value) {
    if (!value.isFinite) return '';
    final int? digits = _decimals;
    if (digits != null) return value.toStringAsFixed(digits.clamp(0, 20));
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  @override
  set value(double newValue) {
    super.value = newValue;
    syncText();
  }

  /// Sets the counter to [value]. Equivalent to assigning [value].
  void setValue(double value) => this.value = value;

  /// Rewrites [textController] so that it spells the current [value].
  ///
  /// Text that already parses to [value] is left untouched so that in-progress
  /// input such as `1.50` or `007` survives until the field is submitted. Pass
  /// `force: true` to normalise it anyway.
  void syncText({bool force = false}) {
    final String text = format(value);
    if (textController.text == text) return;
    if (!force && double.tryParse(textController.text) == value) return;
    _writeText(text);
  }

  void _writeText(String text) {
    textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}

/// Restricts input to a decimal number, optionally signed.
///
/// Unlike `FilteringTextInputFormatter`, which strips offending characters one
/// by one and therefore happily accepts `1.2.3` or drops the leading minus,
/// this validates the whole string. Incomplete values such as `-`, `.` and
/// `1.` are allowed through so that they can be typed.
@immutable
class DecimalTextInputFormatter extends TextInputFormatter {
  /// Creates a formatter accepting at most [decimals] fraction digits, and a
  /// leading minus sign when [signed] is true.
  const DecimalTextInputFormatter({this.signed = false, this.decimals})
    : assert(decimals == null || decimals >= 0);

  /// Whether a leading `-` is accepted.
  final bool signed;

  /// Maximum number of fraction digits, or `null` for no limit.
  final int? decimals;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text;
    if (text.isEmpty) return newValue;

    final String sign = signed ? '-?' : '';
    final String fraction = decimals == 0
        ? ''
        : r'(\.\d{0,'
              '${decimals ?? ''}'
              r'})?';
    final RegExp pattern = RegExp('^$sign\\d*$fraction\$');
    return pattern.hasMatch(text) ? newValue : oldValue;
  }
}
