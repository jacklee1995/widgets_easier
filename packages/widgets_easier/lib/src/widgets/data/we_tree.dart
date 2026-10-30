import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';
import '../form/we_checkbox.dart';

/// A node of a [WeTree].
class WeTreeNode<T> {
  const WeTreeNode(
    this.value,
    this.label, {
    this.children = const [],
    this.disabled = false,
    this.icon,
    this.isLeaf,
  });

  final T value;
  final String label;
  final List<WeTreeNode<T>> children;
  final bool disabled;
  final IconData? icon;

  /// With [WeTree.lazyLoad], `true` stops a childless node from loading.
  /// `null` treats a node without [children] as a leaf unless the tree
  /// loads lazily.
  final bool? isLeaf;
}

/// Replaces the default "label contains the query" match of a filtered tree.
typedef WeTreeFilter<T> = bool Function(String query, WeTreeNode<T> node);

/// A collapsible tree with selection, linked checkboxes, lazy loading and
/// filtering, after `el-tree`.
///
/// ```dart
/// WeTree<String>(
///   nodes: categories,
///   selected: _current,
///   onSelect: (v) => setState(() => _current = v),
///   showCheckbox: true,
///   checked: _checked,
///   onCheck: (s) => setState(() => _checked = s),
/// )
/// ```
///
/// Unless [checkStrictly] is set, checking a parent checks every enabled
/// descendant, a parent shows the dash while only some of its descendants
/// are checked, and [onCheck] receives every fully checked node, parents
/// included.
///
/// Keyboard: arrows move and open or close, Home / End jump, Enter selects
/// and Space checks.
class WeTree<T> extends StatefulWidget {
  const WeTree({
    super.key,
    required this.nodes,
    this.selected,
    this.onSelect,
    this.showCheckbox = false,
    this.checked = const {},
    this.onCheck,
    this.checkStrictly = false,
    this.defaultExpandAll = false,
    this.defaultExpanded = const {},
    this.onExpandedChanged,
    this.expandOnClickNode = true,
    this.accordion = false,
    this.filter = '',
    this.filterMethod,
    this.lazyLoad,
    this.nodeBuilder,
    this.indent = 18,
    this.itemHeight = 32,
    this.showLine = true,
    this.highlightCurrent = true,
    this.emptyText = '暂无数据',
    this.focusNode,
    this.autofocus = false,
  });

  final List<WeTreeNode<T>> nodes;

  /// The current node, tinted when [highlightCurrent].
  final T? selected;
  final ValueChanged<T>? onSelect;

  final bool showCheckbox;
  final Set<T> checked;
  final ValueChanged<Set<T>>? onCheck;

  /// Checks nodes independently instead of linking parents and children.
  final bool checkStrictly;

  final bool defaultExpandAll;
  final Set<T> defaultExpanded;
  final ValueChanged<Set<T>>? onExpandedChanged;

  /// A tap on the row also opens or closes it, not only the arrow.
  final bool expandOnClickNode;

  /// Opening a node closes its open siblings.
  final bool accordion;

  /// Shows only matching nodes and their ancestors, all opened.
  final String filter;
  final WeTreeFilter<T>? filterMethod;

  /// Loads the children of a childless node when it is first opened.
  final Future<List<WeTreeNode<T>>> Function(WeTreeNode<T> node)? lazyLoad;

  /// Replaces the label.
  final Widget Function(BuildContext context, WeTreeNode<T> node)? nodeBuilder;

  final double indent;
  final double itemHeight;

  /// Draws a hairline guide down each open level.
  final bool showLine;
  final bool highlightCurrent;
  final String emptyText;
  final FocusNode? focusNode;
  final bool autofocus;

  /// [checked] after checking or unchecking [value], with parents and
  /// children linked as in a tree without `checkStrictly`. Only [nodes]'
  /// own children are visited, not lazily loaded ones.
  static Set<T> toggleChecked<T>(
    List<WeTreeNode<T>> nodes,
    Set<T> checked,
    T value,
    bool on, {
    bool strict = false,
  }) => _Checks<T>(nodes, (n) => n.children).toggle(checked, value, on, strict);

