import 'package:flutter/material.dart';

import '../../../core/core.dart';

/// The message area of a [WinStyleDialog]: a large icon beside the text, with
/// room for extra content underneath.
class WinDialogBody extends StatelessWidget {
  const WinDialogBody({
    super.key,
    this.icon,
    required this.text,
    this.textStyle,
    this.contents,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
  });

  final Widget? icon;
  final String text;
  final TextStyle? textStyle;
  final Widget? contents;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final WeColorScheme colors = context.weColors;
    final bool hasText = text.isNotEmpty;

    return ColoredBox(
      color: colors.overlayBackground,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasText || icon != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null) ...[
                    SizedBox(
                      width: 34,
                      height: 34,
                      child: FittedBox(child: icon!),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Text(
                      text,
                      style:
                          textStyle ??
                          TextStyle(
                            fontSize: 13.5,
                            height: 1.6,
                            color: colors.regularText,
                          ),
                    ),
                  ),
                ],
              ),
            if (contents != null) ...[
              if (hasText || icon != null) const SizedBox(height: 18),
              contents!,
            ],
          ],
        ),
      ),
    );
  }
}
