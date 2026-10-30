import 'package:flutter/widgets.dart';

import 'bevel_border.dart';

/// A bevelled frame lit from the bottom right, so the box looks pressed into
/// the surface. Equivalent to the CSS `border-style: inset`.
///
/// ```dart
/// DecoratedBox(
///   decoration: const ShapeDecoration(shape: InsetBorder(width: 8)),
///   child: const SizedBox.square(dimension: 120),
/// )
/// ```
class InsetBorder extends WeBevelBorder {
  const InsetBorder({super.width, super.lightColor, super.darkColor})
    : super(style: WeBevelStyle.inset);

  @override
  InsetBorder rebuild({double? width, Color? lightColor, Color? darkColor}) =>
      InsetBorder(
        width: width ?? this.width,
        lightColor: lightColor ?? this.lightColor,
        darkColor: darkColor ?? this.darkColor,
      );
}
