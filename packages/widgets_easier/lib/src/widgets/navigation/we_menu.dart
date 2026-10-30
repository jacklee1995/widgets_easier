import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../badge/we_badge.dart';

/// One entry of a [WeMenu]: an item, a sub-menu or a group title.
sealed class WeMenuEntry {
  const WeMenuEntry();
}

/// A selectable leaf, after `el-menu-item`.
class WeMenuItem extends WeMenuEntry {
  const WeMenuItem(
    this.id,
    this.label, {
    this.icon,
    this.badge,
    this.disabled = false,
  });

  /// Reported through [WeMenu.onSelect]; also used to mark the active item.
  final String id;
  final String label;
  final IconData? icon;

  /// A count shown at the trailing edge, or `null` for none.
  final Object? badge;
  final bool disabled;
}

/// A collapsible node with nested [children], after `el-sub-menu`.
class WeSubMenu extends WeMenuEntry {
  const WeSubMenu(
    this.id,
    this.label, {
    this.icon,
    required this.children,
    this.badge,
  });

  final String id;
  final String label;
  final IconData? icon;
  final List<WeMenuEntry> children;
  final Object? badge;

  /// Whether an item with [itemId] lives anywhere below this node.
  bool contains(String? itemId) =>
      itemId != null && _entriesContain(children, itemId);
}

/// A titled run of entries, after `el-menu-item-group`.
///
/// Groups only add a caption; they do not nest visually. Use them to split a
/// long menu into sections such as "Trade" / "Growth" / "System".
class WeMenuGroup extends WeMenuEntry {
  const WeMenuGroup(this.title, {required this.children});

  final String title;
  final List<WeMenuEntry> children;
}

bool _entriesContain(List<WeMenuEntry> entries, String itemId) => entries.any(
  (c) => switch (c) {
    WeMenuItem() => c.id == itemId,
    WeSubMenu() => c.contains(itemId),
    WeMenuGroup() => _entriesContain(c.children, itemId),
  },
);

/// The sub-menus that sit at the root of the menu, looking through groups,
/// which only add a caption and do not count as a nesting level.
Iterable<WeSubMenu> _topLevelSubMenus(List<WeMenuEntry> entries) sync* {
  for (final e in entries) {
    switch (e) {
      case WeSubMenu():
        yield e;
      case WeMenuGroup():
        yield* _topLevelSubMenus(e.children);
      case WeMenuItem():
        break;
    }
  }
}

/// Every item below [entries], depth first, ignoring sub-menu boundaries.
Iterable<WeMenuItem> _flatten(List<WeMenuEntry> entries) sync* {
  for (final e in entries) {
    switch (e) {
      case WeMenuItem():
        yield e;
      case WeSubMenu():
        yield* _flatten(e.children);
      case WeMenuGroup():
        yield* _flatten(e.children);
    }
  }
}

/// A vertical navigation menu, after `el-menu` in vertical mode.
///
/// Give it a tree of [WeMenuEntry]s, the [selectedId] and an [onSelect]
/// callback. Sub-menus can be opened in controlled mode through [openIds] or
/// left to manage themselves with [defaultOpenIds]; in the latter case the
/// branch holding [selectedId] opens by itself, also when the selection is
/// changed from outside. In [collapsed] mode only icons are shown and
/// sub-menus open in a popup anchored to their tile.
///
/// The look is deliberately rectangular, the way desktop and web navigation
/// panes are: rows run the full width of the menu with square corners, the
/// selected row carries a flush accent bar at its leading edge, and the
/// children of an open sub-menu hang off a hairline tree line. Icons, labels
/// and captions of every level share the same vertical gridlines, so nothing
/// drifts as the tree expands. Pass a non-zero [radius] if you want the rows
/// rounded instead.
///
/// Every row is focusable and activates with <kbd>Space</kbd> /
/// <kbd>Enter</kbd>.
///
/// ```dart
/// WeMenu(
///   selectedId: current,
///   onSelect: (id) => setState(() => current = id),
///   entries: const [
///     WeMenuItem('home', 'Home', icon: Icons.home_outlined),
///     WeSubMenu('goods', 'Goods', icon: Icons.inventory_2_outlined, children: [
///       WeMenuItem('list', 'All goods'),
///       WeMenuItem('stock', 'Low stock', badge: 12),
///     ]),
///   ],
/// )
/// ```
///
/// Platform: desktop and web (pointer + keyboard, wide screen). On phones
/// prefer [WeTabbar].
class WeMenu extends StatefulWidget {
  const WeMenu({
    super.key,
    required this.entries,
    required this.onSelect,
    this.selectedId,
    this.collapsed = false,
    this.openIds,
    this.defaultOpenIds = const {},
    this.autoOpenSelected = true,
    this.onOpenChanged,
    this.uniqueOpened = false,
    this.backgroundColor,
    this.textColor,
    this.activeColor,
    this.activeBackgroundColor,
    this.showIndicator = true,
    this.indicatorWidth = 3,
    this.showRail = true,
    this.showGroupRule = true,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
    this.itemHeight = 36,
    this.gutter = 14,
    this.indent = 28,
    this.radius = 0,
    this.iconSize = 18,
    this.fontSize = 13.5,
    this.badgeMax = 99,
    this.controller,
  });