  /// The first node holding [value], searched depth first.
  static WeTreeNode<T>? find<T>(List<WeTreeNode<T>> nodes, T value) {
    for (final n in nodes) {
      if (n.value == value) return n;
      final WeTreeNode<T>? hit = find(n.children, value);
      if (hit != null) return hit;
    }
    return null;
  }

  @override
  State<WeTree<T>> createState() => _WeTreeState<T>();
}

/// Linked-checkbox arithmetic over a tree whose children come from
/// [childrenOf], so lazily loaded levels take part too.
class _Checks<T> {
  _Checks(this.roots, this.childrenOf);

  final List<WeTreeNode<T>> roots;
  final List<WeTreeNode<T>> Function(WeTreeNode<T> node) childrenOf;

  /// `true`, `false` or `null` for partly checked.
  bool? stateOf(WeTreeNode<T> node, Set<T> checked) {
    final kids = childrenOf(node);
    if (kids.isEmpty) return checked.contains(node.value);
    bool any = false;
    bool all = true;
    for (final k in kids) {
      final bool? s = stateOf(k, checked);
      if (s != false) any = true;
      if (s != true) all = false;
    }
    return all ? true : (any ? null : false);
  }

  /// Whether every enabled leaf under [node] is checked, so a click should
  /// clear it; disabled leaves cannot change and do not count.
  bool enabledFull(WeTreeNode<T> node, Set<T> checked) {
    final kids = childrenOf(node);
    if (kids.isEmpty) return checked.contains(node.value);
    bool sawEnabled = false;
    for (final k in kids) {
      if (k.disabled) continue;
      sawEnabled = true;
      if (!enabledFull(k, checked)) return false;
    }
    return sawEnabled || stateOf(node, checked) == true;
  }

  Set<T> toggle(Set<T> checked, T value, bool on, bool strict) {
    final Set<T> next = {...checked};
    if (strict) {
      on ? next.add(value) : next.remove(value);
      return next;
    }
    final WeTreeNode<T>? node = _find(roots, value);
    if (node == null) return next;
    void apply(WeTreeNode<T> n, {bool root = false}) {
      if (n.disabled && !root) return;
      final kids = childrenOf(n);
      on ? next.add(n.value) : next.remove(n.value);
      for (final k in kids) {
        apply(k);
      }
    }

    apply(node, root: true);
    return normalize(next);
  }

  /// Drops parents that are no longer full and adds parents that became
  /// full, so the set lists exactly the fully checked nodes.
  Set<T> normalize(Set<T> checked) {
    final Set<T> out = {};
    void walk(WeTreeNode<T> n) {
      if (stateOf(n, checked) == true) out.add(n.value);
      for (final k in childrenOf(n)) {
        walk(k);
      }
    }

    for (final r in roots) {
      walk(r);
    }
    return out;
  }

  WeTreeNode<T>? _find(List<WeTreeNode<T>> level, T value) {
    for (final n in level) {
      if (n.value == value) return n;
      final WeTreeNode<T>? hit = _find(childrenOf(n), value);
      if (hit != null) return hit;
    }
    return null;
  }
}

class _Visible<T> {
  const _Visible(this.node, this.depth, this.parent);

  final WeTreeNode<T> node;
  final int depth;
  final WeTreeNode<T>? parent;
}

class _WeTreeState<T> extends State<WeTree<T>> {
  late final Set<T> _expanded = {...widget.defaultExpanded};
  final Map<T, List<WeTreeNode<T>>> _loaded = {};
  final Set<T> _loading = {};
  FocusNode? _ownFocus;
  FocusNode get _focus =>
      widget.focusNode ?? (_ownFocus ??= FocusNode(debugLabel: 'WeTree'));
  T? _cursor;
  bool _hasCursor = false;
  bool _keyboard = false;

  _Checks<T> get _checks => _Checks<T>(widget.nodes, _childrenOf);

  String get _query => widget.filter.trim();

  @override
  void initState() {
    super.initState();
    if (widget.defaultExpandAll) _expandAll(widget.nodes);
    _focus.addListener(_onFocus);
  }

