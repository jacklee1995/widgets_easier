import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:widgets_easier/src/widgets/sliders/image_slider_thumb_shape.dart';

import 'slider_input_widget.dart';

class SliderWidget extends StatefulWidget {
  /// 当前滑块的值。
  final double value;

  /// 次要轨道的值。
  final double? secondaryTrackValue;

  /// 滑块值发生变化时的回调。
  final ValueChanged<double>? onChanged;

  /// 开始滑动滑块时的回调。
  final ValueChanged<double>? onChangeStart;

  /// 结束滑动滑块时的回调。
  final ValueChanged<double>? onChangeEnd;

  /// 最小值。
  final double min;

  /// 最大值。
  final double max;

  /// 刻度线的数量。
  final int? divisions;

  /// 标签文本。
  final String? label;

  /// 活动轨道的颜色。
  final Color? activeColor;

  /// 非活动轨道的颜色。
  final Color? inactiveColor;

  /// 次要活动轨道的颜色。
  final Color? secondaryActiveColor;

  /// 滑块的颜色。
  final Color? thumbColor;

  /// 滑块覆盖层的颜色。
  final MaterialStateProperty<Color?>? overlayColor;

  /// 鼠标光标样式。
  final MouseCursor? mouseCursor;

  /// 焦点节点。
  final FocusNode? focusNode;

  /// 是否自动获取焦点。
  final bool autofocus;

  /// 允许的滑块交互方式。
  final SliderInteraction? allowedInteraction;

  /// 是否垂直方向。
  final bool vertical;

  /// 垂直方向 [vertical]=true 时的高度
  final double? height;

  /// 是否显示刻度线。
  final bool showStops;

  /// 是否显示工具提示。
  final bool showTooltip;

  /// 格式化工具提示文本的函数。
  final String Function(double)? formatTooltip;

  /// 是否显示输入框。
  final bool showInput;

  final Color? sliderInputBgColor;
  final Color? sliderInputButtonColor;
  final Color? sliderInputIconColor;

  /// 刻度标记。
  final Map<double, String>? marks;

  /// 是否启用滑块。
  final bool enabled;

  /// 工具提示的位置。
  final TooltipPlacement tooltipPlacement;

  /// 工具提示的样式类。
  final String? tooltipClass;

  /// 自定义滑块的图标。
  final Widget? imagethumb;

  final double? imagethumbWidth;

  final double? imagethumbHeight;

  /// 轨道的高度。
  final double trackHeight;

  /// 轨道的颜色。
  final Color? trackColor;

  /// 轨道的圆角大小。
  final double trackRadius;

  /// 滑块值指示器的形状。
  final SliderComponentShape? valueIndicatorShape;
  const SliderWidget({
    super.key,
    required this.value,
    this.secondaryTrackValue,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.overlayColor,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.allowedInteraction,
    this.vertical = false,
    this.showStops = false,
    this.showTooltip = true,
    this.formatTooltip,
    this.showInput = false,
    this.sliderInputBgColor,
    this.sliderInputButtonColor,
    this.sliderInputIconColor,
    this.marks,
    this.enabled = true,
    this.tooltipPlacement = TooltipPlacement.top,
    this.tooltipClass,
    this.imagethumb,
    this.imagethumbWidth,
    this.imagethumbHeight,
    this.trackHeight = 8.0,
    this.height,
    this.trackColor,
    this.trackRadius = 1.2,
    this.valueIndicatorShape,
  });

  @override
  State<SliderWidget> createState() => _SliderState();
}

