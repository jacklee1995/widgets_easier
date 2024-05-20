import 'package:flutter/material.dart';
import 'package:flutter_easy_animations/flutter_easy_animations.dart';

import '../../../enums/semantic_enum.dart';
import 'alert_dialog_body.dart';

class AlertDialogs {
  /// 这是没有动画效果的
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required String buttonText,
    required String message,
    required void Function() onTapDismiss,
    String? imagePath,
    required String confirmButtonText,
    required String cancelButtonText,
    required VoidCallback onTapConfirm,
    required VoidCallback onTapCancel,
    required SemanticEnum type,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
  }) =>
      showDialog<T>(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (context) => AlertDialogBody(
          noImage: noImage,
          title: title,
          message: message,
          type: type,
          color: color,
          textColor: textColor,
          buttonTextColor: buttonTextColor,
          imagePath: imagePath,
          margin: margin,
          padding: padding,
          buttonText: buttonText,
          onTapDismiss: onTapDismiss,
        ),
      );

  /// 此方法将以从中心扩大的动画效果显示 PanaraConfirmDialog。
  static Future<T?> zoomIn<T extends Object?>(
    BuildContext context, {
    String? title,
    required String buttonText,
    required String message,
    required void Function() onTapDismiss,
    String? imagePath,
    required SemanticEnum type,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
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
        pageBuilder: (animation, secondaryAnimation, child) => AlertDialogBody(
          title: title,
          message: message,
          type: type,
          color: color,
          textColor: textColor,
          buttonTextColor: buttonTextColor,
          imagePath: imagePath,
          margin: margin,
          padding: padding,
          noImage: noImage,
          buttonText: buttonText,
          onTapDismiss: onTapDismiss,
        ),
      );
}