  final List<WeMenuEntry> entries;
  final ValueChanged<String> onSelect;
  final String? selectedId;

  /// Icons only, labels in tooltips, sub-menus as popups.
  final bool collapsed;

  /// Controlled set of open sub-menu ids. `null` for uncontrolled.
  final Set<String>? openIds;

  /// Sub-menus open at first build, in uncontrolled mode.
  final Set<String> defaultOpenIds;

  /// In uncontrolled mode, open the sub-menus that lead to [selectedId]
  /// whenever it changes, so a selection made elsewhere is always visible.
  final bool autoOpenSelected;

  final ValueChanged<Set<String>>? onOpenChanged;

  /// Only one top-level sub-menu open at a time.
  final bool uniqueOpened;

  final Color? backgroundColor;
  final Color? textColor;

  /// Colour of the selected row's text, icon and accent bar.
  final Color? activeColor;

  /// Fill behind the selected row. Defaults to a faint tint of [activeColor].
  final Color? activeBackgroundColor;

  /// Draw the accent bar at the leading edge of the selected row.
  final bool showIndicator;

  /// Thickness of that accent bar.
  final double indicatorWidth;

  /// Draw the hairline tree line beside the children of an open sub-menu.
  final bool showRail;

  /// Draw a hairline above each [WeMenuGroup] caption.
  final bool showGroupRule;

  final EdgeInsetsGeometry padding;
  final double itemHeight;

  /// Inset from the leading edge to the icon column.
  final double gutter;

  /// Extra leading inset per nesting level. The default lines a child's label
  /// up with its parent's label.
  final double indent;

  /// Corner radius of the rows. `0`, the default, keeps them rectangular.
  final double radius;

  final double iconSize;
  final double fontSize;

  /// Counts above this render as `badgeMax+`.
  final int badgeMax;

  final ScrollController? controller;

  @override
  State<WeMenu> createState() => _WeMenuState();
}

class _WeMenuState extends State<WeMenu> {
  late Set<String> _open = {
    ...widget.defaultOpenIds,
    if (widget.autoOpenSelected) ..._pathTo(widget.selectedId),
  };

  Set<String> get _openIds => widget.openIds ?? _open;

