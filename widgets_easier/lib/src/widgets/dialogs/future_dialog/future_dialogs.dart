import 'package:flutter/material.dart';
import 'package:flutter_easy_animations/flutter_easy_animations.dart';

import 'future_dialog.dart';
import 'default_loading_dialog.dart';

class FutureDialogs {
  /// 无动画
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() futureCallback,
    Widget? loadingDialogBody,
    required Widget Function(String) buildSuccessDialog,
    required Widget Function(String) buildFailureDialog,
  }) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FutureDialog(
          futureCallback: futureCallback,
          loadingDialogBody: loadingDialogBody ?? const DefaultLoadingDialog(),
          buildSuccessDialog: buildSuccessDialog,
          buildFailureDialog: buildFailureDialog,
        );
      },
    );
  }

  /// 支持自定义动画
  static Future<Map<String, dynamic>?> showFutureDialog({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() futureCallback,
    Widget? loadingDialogBody,
    RouteTransitionsBuilder? transitionBuilder,
    required Widget Function(String) buildSuccessDialog,
    required Widget Function(String) buildFailureDialog,
  }) {
    return showGeneralDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FutureDialog(
          futureCallback: futureCallback,
          loadingDialogBody: loadingDialogBody ?? const DefaultLoadingDialog(),
          buildSuccessDialog: buildSuccessDialog,
          buildFailureDialog: buildFailureDialog,
        );
      },
      transitionBuilder: transitionBuilder ??
          (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
    );
  }

  // 使用fadeInLeft动画显示验证对话框
  static Future<Map<String, dynamic>?> zoomIn({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() futureCallback,
    required Widget Function(String) buildSuccessDialog,
    required Widget Function(String) buildFailureDialog,
  }) {
    return showFutureDialog(
      context: context,
      futureCallback: futureCallback,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return AnimateStyles.zoomIn(animation, child);
      },
      buildSuccessDialog: buildSuccessDialog,
      buildFailureDialog: buildFailureDialog,
    );
  }
}
