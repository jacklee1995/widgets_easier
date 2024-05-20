import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../widgets_easier.dart';

import '../images/icons.dart';

class ConfirmBottomSheet extends StatelessWidget {
  final String? title;
  final String message;
  final String img;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onTapConfirm;
  final VoidCallback onTapCancel;
  final SemanticEnum type;
  final Color? color;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? buttonTextColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool noImage;

  const ConfirmBottomSheet({
    super.key,
    this.title,
    required this.message,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.onTapConfirm,
    required this.onTapCancel,
    required this.type,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.buttonTextColor,
    this.img = '',
    this.padding,
    this.margin,
    required this.noImage,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Color statusColor = findStatusColor(type);

    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.dialogBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!noImage && img == '') Iocns.confirm(type, size: 56),
          if (!noImage && img != '')
            Picture(
              source: img,
              width: 56,
              height: 56,
            ),
          const Gap(16),
          if (title != null)
            Text(
              title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor ?? statusColor,
              ),
              textAlign: TextAlign.center,
            ),
          const Gap(8),
          Text(
            message,
            style: TextStyle(
              color: textColor ?? statusColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: SemanticButton(
                  text: cancelButtonText,
                  onTap: onTapCancel,
                  type: type,
                  isOutlined: true,
                ),
              ),
              const Gap(16),
              Expanded(
                child: SemanticButton(
                  text: confirmButtonText,
                  onTap: onTapConfirm,
                  type: type,
                  isOutlined: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
