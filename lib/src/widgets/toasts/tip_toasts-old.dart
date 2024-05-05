import 'dart:async';

import 'package:flutter/material.dart';

import '../../enums/semantic_enum.dart';
import '/src/color/utils.dart';

/// Enum defining the possible positions for a toast message.
enum TipToastPosition {
  /// Position the toast at the top of the screen.
  top,

  /// Center the toast in the middle of the screen.
  center,

  /// Position the toast at the bottom of the screen.
  bottom,
}

/// A utility class for displaying toast messages in a Flutter application.
class TipToasts {
  /// A map to hold the active overlay entries for each toast position.
  static final Map<TipToastPosition, OverlayEntry?> _overlayEntries = {
    TipToastPosition.top: null,
    TipToastPosition.center: null,
    TipToastPosition.bottom: null,
  };

  /// Displays a toast message at the center of the screen.
  ///
  /// Parameters:
  /// - `context`: The build context where the toast should be shown.
  /// - `message`: The text message to display.
  /// - `duration`: The duration for which the toast should be visible.
  /// - `animationEffect`: An optional animation effect to apply to the toast.
  /// - `animationDuration`: The duration of the animation effect.
  /// - `messageStyle`: Optional text style for the message.
  /// - `maxWidth`: Maximum width of the toast message.
  /// - `padding`: Padding around the text message.
  /// - `type`: Optional semantic type for theming the toast message.
  /// - `waitForPrevious`: Whether to wait for a previous toast to hide before showing the new one.
  static void showCenter(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    AnimatedWidget Function(Animation<double>, Widget)? animationEffect,
    Duration animationDuration = const Duration(milliseconds: 300),
    TextStyle? messageStyle,
    double maxWidth = 200,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    SemanticEnum? type,
    bool waitForPrevious = true,
  }) {
    _showToast(
      context: context,
      message: message,
      position: TipToastPosition.center,
      duration: duration,
      animationEffect: animationEffect,
      animationDuration: animationDuration,
      messageStyle: messageStyle,
      maxWidth: maxWidth,
      padding: padding,
      type: type,
      waitForPrevious: waitForPrevious,
    );
  }

  /// Displays a toast message at the top of the screen with an optional vertical offset.
  ///
  /// Parameters:
  /// - `context`: The build context where the toast should be shown.
  /// - `message`: The text message to display.
  /// - `duration`: The duration for which the toast should be visible.
  /// - `animationEffect`: An optional animation effect to apply to the toast.
  /// - `animationDuration`: The duration of the animation effect.
  /// - `messageStyle`: Optional text style for the message.
  /// - `maxWidth`: Maximum width of the toast message.
  /// - `padding`: Padding around the text message.
  /// - `type`: Optional semantic type for theming the toast message.
  /// - `waitForPrevious`: Whether to wait for a previous toast to hide before showing the new one.
  /// - `offset`: The vertical distance from the top of the screen.
  ///
  /// This method configures and displays a toast at the top of the screen, using the provided parameters.
  static void showTop(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    AnimatedWidget Function(Animation<double>, Widget)? animationEffect,
    Duration animationDuration = const Duration(milliseconds: 300),
    TextStyle? messageStyle,
    double maxWidth = 200,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    SemanticEnum? type,
    bool waitForPrevious = true,
    double offset = 100,
  }) {
    _showToast(
      context: context,
      message: message,
      position: TipToastPosition.top,
      duration: duration,
      animationEffect: animationEffect,
      animationDuration: animationDuration,
      messageStyle: messageStyle,
      maxWidth: maxWidth,
      padding: padding,
      type: type,
      waitForPrevious: waitForPrevious,
      offset: offset,
    );
  }

  /// Displays a toast message at the bottom of the screen with an optional vertical offset.
  ///
  /// Parameters:
  /// - `context`: The build context where the toast should be shown.
  /// - `message`: The text message to display.
  /// - `duration`: The duration for which the toast should be visible.
  /// - `animationEffect`: An optional animation effect to apply to the toast.
  /// - `animationDuration`: The duration of the animation effect.
  /// - `messageStyle`: Optional text style for the message.
  /// - `maxWidth`: Maximum width of the toast message.
  /// - `padding`: Padding around the text message.
  /// - `type`: Optional semantic type for theming the toast message.
  /// - `waitForPrevious`: Whether to wait for a previous toast to hide before showing the new one.
  /// - `offset`: The vertical distance from the bottom of the screen.
  ///
  /// This method configures and displays a toast at the bottom of the screen, using the provided parameters.
  static void showBottom(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    AnimatedWidget Function(Animation<double>, Widget)? animationEffect,
    Duration animationDuration = const Duration(milliseconds: 300),
    TextStyle? messageStyle,
    double maxWidth = 200,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    SemanticEnum? type,
    bool waitForPrevious = true,
    double offset = 100,
  }) {
    _showToast(
      context: context,
      message: message,
      position: TipToastPosition.bottom,
      duration: duration,
      animationEffect: animationEffect,
      animationDuration: animationDuration,
      messageStyle: messageStyle,
      maxWidth: maxWidth,
      padding: padding,
      type: type,
      waitForPrevious: waitForPrevious,
      offset: offset,
    );
  }

  /// Displays a toast message on the screen at a specified position.
  ///
  /// This is a private helper method used to manage the display of toast messages.
  /// It handles the creation and insertion of an overlay entry for the toast.
  ///
  /// Parameters:
  /// - `context`: The build context where the toast should be shown.
  /// - `message`: The text message to display.
  /// - `position`: The position on the screen where the toast should appear.
  /// - `duration`: The duration for which the toast should be visible.
  /// - `animationEffect`: An optional animation effect to apply to the toast.
  /// - `animationDuration`: The duration of the animation effect.
  /// - `messageStyle`: Optional text style for the message.
  /// - `maxWidth`: Maximum width of the toast message.
  /// - `padding`: Padding around the text message.
  /// - `type`: Optional semantic type for theming the toast message.
  /// - `waitForPrevious`: Whether to wait for a previous toast to hide before showing the new one.
  /// - `offset`: The vertical offset from the top or bottom of the screen, depending on the position.
  ///
  /// This method first checks if there is an existing toast being displayed at the same position
  /// and if `waitForPrevious` is true, it will delay the display of the new toast until the previous one has been dismissed.
  /// Otherwise, it creates a new overlay entry and inserts it into the overlay of the provided context.
  static void _showToast({
    required BuildContext context,
    required String message,
    required TipToastPosition position,
    Duration duration = const Duration(seconds: 2),
    AnimatedWidget Function(Animation<double>, Widget)? animationEffect,
    Duration animationDuration = const Duration(milliseconds: 300),
    TextStyle? messageStyle,
    required double maxWidth,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    SemanticEnum? type,
    bool waitForPrevious = true,
    double offset = 0,
  }) {
    if (waitForPrevious && _overlayEntries[position] != null) {
      Future.delayed(duration, () {
        _showToast(
          context: context,
          message: message,
          position: position,
          duration: duration,
          animationEffect: animationEffect,
          animationDuration: animationDuration,
          messageStyle: messageStyle,
          maxWidth: maxWidth,
          padding: padding,
          type: type,
          waitForPrevious: false,
          offset: offset,
        );
      });
      return;
    }

    final overlayEntry = OverlayEntry(
      builder: (context) => TipMessage(
        message: message,
        duration: duration,
        animationDuration: animationDuration,
        position: position,
        animationEffect: animationEffect,
        messageStyle: messageStyle,
        maxWidth: maxWidth,
        padding: padding,
        type: type,
        offset: offset,
        onDismissed: () {
          if (_overlayEntries[position] != null) {
            _overlayEntries[position]!.remove();
            _overlayEntries[position] = null;
          }
        },
      ),
    );

    if (_overlayEntries[position] != null) {
      _overlayEntries[position]!.remove();
    }
    _overlayEntries[position] = overlayEntry;
    Overlay.of(context).insert(overlayEntry);
  }
}

