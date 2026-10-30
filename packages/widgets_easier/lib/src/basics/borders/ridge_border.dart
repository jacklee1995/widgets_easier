import 'package:flutter/widgets.dart';

import 'bevel_border.dart';

/// Two bevels back to back, raising a ridge off the surface: the outer half
/// is lit like an [OutsetBorder], the inner half like an [InsetBorder].
/// Equivalent to the CSS `border-style: ridge`.
///
/// ```dart
/// DecoratedBox(
///   decoration: const ShapeDecoration(shape: RidgeBorder(width: 6)),
///   child: const SizedBox.square(dimension: 120),
/// )
/// ```
class RidgeBorder extends WeBevelBorder {
  const RidgeBorder({super.width, super.lightColor, super.darkColor})
    : super(style: WeBevelStyle.ridge);

  @override
  RidgeBorder rebuild({double? width, Color? lightColor, Color? darkColor}) =>
      RidgeBorder(
        width: width ?? this.width,
        lightColor: lightColor ?? this.lightColor,
        darkColor: darkColor ?? this.darkColor,
      );
}
