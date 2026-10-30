import 'package:flutter/widgets.dart';

import 'bevel_border.dart';

/// Two bevels back to back, carving a channel into the surface: the outer
/// half is lit like an [InsetBorder], the inner half like an [OutsetBorder].
/// Equivalent to the CSS `border-style: groove`.
///
/// ```dart
/// DecoratedBox(
///   decoration: const ShapeDecoration(shape: GrooveBorder(width: 6)),
///   child: const SizedBox.square(dimension: 120),
/// )
/// ```
class GrooveBorder extends WeBevelBorder {
  const GrooveBorder({super.width, super.lightColor, super.darkColor})
    : super(style: WeBevelStyle.groove);

  @override
  GrooveBorder rebuild({double? width, Color? lightColor, Color? darkColor}) =>
      GrooveBorder(
        width: width ?? this.width,
        lightColor: lightColor ?? this.lightColor,
        darkColor: darkColor ?? this.darkColor,
      );
}
