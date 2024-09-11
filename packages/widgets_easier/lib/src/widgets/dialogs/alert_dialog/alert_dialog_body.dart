import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../buttons/semantic_button.dart';
import '../../../color/utils.dart';
import '../../../enums/semantic_enum.dart';
import '../../images/icons.dart';

class AlertDialogBody extends StatelessWidget {
  final String? title;
  final String message;
  final String? imagePath;
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

  const AlertDialogBody({
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
    this.imagePath,
    this.padding,
    this.margin,
    required this.noImage,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Color statusColor = findStatusColor(type);

    return AlertDialog(
      backgroundColor: backgroundColor ?? theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: padding ?? const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!noImage && imagePath == null) Iocns.info(type, size: 56),
          if (!noImage && imagePath != null)
            Image.asset(
              imagePath!,
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
          if (title != null) const Gap(8),
          Text(
            message,
            style: TextStyle(
              color: textColor ?? statusColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Center(
          child: SemanticButton(
            text: buttonText,
            onTap: onTapDismiss,
            type: type,
            isOutlined: false,
          ),
        ),
        const Gap(16),
      ],
    );
  }
}
