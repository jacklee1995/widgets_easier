import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WinStyleDialogHeader extends StatelessWidget {
  final String title;

  final Widget? icon;
  final Alignment titleAlignment;
  final double height;
  final double borderRadius;
  final TextStyle? titleStyle;
  final Color backgroundColor;
  final Color closeButtonColor;

  const WinStyleDialogHeader({
    super.key,
    required this.title,
    this.icon,
    this.titleAlignment = Alignment.centerLeft,
    this.height = 30, // 默认高度为30
    this.borderRadius = 0, // 默认圆角为0
    this.titleStyle, // 允许外部指定标题样式
    this.backgroundColor = const Color(0xFFEEF6F2), // 默认背景色
    this.closeButtonColor = const Color(0xFF212323), // 默认关闭按钮颜色
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: height,
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
            const Gap(10),
            Expanded(
              child: Row(
                mainAxisAlignment: titleAlignment == Alignment.centerLeft
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    SizedBox(
                      width: 19,
                      height: 19,
                      child: FittedBox(
                        child: icon!,
                      ),
                    ),
                  if (icon != null) const Gap(8),
                  Text(
                    title,
                    style: titleStyle ??
                        const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
            ),
            // 右侧关闭按钮
            CloseButton(height: height)
          ],
        ),
      ),
    );
  }
}

class CloseButton extends StatefulWidget {
  final double height;
  const CloseButton({
    super.key,
    required this.height,
  });

  @override
  State<CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<CloseButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _setHovered(true),
      onExit: (event) => _setHovered(false),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).maybePop();
        },
        child: AnimatedContainer(
          height: widget.height,
          width: 30,
          duration: const Duration(milliseconds: 200),
          color: _isHovered ? Colors.red : Colors.transparent,
          child: Icon(
            Icons.close,
            color: _isHovered ? Colors.white : const Color(0xFF212323),
          ),
        ),
      ),
    );
  }

  void _setHovered(bool value) {
    setState(() {
      _isHovered = value;
    });
  }
}
