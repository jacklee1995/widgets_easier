import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../color/utils.dart';
import '../../enums/semantic_enum.dart';
import '../../enums/size_enum.dart';
import 'counter_input_controller.dart';

class CounterInput extends StatefulWidget {
  final CounterInputController? controller;
  final Function(double oldValue, double newValue)? onIncrement;
  final Function(double oldValue, double newValue)? onDecrement;
  final Function(double oldValue, double newValue)? onValueChanged;
  final VoidCallback? onMin;
  final VoidCallback? onMax;
  final VoidCallback? onMinOverflow;
  final VoidCallback? onMaxOverflow;
  final SemanticEnum type;
  final bool isOutlined;
  final double radius;
  final SizeEnum size;
  final double minValue;
  final double maxValue;
  final double step;
  final double? height;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? textColor;
  final bool enabled;
  final double? textFieldWidth;

  const CounterInput({
    super.key,
    this.controller,
    this.onIncrement,
    this.onDecrement,
    this.onValueChanged,
    this.onMin,
    this.onMax,
    this.onMinOverflow,
    this.onMaxOverflow,
    this.type = SemanticEnum.secondary,
    this.isOutlined = false,
    this.radius = 4,
    this.size = SizeEnum.defaultSize,
    this.minValue = 0,
    this.maxValue = 100,
    this.step = 1,
    this.height,
    this.iconColor,
    this.backgroundColor,
    this.buttonColor,
    this.textColor,
    this.enabled = true,
    this.textFieldWidth,
  });

  @override
  State<CounterInput> createState() => _CounterInputState();
}

class _CounterInputState extends State<CounterInput> {
  late CounterInputController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? CounterInputController(initialValue: 0);
    _controller.setValue(_controller.value.clamp(
        min(widget.minValue, widget.maxValue),
        max(widget.minValue, widget.maxValue)));
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleIncrement() {
    if (!widget.enabled) return;

    final oldValue = _controller.value;
    final newValue = oldValue + widget.step;
    if (widget.minValue <= widget.maxValue) {
      if (newValue <= widget.maxValue) {
        _controller.setValue(newValue.clamp(
          min(widget.minValue, widget.maxValue),
          max(widget.minValue, widget.maxValue),
        ));
        // 响应变化事件
        if (widget.onValueChanged != null) {
          widget.onValueChanged!(oldValue, _controller.value);
        }
        // 响应加事件
        if (widget.onIncrement != null) {
          widget.onIncrement!(oldValue, _controller.value);
        }

        if (newValue == widget.maxValue && widget.onMax != null) {
          widget.onMax!();
        }
      } else if (widget.onMaxOverflow != null) {
        widget.onMaxOverflow!();
      }
    } else {
      final maxReachableValue = _getMaxReachableValue();
      if (maxReachableValue != _controller.value) {
        final newValue = oldValue + widget.step;
        if (newValue > widget.minValue) {
          _controller.setValue(
            widget.minValue.clamp(
              min(widget.minValue, widget.maxValue),
              max(widget.minValue, widget.maxValue),
            ),
          );
        } else {
          _controller.setValue(
            newValue.clamp(
              min(widget.minValue, widget.maxValue),
              max(widget.minValue, widget.maxValue),
            ),
          );
        }
        if (widget.onIncrement != null) {
          widget.onIncrement!(oldValue, _controller.value);
        }
        if (_controller.value == widget.minValue && widget.onMax != null) {
          widget.onMax!();
        }
      } else if (widget.onMaxOverflow != null) {
        widget.onMaxOverflow!();
      }
    }
  }

