import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Text roles of [WeText], mapped onto the theme's text colours.
enum WeTextRole { primary, regular, secondary, placeholder, disabled }

/// Body text tied to the theme's text ramp and semantic colours, after
/// `el-text`.
///
/// ```dart
/// WeText('Order created')                            // regular text
/// WeText('Paid', type: SemanticEnum.success, bold: true)
/// WeText('Hint', role: WeTextRole.secondary, size: SizeEnum.small)
/// WeText('Very long description…', truncate: true)
/// ```
class WeText extends StatelessWidget {
  const WeText(
    this.data, {
    super.key,
    this.type,
    this.role = WeTextRole.regular,
    this.size = SizeEnum.defaultSize,
    this.bold = false,
    this.italic = false,
    this.strike = false,
    this.mark = false,
    this.truncate = false,
    this.maxLines,
    this.align,
    this.color,
  });

  final String data;

  /// Semantic colour; wins over [role].
  final SemanticEnum? type;
  final WeTextRole role;
  final SizeEnum size;
  final bool bold;
  final bool italic;

  /// Strike-through, like `<del>`.
  final bool strike;

  /// Highlight with a warning-tinted background, like `<mark>`.
  final bool mark;

  /// Single line with an ellipsis.
  final bool truncate;
  final int? maxLines;
  final TextAlign? align;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final Color fg =
        color ??
        (type != null
            ? colors.semantic(type!)
            : switch (role) {
                WeTextRole.primary => colors.primaryText,
                WeTextRole.regular => colors.regularText,
                WeTextRole.secondary => colors.secondaryText,
                WeTextRole.placeholder => colors.placeholderText,
                WeTextRole.disabled => colors.disabledText,
              });

    final Widget text = Text(
      data,
      textAlign: align,
      maxLines: truncate ? 1 : maxLines,
      overflow: truncate || maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: we.sizes.control(size).fontSize,
        color: fg,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        decoration: strike ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: fg,
      ),
    );

    if (!mark) return text;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: colors.light(SemanticEnum.warning, 8),
        borderRadius: BorderRadius.circular(we.radius.small),
      ),
      child: text,
    );
  }
}
