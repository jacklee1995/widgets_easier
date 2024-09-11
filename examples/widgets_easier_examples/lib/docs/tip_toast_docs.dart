import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../widgets/docs_widget.dart';

class TipToastDocs extends StatelessWidget {
  final int c;
  const TipToastDocs(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header1('$c. 提示吐丝'),
        Write.header2('$c.1 TipToasts工具简介'),
        Write.paragraph(
            'TipToasts 是一个用于在 Flutter 应用中显示提示消息的工具类，是一种最简单的吐丝。它提供了一种简单而灵活的方式来在屏幕的不同位置显示短暂的提示信息，并支持自定义动画效果和样式。TipToast 适用各种需要简单提示性的场景：'),
        Write.orderedList([
          Write.listItem('显示操作成功或失败的提示信息；'),
          Write.listItem('向用户提供通知或警告；'),
          Write.listItem('在用户执行特定操作后给予反馈；'),
          Write.listItem('显示临时的状态信息。'),
        ]),
        Write.paragraph(
            'TipToasts 提供了几个静态方法来显示提示消息，分别是toCenter、toTop和toBottom。'),
        const Gap(20),
        Write.header2('$c.2 toCenter方法'),
        const Gap(20),
        HighlightView(
          '''static void toCenter(
  BuildContext context,
  String message, {
  double opacity = 0.7,
  Color backgroundColor = Colors.black,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  double maxWidth = double.infinity,
})''',
          language: 'dart',
          // theme: vs2015Theme,
          padding: const EdgeInsets.all(12),
        ),
        const Gap(20),
        Write.paragraph('toCenter方法是一个静态方法，该方法用于在屏幕中央显示提示消息，包含以下参数：'),
        Write.orderedList([
          Write.listItem('context: 构建上下文；'),
          Write.listItem('message: 要显示的文本消息；'),
          Write.listItem('opacity：背景透明度，默认为 0.7；'),
          Write.listItem('backgroundColor：背景颜色，默认为黑色；'),
          Write.listItem('textStyle：文本样式，默认为白色字体，字号为 16；'),
          Write.listItem('messageStyle: 消息文本的样式；'),
          Write.listItem('maxWidth: 提示消息的最大宽度，默认为 200。'),
        ]),
        const Gap(20),
        Write.header2('$c.3 toTop方法'),
        const Gap(20),
        Write.paragraph('该方法用于在屏幕顶部显示提示消息，并可以指定垂直偏移量。'),
        const Gap(20),
        HighlightView(
          '''static void toTop(
  BuildContext context,
  String message, {
  double offset = 100,
  double opacity = 0.7,
  Color backgroundColor = Colors.black,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  double maxWidth = double.infinity,
})''',
          language: 'dart',
          // theme: vs2015Theme,
          padding: const EdgeInsets.all(12),
        ),
        const Gap(20),
        Write.paragraph('其中参数offset表示从屏幕顶部的垂直偏移量，默认为 100，其他参数与 toCenter 方法相同。'),
        const Gap(20),
        Write.header2('$c.4 toBottom方法'),
        const Gap(20),
        Write.paragraph('该方法用于在屏幕底部显示提示消息，并可以指定垂直偏移量。'),
        HighlightView(
          '''static void toBottom(
  BuildContext context,
  String message, {
  double offset = 100,
  double opacity = 0.7,
  Color backgroundColor = Colors.black,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  double maxWidth = double.infinity,
})''',
          language: 'dart',
          // theme: vs2015Theme,
          padding: const EdgeInsets.all(12),
        ),
        Write.paragraph('其中参数offset表示从屏幕底部的垂直偏移量，默认为 100。'),
        const Gap(20),
        Write.header2('$c.5 代码示例'),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SemanticButton(
              shrink: true,
              text: 'toCenter',
              onTap: () => TipToasts.toCenter(context, 'toCenter'),
            ),
            SemanticButton(
              shrink: true,
              text: 'toTop',
              onTap: () => TipToasts.toTop(context, 'toTop'),
            ),
            SemanticButton(
              shrink: true,
              text: 'toBottom',
              onTap: () => TipToasts.toBottom(context, 'toBottom'),
            ),
          ],
        ),
        const Gap(20),
        const Gap(20),
        const Gap(20),
      ],
    );
  }
}
