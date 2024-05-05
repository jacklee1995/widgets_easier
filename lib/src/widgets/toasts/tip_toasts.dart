import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_animations/flutter_easy_animations.dart';
import '../../types.dart';

enum TipToastPosition {
  top,
  center,
  bottom,
}

class TipToasts {
  static void toCenter(
    BuildContext context,
    String message, {
    double opacity = 0.7,
    Color backgroundColor = Colors.black,
    TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
    double maxWidth = 200,
  }) {
    showOverlay(
      context,
      _CenterToast(
        message: message,
        opacity: opacity,
        backgroundColor: backgroundColor,
        textStyle: textStyle,
        maxWidth: maxWidth,
      ),
      AnimateStyles.fadeIn,
    );
  }

  static void toTop(
    BuildContext context,
    String message, {
    double offset = 100,
    double opacity = 0.7,
    Color backgroundColor = Colors.black,
    TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
    double maxWidth = 200,
  }) {
    showOverlay(
      context,
      _TopToast(
        message: message,
        offset: offset,
        opacity: opacity,
        backgroundColor: backgroundColor,
        textStyle: textStyle,
        maxWidth: maxWidth,
      ),
      AnimateStyles.slideInDown,
    );
  }

  static void toBottom(
    BuildContext context,
    String message, {
    double offset = 100,
    double opacity = 0.7,
    Color backgroundColor = Colors.black,
    TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
    double maxWidth = 200,
  }) {
    showOverlay(
      context,
      _BottomToast(
        message: message,
        offset: offset,
        opacity: opacity,
        backgroundColor: backgroundColor,
        textStyle: textStyle,
        maxWidth: maxWidth,
      ),
      AnimateStyles.slideInUp,
    );
  }

  static void showOverlay(
    BuildContext context,
    Widget overlay,
    TransitionFunction animationBuilder,
  ) {
    final overlayState = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) =>
          _ToastOverlay(animationBuilder: animationBuilder, child: overlay),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }
}

class _ToastOverlay extends StatefulWidget {
  final Widget child;
  final TransitionFunction animationBuilder;

  const _ToastOverlay({required this.child, required this.animationBuilder});

  @override
  _ToastOverlayState createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
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
    return widget.animationBuilder(_animation, widget.child);
  }
}

class _CenterToast extends StatelessWidget {
  final String message;
  final double opacity;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double maxWidth;

  const _CenterToast({
    required this.message,
    required this.opacity,
    required this.backgroundColor,
    required this.textStyle,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          constraints: BoxConstraints(maxWidth: maxWidth),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(opacity),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

class _TopToast extends StatelessWidget {
  final String message;
  final double offset;
  final double opacity;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double maxWidth;

  const _TopToast({
    required this.message,
    required this.offset,
    required this.opacity,
    required this.backgroundColor,
    required this.textStyle,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: offset),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            constraints: BoxConstraints(maxWidth: maxWidth),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(opacity),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomToast extends StatelessWidget {
  final String message;
  final double offset;
  final double opacity;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double maxWidth;

  const _BottomToast({
    required this.message,
    required this.offset,
    required this.opacity,
    required this.backgroundColor,
    required this.textStyle,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: offset),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            constraints: BoxConstraints(maxWidth: maxWidth),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(opacity),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