  @override
  void didUpdateWidget(WeMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openIds == null &&
        widget.autoOpenSelected &&
        widget.selectedId != oldWidget.selectedId) {
      final path = _pathTo(widget.selectedId);
      if (!_open.containsAll(path)) {
        _open = {..._open, ...path};
      }
    }
  }

  /// Ids of every sub-menu on the way down to [itemId].
  Set<String> _pathTo(String? itemId) {
    final path = <String>{};
    if (itemId == null) return path;
    bool walk(List<WeMenuEntry> entries) {
      for (final e in entries) {
        switch (e) {
          case WeMenuItem():
            if (e.id == itemId) return true;
          case WeMenuGroup():
            if (walk(e.children)) return true;
          case WeSubMenu():
            if (walk(e.children)) {
              path.add(e.id);
              return true;
            }
        }
      }
      return false;
    }

    walk(widget.entries);
    return path;
  }

  void _toggle(WeSubMenu sub, {required bool topLevel}) {
    final next = {..._openIds};
    if (next.contains(sub.id)) {
      next.remove(sub.id);
    } else {
      if (widget.uniqueOpened && topLevel) {
        for (final e in _topLevelSubMenus(widget.entries)) {
          next.remove(e.id);
        }
      }
      next.add(sub.id);
    }
    if (widget.openIds == null) setState(() => _open = next);
    widget.onOpenChanged?.call(next);
  }

  /// Whether the tree has any sub-menu at all. When it does, every row keeps
  /// a trailing column free for the chevron so that badges of rows with and
  /// without one still right-align on the same gridline.
  late final bool _hasSubMenus = _topLevelSubMenusDeep(widget.entries);

  static bool _topLevelSubMenusDeep(List<WeMenuEntry> entries) => entries.any(
    (e) => switch (e) {
      WeSubMenu() => true,
      WeMenuGroup() => _topLevelSubMenusDeep(e.children),
      WeMenuItem() => false,
    },
  );

  _MenuStyle _style(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final Color active = widget.activeColor ?? colors.primary;
    return _MenuStyle(
      active: active,
      activeBackground:
          widget.activeBackgroundColor ?? colors.lighten(active, 8),
      hoverBackground: colors.lightFill,
      text: widget.textColor ?? colors.regularText,
      strongText: widget.textColor ?? colors.primaryText,
      muted: colors.placeholderText,
      disabled: colors.disabledText,
      rail: colors.lightBorder,
      divider: colors.lighterBorder,
      radius: widget.radius,
      popupRadius: we.radius.base,
      height: widget.itemHeight,
      gutter: widget.gutter,
      indent: widget.indent,
      iconSize: widget.iconSize,
      fontSize: widget.fontSize,
      badgeMax: widget.badgeMax,
      indicatorWidth: widget.showIndicator ? widget.indicatorWidth : 0,
      trailingSlot: _hasSubMenus ? 16 : 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    WePlatform.debugCheckFit(
      context,
      'WeMenu',
      WePlatformFit.desktop,
      alternative: '底部导航栏 WeTabbar',
    );
    final colors = context.weColors;
    final style = _style(context);
    return Container(
      color: widget.backgroundColor ?? colors.baseBackground,
      child: ListView(
        controller: widget.controller,
        padding: widget.padding,
        children: [
          for (final (i, e) in widget.entries.indexed)
            ..._build(context, e, 0, true, style, first: i == 0),
        ],
      ),
    );
  }

  List<Widget> _build(
    BuildContext context,
    WeMenuEntry entry,
    int level,
    bool topLevel,
    _MenuStyle style, {
    bool first = false,
  }) {
    switch (entry) {
      case WeMenuItem():
        return [_item(entry, level, style)];
      case WeMenuGroup():
        return [
          if (widget.collapsed)
            if (!first && widget.showGroupRule)
              _GroupRule(style: style)
            else
              const SizedBox.shrink()
          else
            _GroupCaption(
              title: entry.title,
              level: level,
              style: style,
              withRule: !first && widget.showGroupRule,
            ),
          for (final c in entry.children)
            ..._build(context, c, level, topLevel, style),
        ];
      case WeSubMenu():
        final bool open = _openIds.contains(entry.id);
        final bool active = entry.contains(widget.selectedId);
        if (widget.collapsed) {
          return [
            Builder(
              builder: (tileContext) => _MenuTile(
                style: style,
                level: 0,
                icon: entry.icon,
                label: entry.label,
                badge: entry.badge,
                collapsed: true,
                selected: active,
                parentOfSelected: false,
                onTap: () => _popup(tileContext, entry),
              ),
            ),
          ];
        }
        return [
          _MenuTile(
            style: style,
            level: level,
            icon: entry.icon,
            label: entry.label,
            badge: entry.badge,
            collapsed: false,
            selected: false,
            parentOfSelected: active,
            expanded: open,
            trailing: AnimatedRotation(
              turns: open ? 0.25 : 0,
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: active ? style.active : style.muted,
              ),
            ),
            onTap: () => _toggle(entry, topLevel: topLevel),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: open
                ? _Children(
                    style: style,
                    level: level,
                    showRail: widget.showRail,
                    children: [
                      for (final c in entry.children)
                        ..._build(context, c, level + 1, false, style),
                    ],
                  )
                : const SizedBox(width: double.infinity),
          ),
        ];
    }
  }

  Widget _item(WeMenuItem item, int level, _MenuStyle style) => _MenuTile(
    style: style,
    level: level,
    icon: item.icon,
    label: item.label,
    badge: item.badge,
    collapsed: widget.collapsed,
    selected: item.id == widget.selectedId,
    parentOfSelected: false,
    disabled: item.disabled,
    onTap: item.disabled ? null : () => widget.onSelect(item.id),
  );

  /// Opens [sub] as a popup beside the tile that owns [tileContext].
  Future<void> _popup(BuildContext tileContext, WeSubMenu sub) async {
    final colors = tileContext.weColors;
    final style = _style(tileContext);
    final box = tileContext.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(tileContext).context.findRenderObject()! as RenderBox;
    final topRight = box.localToGlobal(
      Offset(box.size.width + 4, 0),
      ancestor: overlay,
    );
    final items = _flatten(sub.children).toList();
    final picked = await showMenu<String>(
      context: tileContext,
      position: RelativeRect.fromLTRB(
        topRight.dx,
        topRight.dy,
        overlay.size.width - topRight.dx,
        0,
      ),
      color: colors.overlayBackground,
      elevation: 6,
      shadowColor: const Color(0x1F000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(style.popupRadius),
        side: BorderSide(color: colors.lighterBorder),
      ),
      constraints: const BoxConstraints(minWidth: 168),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          height: 28,
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
          child: Text(
            sub.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: style.muted,
            ),
          ),
        ),
        for (final i in items)
          PopupMenuItem<String>(
            value: i.id,
            height: 34,
            enabled: !i.disabled,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    i.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: i.id == widget.selectedId
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: i.disabled
                          ? style.disabled
                          : i.id == widget.selectedId
                          ? style.active
                          : style.text,
                    ),
                  ),
                ),
                if (i.badge != null) ...[
                  const SizedBox(width: 12),
                  WeBadge(value: i.badge, max: style.badgeMax, radius: 2),
                ],
              ],
            ),
          ),
      ],
    );
    if (picked != null) widget.onSelect(picked);
  }
}

