import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../widgets/docs_widget.dart';

class CounterInputDocs extends StatelessWidget {
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final _textController4 = TextEditingController();
  final _textController5 = TextEditingController();
  final _textController6 = TextEditingController();
  final _textController7 = TextEditingController();
  final _textController8 = TextEditingController();
  final _textController9 = TextEditingController();
  final _textController10 = TextEditingController();
  final _textController11 = TextEditingController();
  final _textController12 = TextEditingController();
  final _textController13 = TextEditingController();
  final _textController14 = TextEditingController();
  final _textController15 = TextEditingController();
  final _textController16 = TextEditingController();
  final _textController17 = TextEditingController();
  final _textController18 = TextEditingController();
  final _textController19 = TextEditingController();
  final _textController20 = TextEditingController();
  final _textController21 = TextEditingController();
  final _textController22 = TextEditingController();
  CounterInputDocs({super.key});

  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header2('5.1 使用语义'),
        Write.paragraph('和其它组件一样，通过type属性可以指定语义枚举值，以得到不同的语义色彩。'),
        Row(
          children: [
            Column(
              children: [
                CounterInput(
                  textController: _textController1,
                  type: SemanticEnum.primary,
                ),
                const Text('Primary'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.secondary,
                  textController: _textController2,
                ),
                const Text('Secondary'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.info,
                  textController: _textController3,
                ),
                const Text('Info'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.success,
                  textController: _textController4,
                ),
                const Text('Success'),
              ],
            ),
          ],
        ),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.warning,
                  textController: _textController5,
                ),
                const Text('Warning'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.danger,
                  textController: _textController6,
                ),
                const Text('Danger'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.fatal,
                  textController: _textController7,
                ),
                const Text('fatal'),
              ],
            ),
          ],
        ),
        Write.header2('5.2 自定义色彩'),
        Write.paragraph('如果不使用语义色彩，还可以自己指定加减器各个部分的颜色。具体来说，有以下几个颜色参数'),
        Write.orderedList([
          Write.listItem('iconColor：加减图标的颜色'),
          Write.listItem('backgroundColor：输入框背景色；'),
          Write.listItem('buttonColor：按钮颜色；'),
          Write.listItem('textColor：输入框文本颜色。'),
        ]),
        Write.paragraph(
            '例如下面的例子指定了iconColor: Colors.amber, backgroundColor: Colors.black, buttonColor: Colors.blue, textColor: Colors.white。：'),
        CounterInput(
          size: SizeEnum.small,
          iconColor: Colors.amber,
          backgroundColor: Colors.black,
          buttonColor: Colors.blue,
          textColor: Colors.white,
          textController: _textController8,
        ),
        Write.header2('5.3 尺寸枚举'),
        Write.paragraph(
            '通过size组件可以指定尺寸枚举，包括SizeEnum.small、SizeEnum.defaultSize、SizeEnum.large，如果未指定，默认为SizeEnum.defaultSize。'),
        Row(
          children: [
            Column(
              children: [
                CounterInput(
                  size: SizeEnum.small,
                  textController: _textController9,
                ),
                const Text('SizeEnum.small'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  size: SizeEnum.defaultSize,
                  textController: _textController10,
                ),
                const Text('SizeEnum.defaultSize'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  size: SizeEnum.large,
                  textController: _textController11,
                ),
                const Text('izeEnum.large'),
              ],
            ),
          ],
        ),
        Write.header2('5.4 轮廓型加减器'),
        Write.paragraph('通过指定isOutlined的值为true，可以设置加减器为轮廓型。'),
        Row(
          children: [
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.primary,
                  textController: _textController12,
                  isOutlined: true,
                ),
                const Text('Primary'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.secondary,
                  textController: _textController13,
                  isOutlined: true,
                ),
                const Text('Secondary'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.info,
                  textController: _textController14,
                  isOutlined: true,
                ),
                const Text('Info'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.success,
                  textController: _textController15,
                  isOutlined: true,
                ),
                const Text('Success'),
              ],
            ),
          ],
        ),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.warning,
                  textController: _textController16,
                  isOutlined: true,
                ),
                const Text('Warning'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.danger,
                  textController: _textController17,
                  isOutlined: true,
                ),
                const Text('Danger'),
              ],
            ),
            Column(
              children: [
                CounterInput(
                  type: SemanticEnum.fatal,
                  textController: _textController18,
                  isOutlined: true,
                ),
                const Text('fatal'),
              ],
            ),
          ],
        ),
        Write.header2('5.5 步进单位'),
        Write.paragraph('通过step属性，可以指定步进单位。步进单位是每次增加或者减少的最小单位。'),
        Write.paragraph('比如下面的例子中步进单位值为3；'),
        CounterInput(
          type: SemanticEnum.primary,
          textController: _textController19,
          step: 3,
        ),
        Write.header2('5.6 加减回调'),
        Write.paragraph('加回调用于监听值增加事件，当数值增加时触发；类似地，减回调用于监听减少事件，当数值减少时触发。'),
        Write.unorderedList([
          Write.listItem('通过onIncrement回调，用于监值增加事件；'),
          Write.listItem('通过Decremented回调，用于监值减少事件。'),
        ]),
        Write.paragraph('下面这个例子中，初始值为7，步进值为2，当增加或者减少时在控制台打印新值和旧值：'),
        CounterInput(
          type: SemanticEnum.primary,
          initialValue: 7,
          textController: _textController20,
          step: 2,
          onIncrement: (oldValue, value) {
            debugPrint("+增加前为$oldValue；增加后为：$value");
          },
          onDecrement: (oldValue, value) {
            debugPrint("-减少前为$oldValue；减少后为：$value");
          },
        ),
        Write.header2('5.7 最值与最值回调'),
        Write.paragraph('加减器有一个最大值和一个最小值，默认情况下最小值为0，最大值为100。'),
        Write.paragraph('当变化到最小值时，将出发最小值回调'),
        Write.paragraph('下面的例子展示了到达最大/最小值时，执行相关回调。'),
        CounterInput(
          type: SemanticEnum.primary,
          initialValue: 6,
          minValue: 10,
          maxValue: 1,
          textController: _textController21,
          step: 2,
          onIncrement: (oldValue, value) {
            debugPrint("+增加前为$oldValue；增加后为：$value");
          },
          onDecrement: (oldValue, value) {
            debugPrint("-减少前为$oldValue；减少后为：$value");
          },
          onMax: () => debugPrint('到达最大值'),
          onMin: () => debugPrint('到达最小值'),
        ),
        Write.header2('5.8 溢出回调'),
        Write.paragraph(
            '溢出回调包括最小值溢出回调和最大值溢出回调。最小值溢出回调指的是，当前已经是最小值了，继续点击减号时执行的回调函数；最大值溢出回调指的是，当前已经是最大值了，继续点击加号时执行的回调函数。这两个回调在已经达到最值的时候提醒用户无法继续相关操作时特别有用。'),
        Write.paragraph('下面的例子中，最小值1，最大值13，初始值7，步进值4。'),
        CounterInput(
          type: SemanticEnum.primary,
          initialValue: 7,
          minValue: 1,
          maxValue: 13,
          textController: _textController22,
          step: 7,
          onIncrement: (oldValue, value) {
            debugPrint("+增加前为$oldValue；增加后为：$value");
          },
          onDecrement: (oldValue, value) {
            debugPrint("-减少前为$oldValue；减少后为：$value");
          },
          onMin: () => debugPrint('到达最小值'),
          onMax: () => debugPrint('到达最大值'),
          onMinOverflow: () => InfoDialogs.zoomIn(
            context,
            message: '当前已经时最小值，无法继续减少',
            buttonText: '确定',
            onTapDismiss: () {
              Navigator.of(context).pop();
            },
          ),
          onMaxOverflow: () => InfoDialogs.zoomIn(
            context,
            message: '当前已经时最大值，无法继续增加',
            buttonText: '确定',
            onTapDismiss: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Write.header2('5.8 变化监听器'),
        Write.paragraph('监听器时一个用于监听加减器内部值改变的回调函数，它在数值变化时将被调用。'),
        Write.paragraph('监听器回调函数通过onValueChanged参数指定，这个回调函数有一个参数，表示变化后的值。'),
      ],
    );
  }
}
