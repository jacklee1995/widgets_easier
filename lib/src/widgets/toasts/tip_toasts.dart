import 'dart:async';
import 'package:flutter/material.dart';

import '../../color/utils.dart';
import '../../enums/semantic_enum.dart';

class TipToasts {
  static OverlayEntry? _overlayEntry;

  /// 在屏幕中央显示提示吐司
  static void showCenter(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 300),
    AnimatedWidget Function(Listenable, Widget?)? animationEffect,
    SemanticEnum? type,
    double? width,
    TextStyle? messageStyle,
  }) {
    if (animationEffect != null) {
      _showByAnimation(
        context,
        message: message,
        duration: duration,
        animationDuration: animationDuration,
        position: TipToastPosition.center,
        animationEffect: animationEffect,
        type: type,
        width: width,
        messageStyle: messageStyle,
      );
    } else {
      _show(
        context,
        message: message,
        duration: duration,
        position: TipToastPosition.center,
        type: type,
        width: width,
        messageStyle: messageStyle,
      );
    }
  }

  /// 在屏幕顶部显示提示吐司
  static void showTop(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 300),
    AnimatedWidget Function(Listenable, Widget?)? animationEffect,
    SemanticEnum? type,
    double? width,
    TextStyle? messageStyle,
    double topOffset = 80,
  }) {
    if (animationEffect != null) {
      _showByAnimation(
        context,
        message: message,
        duration: duration,
        animationDuration: animationDuration,
        position: TipToastPosition.top,
        animationEffect: animationEffect,
        type: type,
        width: width,
        messageStyle: messageStyle,
        topOffset: topOffset,
      );
    } else {
      _show(
        context,
        message: message,
        duration: duration,
        position: TipToastPosition.top,
        type: type,
        width: width,
        messageStyle: messageStyle,
        topOffset: topOffset,
      );
    }
  }

  /// 在屏幕底部显示提示吐司
  static void showBottom(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 300),
    AnimatedWidget Function(Listenable, Widget?)? animationEffect,
    SemanticEnum? type,
    double? width,
    TextStyle? messageStyle,
    double bottomOffset = 80,
  }) {
    if (animationEffect != null) {
      _showByAnimation(
        context,
        message: message,
        duration: duration,
        animationDuration: animationDuration,
        position: TipToastPosition.bottom,
        animationEffect: animationEffect,
        type: type,
        width: width,
        messageStyle: messageStyle,
        bottomOffset: bottomOffset,
      );
    } else {
      _show(
        context,
        message: message,
        duration: duration,
        position: TipToastPosition.bottom,
        type: type,
        width: width,
        messageStyle: messageStyle,
        bottomOffset: bottomOffset,
      );
    }
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Duration duration,
    required TipToastPosition position,
    SemanticEnum? type,
    double? width,
    TextStyle? messageStyle,
    double topOffset = 0,
    double bottomOffset = 0,
  }) {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => TipToast(
        message: message,
        duration: duration,
        animationDuration: Duration.zero,
        position: position,
        animationEffect: (listenable, _) => AnimatedBuilder(
          animation: listenable as Listenable,
          builder: (context, child) => child!,
          child: const SizedBox.shrink(),
        ),
        type: type,
        width: width,
        messageStyle: messageStyle,
        topOffset: topOffset,
        bottomOffset: bottomOffset,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Timer(duration, () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  static void _showByAnimation(
    BuildContext context, {
    required String message,
    required Duration duration,
    required Duration animationDuration,
    required TipToastPosition position,
    required AnimatedWidget Function(Listenable, Widget?) animationEffect,
    SemanticEnum? type,
    double? width,
    TextStyle? messageStyle,
    double topOffset = 0,
    double bottomOffset = 0,
  }) {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => TipToast(
        message: message,
        duration: duration,
        animationDuration: animationDuration,
        position: position,
        animationEffect: animationEffect,
        type: type,
        width: width,
        messageStyle: messageStyle,
        topOffset: topOffset,
        bottomOffset: bottomOffset,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Timer(duration, () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}

class TipToast extends StatefulWidget {
  final String message;
  final Duration duration;
  final Duration animationDuration;
  final TipToastPosition position;
  final AnimatedWidget Function(Listenable, Widget?) animationEffect;
  final SemanticEnum? type;
  final double? width;
  final TextStyle? messageStyle;
  final double topOffset;
  final double bottomOffset;

  const TipToast({
    super.key,
    required this.message,
    required this.duration,
    required this.animationDuration,
    required this.position,
    required this.animationEffect,
    this.type,
    this.width,
    this.messageStyle,
    this.topOffset = 0,
    this.bottomOffset = 0,
  });

  @override
  State<TipToast> createState() => _TipToastState();
}

class _TipToastState extends State<TipToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.type != null
        ? findStatusColor(widget.type!).withOpacity(0.8)
        : Colors.black.withOpacity(0.8);
    final textColor =
        widget.type != null ? findStatusColor(widget.type!) : Colors.white;

    return Positioned(
      top: widget.position == TipToastPosition.top ? widget.topOffset : null,
      bottom: widget.position == TipToastPosition.bottom
          ? widget.bottomOffset
          : null,
      left: 0,
      right: 0,
      child: Center(
        child: widget.animationEffect(
          _animationController,
          Material(
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: widget.width ?? 200,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: widget.messageStyle ??
                    TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum TipToastPosition {
  top,
  center,
  bottom,
}
