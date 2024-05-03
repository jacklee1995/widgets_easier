import 'package:flutter/material.dart';
import 'package:widgets_easier/src/widgets/dialogs/win_style_dialog/win_style_dialog_header.dart';

import 'win_dialog_body.dart';
import 'win_style_dialog_footer.dart';

class WinStyleDialog extends StatelessWidget {
  final Widget icon;
  final String title;
  final String text;
  final TextStyle? textStyle;
  final double textWidth;
  final Widget? bottomWidget;
  final List<Widget> actions;
  final double maxWidth;
  final Widget? contents;

  const WinStyleDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    this.textStyle,
    this.maxWidth = 420,
    this.textWidth = 340,
    this.bottomWidget,
    this.contents,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Material(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFB7B7B7),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WinStyleDialogHeader(
                    icon: icon,
                    title: title,
                  ),
                  WinDialogBody(
                    icon: icon,
                    text: text,
                    contents: contents,
                  ),
                  WinStyleInfoDialogFooter(
                    actions: actions,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