/// Colours and metrics shared by every row of one menu.
@immutable
class _MenuStyle {
  const _MenuStyle({
    required this.active,
    required this.activeBackground,
    required this.hoverBackground,
    required this.text,
    required this.strongText,
    required this.muted,
    required this.disabled,
    required this.rail,
    required this.divider,
    required this.radius,
    required this.popupRadius,
    required this.height,
    required this.gutter,
    required this.indent,
    required this.iconSize,
    required this.fontSize,
    required this.badgeMax,
    required this.indicatorWidth,
    required this.trailingSlot,
  });

  final Color active;
  final Color activeBackground;
  final Color hoverBackground;
  final Color text;
  final Color strongText;
  final Color muted;
  final Color disabled;
  final Color rail;
  final Color divider;
  final double radius;
  final double popupRadius;
  final double height;
  final double gutter;
  final double indent;
  final double iconSize;
  final double fontSize;
  final int badgeMax;
  final double indicatorWidth;

  /// Width held free at the trailing edge for the disclosure chevron.
  final double trailingSlot;

  /// Leading inset of the icon column at [level].
  double leadingOf(int level) => gutter + level * indent;

  /// Where the label column starts at [level]; children of a sub-menu line up
  /// with their parent's label because [indent] is the width of the icon slot.
  double labelStartOf(int level) => leadingOf(level) + iconSize + 10;
}

/// Stands in for a group caption while the menu is collapsed.
class _GroupRule extends StatelessWidget {
  const _GroupRule({required this.style});

  final _MenuStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(height: 1, color: style.divider),
    );
  }
}

/// The caption above a [WeMenuGroup], with an optional hairline above it.
class _GroupCaption extends StatelessWidget {
  const _GroupCaption({
    required this.title,
    required this.level,
    required this.style,
    required this.withRule,
  });

  final String title;
  final int level;
  final _MenuStyle style;
  final bool withRule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (withRule) ...[
          const SizedBox(height: 7),
          Container(height: 1, color: style.divider),
        ],
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            style.leadingOf(level),
            10,
            12,
            4,
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              height: 1.2,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: style.muted,
            ),
          ),
        ),
      ],
    );
  }
}

/// The children of an open sub-menu, with the tree line beside them.
class _Children extends StatelessWidget {
  const _Children({
    required this.style,
    required this.level,
    required this.showRail,
    required this.children,
  });

  final _MenuStyle style;
  final int level;
  final bool showRail;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
    if (!showRail) return column;
    // The line runs down the middle of the parent's icon column. It is
    // painted over the rows so that it stays unbroken across a hovered or
    // selected child; the label column starts well to its right.
    final double x = style.leadingOf(level) + style.iconSize / 2;
    return Stack(
      children: [
        column,
        PositionedDirectional(
          start: x,
          top: 0,
          bottom: 0,
          child: Container(width: 1, color: style.rail),
        ),
      ],
    );
  }
}

