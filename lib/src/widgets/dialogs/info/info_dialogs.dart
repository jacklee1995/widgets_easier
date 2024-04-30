import 'package:flutter/material.dart';

import 'package:flutter_easy_animations/flutter_easy_animations.dart';

import '../../../enums/semantic_enum.dart';
import 'info_dialog_body.dart';

class InfoDialogs {
  /// 无动画
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required String message,
    String? imagePath,
    required String buttonText,
    required VoidCallback onTapDismiss,
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
        builder: (context) => InfoDialogBody(
          title: title,
          message: message,
          buttonText: buttonText,
          onTapDismiss: onTapDismiss,
          type: type,
          color: color,
          textColor: textColor,
          buttonTextColor: buttonTextColor,
          imagePath: imagePath,
          margin: margin,
          padding: padding,
          noImage: noImage,
        ),
      );

  /// 可以指定任意自定义动画
  static Future<T?> showInfoDialogContents<T extends Object?>(
    BuildContext context, {
    String? title,
    required String message,
    String? imagePath,
    required String buttonText,
    required VoidCallback onTapDismiss,
    required SemanticEnum type,
    RouteTransitionsBuilder? transitionBuilder,
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
        pageBuilder: (animation, secondaryAnimation, child) => InfoDialogBody(
          title: title,
          message: message,
          imagePath: imagePath,
          buttonText: buttonText,
          onTapDismiss: onTapDismiss,
          type: type,
          color: color,
          textColor: textColor,
          buttonTextColor: buttonTextColor,
          margin: margin,
          padding: padding,
          noImage: noImage,
        ),
      );

  static Future<T?> fadeInLeft<T extends Object?>(
    BuildContext context, {
    String? title,
    required String message,
    String? imagePath,
    required String buttonText,
    required VoidCallback onTapDismiss,
    required SemanticEnum type,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
  }) =>
      showInfoDialogContents<T>(
        context,
        title: title,
        message: message,
        imagePath: imagePath,
        buttonText: buttonText,
        onTapDismiss: onTapDismiss,
        type: type,
        color: color,
        textColor: textColor,
        buttonTextColor: buttonTextColor,
        margin: margin,
        padding: padding,
        barrierDismissible: barrierDismissible,
        noImage: noImage,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return AnimateStyles.fadeInLeft(animation, child);
        },
      );

  static Future<T?> fadeInRight<T extends Object?>(
    BuildContext context, {
    String? title,
    required String message,
    String? imagePath,
    required String buttonText,
    required VoidCallback onTapDismiss,
    required SemanticEnum type,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
  }) =>
      showInfoDialogContents<T>(
        context,
        title: title,
        message: message,
        imagePath: imagePath,
        buttonText: buttonText,
        onTapDismiss: onTapDismiss,
        type: type,
        color: color,
        textColor: textColor,
        buttonTextColor: buttonTextColor,
        margin: margin,
        padding: padding,
        barrierDismissible: barrierDismissible,
        noImage: noImage,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return AnimateStyles.fadeInRight(animation, child);
        },
      );

  static Future<T?> fadeInDown<T extends Object?>(
    BuildContext context, {
    String? title,
    required String message,
    String? imagePath,
    required String buttonText,
    required VoidCallback onTapDismiss,
    required SemanticEnum type,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
  }) =>
      showInfoDialogContents<T>(
        context,
        title: title,
        message: message,
        imagePath: imagePath,
        buttonText: buttonText,
        onTapDismiss: onTapDismiss,
        type: type,
        color: color,
        textColor: textColor,
        buttonTextColor: buttonTextColor,
        margin: margin,
        padding: padding,
        barrierDismissible: barrierDismissible,
        noImage: noImage,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return AnimateStyles.fadeInDown(animation, child);
        },
      );

  static Future<T?> slideInUp<T extends Object?>(
    BuildContext context, {
    String? title,
    required String message,
    String? imagePath,
    required String buttonText,
    required VoidCallback onTapDismiss,
    required SemanticEnum type,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
  }) =>
      showInfoDialogContents<T>(
        context,
        title: title,
        message: message,
        imagePath: imagePath,
        buttonText: buttonText,
        onTapDismiss: onTapDismiss,
        type: type,
        color: color,
        textColor: textColor,
        buttonTextColor: buttonTextColor,
        margin: margin,
        padding: padding,
        barrierDismissible: barrierDismissible,
        noImage: noImage,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return AnimateStyles.slideInUp(animation, child);
        },
      );

  static Future<T?> zoomIn<T extends Object?>(
    BuildContext context, {
    String? title,
    required String message,
    String? imagePath,
    required String buttonText,
    required VoidCallback onTapDismiss,
    SemanticEnum type = SemanticEnum.primary,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
  }) =>
      showInfoDialogContents<T>(
        context,
        title: title,
        message: message,
        imagePath: imagePath,
        buttonText: buttonText,
        onTapDismiss: onTapDismiss,
        type: type,
        color: color,
        textColor: textColor,
        buttonTextColor: buttonTextColor,
        margin: margin,
        padding: padding,
        barrierDismissible: barrierDismissible,
        noImage: noImage,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return AnimateStyles.zoomIn(animation, child);
        },
      );

  static Future<T?> zoomOut<T extends Object?>(
    BuildContext context, {
    String? title,
    required String message,
    String? imagePath,
    required String buttonText,
    required VoidCallback onTapDismiss,
    required SemanticEnum type,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
  }) =>
      showInfoDialogContents<T>(
        context,
        title: title,
        message: message,
        imagePath: imagePath,
        buttonText: buttonText,
        onTapDismiss: onTapDismiss,
        type: type,
        color: color,
        textColor: textColor,
        buttonTextColor: buttonTextColor,
        margin: margin,
        padding: padding,
        barrierDismissible: barrierDismissible,
        noImage: noImage,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return AnimateStyles.zoomOut(animation, child);
        },
      );
}
