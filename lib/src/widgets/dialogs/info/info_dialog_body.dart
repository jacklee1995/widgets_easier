import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../buttons/semantic_button.dart';
import '../../../color/utils.dart';
import '../../../enums/semantic_enum.dart';
import '../../images/icons.dart';

class InfoDialogBody extends StatelessWidget {
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

  const InfoDialogBody({
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
    this.padding = const EdgeInsets.all(24),
    this.margin = const EdgeInsets.all(24),
    required this.noImage,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Color statusColor = findStatusColor(type);

    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 340,
          ),
          margin: margin ?? const EdgeInsets.all(24),
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.dialogBackgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!noImage && imagePath == null) Iocns.info(type, size: 56),
              if (!noImage && imagePath != null)
                Image.asset(
                  imagePath!,
                  width: 56,
                  height: 56,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (title != null)
                        Text(
                          title ?? "",
                          style: TextStyle(
                            fontSize: 24,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                            color: textColor ?? statusColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (title != null) const Gap(5),
                      Text(
                        message,
                        style: TextStyle(
                          color: textColor ?? statusColor,
                          height: 1.5,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(20),
              SemanticButton(
                text: buttonText,
                onTap: onTapDismiss,
                type: type,
                isOutlined: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
