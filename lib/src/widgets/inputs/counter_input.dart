import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../color/utils.dart';
import '../../enums/semantic_enum.dart';
import '../../enums/size_enum.dart';

/// 加减输入器
class CounterInput extends StatefulWidget {
  final TextEditingController textController;
  final Function(double oldValue, double newValue)? onIncrement;
  final Function(double oldValue, double newValue)? onDecrement;
  final Function(double oldValue, double newValue)? onValueChanged;
  final VoidCallback? onMin;
  final VoidCallback? onMax;
  final VoidCallback? onMinOverflow; // 新增：最小值溢出回调
  final VoidCallback? onMaxOverflow; // 新增：最大值溢出回调
  final SemanticEnum type;
  final bool isOutlined;
  final double radius;
  final SizeEnum size;
  final double initialValue;
  final double minValue;
  final double maxValue;
  final double step;
  final double? height;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? textColor;
  final bool enabled;

  const CounterInput({
    super.key,
    required this.textController,
    this.onIncrement,
    this.onDecrement,
    this.onValueChanged,
    this.onMin,
    this.onMax,
    this.onMinOverflow,
    this.onMaxOverflow,
    this.type = SemanticEnum.secondary,
    this.isOutlined = false,
    this.radius = 18,
    this.size = SizeEnum.defaultSize,
    this.initialValue = 0,
    this.minValue = 0,
    this.maxValue = 100,
    this.step = 1,
    this.height,
    this.iconColor,
    this.backgroundColor,
    this.buttonColor,
    this.textColor,
    this.enabled = true,
  });

  @override
  State<CounterInput> createState() => _CounterInputState();
}

