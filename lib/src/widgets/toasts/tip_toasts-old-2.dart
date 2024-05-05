import 'dart:async';

import 'package:flutter/material.dart';

import '../../enums/semantic_enum.dart';
import '/src/color/utils.dart';

enum TipToastPosition {
  top,
  center,
  bottom,
}

class TipToasts {
  static final Map<TipToastPosition, OverlayEntry?> _overlayEntries = {
    TipToastPosition.top: null,
    TipToastPosition.center: null,
    TipToastPosition.bottom: null,
  };

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

  static final Map<TipToastPosition, DateTime> _expectedShowTimes = {
    TipToastPosition.top: DateTime.now(),
    TipToastPosition.center: DateTime.now(),
    TipToastPosition.bottom: DateTime.now(),
  };

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
    final expectedShowTime = DateTime.now().add(duration + animationDuration);

    if (waitForPrevious && _overlayEntries[position] != null) {
      final previousExpectedShowTime = _expectedShowTimes[position]!;
      if (expectedShowTime.isBefore(previousExpectedShowTime)) {
        final delay = previousExpectedShowTime.difference(expectedShowTime);
        Future.delayed(delay, () {
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
    }

    _expectedShowTimes[position] = expectedShowTime;

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

class TipMessage extends StatefulWidget {
  final String message;
  final Duration duration;
  final Duration animationDuration;
  final TipToastPosition position;
  final AnimatedWidget Function(Animation<double>, Widget)? animationEffect;
  final TextStyle? messageStyle;
  final double? maxWidth;
  final EdgeInsets padding;
  final SemanticEnum? type;
  final double offset;
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
            child: widget.animationEffect != null
                ? widget.animationEffect!(_animation, _buildToastContent())
                : _buildToastContent(),
          );
        },
      ),
    );
  }

  Widget _buildToastContent() {
    return Align(
      alignment: widget.position == TipToastPosition.center
          ? Alignment.center
          : widget.position == TipToastPosition.top
              ? Alignment.topCenter
              : Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: widget.position == TipToastPosition.top ? widget.offset : 0,
          bottom:
              widget.position == TipToastPosition.bottom ? widget.offset : 0,
        ),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: widget.maxWidth ?? double.infinity),
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
                style:
                    widget.messageStyle ?? const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
