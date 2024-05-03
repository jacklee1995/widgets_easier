import 'package:flutter/material.dart';
import 'package:flutter_easy_animations/flutter_easy_animations.dart';

import 'win_style_dialog.dart';

class WinDialogs {
  /// 这是没有动画效果的
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget icon,
    required String text,
    Widget? contents,
    required List<Widget> actions,
    bool barrierDismissible = true,
  }) =>
      showDialog<T>(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (context) => WinStyleDialog(
          title: title,
          icon: icon,
          text: text,
          contents: contents,
          actions: actions,
        ),
      );

  /// 此方法将以从中心扩大的动画效果显示 PanaraConfirmDialog。
  static Future<T?> zoomIn<T extends Object?>(
    BuildContext context, {
    required String title,
    required Widget icon,
    required String text,
    required List<Widget> actions,
    bool barrierDismissible = true,
  }) =>
      showGeneralDialog<T>(
        barrierDismissible: barrierDismissible,
        context: context,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 300),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return AnimateStyles.zoomIn(
            animation,
            child,
          );
        },
        pageBuilder: (animation, secondaryAnimation, child) => WinStyleDialog(
          title: title,
          icon: icon,
          text: text,
          actions: actions,
        ),
      );
}
