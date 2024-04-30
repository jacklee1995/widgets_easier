import 'package:flutter/material.dart';
import 'package:flutter_easy_animations/flutter_easy_animations.dart';

import 'verification_dialog.dart';

class VerificationDialogs {
  // 使用showDialog显示验证弹窗的方法
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() verificationFunction,
  }) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return VerificationDialog(verificationFunction: verificationFunction);
      },
    );
  }

  // 使用showGeneralDialog显示验证弹窗的方法
  static Future<Map<String, dynamic>?> showVerificationDialog({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() verificationFunction,
    RouteTransitionsBuilder? transitionBuilder, // 新增参数
  }) {
    return showGeneralDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return VerificationDialog(verificationFunction: verificationFunction);
      },
      transitionBuilder: transitionBuilder ?? // 使用传入的transitionBuilder或默认动画
          (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            return FadeTransition(
              opacity:
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: child,
            );
          },
    );
  }

  // 使用fadeInLeft动画显示验证对话框
  static Future<Map<String, dynamic>?> zoomIn({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() verificationFunction,
  }) {
    return showVerificationDialog(
      context: context,
      verificationFunction: verificationFunction,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return AnimateStyles.zoomIn(animation, child);
      },
    );
  }

  // 使用fadeInLeft动画显示验证对话框
  static Future<Map<String, dynamic>?> fadeInLeft({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() verificationFunction,
  }) {
    return showVerificationDialog(
      context: context,
      verificationFunction: verificationFunction,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return AnimateStyles.fadeInLeft(animation, child);
      },
    );
  }

  // 使用fadeInRight动画显示验证对话框
  static Future<Map<String, dynamic>?> fadeInRight({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() verificationFunction,
  }) {
    return showVerificationDialog(
      context: context,
      verificationFunction: verificationFunction,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return AnimateStyles.fadeInRight(animation, child);
      },
    );
  }
}
