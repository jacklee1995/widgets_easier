import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 滑动器输入框组件
class SliderInputWidget extends StatefulWidget {
  final TextEditingController textController;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? iconColor;
  final double height;

  const SliderInputWidget({
    super.key,
    required this.textController,
    required this.onIncrement,
    required this.onDecrement,
    this.backgroundColor,
    this.buttonColor,
    this.iconColor,
    required this.height,
  });

  @override
  State<SliderInputWidget> createState() => _SliderInputWidgetState();
}

class _SliderInputWidgetState extends State<SliderInputWidget> {
  late Timer _timer;

  void _handleLongPress(bool increment) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (increment) {
        widget.onIncrement();
      } else {
        widget.onDecrement();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ??
                const Color.fromARGB(255, 238, 238, 238),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onLongPressStart: (_) => _handleLongPress(false),
                onLongPressEnd: (_) => _timer.cancel(),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                  child: Material(
                    color: widget.buttonColor ??
                        const Color.fromARGB(255, 224, 224, 224),
                    child: InkWell(
                      onTap: widget.onDecrement,
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.remove,
                          color: widget.iconColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                child: Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: widget.textController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      final double? newValue = double.tryParse(value);
                      if (newValue != null && newValue >= 0 && newValue <= 1) {
                        widget.textController.text =
                            newValue.toStringAsFixed(1);
                      }
                    },
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 1.0),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onLongPressStart: (_) => _handleLongPress(true),
                onLongPressEnd: (_) => _timer.cancel(),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  child: Material(
                    color: widget.buttonColor ??
                        const Color.fromARGB(255, 224, 224, 224),
                    child: InkWell(
                      onTap: widget.onIncrement,
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.add,
                          color: widget.iconColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
