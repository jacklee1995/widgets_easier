import 'package:flutter/widgets.dart';

import 'bevel_border.dart';

/// A bevelled frame lit from the top left, so the box looks raised off the
/// surface. Equivalent to the CSS `border-style: outset`.
///
/// ```dart
/// DecoratedBox(
///   decoration: const ShapeDecoration(shape: OutsetBorder(width: 8)),
///   child: const SizedBox.square(dimension: 120),
/// )
/// ```
class OutsetBorder extends WeBevelBorder {
  const OutsetBorder({super.width, super.lightColor, super.darkColor})
    : super(style: WeBevelStyle.outset);

  @override
  OutsetBorder rebuild({double? width, Color? lightColor, Color? darkColor}) =>
      OutsetBorder(
        width: width ?? this.width,
        lightColor: lightColor ?? this.lightColor,
        darkColor: darkColor ?? this.darkColor,
      );
}
