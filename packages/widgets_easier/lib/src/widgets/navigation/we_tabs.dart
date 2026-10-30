import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../badge/we_badge.dart';

/// One tab of a [WeTabs].
class WeTab {
  const WeTab(this.label, {this.icon, this.badge, this.disabled = false});

  final String label;
  final IconData? icon;
  final Object? badge;
  final bool disabled;
}

/// Visual style of a [WeTabs] header, after `el-tabs` `type`.
enum WeTabsType {
  /// Text with an underline indicator. The default.
  line,

  /// Each tab is a card; the active one connects to the content.
  card,

  /// Like [card] but the whole strip sits on a filled bar.
  borderCard,
}

/// A tab strip with optional pane content, after `el-tabs`.
///
/// Controlled: pass [index] and [onChanged]. Give [children] (one per tab) to
/// have the matching pane shown below the strip in an [IndexedStack], or omit
/// them and render the content yourself.
class WeTabs extends StatelessWidget {
  const WeTabs({
    super.key,
    required this.tabs,
    required this.index,
    required this.onChanged,
    this.children,
    this.type = WeTabsType.line,
    this.stretch = false,
    this.size = SizeEnum.defaultSize,
  }) : assert(children == null || children.length == tabs.length);

  final List<WeTab> tabs;
  final int index;
  final ValueChanged<int> onChanged;
  final List<Widget>? children;
  final WeTabsType type;

  /// Spread tabs evenly across the full width.
  final bool stretch;
  final SizeEnum size;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final metrics = we.sizes.control(size);
    final double height = metrics.height + 8;

    final List<Widget> heads = [
      for (int i = 0; i < tabs.length; i++)
        _TabHead(
          tab: tabs[i],
          active: i == index,
          type: type,
          height: height,
          fontSize: metrics.fontSize,
          stretch: stretch,
          onTap: tabs[i].disabled ? null : () => onChanged(i),
        ),
    ];

    // Heads that do not fit (five tabs on a phone) scroll sideways instead of
    // overflowing; an unbounded parent keeps the plain row.
    Widget strip = stretch
        ? Row(children: [for (final h in heads) Expanded(child: h)])
        : LayoutBuilder(
            builder: (context, box) {
              final Widget row = Row(
                mainAxisSize: MainAxisSize.min,
                children: heads,
              );
              if (!box.hasBoundedWidth) return row;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: row,
              );
            },
          );

    switch (type) {
      case WeTabsType.line:
        strip = Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.lightBorder)),
          ),
          child: strip,
        );
      case WeTabsType.card:
        strip = Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.lightBorder)),
          ),
          child: strip,
        );
      case WeTabsType.borderCard:
        strip = Container(
          decoration: BoxDecoration(
            color: colors.lightFill,
            border: Border(bottom: BorderSide(color: colors.lightBorder)),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(we.radius.base),
            ),
          ),
          child: strip,
        );
    }

    if (children == null) return strip;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        strip,
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 160),
          child: KeyedSubtree(key: ValueKey(index), child: children![index]),
        ),
      ],
    );
  }
}

class _TabHead extends StatefulWidget {
  const _TabHead({
    required this.tab,
    required this.active,
    required this.type,
    required this.height,
    required this.fontSize,
    required this.stretch,
    required this.onTap,
  });

  final WeTab tab;
  final bool active;
  final WeTabsType type;
  final double height;
  final double fontSize;
  final bool stretch;
  final VoidCallback? onTap;

  @override
  State<_TabHead> createState() => _TabHeadState();
}

class _TabHeadState extends State<_TabHead> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final bool disabled = widget.tab.disabled;
    final Color fg = disabled
        ? colors.disabledText
        : widget.active || _hover
        ? colors.primary
        : colors.regularText;

    final Widget label = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.tab.icon != null) ...[
          Icon(widget.tab.icon, size: widget.fontSize + 2, color: fg),
          const SizedBox(width: 6),
        ],
        Text(
          widget.tab.label,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.active ? FontWeight.w600 : FontWeight.w400,
            color: fg,
          ),
        ),
        if (widget.tab.badge != null) ...[
          const SizedBox(width: 6),
          WeBadge(value: widget.tab.badge),
        ],
      ],
    );

    BoxDecoration deco;
    switch (widget.type) {
      case WeTabsType.line:
        deco = BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: widget.active ? colors.primary : Colors.transparent,
            ),
          ),
        );
      case WeTabsType.card:
        deco = BoxDecoration(
          color: widget.active ? colors.baseBackground : null,
          border: Border.all(
            color: widget.active ? colors.lightBorder : Colors.transparent,
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(we.radius.base),
          ),
        );
      case WeTabsType.borderCard:
        deco = BoxDecoration(
          color: widget.active ? colors.baseBackground : null,
          border: Border.all(
            color: widget.active ? colors.lightBorder : Colors.transparent,
          ),
        );
    }

    Widget box = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: deco,
      alignment: Alignment.center,
      child: label,
    );

    // Card tabs: the active tab "opens" into the pane. Cover its bottom edge
    // and the strip's rule with a 1px strip in the background colour.
    if (widget.type != WeTabsType.line && widget.active) {
      box = Transform.translate(
        offset: const Offset(0, 1),
        child: Stack(
          children: [
            box,
            Positioned(
              left: 1,
              right: 1,
              bottom: 0,
              height: 2,
              child: ColoredBox(color: colors.baseBackground),
            ),
          ],
        ),
      );
    }

    return MouseRegion(
      cursor: disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: box,
      ),
    );
  }
}
