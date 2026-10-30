import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';

/// One panel of a [WeCollapse].
class WeCollapseItem {
  const WeCollapseItem({
    required this.name,
    required this.title,
    required this.child,
    this.icon,
    this.extra,
    this.disabled = false,
    this.titleBuilder,
  });

  /// Identifies the panel in [WeCollapse.expanded].
  final String name;
  final String title;
  final Widget child;
  final IconData? icon;

  /// Sits at the right of the header, before the arrow, e.g. a badge or a
  /// short status. Tapping it still toggles the panel unless it handles the
  /// tap itself.
  final Widget? extra;
  final bool disabled;

  /// Replaces the whole header row except the arrow.
  final Widget Function(BuildContext context, bool expanded)? titleBuilder;
}

/// An accordion of titled panels, after `el-collapse`.
///
/// Headers take keyboard focus; Enter or Space toggles. Content of a closed
/// panel is excluded from focus traversal, so Tab never lands in a hidden
/// field.
///
/// ```dart
/// WeCollapse(
///   expanded: open,
///   accordion: true,
///   onChanged: (s) => setState(() => open = s),
///   items: [
///     WeCollapseItem(name: 'a', title: '基础', child: Text('...')),
///     WeCollapseItem(name: 'b', title: '安全', extra: WeBadge.dot(), child: ...),
///   ],
/// )
/// ```
class WeCollapse extends StatelessWidget {
  const WeCollapse({
    super.key,
    required this.items,
    required this.expanded,
    required this.onChanged,
    this.accordion = false,
    this.border = true,
  });

  final List<WeCollapseItem> items;
  final Set<String> expanded;
  final ValueChanged<Set<String>> onChanged;

  /// Opening one panel closes the others.
  final bool accordion;

  /// Draws the outer frame; without it only the dividers remain.
  final bool border;

  void _toggle(WeCollapseItem item) {
    if (item.disabled) return;
    final next = {...expanded};
    if (next.contains(item.name)) {
      next.remove(item.name);
    } else {
      if (accordion) next.clear();
      next.add(item.name);
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    return Container(
      clipBehavior: border ? Clip.antiAlias : Clip.none,
      decoration: border
          ? BoxDecoration(
              border: Border.all(color: colors.lighterBorder),
              borderRadius: BorderRadius.circular(we.radius.base),
            )
          : BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: colors.lighterBorder),
              ),
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) Container(height: 1, color: colors.lighterBorder),
            _Panel(
              key: ValueKey(items[i].name),
              item: items[i],
              open: expanded.contains(items[i].name),
              onTap: () => _toggle(items[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _Panel extends StatefulWidget {
  const _Panel({
    super.key,
    required this.item,
    required this.open,
    required this.onTap,
  });

  final WeCollapseItem item;
  final bool open;
  final VoidCallback onTap;

  @override
  State<_Panel> createState() => _PanelState();
}

class _PanelState extends State<_Panel> {
  bool _focused = false;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final item = widget.item;
    final bool open = widget.open;
    final Color titleColor = item.disabled
        ? colors.disabledText
        : _hover
        ? colors.primary
        : colors.primaryText;

    final Widget title =
        item.titleBuilder?.call(context, open) ??
        Row(
          children: [
            if (item.icon != null) ...[
              Icon(item.icon, size: 16, color: titleColor),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                item.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ),
          ],
        );

    final Widget header = FocusableActionDetector(
      enabled: !item.disabled,
      mouseCursor: item.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      onShowHoverHighlight: (v) => setState(() => _hover = v),
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap();
            return null;
          },
        ),
      },
      child: Semantics(
        button: true,
        expanded: open,
        enabled: !item.disabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: item.disabled ? null : widget.onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            foregroundDecoration: _focused
                ? BoxDecoration(
                    border: Border.all(
                      color: colors.lighten(colors.primary, 4),
                      width: 1.5,
                    ),
                  )
                : null,
            child: Row(
              children: [
                Expanded(child: title),
                if (item.extra != null) ...[
                  const SizedBox(width: 12),
                  item.extra!,
                ],
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: open ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: item.disabled
                        ? colors.disabledText
                        : colors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        ClipRect(
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topLeft,
            heightFactor: open ? 1 : 0,
            child: ExcludeFocus(
              excluding: !open,
              child: ExcludeSemantics(
                excluding: !open,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.7,
                      color: colors.regularText,
                    ),
                    child: item.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