class _MenuTile extends StatefulWidget {
  const _MenuTile({
    required this.style,
    required this.level,
    required this.label,
    required this.collapsed,
    required this.selected,
    required this.parentOfSelected,
    required this.onTap,
    this.icon,
    this.badge,
    this.trailing,
    this.expanded,
    this.disabled = false,
  });

  final _MenuStyle style;
  final int level;
  final IconData? icon;
  final String label;
  final Object? badge;
  final Widget? trailing;
  final bool collapsed;
  final bool selected;

  /// A sub-menu whose descendant is selected: emphasised, but no fill.
  final bool parentOfSelected;

  /// Open state of a sub-menu row, for semantics. `null` for items.
  final bool? expanded;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  State<_MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile> {
  /// Below this width a row drops its label, so a menu that is being animated
  /// between its wide and narrow widths never overflows.
  static const double _kIconOnlyBelow = 120;

  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _build(
        context,
        collapsed: widget.collapsed || constraints.maxWidth < _kIconOnlyBelow,
      ),
    );
  }

  Widget _build(BuildContext context, {required bool collapsed}) {
    final s = widget.style;
    final bool interactive = !widget.disabled && widget.onTap != null;
    final bool lit = widget.selected || widget.parentOfSelected;

    final Color iconColor = widget.disabled
        ? s.disabled
        : lit
        ? s.active
        : s.text;
    final Color labelColor = widget.disabled
        ? s.disabled
        : widget.selected
        ? s.active
        : widget.parentOfSelected
        ? s.strongText
        : s.text;
    final Color? background = widget.selected
        ? s.activeBackground
        : (_hovered || _focused) && interactive
        ? s.hoverBackground
        : null;

    // Nested rows without an icon start at the label column, which is where
    // their parent's label starts too. Top-level rows always reserve the icon
    // slot so a mixed run of rows stays aligned.
    final bool reserveIcon = widget.icon != null || widget.level == 0;

    final Widget row = Row(
      mainAxisAlignment: collapsed
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (widget.icon != null)
          Icon(widget.icon, size: s.iconSize, color: iconColor)
        else if (!collapsed && reserveIcon)
          SizedBox(width: s.iconSize),
        if (!collapsed) ...[
          if (reserveIcon) const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: s.fontSize,
                height: 1.2,
                fontWeight: lit ? FontWeight.w600 : FontWeight.w400,
                color: labelColor,
              ),
            ),
          ),
          if (widget.badge != null)
            WeBadge(value: widget.badge, max: s.badgeMax, radius: 2),
          if (s.trailingSlot > 0) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: s.trailingSlot,
              child: widget.trailing == null
                  ? null
                  : Center(child: widget.trailing),
            ),
          ] else if (widget.trailing != null) ...[
            const SizedBox(width: 8),
            widget.trailing!,
          ],
        ],
      ],
    );

    Widget tile = AnimatedContainer(
      duration: const Duration(milliseconds: 110),
      height: s.height,
      padding: EdgeInsetsDirectional.only(
        start: collapsed ? 0 : s.leadingOf(widget.level),
        end: collapsed ? 0 : 12,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: s.radius == 0 ? null : BorderRadius.circular(s.radius),
      ),
      // Drawn over the row so the focus outline never shifts the layout.
      foregroundDecoration: _focused && interactive
          ? BoxDecoration(
              border: Border.all(color: s.active),
              borderRadius: s.radius == 0
                  ? null
                  : BorderRadius.circular(s.radius),
            )
          : null,
      child: row,
    );

    if (widget.selected && s.indicatorWidth > 0) {
      tile = Stack(
        children: [
          tile,
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: Container(width: s.indicatorWidth, color: s.active),
          ),
        ],
      );
    }

    tile = FocusableActionDetector(
      enabled: interactive,
      mouseCursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onShowHoverHighlight: (v) => setState(() => _hovered = v),
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: Semantics(
        button: true,
        enabled: interactive,
        selected: widget.selected,
        expanded: widget.expanded,
        label: collapsed ? widget.label : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: tile,
        ),
      ),
    );

    if (collapsed) {
      tile = Tooltip(
        message: widget.label,
        waitDuration: const Duration(milliseconds: 300),
        child: tile,
      );
      if (widget.badge != null) {
        // Tuck the dot against the icon's top-right corner, inside the row.
        tile = WeBadge(dot: true, offset: const Offset(12, 9), child: tile);
      }
    }
    return tile;
  }
}
