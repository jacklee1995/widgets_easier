import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The way a [WeBevelBorder] fakes depth by lighting two of its sides.
enum WeBevelStyle {
  /// One bevel, lit from the bottom right: the frame looks pressed in.
  inset,

  /// One bevel, lit from the top left: the frame looks raised.
  outset,

  /// Two bevels, [inset] outside and [outset] inside: a carved channel.
  groove,

  /// Two bevels, [outset] outside and [inset] inside: a raised ridge.
  ridge,
}

/// A rectangular [ShapeBorder] that fakes depth by painting two of its sides
/// light and two dark, matching the CSS `inset`, `outset`, `groove` and
/// `ridge` border styles.
///
/// Prefer the named subclasses [InsetBorder], [OutsetBorder], [GrooveBorder]
/// and [RidgeBorder] unless the style has to be chosen at runtime.
///
/// ```dart
/// DecoratedBox(
///   decoration: const ShapeDecoration(shape: OutsetBorder(width: 8)),
///   child: const SizedBox.square(dimension: 120),
/// )
/// ```
@immutable
class WeBevelBorder extends ShapeBorder {
  /// Which face of the border catches the light.
  final WeBevelStyle style;

  /// Thickness of the whole frame, in logical pixels.
  ///
  /// For [WeBevelStyle.groove] and [WeBevelStyle.ridge] the two bevels each
  /// take half of it. When the rect is too small to fit a frame this thick on
  /// both sides, the frame is thinned down to half the shorter side.
  final double width;

  /// Colour of the sides facing the light.
  final Color lightColor;

  /// Colour of the sides facing away from the light.
  final Color darkColor;

  const WeBevelBorder({
    required this.style,
    this.width = 2.0,
    this.lightColor = const Color(0xFFE0E0E0),
    this.darkColor = const Color(0xFF808080),
  }) : assert(width >= 0, 'width must not be negative');

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect.deflate(_effectiveWidth(rect)));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final double w = _effectiveWidth(rect);
    if (w <= 0) return;

    switch (style) {
      case WeBevelStyle.inset:
        _paintBevel(canvas, rect, rect.deflate(w), darkColor, lightColor);
      case WeBevelStyle.outset:
        _paintBevel(canvas, rect, rect.deflate(w), lightColor, darkColor);
      case WeBevelStyle.groove:
        final Rect middle = rect.deflate(w / 2);
        _paintBevel(canvas, rect, middle, darkColor, lightColor);
        _paintBevel(canvas, middle, rect.deflate(w), lightColor, darkColor);
      case WeBevelStyle.ridge:
        final Rect middle = rect.deflate(w / 2);
        _paintBevel(canvas, rect, middle, lightColor, darkColor);
        _paintBevel(canvas, middle, rect.deflate(w), darkColor, lightColor);
    }
  }

  /// Fills the band between [outer] and [inner] with mitred corners.
  ///
  /// The whole band is laid down in [bottomRight] first and the top-left
  /// elbow painted over it, so the two diagonal joins land on opaque pixels
  /// instead of leaving antialiasing seams.
  static void _paintBevel(
    Canvas canvas,
    Rect outer,
    Rect inner,
    Color topLeft,
    Color bottomRight,
  ) {
    final Path band = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(outer)
      ..addRect(inner);
    canvas.drawPath(band, Paint()..color = bottomRight);

    final Path elbow = Path()
      ..moveTo(outer.left, outer.bottom)
      ..lineTo(outer.left, outer.top)
      ..lineTo(outer.right, outer.top)
      ..lineTo(inner.right, inner.top)
      ..lineTo(inner.left, inner.top)
      ..lineTo(inner.left, inner.bottom)
      ..close();
    canvas.drawPath(elbow, Paint()..color = topLeft);
  }

  /// [width], capped so the frame never folds through itself on a small rect.
  double _effectiveWidth(Rect rect) =>
      math.min(width, math.min(rect.width, rect.height) / 2);

  /// Returns a border of this exact runtime type with the given overrides.
  ///
  /// Subclasses must override this so that [scale] and the `lerp` methods
  /// keep returning their own type rather than a plain [WeBevelBorder].
  @protected
  WeBevelBorder rebuild({double? width, Color? lightColor, Color? darkColor}) =>
      WeBevelBorder(
        style: style,
        width: width ?? this.width,
        lightColor: lightColor ?? this.lightColor,
        darkColor: darkColor ?? this.darkColor,
      );

  @override
  WeBevelBorder scale(double t) => rebuild(width: width * t);

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) =>
      a is WeBevelBorder ? _lerp(a, this, t) : super.lerpFrom(a, t);

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) =>
      b is WeBevelBorder ? _lerp(this, b, t) : super.lerpTo(b, t);

  static WeBevelBorder? _lerp(WeBevelBorder a, WeBevelBorder b, double t) {
    if (a.runtimeType != b.runtimeType || a.style != b.style) return null;
    return b.rebuild(
      width: ui.lerpDouble(a.width, b.width, t),
      lightColor: Color.lerp(a.lightColor, b.lightColor, t),
      darkColor: Color.lerp(a.darkColor, b.darkColor, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeBevelBorder &&
          other.runtimeType == runtimeType &&
          other.style == style &&
          other.width == width &&
          other.lightColor == lightColor &&
          other.darkColor == darkColor;

  @override
  int get hashCode =>
      Object.hash(runtimeType, style, width, lightColor, darkColor);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'WeBevelBorder')}($style, $width)';
}
