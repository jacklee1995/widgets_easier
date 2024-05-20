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
  static Future<Map<String, dynamic>?> zoomIn<T extends Object?>(
    BuildContext context, {
    required String title,
    required Widget icon,
    required String text,
    Widget? contents,
    required List<Widget> actions,
    bool barrierDismissible = true,
  }) =>
      showWinDialog(
        context,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return AnimateStyles.zoomIn(animation, child);
        },
        title: title,
        icon: icon,
        text: text,
        actions: actions,
      );

  /// 支持自定义动画
  static Future<Map<String, dynamic>?> showWinDialog(
    BuildContext context, {
    required String title,
    required Widget icon,
    required String text,
    Widget? contents,
    required List<Widget> actions,
    bool barrierDismissible = true,
    RouteTransitionsBuilder? transitionBuilder,
  }) {
    return showGeneralDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return WinStyleDialog(
          title: title,
          icon: icon,
          text: text,
          contents: contents,
          actions: actions,
        );
      },
      transitionBuilder: transitionBuilder ??
          (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            return child;
          },
    );
  }
}
