import 'package:flutter/material.dart';

import '../../core/core.dart';

/// When a [WeCard] shows its drop shadow, after `el-card` `shadow`.
enum WeCardShadow { always, hover, never }

/// A bordered surface with an optional header and footer, after `el-card`.
///
/// ```dart
/// WeCard(
///   title: 'Sales',
///   subtitle: 'Last 30 days',
///   extra: WeLink('More', onTap: ...),
///   child: TrendChart(...),
/// )
/// ```
class WeCard extends StatefulWidget {
  const WeCard({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.header,
    this.extra,
    this.footer,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.headerPadding = const EdgeInsets.fromLTRB(20, 16, 20, 14),
    this.shadow = WeCardShadow.never,
    this.bordered = true,
    this.color,
    this.borderRadius,
    this.dividedHeader = true,
    this.fillHeight = false,
    this.onTap,
  });

  final String? title;
  final String? subtitle;

  /// An icon drawn in a tinted square before the title.
  final IconData? icon;

  /// Replaces the generated title row entirely.
  final Widget? header;

  /// Trailing header widget, e.g. a link or a button group.
  final Widget? extra;
  final Widget? footer;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry headerPadding;
  final WeCardShadow shadow;
  final bool bordered;
  final Color? color;
  final BorderRadius? borderRadius;

  /// Draw a rule between header and body.
  final bool dividedHeader;

  /// Let the body take all remaining height, for scrollable content inside a
  /// card that is itself given a fixed height (e.g. through `Expanded`).
  final bool fillHeight;

  /// Makes the whole card clickable.
  final VoidCallback? onTap;

  @override
  State<WeCard> createState() => _WeCardState();
}

class _WeCardState extends State<WeCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final bool hasHeader =
        widget.header != null || widget.title != null || widget.extra != null;
    final BorderRadius radius =
        widget.borderRadius ?? BorderRadius.circular(we.radius.base * 2.5);

    final bool shadowOn = switch (widget.shadow) {
      WeCardShadow.always => true,
      WeCardShadow.hover => _hover,
      WeCardShadow.never => false,
    };

    Widget header = const SizedBox.shrink();
    if (hasHeader) {
      header = Padding(
        padding: widget.headerPadding,
        child:
            widget.header ??
            Row(
              children: [
                if (widget.icon != null) ...[
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.light(SemanticEnum.primary, 9),
                      borderRadius: BorderRadius.circular(we.radius.base * 2),
                    ),
                    child: Icon(widget.icon, size: 16, color: colors.primary),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.title != null)
                        Text(
                          widget.title!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colors.primaryText,
                          ),
                        ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.extra != null) widget.extra!,
              ],
            ),
      );
    }

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.color ?? colors.overlayBackground,
        borderRadius: radius,
        border: widget.bordered
            ? Border.all(color: colors.lighterBorder)
            : null,
        boxShadow: shadowOn ? we.shadows.light : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: widget.fillHeight ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (hasHeader) header,
          if (hasHeader && widget.dividedHeader)
            Divider(height: 1, thickness: 1, color: colors.lighterBorder),
          if (widget.fillHeight)
            Expanded(
              child: Padding(padding: widget.padding, child: widget.child),
            )
          else
            Padding(padding: widget.padding, child: widget.child),
          if (widget.footer != null) ...[
            Divider(height: 1, thickness: 1, color: colors.lighterBorder),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.padding.horizontal / 2,
                vertical: 12,
              ),
              child: widget.footer!,
            ),
          ],
        ],
      ),
    );

    if (widget.shadow == WeCardShadow.hover || widget.onTap != null) {
      card = MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(onTap: widget.onTap, child: card),
      );
    }
    return card;
  }
}
