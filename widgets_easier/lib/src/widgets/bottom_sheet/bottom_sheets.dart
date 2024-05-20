import 'package:flutter/material.dart';

import '../../enums/semantic_enum.dart';
import 'cascade_bottom_sheet.dart';
import 'confirm_bottom_sheet.dart';
import 'info_bottom_sheet.dart';

class BottomSheets {
  static Future<T?> showInfoSheet<T extends Object?>(
    BuildContext context, {
    String? title,
    required String buttonText,
    required String message,
    required void Function() onTapDismiss,
    String img = '',
    required SemanticEnum type,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
  }) =>
      showModalBottomSheet<T>(
        barrierColor: Colors.black54,
        isDismissible: barrierDismissible,
        context: context,
        transitionAnimationController: AnimationController(
          vsync: Navigator.of(context),
          duration: const Duration(milliseconds: 300),
        ),
        builder: (context) => IofoBottomSheet(
          title: title,
          message: message,
          type: type,
          color: color,
          textColor: textColor,
          buttonTextColor: buttonTextColor,
          img: img,
          margin: margin,
          padding: padding,
          noImage: noImage,
          buttonText: buttonText,
          onTapDismiss: onTapDismiss,
        ),
      );

  static Future<T?> showConfirmSheet<T extends Object?>(
    BuildContext context, {
    String? title,
    required String confirmButtonText,
    required String cancelButtonText,
    required String message,
    required VoidCallback onTapConfirm,
    required VoidCallback onTapCancel,
    String img = '',
    required SemanticEnum type,
    Color? color,
    Color? textColor,
    Color? buttonTextColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    bool noImage = false,
  }) =>
      showModalBottomSheet<T>(
        barrierColor: Colors.black54,
        isDismissible: barrierDismissible,
        context: context,
        transitionAnimationController: AnimationController(
          vsync: Navigator.of(context),
          duration: const Duration(milliseconds: 300),
        ),
        builder: (context) => ConfirmBottomSheet(
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
          img: img,
          margin: margin,
          padding: padding,
          noImage: noImage,
        ),
      );

  static Future<List<String>?> showCascadeSheet<T extends Object?>(
    BuildContext context, {
    required List<Map<String, dynamic>> items,
    String cancelButtonText = 'Cancel',
    String confirmButtonText = 'Confirm',
    TextStyle? cancelButtonStyle,
    TextStyle? confirmButtonStyle,
    bool barrierDismissible = true,
  }) =>
      showModalBottomSheet<List<String>>(
        barrierColor: Colors.black54,
        isDismissible: barrierDismissible,
        context: context,
        transitionAnimationController: AnimationController(
          vsync: Navigator.of(context),
          duration: const Duration(milliseconds: 300),
        ),
        builder: (context) => CascadeBottomSheet(
          items: items,
          cancelButtonText: cancelButtonText,
          confirmButtonText: confirmButtonText,
          cancelButtonStyle: cancelButtonStyle,
          confirmButtonStyle: confirmButtonStyle,
        ),
      );
}
