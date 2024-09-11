import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../buttons/semantic_button.dart';
import '../../color/utils.dart';
import '../../enums/semantic_enum.dart';
import '../images/icons.dart';
import '../images/picture.dart';

class IofoBottomSheet extends StatelessWidget {
  final String? title;
  final String message;
  final String img;
  final String buttonText;
  final VoidCallback onTapDismiss;
  final SemanticEnum type;
  final Color? color;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? buttonTextColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool noImage;

  const IofoBottomSheet({
    super.key,
    this.title,
    required this.message,
    required this.buttonText,
    required this.onTapDismiss,
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
          if (!noImage && img == '') Iocns.info(type, size: 56),
          if (!noImage && img != '') Picture(source: img),
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
          if (title != null) const Gap(8),
          Text(
            message,
            style: TextStyle(
              color: textColor ?? statusColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          SemanticButton(
            text: buttonText,
            onTap: onTapDismiss,
            type: type,
            isOutlined: false,
          ),
        ],
      ),
    );
  }
}