  void _handleDecrement() {
    if (!widget.enabled) return;

    final oldValue = _controller.value;
    final newValue = oldValue - widget.step;
    if (widget.minValue <= widget.maxValue) {
      if (newValue >= widget.minValue) {
        _controller.setValue(newValue.clamp(
            min(widget.minValue, widget.maxValue),
            max(widget.minValue, widget.maxValue)));
        // 响应变化事件
        if (widget.onValueChanged != null) {
          widget.onValueChanged!(oldValue, _controller.value);
        }
        // 响应减事件
        if (widget.onDecrement != null) {
          widget.onDecrement!(oldValue, _controller.value);
        }
        if (newValue == widget.minValue && widget.onMin != null) {
          widget.onMin!();
        }
      } else if (widget.onMinOverflow != null) {
        widget.onMinOverflow!();
      }
    } else {
      final minReachableValue = _getMinReachableValue();
      if (minReachableValue != _controller.value) {
        final newValue = oldValue - widget.step;
        if (newValue < widget.maxValue) {
          _controller.setValue(widget.maxValue.clamp(
              min(widget.minValue, widget.maxValue),
              max(widget.minValue, widget.maxValue)));
        } else {
          _controller.setValue(newValue.clamp(
              min(widget.minValue, widget.maxValue),
              max(widget.minValue, widget.maxValue)));
        }

        if (widget.onDecrement != null) {
          widget.onDecrement!(oldValue, _controller.value);
        }
        if (_controller.value == widget.maxValue && widget.onMin != null) {
          widget.onMin!();
        }
      } else if (widget.onMinOverflow != null) {
        widget.onMinOverflow!();
      }
    }
  }

  double _getMaxReachableValue() {
    double potentialValue = _controller.value;
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
    double potentialValue = _controller.value;
    while (potentialValue > widget.maxValue) {
      potentialValue -= widget.step;
      if (potentialValue < widget.maxValue) {
        potentialValue = widget.maxValue;
        break;
      }
    }
    return potentialValue;
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
            _buildTextField(
                backgroundColor, height, textColor, widget.textFieldWidth),
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
    double minHeight = 12.0; // 设置最小高度值
    height = max(height, minHeight); // 确保高度不小于最小值
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
    Color backgroundColor,
    double height,
    Color textColor,
    double? textFieldWidth,
  ) {
    double minHeight = 12.0; // 设置最小高度值
    height = max(height, minHeight); // 确保高度不小于最小值
    return Container(
      height: height,
      width: textFieldWidth,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // 设置背景颜色，如果是outlined风格则为透明，否则使用指定的backgroundColor
        color: widget.isOutlined ? Colors.transparent : backgroundColor,
        // 如果是outlined风格，设置边框颜色和宽度
        border: widget.isOutlined
            ? Border.symmetric(
                vertical:
                    BorderSide(color: findStatusColor(widget.type), width: 1),
              )
            : null,
      ),
      child: IntrinsicWidth(
        child: Center(
          child: TextField(
            controller: _controller.textController,
            // 设置键盘类型为数字，允许小数点
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            // 允许输入数字和小数点
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            // 文本对齐方式为开始，使光标和文本从左侧开始
            textAlign: TextAlign.end,
            // 设置文本样式，包括行高和颜色
            style: TextStyle(
              // height: 1.5,
              color: textColor,
              fontSize: height * 0.6, // 根据高度设置字体大小
            ),
            // 设置输入框的内边距和边框样式
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: (height - height * 0.8) / 2, // 根据高度计算垂直内边距
              ),
              border: InputBorder.none,
            ),
            // 允许交互选择，用于复制粘贴等操作
            enableInteractiveSelection: true,
            // 根据enabled状态禁用或启用输入框
            enabled: widget.enabled,
            // 当文本改变时的处理逻辑
            onChanged: (value) {
              final oldValue = _controller.value;
              if (value == '') {
                _controller.setValue(widget.minValue);
              } else {
                // 尝试将输入的文本转换为double类型
                final parsedValue = double.tryParse(value);
                if (parsedValue != null) {
                  // 如果转换成功，设置新的值，并确保它在允许的范围内
                  _controller.setValue(parsedValue.clamp(
                      min(widget.minValue, widget.maxValue),
                      max(widget.minValue, widget.maxValue)));
                } else {
                  // 如果转换失败，保持当前的值不变
                  _controller.setValue(oldValue);
                }
              }

              // 检查值的变化并触发相应的回调函数
              if (_controller.value != oldValue) {
                if (widget.onValueChanged != null) {
                  widget.onValueChanged!(oldValue, _controller.value);
                }

                if (_controller.value > oldValue) {
                  if (widget.onIncrement != null) {
                    widget.onIncrement!(oldValue, _controller.value);
                  }
                  if (_controller.value == widget.maxValue &&
                      widget.onMax != null) {
                    widget.onMax!();
                  }
                } else if (_controller.value < oldValue) {
                  if (widget.onDecrement != null) {
                    widget.onDecrement!(oldValue, _controller.value);
                  }
                  if (_controller.value == widget.minValue &&
                      widget.onMin != null) {
                    widget.onMin!();
                  }
                }
              }
            },
          ),
        ),
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
