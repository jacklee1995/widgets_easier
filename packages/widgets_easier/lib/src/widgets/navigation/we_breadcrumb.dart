import 'package:flutter/material.dart';

import '../../core/core.dart';

/// One crumb of a [WeBreadcrumb].
class WeBreadcrumbItem {
  const WeBreadcrumbItem(this.label, {this.icon, this.onTap});

  final String label;
  final IconData? icon;

  /// Makes the crumb a link. The last crumb is never clickable.
  final VoidCallback? onTap;
}

/// A location trail, after `el-breadcrumb`.
///
/// ```dart
/// WeBreadcrumb(items: [
///   WeBreadcrumbItem('Home', icon: Icons.home_outlined, onTap: goHome),
///   WeBreadcrumbItem('Goods', onTap: goGoods),
///   WeBreadcrumbItem('Edit'),
/// ])
/// ```
class WeBreadcrumb extends StatelessWidget {
  const WeBreadcrumb({
    super.key,
    required this.items,
    this.separator = '/',
    this.separatorIcon,
    this.fontSize = 13,
  });

  final List<WeBreadcrumbItem> items;

  /// Text between crumbs; ignored when [separatorIcon] is given.
  final String separator;
  final IconData? separatorIcon;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final int last = items.length - 1;
    final Widget sep = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: separatorIcon != null
          ? Icon(separatorIcon, size: fontSize, color: colors.placeholderText)
          : Text(
              separator,
              style: TextStyle(
                fontSize: fontSize,
                color: colors.placeholderText,
                fontWeight: FontWeight.w300,
              ),
            ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _Crumb(item: items[i], current: i == last, fontSize: fontSize),
          if (i != last) sep,
        ],
      ],
    );
  }
}

class _Crumb extends StatefulWidget {
  const _Crumb({
    required this.item,
    required this.current,
    required this.fontSize,
  });

  final WeBreadcrumbItem item;
  final bool current;
  final double fontSize;

  @override
  State<_Crumb> createState() => _CrumbState();
}

class _CrumbState extends State<_Crumb> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final bool link = !widget.current && widget.item.onTap != null;
    final Color color = widget.current
        ? colors.primaryText
        : link && _hover
        ? colors.primary
        : colors.regularText;

    final Widget label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.item.icon != null) ...[
          Icon(widget.item.icon, size: widget.fontSize + 2, color: color),
          const SizedBox(width: 4),
        ],
        Text(
          widget.item.label,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: color,
            fontWeight: widget.current ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );

    if (!link) return label;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(onTap: widget.item.onTap, child: label),
    );
  }
}