class _CounterInputState extends State<CounterInput> {
  late Timer _timer;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    double adjustedMinValue = widget.minValue;
    double adjustedMaxValue = widget.maxValue;
    if (adjustedMinValue > adjustedMaxValue) {
      // 如果最小值大于最大值，交换它们的值
      double temp = adjustedMinValue;
      adjustedMinValue = adjustedMaxValue;
      adjustedMaxValue = temp;
    }
    _currentValue =
        widget.initialValue.clamp(adjustedMinValue, adjustedMaxValue);
    widget.textController.text = _formatValue(_currentValue);
  }

  void _handleIncrement() {
    if (!widget.enabled) return;

    setState(() {
      double oldValue = _currentValue;
      double newValue = _currentValue + widget.step;
      if (widget.minValue <= widget.maxValue) {
        if (newValue <= widget.maxValue) {
          _currentValue = newValue;
          _updateValue();
          if (widget.onIncrement != null) {
            widget.onIncrement!(oldValue, _currentValue);
          }
          if (newValue == widget.maxValue && widget.onMax != null) {
            widget.onMax!();
          }
        } else if (widget.onMaxOverflow != null) {
          // 新增
          widget.onMaxOverflow!();
        }
      } else {
        double maxReachableValue = _getMaxReachableValue();
        if (maxReachableValue != _currentValue) {
          double newValue = _currentValue + widget.step;
          if (newValue > widget.minValue) {
            newValue = widget.minValue;
          }
          _currentValue = newValue;
          _updateValue();
          if (widget.onIncrement != null) {
            widget.onIncrement!(oldValue, _currentValue);
          }
          if (_currentValue == widget.minValue && widget.onMax != null) {
            widget.onMax!();
          }
        } else if (widget.onMaxOverflow != null) {
          // 新增
          widget.onMaxOverflow!();
        }
      }
    });
  }

  void _handleDecrement() {
    if (!widget.enabled) return;

    setState(() {
      double oldValue = _currentValue;
      double newValue = _currentValue - widget.step;
      if (widget.minValue <= widget.maxValue) {
        if (newValue >= widget.minValue) {
          _currentValue = newValue;
          _updateValue();
          if (widget.onDecrement != null) {
            widget.onDecrement!(oldValue, _currentValue);
          }
          if (newValue == widget.minValue && widget.onMin != null) {
            widget.onMin!();
          }
        } else if (widget.onMinOverflow != null) {
          // 新增
          widget.onMinOverflow!();
        }
      } else {
        double minReachableValue = _getMinReachableValue();
        if (minReachableValue != _currentValue) {
          double newValue = _currentValue - widget.step;
          if (newValue < widget.maxValue) {
            newValue = widget.maxValue;
          }
          _currentValue = newValue;
          _updateValue();
          if (widget.onDecrement != null) {
            widget.onDecrement!(oldValue, _currentValue);
          }
          if (_currentValue == widget.maxValue && widget.onMin != null) {
            widget.onMin!();
          }
        } else if (widget.onMinOverflow != null) {
          // 新增
          widget.onMinOverflow!();
        }
      }
    });
  }

  double _getMaxReachableValue() {
    double potentialValue = _currentValue;
    while (potentialValue < widget.minValue) {
      potentialValue += widget.step;
      if (potentialValue > widget.minValue) {
        potentialValue = widget.minValue;
        break;
      }
    }
    return potentialValue;
  }

  double _getMinReachableValue() {
    double potentialValue = _currentValue;
    while (potentialValue > widget.maxValue) {
      potentialValue -= widget.step;
      if (potentialValue < widget.maxValue) {
        potentialValue = widget.maxValue;
        break;
      }
    }
    return potentialValue;
  }

  void _updateValue() {
    double oldValue = double.parse(widget.textController.text);
    widget.textController.text = _formatValue(_currentValue);
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(oldValue, _currentValue);
    }
  }

  String _formatValue(double value) {
    if (widget.step.floor() == widget.step) {
      return value.toInt().toString();
    } else {
      return value.toString();
    }
  }

  void _handleLongPress(bool increment) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (increment) {
        _handleIncrement();
      } else {
        _handleDecrement();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.height ?? _getHeightForSize(widget.size);
    Color primaryColor = findStatusColor(widget.type);
    Color backgroundColor =
        widget.backgroundColor ?? primaryColor.withOpacity(0.1);
    Color buttonColor =
        widget.buttonColor ?? (widget.isOutlined ? Colors.white : primaryColor);
    Color iconColor =
        widget.iconColor ?? (widget.isOutlined ? primaryColor : Colors.white);
    Color textColor = widget.textColor ?? Colors.black;
    Color disabledColor = Colors.grey;

    return SizedBox(
      height: height,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButton(Icons.remove, () => _handleLongPress(false),
                buttonColor, iconColor, true, height, disabledColor),
            _buildTextField(backgroundColor, height, textColor),
            _buildButton(Icons.add, () => _handleLongPress(true), buttonColor,
                iconColor, false, height, disabledColor),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      IconData icon,
      VoidCallback onLongPress,
      Color buttonColor,
      Color iconColor,
      bool isLeft,
      double height,
      Color disabledColor) {
    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onLongPressStart: (_) {
          if (widget.enabled) onLongPress();
        },
        onLongPressEnd: (_) => _timer.cancel(),
        child: ClipRRect(
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? Radius.circular(widget.radius) : Radius.zero,
            right: !isLeft ? Radius.circular(widget.radius) : Radius.zero,
          ),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: widget.enabled
                  ? (widget.isOutlined ? Colors.transparent : buttonColor)
                  : disabledColor,
              border: widget.isOutlined
                  ? Border.all(
                      color: widget.enabled ? buttonColor : disabledColor,
                      width: 1)
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.enabled
                    ? (icon == Icons.add ? _handleIncrement : _handleDecrement)
                    : null,
                child: Container(
                  width: height,
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: widget.enabled ? iconColor : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      Color backgroundColor, double height, Color textColor) {
    return Container(
      width: 60,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.isOutlined ? Colors.transparent : backgroundColor,
        border: widget.isOutlined
            ? Border.symmetric(
                vertical:
                    BorderSide(color: findStatusColor(widget.type), width: 1),
              )
            : null,
      ),
      child: TextFormField(
        controller: widget.textController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        textAlign: TextAlign.center,
        style: TextStyle(height: 1.0, color: textColor),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        enabled: widget.enabled,
      ),
    );
  }

  double _getHeightForSize(SizeEnum size) {
    switch (size) {
      case SizeEnum.small:
        return 24;
      case SizeEnum.large:
        return 40;
      default:
        return 32;
    }
  }
}
