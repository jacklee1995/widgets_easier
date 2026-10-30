import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A count or dot pinned to the corner of [child], after `el-badge`.
///
/// Without a [child] the badge renders inline as a small pill, which is handy
/// inside menus and tabs.
///
/// ```dart
/// WeBadge(value: 12, child: Icon(Icons.notifications_none))
/// WeBadge(dot: true, child: Text('Messages'))
/// WeBadge(value: 128, max: 99)            // inline "99+"
/// ```
class WeBadge extends StatelessWidget {
  const WeBadge({
    super.key,
    this.child,
    this.value,
    this.max = 99,
    this.dot = false,
    this.hidden = false,
    this.type = SemanticEnum.danger,
    this.color,
    this.offset = Offset.zero,
    this.radius,
  });

  final Widget? child;

  /// The number or text to show. Numbers above [max] render as `max+`.
  final Object? value;
  final int max;

  /// Show a small dot instead of the value.
  final bool dot;

  /// Hide the badge but keep the child in place.
  final bool hidden;

  final SemanticEnum type;

  /// Overrides the colour derived from [type].
  final Color? color;

  /// Nudges the badge from the top-right corner of [child].
  final Offset offset;

  /// Corner radius of the count. Defaults to a full pill; pass a small value
  /// to square it off next to rectangular components.
  final double? radius;

  String get _label {
    final v = value;
    if (v is num) return v > max ? '$max+' : v.toInt().toString();
    return v?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Color fill = color ?? colors.semantic(type);
    final bool empty = !dot && _label.isEmpty;
    final double corner = radius ?? 9;

    final Widget badge = dot
        ? Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
          )
        : Container(
            height: 18,
            constraints: const BoxConstraints(minWidth: 18),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(corner),
            ),
            child: Text(
              _label,
              style: TextStyle(
                fontSize: 11,
                height: 1,
                fontWeight: FontWeight.w600,
                color: colors.onSemantic,
              ),
            ),
          );

    if (child == null) {
      return hidden || empty ? const SizedBox.shrink() : badge;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        if (!hidden && !empty)
          Positioned(
            top: (dot ? -2 : -8) + offset.dy,
            right: (dot ? -2 : -10) + offset.dx,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: dot ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: dot ? null : BorderRadius.circular(corner + 1.5),
                border: Border.all(color: colors.baseBackground, width: 1.5),
              ),
              child: badge,
            ),
          ),
      ],
    );
  }
}
