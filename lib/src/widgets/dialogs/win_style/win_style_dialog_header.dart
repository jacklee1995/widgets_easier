import 'package:flutter/material.dart';

class WinStyleDialogHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final Widget? leading;
  final Alignment titleAlignment;
  final double height;
  final double borderRadius;
  final TextStyle? titleStyle;
  final Color backgroundColor;
  final Color closeButtonColor;

  const WinStyleDialogHeader({
    Key? key,
    required this.title,
    required this.onClose,
    this.leading,
    this.titleAlignment = Alignment.centerLeft,
    this.height = 30, // 默认高度为30
    this.borderRadius = 0, // 默认圆角为0
    this.titleStyle, // 允许外部指定标题样式
    this.backgroundColor = Colors.grey, // 默认背景色
    this.closeButtonColor = Colors.black, // 默认关闭按钮颜色
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左侧组件和标题
          Expanded(
            child: Row(
              mainAxisAlignment: titleAlignment == Alignment.centerLeft
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                if (leading != null) leading!,
                if (leading != null) const SizedBox(width: 8), // 如果有图标，则添加间隔
                Text(
                  title,
                  style: titleStyle ??
                      const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
              ],
            ),
          ),
          // 右侧关闭按钮
          IconButton(
            icon: Icon(Icons.close, color: closeButtonColor),
            onPressed: onClose,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}
