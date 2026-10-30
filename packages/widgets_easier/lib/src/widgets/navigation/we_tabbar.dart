import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../badge/we_badge.dart';

/// One destination of a [WeTabbar].
@immutable
class WeTabbarItem {
  const WeTabbarItem(
    this.label,
    this.icon, {
    this.activeIcon,
    this.badge,
    this.dot = false,
  });

  final String label;
  final IconData icon;

  /// Shown instead of [icon] while the item is selected, e.g. a filled
  /// version of an outlined icon.
  final IconData? activeIcon;

  /// A count or a short text in the corner of the icon; numbers above 99
  /// read `99+`.
  final Object? badge;

  /// A small dot in the corner of the icon, for "something new".
  final bool dot;
}

/// The row of destinations along the bottom of a phone app.
///
/// ```dart
/// Scaffold(
///   body: pages[tab],
///   bottomNavigationBar: WeTabbar(
///     index: tab,
///     onChanged: (i) => setState(() => tab = i),
///     items: const [
///       WeTabbarItem('首页', Icons.home_outlined, activeIcon: Icons.home),
///       WeTabbarItem('消息', Icons.chat_bubble_outline, badge: 3),
///       WeTabbarItem('我的', Icons.person_outline, dot: true),
///     ],
///   ),
/// )
/// ```
///
/// Items share the width equally and are 56 tall, plus the bottom safe area
/// (the home indicator on recent phones) when [safeArea] is on. Tapping the
/// selected item again calls [onReselect], usually to scroll back to the top.
/// Screen readers hear each item as a selectable tab, "2 of 4".
///
/// Platform: mobile. On desktop and web use [WeMenu] or [WeTabs].
class WeTabbar extends StatelessWidget {
  const WeTabbar({
    super.key,
    required this.items,
    required this.index,
    required this.onChanged,
    this.onReselect,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.safeArea = true,
    this.border = true,
    this.height = 56,
  }) : assert(items.length >= 2, 'A tab bar needs at least two items.');

  final List<WeTabbarItem> items;
  final int index;
  final ValueChanged<int> onChanged;

  /// Called when the selected item is tapped again.
  final ValueChanged<int>? onReselect;

  /// Defaults to the theme's primary colour.
  final Color? activeColor;

  /// Defaults to the theme's secondary text colour.
  final Color? inactiveColor;

  /// Defaults to the theme's overlay background.
  final Color? backgroundColor;

  /// Pad the bottom by the device's safe area.
  final bool safeArea;

  /// A hairline along the top edge.
  final bool border;

  /// Height of the items, without the safe area. Never below 48 so every
  /// item stays an easy target.
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final double bottom = safeArea ? MediaQuery.paddingOf(context).bottom : 0;
    final Color active = activeColor ?? colors.primary;
    final Color inactive = inactiveColor ?? colors.secondaryText;

    return Material(
      color: backgroundColor ?? colors.overlayBackground,
      child: Container(
        decoration: BoxDecoration(
          border: border
              ? Border(top: BorderSide(color: colors.lighterBorder))
              : null,
        ),
        padding: EdgeInsets.only(bottom: bottom),
        child: SizedBox(
          height: height < 48 ? 48 : height,
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++)
                Expanded(
                  child: _TabbarCell(
                    item: items[i],
                    selected: i == index,
                    position: i,
                    count: items.length,
                    color: i == index ? active : inactive,
                    onTap: () =>
                        i == index ? onReselect?.call(i) : onChanged(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabbarCell extends StatelessWidget {
  const _TabbarCell({
    required this.item,
    required this.selected,
    required this.position,
    required this.count,
    required this.color,
    required this.onTap,
  });

  final WeTabbarItem item;
  final bool selected;
  final int position;
  final int count;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Widget icon = TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: color),
      duration: const Duration(milliseconds: 150),
      builder: (context, c, _) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WeBadge(
            value: item.badge,
            dot: item.dot && item.badge == null,
            hidden: item.badge == null && !item.dot,
            child: Icon(
              selected ? item.activeIcon ?? item.icon : item.icon,
              size: 22,
              color: c,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              height: 1.2,
              color: c,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );

    return Semantics(
      container: true,
      button: true,
      selected: selected,
      label: item.label,
      hint: '${position + 1} / $count',
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(onTap: onTap, child: icon),
    );
  }
}
