import 'dart:ui' as ui;
import 'package:example/widgets/docs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:widgets_easier/widgets_easier.dart';

class SliderDocs extends StatefulWidget {
  const SliderDocs({super.key});

  @override
  State<StatefulWidget> createState() => SliderDocsState();
}

class SliderDocsState extends State<SliderDocs> {
  double _value1 = 0.5;
  double _value2 = 0.6;
  double _value3 = 0.2;
  double _value4 = 0.7;
  double _value5 = 0.8;
  double _value6 = 0.3;
  double _value7 = 0.6;
  double _value8 = 0.4;
  double _value9 = 0.5;
  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.paragraph('SliderWidget 是一个常用的 UI 组件, 用于在一个范围内选择一个值。'),
        Write.header2('.1 基本用法'),
        SliderWidget(
          value: _value1,
          onChanged: (value) {
            setState(() {
              _value1 = value;
            });
          },
          min: 0.0,
          max: 100.0,
        ),
        Write.header2('.2 自定义外观'),
        Write.paragraph('CustomSlider 提供了多个参数来自定义滑块的外观:'),
        Write.orderedList([
          Write.listItem('activeColor: 滑块激活部分的颜色;'),
          Write.listItem('inactiveColor: 滑块非激活部分的颜色;'),
          Write.listItem('thumbColor: 滑块拇指 (圆形滑块) 的颜色;'),
          Write.listItem('overlayColor: 滑块拇指上覆盖层的颜色。'),
        ]),
        SliderWidget(
          value: _value2,
          onChanged: (value) {
            setState(() {
              _value2 = value;
            });
          },
          min: 0.0,
          max: 100.0,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
          thumbColor: Colors.white,
          overlayColor:
              MaterialStateProperty.all<Color>(Colors.blue.withOpacity(0.2)),
        ),
        Write.header2('.3 显示间断点'),
        Write.paragraph('通过设置 divisions 参数,我们可以在滑块上显示间断点:'),
        SliderWidget(
          value: _value3,
          onChanged: (value) {
            setState(() {
              _value3 = value;
            });
          },
          min: 0.0,
          max: 100.0,
          divisions: 10,
          showStops: true,
        ),
        Write.header2('.4 显示标签'),
        Write.paragraph('我们可以使用 label 参数在滑块上方显示一个标签:'),
        SliderWidget(
          value: _value4,
          imagethumb:
              const Image(image: AssetImage('assets/double-arrow-right.png')),
          showInput: true,
          trackHeight: 30,
          onChanged: (value) {
            setState(() {
              _value4 = value;
            });
          },
          min: 0.0,
          max: 100.0,
          label: '${_value4.round()}',
        ),
        Write.paragraph('这将在滑块上方显示当前值。'),
        Write.header2('.5 显示刻度'),
        Write.paragraph('通过设置 marks 参数,我们可以在滑块下方显示刻度:'),
        SliderWidget(
          value: _value5,
          onChanged: (value) {
            setState(() {
              _value5 = value;
            });
          },
          min: 0.0,
          max: 100.0,
          height: 240,
          marks: {
            0.0: '0',
            50.0: '50',
            100.0: '100',
          },
        ),
        Write.paragraph('这将在滑块下方显示 0、50 和 100 的刻度。'),
        Write.header2('.6 禁用滑块'),
        Write.paragraph('通过设置 enabled 参数为 false,我们可以禁用滑块:'),
        SliderWidget(
          value: _value6,
          onChanged: (value) {
            setState(() {
              _value6 = value;
            });
          },
          min: 0.0,
          max: 100.0,
          enabled: false,
        ),
        Write.header2('.7 垂直滑块'),
        Write.paragraph('通过设置 vertical 参数为 true,我们可以创建一个垂直滑块:'),
        SliderWidget(
          value: _value7,
          onChanged: (value) {
            setState(() {
              _value7 = value;
            });
          },
          min: 0.0,
          max: 100.0,
          vertical: true,
        ),
        Write.paragraph('这将创建一个垂直方向的滑块。'),
        Write.header2('.8 自定义工具提示'),
        Write.paragraph('我们可以使用 formatTooltip 参数自定义工具提示的格式:'),
        SliderWidget(
          value: _value8,
          onChanged: (value) {
            setState(() {
              _value8 = value;
            });
          },
          min: 0.0,
          max: 100.0,
          formatTooltip: (value) => '${value.round()}%',
        ),
        Write.paragraph('这将在工具提示中显示百分比值。'),
        Write.header2('.9 自定义滑块'),
      ],
    );
  }
}
