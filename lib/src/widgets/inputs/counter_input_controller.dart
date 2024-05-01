import 'package:flutter/material.dart';

class CounterInputController extends ValueNotifier<double> {
  // 接受一个初始值，默认为 0
  CounterInputController({double initialValue = 0}) : super(initialValue);

  // 使用 TextEditingController 来控制文本输入
  final TextEditingController textController = TextEditingController();

  // 设置计数器的值，并更新文本控制器的文本
  void setValue(double value) {
    this.value = value; // 更新 ValueNotifier 的值
    textController.text = _formatValue(value); // 更新文本控制器的文本
  }

  // 格式化显示的值，如果是整数则不显示小数点，否则显示小数
  String _formatValue(double value) {
    if (value.floor() == value) {
      // 如果值的整数部分等于值本身，说明是整数，转换为整数并转为字符串
      return value.toInt().toString();
    } else {
      // 否则，直接转为字符串
      return value.toString();
    }
  }
}
