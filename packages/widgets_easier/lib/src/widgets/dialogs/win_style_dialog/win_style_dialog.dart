import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../we_dialog/dialog_drag.dart';
import 'win_dialog_body.dart';
import 'win_style_dialog_footer.dart';
import 'win_style_dialog_header.dart';

/// A desktop-looking dialog: title bar, message area, command bar.
///
/// It reads its colours from `WeTheme`, so it follows dark mode, and its title
/// bar drags the dialog around like a real window. Use [WinDialogs] to show
/// one; build it directly only when you need it inside another route.
///
/// Prefer [WeDialog] for anything web-flavoured; this one is for apps that
/// want to look at home on Windows.
///
/// Platform: desktop and web (pointer + keyboard, wide screen). On phones prefer [BottomSheets] or [WeMessageBox].
class WinStyleDialog extends StatelessWidget {
  const WinStyleDialog({
    super.key,
    required this.title,
    this.icon,
    this.text = '',
    this.textStyle,
    this.contents,
    this.actions = const [],
    this.maxWidth = 460,
    this.draggable = true,
    this.showClose = true,
    this.bodyPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
  });

  /// Shown in the title bar and used as the dialog's accessible name.
  final String title;

  /// Small icon in the title bar and large icon beside [text].
  final Widget? icon;

  /// The message. May be empty when [contents] carries everything.
  final String text;
  final TextStyle? textStyle;

  /// Extra content under the message.
  final Widget? contents;

  /// Buttons in the command bar, laid out from left to right.
  final List<Widget> actions;

  final double maxWidth;

  /// Lets the title bar drag the dialog.
  final bool draggable;

  final bool showClose;
  final EdgeInsets bodyPadding;

  @override
  Widget build(BuildContext context) {
    WePlatform.debugCheckFit(
      context,
      'WinStyleDialog',
      WePlatformFit.desktop,
      alternative: 'WeMessageBox 或底部弹窗 BottomSheets',
    );
    final WeTheme theme = WeTheme.of(context);
    final WeColorScheme colors = theme.colors;

    final Widget surface = Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: math.max(
            0.0,
            math.min(maxWidth, MediaQuery.sizeOf(context).width - 32),
          ),
        ),
        decoration: BoxDecoration(
          color: colors.overlayBackground,
          border: Border.all(color: colors.baseBorder),
          borderRadius: BorderRadius.circular(theme.radius.base),
          boxShadow: theme.shadows.dark,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WinStyleDialogHeader(
              title: title,
              icon: icon,
              showClose: showClose,
            ),
            // 不用 Flexible：弹窗也可能被直接嵌在滚动页面里做示例，那里高度是无界的。
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.7,
              ),
              child: SingleChildScrollView(
                child: WinDialogBody(
                  icon: icon,
                  text: text,
                  textStyle: textStyle,
                  contents: contents,
                  padding: bodyPadding,
                ),
              ),
            ),
            WinStyleInfoDialogFooter(actions: actions),
          ],
        ),
      ),
    );

    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      label: title,
      child: WeMovableDialog(enabled: draggable, child: surface),
    );
  }
}
