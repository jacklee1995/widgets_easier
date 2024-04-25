import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WinStyleDialogBody extends StatelessWidget {
  final Widget icon;
  final String text;
  final TextStyle? textStyle;
  final double height;
  final double textWidth;
  final Widget? bottomWidget;

  const WinStyleDialogBody({
    Key? key,
    required this.icon,
    required this.text,
    this.textStyle,
    this.height = 120,
    this.textWidth = 340,
    this.bottomWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(width: 25), // 图标和文本之间的间隔
              SizedBox(
                width: textWidth, // 文本区域的宽度
                child: Text(
                  text,
                  style: textStyle ?? const TextStyle(fontSize: 16), // 默认文本样式
                ),
              ),
            ],
          ),
          if (bottomWidget != null) ...[
            const SizedBox(height: 20), // 第一行和底部组件之间的间隔
            bottomWidget!,
          ],
        ],
      ),
    );
  }
}