  @override
  void didUpdateWidget(WeTree<T> old) {
    super.didUpdateWidget(old);
    if (old.focusNode != widget.focusNode) {
      (old.focusNode ?? _ownFocus)?.removeListener(_onFocus);
      _focus.addListener(_onFocus);
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _ownFocus?.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (!_focus.hasFocus && _keyboard) setState(() => _keyboard = false);
    if (_focus.hasFocus && !_hasCursor) {
      final rows = _visible();
      if (rows.isNotEmpty) {
        final int i = rows.indexWhere((r) => r.node.value == widget.selected);
        setState(() => _setCursor(rows[i < 0 ? 0 : i].node.value));
      }
    }
  }

  void _setCursor(T value) {
    _cursor = value;
    _hasCursor = true;
  }

  void _expandAll(List<WeTreeNode<T>> level) {
    for (final n in level) {
      if (n.children.isNotEmpty) {
        _expanded.add(n.value);
        _expandAll(n.children);
      }
    }
  }

  // ---- tree shape ---------------------------------------------------------

  List<WeTreeNode<T>> _childrenOf(WeTreeNode<T> n) =>
      n.children.isNotEmpty ? n.children : _loaded[n.value] ?? const [];

  bool _isLeaf(WeTreeNode<T> n) {
    if (n.isLeaf != null) return n.isLeaf!;
    if (n.children.isNotEmpty) return false;
    if (widget.lazyLoad == null) return true;
    final List<WeTreeNode<T>>? got = _loaded[n.value];
    return got != null && got.isEmpty;
  }

  bool _matches(WeTreeNode<T> n) {
    final String q = _query;
    if (q.isEmpty) return true;
    final WeTreeFilter<T>? f = widget.filterMethod;
    if (f != null) return f(q, n);
    return n.label.toLowerCase().contains(q.toLowerCase());
  }

  /// Nodes kept by the filter: matches, and ancestors of matches.
  bool _keep(WeTreeNode<T> n) {
    if (_query.isEmpty || _matches(n)) return true;
    return _childrenOf(n).any(_keep);
  }

  bool _isOpen(WeTreeNode<T> n) {
    if (_isLeaf(n)) return false;
    if (_query.isNotEmpty) return _childrenOf(n).any(_keep);
    return _expanded.contains(n.value);
  }

  List<_Visible<T>> _visible() {
    final List<_Visible<T>> out = [];
    void walk(List<WeTreeNode<T>> level, int depth, WeTreeNode<T>? parent) {
      for (final n in level) {
        if (!_keep(n)) continue;
        out.add(_Visible(n, depth, parent));
        if (_isOpen(n)) walk(_childrenOf(n), depth + 1, n);
      }
    }

    walk(widget.nodes, 0, null);
    return out;
  }

  List<WeTreeNode<T>> _siblingsOf(T value) {
    List<WeTreeNode<T>>? search(List<WeTreeNode<T>> level) {
      for (final n in level) {
        if (n.value == value) return level;
        final List<WeTreeNode<T>>? hit = search(_childrenOf(n));
        if (hit != null) return hit;
      }
      return null;
    }

    return search(widget.nodes) ?? const [];
  }

  // ---- actions ------------------------------------------------------------

  Future<void> _setOpen(WeTreeNode<T> n, bool open) async {
    if (_isLeaf(n)) return;
    setState(() {
      if (open) {
        if (widget.accordion) {
          for (final s in _siblingsOf(n.value)) {
            if (s.value != n.value) _expanded.remove(s.value);
          }
        }
        _expanded.add(n.value);
      } else {
        _expanded.remove(n.value);
      }
    });
    widget.onExpandedChanged?.call({..._expanded});
    if (open &&
        n.children.isEmpty &&
        widget.lazyLoad != null &&
        !_loaded.containsKey(n.value) &&
        !_loading.contains(n.value)) {
      await _load(n);
    }
  }

  Future<void> _load(WeTreeNode<T> n) async {
    setState(() => _loading.add(n.value));
    List<WeTreeNode<T>> kids;
    try {
      kids = await widget.lazyLoad!(n);
    } catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'widgets_easier',
          context: ErrorDescription('while running WeTree.lazyLoad'),
        ),
      );
      if (!mounted) return;
      setState(() {
        _loading.remove(n.value);
        _expanded.remove(n.value);
      });
      return;
    }
    if (!mounted) return;
    setState(() {
      _loading.remove(n.value);
      _loaded[n.value] = kids;
    });
    // A parent checked before its children arrived passes the tick down.
    if (widget.showCheckbox &&
        !widget.checkStrictly &&
        widget.checked.contains(n.value) &&
        kids.isNotEmpty) {
      widget.onCheck?.call(
        _checks.toggle(widget.checked, n.value, true, false),
      );
    }
  }

  void _select(WeTreeNode<T> n) {
    if (n.disabled) return;
    setState(() => _setCursor(n.value));
    widget.onSelect?.call(n.value);
  }

  void _tap(WeTreeNode<T> n) {
    if (n.disabled) return;
    _select(n);
    if (widget.expandOnClickNode && !_isLeaf(n) && _query.isEmpty) {
      _setOpen(n, !_expanded.contains(n.value));
    }
  }

  bool? _checkState(WeTreeNode<T> n) => widget.checkStrictly
      ? widget.checked.contains(n.value)
      : _checks.stateOf(n, widget.checked);

  void _toggleCheck(WeTreeNode<T> n) {
    if (n.disabled || widget.onCheck == null) return;
    final bool on = widget.checkStrictly
        ? !widget.checked.contains(n.value)
        : !_checks.enabledFull(n, widget.checked);
    widget.onCheck!(
      _checks.toggle(widget.checked, n.value, on, widget.checkStrictly),
    );
  }

  // ---- keyboard -----------------------------------------------------------

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final rows = _visible();
    if (rows.isEmpty) return KeyEventResult.ignored;
    final int i = _hasCursor
        ? rows.indexWhere((r) => r.node.value == _cursor)
        : -1;
    final LogicalKeyboardKey key = event.logicalKey;

    void moveTo(int j) {
      j = j.clamp(0, rows.length - 1);
      setState(() {
        _keyboard = true;
        _setCursor(rows[j].node.value);
      });
    }

    if (key == LogicalKeyboardKey.arrowDown) {
      moveTo(i + 1);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      moveTo(i < 0 ? 0 : i - 1);
    } else if (key == LogicalKeyboardKey.home) {
      moveTo(0);
    } else if (key == LogicalKeyboardKey.end) {
      moveTo(rows.length - 1);
    } else if (i < 0) {
      return KeyEventResult.ignored;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      final n = rows[i].node;
      if (_isLeaf(n)) return KeyEventResult.handled;
      if (!_isOpen(n)) {
        setState(() => _keyboard = true);
        _setOpen(n, true);
      } else if (i + 1 < rows.length && rows[i + 1].parent == n) {
        moveTo(i + 1);
      }
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      final n = rows[i].node;
      if (_isOpen(n) && _query.isEmpty) {
        setState(() => _keyboard = true);
        _setOpen(n, false);
      } else if (rows[i].parent != null) {
        moveTo(rows.indexWhere((r) => r.node == rows[i].parent));
      }
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _select(rows[i].node);
    } else if (key == LogicalKeyboardKey.space) {
      widget.showCheckbox ? _toggleCheck(rows[i].node) : _select(rows[i].node);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  // ---- build --------------------------------------------------------------

  Widget _buildLevel(List<WeTreeNode<T>> level, int depth) {
    final colors = context.weColors;
    final List<Widget> rows = [];
    for (final n in level) {
      if (!_keep(n)) continue;
      final bool open = _isOpen(n);
      final List<WeTreeNode<T>> kids = _childrenOf(n);
      rows.add(_row(n, depth, open));
      rows.add(
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: open && kids.isNotEmpty
              ? Stack(
                  children: [
                    if (widget.showLine)
                      Positioned(
                        left: 4 + depth * widget.indent + 10,
                        top: 0,
                        bottom: 0,
                        child: Container(width: 1, color: colors.lighterBorder),
                      ),
                    _buildLevel(kids, depth + 1),
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  Widget _row(WeTreeNode<T> n, int depth, bool open) {
    return _TreeRow(
      key: ValueKey<Object?>(n.value),
      label: widget.nodeBuilder?.call(context, n),
      text: n.label,
      icon: n.icon,
      height: widget.itemHeight,
      leading: 4 + depth * widget.indent,
      leaf: _isLeaf(n),
      open: open,
      loading: _loading.contains(n.value),
      disabled: n.disabled,
      current: widget.highlightCurrent && widget.selected == n.value,
      cursor: _keyboard && _hasCursor && _cursor == n.value,
      checkbox: widget.showCheckbox,
      checkState: widget.showCheckbox ? _checkState(n) : false,
      query: _query,
      onTap: () => _tap(n),
      onArrow: () {
        setState(() => _setCursor(n.value));
        _setOpen(n, !open);
      },
      onCheck: widget.onCheck == null ? null : () => _toggleCheck(n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Widget body = widget.nodes.where(_keep).isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                widget.emptyText,
                style: TextStyle(fontSize: 13, color: colors.secondaryText),
              ),
            ),
          )
        : _buildLevel(widget.nodes, 0);
    return Focus(
      focusNode: _focus,
      autofocus: widget.autofocus,
      onKeyEvent: _onKey,
      child: body,
    );
  }
}

class _TreeRow extends StatefulWidget {
  const _TreeRow({
    super.key,
    required this.label,
    required this.text,
    required this.icon,
    required this.height,
    required this.leading,
    required this.leaf,
    required this.open,
    required this.loading,
    required this.disabled,
    required this.current,
    required this.cursor,
    required this.checkbox,
    required this.checkState,
    required this.query,
    required this.onTap,
    required this.onArrow,
    required this.onCheck,
  });

  final Widget? label;
  final String text;
  final IconData? icon;
  final double height;
  final double leading;
  final bool leaf;
  final bool open;
  final bool loading;
  final bool disabled;
  final bool current;
  final bool cursor;
  final bool checkbox;
  final bool? checkState;
  final String query;
  final VoidCallback onTap;
  final VoidCallback onArrow;
  final VoidCallback? onCheck;

  @override
  State<_TreeRow> createState() => _TreeRowState();
}

class _TreeRowState extends State<_TreeRow> {
  bool _hover = false;

  /// The label with the first match of the filter in the primary colour.
  Widget _text(Color fg, Color hit) {
    final TextStyle style = TextStyle(
      fontSize: 13.5,
      color: fg,
      fontWeight: widget.current ? FontWeight.w600 : FontWeight.w400,
    );
    final String q = widget.query;
    final int at = q.isEmpty
        ? -1
        : widget.text.toLowerCase().indexOf(q.toLowerCase());
    if (at < 0) {
      return Text(
        widget.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: widget.text.substring(0, at)),
          TextSpan(
            text: widget.text.substring(at, at + q.length),
            style: TextStyle(color: hit, fontWeight: FontWeight.w600),
          ),
          TextSpan(text: widget.text.substring(at + q.length)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Color fg = widget.disabled
        ? colors.disabledText
        : widget.current
        ? colors.primary
        : colors.regularText;
    final Color? bg = widget.current
        ? colors.lighten(colors.primary, 9)
        : _hover && !widget.disabled
        ? colors.lightFill
        : null;

    final Widget arrow = SizedBox(
      width: 20,
      height: 20,
      child: widget.loading
          ? Padding(
              padding: const EdgeInsets.all(4),
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: colors.secondaryText,
              ),
            )
          : widget.leaf
          ? null
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onArrow,
              child: AnimatedRotation(
                turns: widget.open ? 0.25 : 0,
                duration: const Duration(milliseconds: 160),
                child: Icon(
                  Icons.arrow_right_rounded,
                  size: 20,
                  color: colors.secondaryText,
                ),
              ),
            ),
    );

    return MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.disabled ? null : widget.onTap,
        child: Container(
          height: widget.height,
          padding: EdgeInsets.only(left: widget.leading, right: 8),
          decoration: BoxDecoration(color: bg),
          foregroundDecoration: widget.cursor
              ? BoxDecoration(
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.6),
                  ),
                )
              : null,
          child: Row(
            children: [
              arrow,
              const SizedBox(width: 2),
              if (widget.checkbox) ...[
                WeCheckbox(
                  value: widget.checkState,
                  size: SizeEnum.small,
                  disabled: widget.disabled,
                  onChanged: widget.onCheck == null
                      ? null
                      : (_) => widget.onCheck!(),
                ),
                const SizedBox(width: 6),
              ],
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 16,
                  color: widget.disabled
                      ? colors.disabledText
                      : colors.secondaryText,
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: widget.label != null
                    ? DefaultTextStyle.merge(
                        style: TextStyle(fontSize: 13.5, color: fg),
                        child: widget.label!,
                      )
                    : _text(fg, colors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