class _SliderState extends State<SliderWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.value.toString());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleIncrement() {
    final double newValue =
        widget.value + (widget.divisions != null ? 1 / widget.divisions! : 0.1);
    if (newValue <= widget.max) {
      widget.onChanged?.call(newValue);
      _textController.text = newValue.toStringAsFixed(1);
    }
  }

  void _handleDecrement() {
    final double newValue =
        widget.value - (widget.divisions != null ? 1 / widget.divisions! : 0.1);
    if (newValue >= widget.min) {
      widget.onChanged?.call(newValue);
      _textController.text = newValue.toStringAsFixed(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RotatedBox(
            quarterTurns: widget.vertical ? 3 : 0,
            child: SizedBox(
              width: widget.vertical ? widget.height : null,
              height: widget.vertical ? null : 48.0,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: widget.trackHeight,
                  activeTrackColor: widget.activeColor,
                  inactiveTrackColor: widget.inactiveColor,
                  secondaryActiveTrackColor: widget.secondaryActiveColor,
                  thumbColor: widget.thumbColor,
                  trackShape: RoundedRectSliderTrackShape(
                    showStops: widget.showStops,
                    marks: widget.marks,
                    min: widget.min,
                    max: widget.max,
                    trackColor: widget.trackColor,
                    trackRadius: widget.trackRadius,
                    secondaryTrackValue: widget.secondaryTrackValue,
                    secondaryActiveColor: widget.secondaryActiveColor,
                  ),
                  thumbShape: widget.imagethumb != null
                      ? ImageSliderThumbShape(
                          image: widget.imagethumb!,
                          width: widget.imagethumbWidth ?? 8.0,
                          height: widget.imagethumbHeight ?? 8.0,
                        )
                      : const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                  showValueIndicator: widget.showTooltip
                      ? ShowValueIndicator.always
                      : ShowValueIndicator.never,
                  valueIndicatorShape:
                      const RectangularSliderValueIndicatorShape(),
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
                child: Slider(
                  value: widget.value,
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    _textController.text = value.toStringAsFixed(1);
                  },
                  onChangeStart: widget.onChangeStart,
                  onChangeEnd: widget.onChangeEnd,
                  min: widget.min,
                  max: widget.max,
                  divisions: widget.divisions,
                  label: widget.formatTooltip != null
                      ? widget.formatTooltip!(widget.value)
                      : widget.label,
                  mouseCursor: widget.mouseCursor,
                  focusNode: widget.focusNode,
                  autofocus: widget.autofocus,
                  overlayColor: widget.overlayColor,
                ),
              ),
            ),
          ),
        ),
        if (widget.showInput) const SizedBox(width: 30),
        if (widget.showInput)
          SliderInputWidget(
            textController: _textController,
            onIncrement: _handleIncrement,
            onDecrement: _handleDecrement,
            height: widget.trackHeight,
            backgroundColor: widget.sliderInputBgColor,
            buttonColor: widget.sliderInputButtonColor,
            iconColor: widget.sliderInputIconColor,
          ),
      ],
    );
  }
}

class RoundedRectSliderTrackShape extends SliderTrackShape {
  final bool showStops;
  final Map<double, String>? marks;
  final double? min;
  final double? max;
  final Color? trackColor;
  final double trackRadius;
  final double? secondaryTrackValue;
  final Color? secondaryActiveColor;

  RoundedRectSliderTrackShape({
    this.showStops = false,
    this.marks,
    this.min,
    this.max,
    this.trackColor,
    this.trackRadius = 4.0,
    this.secondaryTrackValue,
    this.secondaryActiveColor,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
    bool vertical = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 8.0;
    final double trackWidth = vertical ? trackHeight : parentBox.size.width;
    final double trackTop = vertical
        ? offset.dy
        : offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackLeft = vertical
        ? offset.dx + (parentBox.size.width - trackHeight) / 2
        : offset.dx;
    final Rect trackRect =
        Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
    return trackRect;
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    Offset? secondaryOffset,
    int? divisions,
    double? min,
    double? max,
    bool vertical = false,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final RRect roundedTrackRect = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackRadius), // 使用传入的圆角大小
    );

    final Paint trackPaint = Paint()
      ..color = trackColor ?? sliderTheme.inactiveTrackColor ?? Colors.grey;
    context.canvas.drawRRect(roundedTrackRect, trackPaint);

    // 绘制次要轨道（如果有）
    if (secondaryTrackValue != null && min != null && max != null) {
      final double secondaryTrackLength = vertical
          ? ((secondaryTrackValue! - min) / (max - min)) * trackRect.height
          : ((secondaryTrackValue! - min) / (max - min)) * trackRect.width;
      final RRect secondaryRoundedTrackRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          vertical ? trackRect.left : trackRect.left,
          vertical ? trackRect.top : trackRect.top,
          vertical ? trackRect.width : secondaryTrackLength,
          vertical ? secondaryTrackLength : trackRect.height,
        ),
        Radius.circular(trackRadius),
      );
      final Paint secondaryTrackPaint = Paint()
        ..color = secondaryActiveColor ?? Colors.blue.shade200;
      context.canvas.drawRRect(secondaryRoundedTrackRect, secondaryTrackPaint);
    }
  }
}

class RectSliderValueIndicatorShape extends SliderComponentShape {
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? padding;
  final double? distanceFromThumb;

  RectSliderValueIndicatorShape({
    this.backgroundColor,
    this.textStyle,
    this.padding,
    this.distanceFromThumb,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final double rectWidth = labelPainter.width + (padding ?? 8) * 2;
    final double rectHeight = labelPainter.height + (padding ?? 4) * 2;
    final double thumbRadius =
        sliderTheme.thumbShape?.getPreferredSize(true, isDiscrete).width ?? 10;
    final double distance = distanceFromThumb ?? thumbRadius + 16;
    final Rect rect = Rect.fromLTWH(
      center.dx - rectWidth / 2,
      center.dy - rectHeight - distance,
      rectWidth,
      rectHeight,
    );

    final Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)));
    path.moveTo(center.dx, rect.bottomCenter.dy);
    path.lineTo(center.dx, center.dy - distance);
    path.close();

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor ?? Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, backgroundPaint);

    final Offset labelOffset = Offset(
      center.dx - rectWidth / 2 + (padding ?? 8),
      center.dy - rectHeight - distance + (padding ?? 4),
    );

    labelPainter.paint(canvas, labelOffset);
  }
}

enum TooltipPlacement {
  top,
  bottom,
  left,
  right,
}
