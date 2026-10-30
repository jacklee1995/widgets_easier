import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Signature for an entrance-animation builder used by toasts and dialogs.
typedef AnimateStyleBuilder =
    AnimatedWidget Function(Animation<double> animation, Widget child);

/// A small set of entrance animations used internally by Widgets Easier.
///
/// Every method takes the driving [Animation] and the [child] to animate and
/// returns a ready-to-use transition widget, so they can be passed directly
/// as `transitionBuilder`s or as `animationEffect` callbacks.
abstract final class AnimateStyles {
  /// Fades the child in.
  static FadeTransition fadeIn(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
      child: child,
    );
  }

  /// Scales the child from 0 to its natural size.
  static ScaleTransition zoomIn(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
      child: child,
    );
  }

  /// Slides the child in from above.
  static SlideTransition slideInDown(
    Animation<double> animation,
    Widget child,
  ) {
    return _slide(animation, const Offset(0.0, -1.0), child);
  }

  /// Slides the child in from below.
  static SlideTransition slideInUp(Animation<double> animation, Widget child) {
    return _slide(animation, const Offset(0.0, 1.0), child);
  }

  /// Slides the child in from the left.
  static SlideTransition slideInLeft(
    Animation<double> animation,
    Widget child,
  ) {
    return _slide(animation, const Offset(-1.0, 0.0), child);
  }

  /// Slides the child in from the right.
  static SlideTransition slideInRight(
    Animation<double> animation,
    Widget child,
  ) {
    return _slide(animation, const Offset(1.0, 0.0), child);
  }

  /// Scales the child in while sliding from the right.
  static ScaleTransition zoomInRight(
    Animation<double> animation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  /// Scales the child in with a bounce.
  static ScaleTransition bounceIn(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.bounceOut)),
      child: child,
    );
  }

  /// Slides the child in from above with an ease-in-out curve.
  static SlideTransition backInDown(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
      child: child,
    );
  }

  /// Flips the child in around the X axis.
  static AnimatedBuilder flipInX(Animation<double> animation, Widget child) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final angle = math.pi * (1.0 - animation.value);
        final scale = animation.value;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(angle)
            ..scaleByDouble(scale, scale, scale, 1.0),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
      child: child,
    );
  }

  /// Rolls the child in from the left.
  static AnimatedBuilder rollIn(Animation<double> animation, Widget child) {
    final offset = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(animation);
    final angle = Tween<double>(
      begin: -math.pi / 2,
      end: 0.0,
    ).animate(animation);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: offset.value,
          child: Transform.rotate(angle: angle.value, child: child),
        );
      },
      child: child,
    );
  }

  static SlideTransition _slide(
    Animation<double> animation,
    Offset begin,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: child,
    );
  }
}
