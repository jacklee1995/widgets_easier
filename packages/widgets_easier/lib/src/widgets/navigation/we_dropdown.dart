import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../overlay/we_popper.dart';

/// One choice of a [WeDropdown].
class WeDropdownItem<T> {
  const WeDropdownItem(
    this.value,
    this.label, {
    this.icon,
    this.divided = false,
    this.disabled = false,
    this.type,
  });

  final T value;
  final String label;
  final IconData? icon;

  /// Draws a separator above this item.
  final bool divided;
  final bool disabled;

  /// Tints the row, e.g. `SemanticEnum.danger` for a destructive action.
  final SemanticEnum? type;
}

/// A trigger that opens a list of actions, after `el-dropdown`.
///
/// Wraps any [child]; the panel opens on tap below (or above if there is no
/// room) and reports the picked value through [onSelected].
///
/// ```dart
/// WeDropdown<String>(
///   onSelected: (v) => ...,
///   items: const [
///     WeDropdownItem('profile', 'Profile', icon: Icons.person_outline),
///     WeDropdownItem('logout', 'Sign out', divided: true, type: SemanticEnum.danger),
///   ],
///   child: WeButton(text: 'Account', trailingIcon: Icons.expand_more),
/// )
/// ```
class WeDropdown<T> extends StatefulWidget {
  const WeDropdown({
    super.key,
    required this.items,
    required Widget this.child,
    this.onSelected,
    this.width = 160,
    this.alignRight = false,
    this.trigger = WePopperTrigger.click,
    this.placement,
  }) : builder = null;

  /// Builds the trigger yourself and call `open` from it. Use this when the
  /// trigger is a button that would otherwise swallow the tap.
  ///
  /// ```dart
  /// WeDropdown<String>.builder(
  ///   items: [...],
  ///   builder: (context, open) => WeButton(text: 'More', onPressed: open),
  /// )
  /// ```
  const WeDropdown.builder({
    super.key,
    required this.items,
    required Widget Function(BuildContext context, VoidCallback open)
    this.builder,
    this.onSelected,
    this.width = 160,
    this.alignRight = false,
    this.placement,
  }) : child = null,
       trigger = WePopperTrigger.manual;

  final List<WeDropdownItem<T>> items;
  final Widget? child;
  final Widget Function(BuildContext context, VoidCallback open)? builder;
  final ValueChanged<T>? onSelected;
  final double width;

  /// Align the panel's right edge with the trigger's right edge.
  final bool alignRight;

  /// `click` (default) or `hover`, after `el-dropdown`'s `trigger`.
  final WePopperTrigger trigger;

  /// Overrides the placement derived from [alignRight].
  final WePlacement? placement;

  /// Shows the menu as a route anchored to [context], which must belong to
  /// the trigger widget, and completes with the picked value. The widget
  /// form is preferred: its panel follows the trigger and nests in dialogs.
  static Future<T?> open<T>(
    BuildContext context, {
    required List<WeDropdownItem<T>> items,
    double width = 160,
    bool alignRight = false,
  }) {
    final colors = context.weColors;
    final box = context.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final Offset topLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
    final Offset bottomRight = box.localToGlobal(
      box.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );
    final position = alignRight
        ? RelativeRect.fromLTRB(
            bottomRight.dx - width,
            bottomRight.dy + 4,
            overlay.size.width - bottomRight.dx,
            0,
          )
        : RelativeRect.fromLTRB(
            topLeft.dx,
            bottomRight.dy + 4,
            overlay.size.width - topLeft.dx - width,
            0,
          );

    return showMenu<T>(
      context: context,
      position: position,
      elevation: 0,
      color: colors.overlayBackground,
      constraints: BoxConstraints.tightFor(width: width),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colors.lighterBorder),
      ),
      menuPadding: const EdgeInsets.symmetric(vertical: 6),
      items: [
        for (final item in items)
          PopupMenuItem<T>(
            value: item.value,
            enabled: !item.disabled,
            height: 36,
            padding: EdgeInsets.zero,
            child: _DropdownRow(item: item),
          ),
      ],
    );
  }

  @override
  State<WeDropdown<T>> createState() => _WeDropdownState<T>();
}

class _WeDropdownState<T> extends State<WeDropdown<T>> {
  final WePopperController _popper = WePopperController();

  @override
  void dispose() {
    _popper.dispose();
    super.dispose();
  }

  void _select(WeDropdownItem<T> item) {
    _popper.hide();
    widget.onSelected?.call(item.value);
  }

  Widget _panel(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final item in widget.items)
        _DropdownRow<T>(
          item: item,
          onTap: item.disabled ? null : () => _select(item),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final WePlacement placement =
        widget.placement ??
        (widget.alignRight ? WePlacement.bottomEnd : WePlacement.bottomStart);
    const style = WePopperStyle(padding: EdgeInsets.symmetric(vertical: 6));
    if (widget.builder != null) {
      return WePopper.builder(
        controller: _popper,
        placement: placement,
        width: widget.width,
        gap: 4,
        style: style,
        popupBuilder: _panel,
        builder: (context, _) => widget.builder!(context, _popper.show),
      );
    }
    return WePopper(
      controller: _popper,
      placement: placement,
      trigger: widget.trigger,
      width: widget.width,
      gap: 4,
      style: style,
      popupBuilder: _panel,
      child: widget.child!,
    );
  }
}

class _DropdownRow<T> extends StatefulWidget {
  const _DropdownRow({required this.item, this.onTap});

  final WeDropdownItem<T> item;
  final VoidCallback? onTap;

  @override
  State<_DropdownRow<T>> createState() => _DropdownRowState<T>();
}

class _DropdownRowState<T> extends State<_DropdownRow<T>> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final item = widget.item;
    final bool interactive = widget.onTap != null && !item.disabled;
    final Color accent = item.type != null
        ? colors.semantic(item.type!)
        : colors.primary;
    final Color fg = item.disabled
        ? colors.disabledText
        : _hover && interactive
        ? accent
        : item.type != null
        ? accent
        : colors.regularText;
    final Widget row = Container(
      color: _hover && interactive ? accent.withValues(alpha: 0.1) : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          if (item.icon != null) ...[
            Icon(item.icon, size: 16, color: fg),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(item.label, style: TextStyle(fontSize: 13, color: fg)),
          ),
        ],
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (item.divided)
          Divider(height: 7, thickness: 1, color: colors.lighterBorder),
        if (widget.onTap == null && !item.disabled)
          row
        else
          MouseRegion(
            cursor: interactive
                ? SystemMouseCursors.click
                : SystemMouseCursors.forbidden,
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
              child: row,
            ),
          ),
      ],
    );
  }
}