/// A widget that displays a message in a toast-like overlay.
///
/// This widget is used internally by the TipToasts class to show animated toast messages.
/// It supports custom animations, styles, and positioning.
///
/// Parameters:
/// - `message`: The text message to display in the toast.
/// - `duration`: The duration for which the toast should be visible before automatically dismissing.
/// - `animationDuration`: The duration of the animation effect applied to the toast.
/// - `position`: The position on the screen where the toast should appear (top, center, bottom).
/// - `animationEffect`: An optional function that returns an animated widget used for the toast's appearance.
/// - `messageStyle`: Optional text style for the message.
/// - `maxWidth`: Maximum width of the toast message; if not set, it defaults to double.infinity.
/// - `padding`: Padding around the text message inside the toast.
/// - `type`: Optional semantic type for theming the toast message based on predefined statuses.
/// - `offset`: The vertical offset from the top or bottom of the screen, depending on the position.
/// - `onDismissed`: A callback that is called when the toast is automatically dismissed after the duration.
///
/// This widget manages its own animation controller for the animation effect.
class TipMessage extends StatefulWidget {
  /// 要显示的消息文本。
  final String message;

  /// Toast显示的持续时间。
  final Duration duration;

  /// 动画效果的持续时间。
  final Duration animationDuration;

  /// Toast的位置（顶部、中心、底部）。
  final TipToastPosition position;

  /// 可选的动画效果函数。
  final AnimatedWidget Function(Animation<double>, Widget)? animationEffect;

  /// 消息文本的样式。
  final TextStyle? messageStyle;

  /// Toast消息的最大宽度。
  final double? maxWidth;

  /// 消息文本周围的填充。
  final EdgeInsets padding;

  /// 可选的语义类型，用于主题化Toast消息。
  final SemanticEnum? type;

  /// 从屏幕顶部或底部的垂直偏移量。
  final double offset;

  /// 当Toast自动消失后的回调函数。
  final VoidCallback onDismissed;

  const TipMessage({
    super.key,
    required this.message,
    required this.duration,
    required this.animationDuration,
    required this.position,
    this.animationEffect,
    this.messageStyle,
    this.maxWidth,
    required this.padding,
    this.type,
    required this.offset,
    required this.onDismissed,
  });

  @override
  State<TipMessage> createState() => _TipMessageState();
}

class _TipMessageState extends State<TipMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
    Future.delayed(widget.duration, widget.onDismissed);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: SlideTransition(
              // scale: _animation.value,
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(_animation),
              child: Align(
                alignment: widget.position == TipToastPosition.center
                    ? Alignment.center
                    : widget.position == TipToastPosition.top
                        ? Alignment.topCenter
                        : Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: widget.position == TipToastPosition.top
                        ? widget.offset
                        : 0,
                    bottom: widget.position == TipToastPosition.bottom
                        ? widget.offset
                        : 0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: widget.maxWidth ?? double.infinity),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: widget.padding,
                        decoration: BoxDecoration(
                          color: widget.type != null
                              ? findStatusColor(widget.type!).withOpacity(0.9)
                              : Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.message,
                          style: widget.messageStyle ??
                              const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
