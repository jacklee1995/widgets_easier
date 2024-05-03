import 'package:flutter/material.dart';
import 'package:flutter_easy_animations/flutter_easy_animations.dart';

import '../../../enums/semantic_enum.dart';
import 'confirm_dialog.dart';

class ConfirmDialogs {
  /// 这是没有动画效果的
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required String message,
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
        builder: (context) => ConfirmDialog(
          noImage: noImage,
          title: title,
          message: message,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
          onTapConfirm: onTapConfirm,
          onTapCancel: onTapCancel,
          type: type,
          color: color,
          textColor: textColor,
          buttonTextColor: buttonTextColor,
          imagePath: imagePath,
          margin: margin,
          padding: padding,
        ),
      );

  /// 允许自定义动画
  static Future<T?> showConfirmDialog<T extends Object?>(
    BuildContext context, {
    RouteTransitionsBuilder? transitionBuilder,
    String? title,
    required String message,
    String? imagePath,
    required String confirmButtonText,
    required String cancelButtonText,
    required VoidCallback onTapConfirm,
    required VoidCallback onTapCancel,
    SemanticEnum type = SemanticEnum.primary,
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
        transitionBuilder: transitionBuilder,
        pageBuilder: (animation, secondaryAnimation, child) => ConfirmDialog(
          noImage: noImage,
          title: title,
          message: message,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
          onTapConfirm: onTapConfirm,
          onTapCancel: onTapCancel,
          type: type,
          color: color,
          textColor: textColor,
          buttonTextColor: buttonTextColor,
          imagePath: imagePath,
          margin: margin,
          padding: padding,
        ),
      );

  /// 此方法将以从中心扩大的动画效果显示
  static Future<T?> zoomIn<T extends Object?>(
    BuildContext context, {
    String? title,
    required String message,
    String? imagePath,
    required String confirmButtonText,
    required String cancelButtonText,
    required VoidCallback onTapConfirm,
    required VoidCallback onTapCancel,
    SemanticEnum type = SemanticEnum.primary,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
  }) =>
      showConfirmDialog(
        context,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return AnimateStyles.zoomIn(
            animation,
            child,
          );
        },
        barrierDismissible: barrierDismissible,
        noImage: noImage,
        title: title,
        message: message,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onTapConfirm: onTapConfirm,
        onTapCancel: onTapCancel,
        type: type,
        color: color,
        textColor: textColor,
        buttonTextColor: buttonTextColor,
        imagePath: imagePath,
        margin: margin,
        padding: padding,
      );
}
