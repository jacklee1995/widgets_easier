import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../inputs/counter_input.dart';
import '../inputs/counter_input_controller.dart';
import 'we_form.dart';

/// A labelled stop on a [WeSlider] track.
class WeSliderMark {
  const WeSliderMark(this.value, [this.label]);
  final double value;
  final String? label;
}

/// A themed slider after `el-slider`.
///
/// ```dart
/// WeSlider(value: v, min: 0, max: 100, onChanged: (n) => setState(() => v = n))
/// WeSlider.range(values: (20, 80), onRangeChanged: (r) => setState(() => range = r))
/// ```
class WeSlider extends StatefulWidget {
  const WeSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.step,
    this.showStops = false,
    this.showTooltip = true,
    this.formatTooltip,
    this.marks = const [],
    this.disabled = false,
    this.vertical = false,
    this.height = 200,
    this.showInput = false,
    this.size = SizeEnum.defaultSize,
    this.onChangeStart,
    this.onChangeEnd,
  }) : values = null,
       onRangeChanged = null,
       range = false;

  const WeSlider.range({
    super.key,
    required (double, double) this.values,
    required ValueChanged<(double, double)> this.onRangeChanged,
    this.min = 0,
    this.max = 100,
    this.step,
    this.showStops = false,
    this.showTooltip = true,
    this.formatTooltip,
    this.marks = const [],
    this.disabled = false,
    this.vertical = false,
    this.height = 200,
    this.size = SizeEnum.defaultSize,
    this.onChangeStart,
    this.onChangeEnd,
  }) : value = 0,
       onChanged = null,
       showInput = false,
       range = true;

  final double value;
  final ValueChanged<double>? onChanged;
  final (double, double)? values;
  final ValueChanged<(double, double)>? onRangeChanged;
  final bool range;
  final double min;
  final double max;

  /// Snap interval. `null` is continuous.
  final double? step;
  final bool showStops;
  final bool showTooltip;
  final String Function(double value)? formatTooltip;
  final List<WeSliderMark> marks;
  final bool disabled;
  final bool vertical;

  /// Track length when [vertical] is true.
  final double height;
  final bool showInput;
  final SizeEnum size;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;

  @override
  State<WeSlider> createState() => _WeSliderState();
}

class _WeSliderState extends State<WeSlider> {
  WeFormItemState? _item;
  late CounterInputController _counter;

  bool get _disabled => widget.disabled || (_item?.disabled ?? false);

  SizeEnum get _size {
    final own = widget.size;
    if (own != SizeEnum.defaultSize) return own;
    return _item?.size ?? SizeEnum.defaultSize;
  }

  double get _span => (widget.max - widget.min).clamp(0.0001, double.infinity);

  int? get _divisions {
    final step = widget.step;
    if (step == null || step <= 0) return null;
    return (_span / step).round();
  }

  @override
  void initState() {
    super.initState();
    _counter = CounterInputController(initialValue: widget.value);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _item = WeFormItem.maybeOf(context);
  }

  @override
  void didUpdateWidget(WeSlider old) {
    super.didUpdateWidget(old);
    if (!widget.range && old.value != widget.value) {
      _counter.value = widget.value;
    }
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  void _emit(double v) {
    widget.onChanged?.call(v);
    _item?.onChange();
  }

  String _label(double v) =>
      widget.formatTooltip?.call(v) ??
      (v == v.roundToDouble() ? '${v.round()}' : v.toStringAsFixed(1));

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final theme = SliderTheme.of(context).copyWith(
      activeTrackColor: colors.primary,
      inactiveTrackColor: colors.lightFill,
      thumbColor: colors.baseBackground,
      overlayColor: colors.primary.withValues(alpha: 0.12),
      valueIndicatorColor: colors.primaryText,
      valueIndicatorTextStyle: TextStyle(
        color: colors.overlayBackground,
        fontSize: 12,
      ),
      showValueIndicator: widget.showTooltip
          ? ShowValueIndicator.onlyForContinuous
          : ShowValueIndicator.never,
      trackHeight: _size == SizeEnum.small ? 4 : 6,
      thumbShape: RoundSliderThumbShape(
        enabledThumbRadius: _size == SizeEnum.small ? 7 : 8,
        disabledThumbRadius: 7,
        elevation: 1,
      ),
      tickMarkShape: widget.showStops
          ? RoundSliderTickMarkShape(
              tickMarkRadius: _size == SizeEnum.small ? 1.5 : 2,
            )
          : const RoundSliderTickMarkShape(tickMarkRadius: 0),
      activeTickMarkColor: colors.overlayBackground,
      inactiveTickMarkColor: colors.placeholderText,
    );

    Widget slider;
    if (widget.range) {
      final (a, b) = widget.values!;
      slider = SliderTheme(
        data: theme,
        child: RangeSlider(
          values: RangeValues(a, b),
          min: widget.min,
          max: widget.max,
          divisions: _divisions,
          labels: widget.showTooltip ? RangeLabels(_label(a), _label(b)) : null,
          onChanged: _disabled
              ? null
              : (r) {
                  widget.onRangeChanged!((r.start, r.end));
                  _item?.onChange();
                },
          onChangeStart: widget.onChangeStart == null
              ? null
              : (r) => widget.onChangeStart!(r.start),
          onChangeEnd: widget.onChangeEnd == null
              ? null
              : (r) => widget.onChangeEnd!(r.end),
        ),
      );
    } else {
      slider = SliderTheme(
        data: theme,
        child: Slider(
          value: widget.value.clamp(widget.min, widget.max),
          min: widget.min,
          max: widget.max,
          divisions: _divisions,
          label: widget.showTooltip ? _label(widget.value) : null,
          onChanged: _disabled ? null : _emit,
          onChangeStart: widget.onChangeStart,
          onChangeEnd: widget.onChangeEnd,
        ),
      );
    }

    if (widget.vertical) {
      slider = SizedBox(
        height: widget.height,
        child: RotatedBox(quarterTurns: 3, child: slider),
      );
    }

    Widget track = slider;
    if (widget.marks.isNotEmpty && !widget.vertical) {
      track = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          slider,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LayoutBuilder(
              builder: (context, box) {
                return SizedBox(
                  height: 18,
                  child: Stack(
                    children: [
                      for (final m in widget.marks)
                        Positioned(
                          left:
                              ((m.value - widget.min) / _span) * box.maxWidth -
                              16,
                          width: 32,
                          child: Text(
                            m.label ?? _label(m.value),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.secondaryText,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    if (!widget.showInput || widget.range) return track;

    return Row(
      children: [
        Expanded(child: track),
        const SizedBox(width: 12),
        CounterInput(
          controller: _counter,
          minValue: widget.min,
          maxValue: widget.max,
          step: widget.step ?? 1,
          size: _size,
          enabled: !_disabled,
          textFieldWidth: 56,
          onValueChanged: (_, n) => _emit(n),
        ),
      ],
    );
  }
}
