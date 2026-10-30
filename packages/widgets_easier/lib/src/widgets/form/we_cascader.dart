import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';
import '../overlay/we_popper.dart';
import 'we_field_box.dart';
import 'we_form.dart';

/// A node of a [WeCascader] tree.
class WeCascaderOption<T> {
  const WeCascaderOption(
    this.value,
    this.label, {
    this.children = const [],
    this.disabled = false,
  });

  final T value;
  final String label;
  final List<WeCascaderOption<T>> children;
  final bool disabled;

  bool get isLeaf => children.isEmpty;
}

/// What opens the next column of a [WeCascader].
enum WeCascaderTrigger { click, hover }

/// Decides whether a whole path matches the search text.
typedef WeCascaderFilter<T> =
    bool Function(String query, List<WeCascaderOption<T>> path);

/// A dropdown that picks one path from a tree, after `el-cascader`.
///
/// The value is the list of option values from the root to the picked node.
/// Only leaves can be picked unless [checkStrictly] is set, in which case a
/// radio in front of every row picks that level.
///
/// ```dart
/// WeCascader<String>(
///   value: _region,
///   onChanged: (path) => setState(() => _region = path),
///   options: const [
///     WeCascaderOption('zj', '浙江', children: [
///       WeCascaderOption('hz', '杭州', children: [
///         WeCascaderOption('xh', '西湖区'),
///       ]),
///     ]),
///   ],
/// )
/// ```
///
/// Platform: desktop and web (pointer + keyboard, wide screen). On phones prefer [CascadeBottomSheet].
class WeCascader<T> extends StatefulWidget {
  const WeCascader({
    super.key,
    required this.options,
    this.value,
    required this.onChanged,
    this.hint = '请选择',
    this.clearable = false,
    this.disabled = false,
    this.size = SizeEnum.defaultSize,
    this.width = 240,
    this.status,
    this.filterable = false,
    this.filterMethod,
    this.checkStrictly = false,
    this.showAllLevels = true,
    this.separator = ' / ',
    this.expandTrigger = WeCascaderTrigger.click,
    this.columnWidth = 180,
    this.columnHeight = 204,
    this.noMatchText = '无匹配数据',
    this.noDataText = '暂无数据',
  });

  final List<WeCascaderOption<T>> options;

  /// Values from the root down to the picked node.
  final List<T>? value;
  final ValueChanged<List<T>?>? onChanged;

  final String? hint;
  final bool clearable;
  final bool disabled;
  final SizeEnum size;
  final double? width;

  /// Colours the border; a surrounding [WeFormItem] sets it on error.
  final SemanticEnum? status;

  /// Type into the field to search every path by label.
  final bool filterable;

  /// Replaces the default "any label contains the query" match.
  final WeCascaderFilter<T>? filterMethod;

  /// Lets any level be picked, not only leaves.
  final bool checkStrictly;

  /// Shows the whole path in the field; `false` shows only the last label.
  final bool showAllLevels;
  final String separator;
  final WeCascaderTrigger expandTrigger;
  final double columnWidth;
  final double columnHeight;
  final String noMatchText;
  final String noDataText;

  @override
  State<WeCascader<T>> createState() => _WeCascaderState<T>();
}

class _WeCascaderState<T> extends State<WeCascader<T>> {
  static const double _rowHeight = 34;
  static const double _listPadding = 6;

  final WePopperController _popper = WePopperController();
  final FocusNode _focus = FocusNode(debugLabel: 'WeCascader');
  final FocusNode _queryFocus = FocusNode(debugLabel: 'WeCascader.query');
  final TextEditingController _query = TextEditingController();
  final GlobalKey _highlightKey = GlobalKey();

  /// Row index opened in each column; column `k + 1` lists the children of
  /// `columns[k][_expanded[k]]`.
  List<int> _expanded = const [];
  int _col = 0;
  int _row = -1;
  int _hit = -1;

  bool _open = false;
  bool _focused = false;
  WeFormItemState? _formItem;

  bool get _enabled =>
      !widget.disabled &&
      !(_formItem?.disabled ?? false) &&
      widget.onChanged != null;

  bool get _searching => widget.filterable && _query.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
    _queryFocus.addListener(_onFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formItem = WeFormItem.maybeOf(context);
  }

  @override
  void didUpdateWidget(WeCascader<T> old) {
    super.didUpdateWidget(old);
    if (!_enabled && _open) _popper.hide();
  }

  @override
  void dispose() {
    _popper.dispose();
    _focus.dispose();
    _queryFocus.dispose();
    _query.dispose();
    super.dispose();
  }

  void _onFocus() {
    final bool focused = _focus.hasFocus || _queryFocus.hasFocus;
    if (focused == _focused) return;
    setState(() => _focused = focused);
    if (!focused) {
      if (_open) _popper.hide();
      _formItem?.onBlur();
    }
  }

  // ---- tree ---------------------------------------------------------------

  List<List<WeCascaderOption<T>>> get _columns {
    final List<List<WeCascaderOption<T>>> out = [widget.options];
    for (final int i in _expanded) {
      final List<WeCascaderOption<T>> col = out.last;
      if (i < 0 || i >= col.length || col[i].isLeaf) break;
      out.add(col[i].children);
    }
    return out;
  }

  /// Row indices of [path] down the tree, or `null` if it is not in it.
  List<int>? _indicesOf(List<T>? path) {
    if (path == null || path.isEmpty) return null;
    final List<int> out = [];
    List<WeCascaderOption<T>> level = widget.options;
    for (final T v in path) {
      final int i = level.indexWhere((o) => o.value == v);
      if (i < 0) return null;
      out.add(i);
      level = level[i].children;
    }
    return out;
  }

  List<WeCascaderOption<T>>? _optionsOf(List<T>? path) {
    final List<int>? idx = _indicesOf(path);
    if (idx == null) return null;
    final List<WeCascaderOption<T>> out = [];
    List<WeCascaderOption<T>> level = widget.options;
    for (final int i in idx) {
      out.add(level[i]);
      level = level[i].children;
    }
    return out;
  }

  List<T> _pathTo(int col, int row) {
    final cols = _columns;
    return [
      for (int k = 0; k < col; k++) cols[k][_expanded[k]].value,
      cols[col][row].value,
    ];
  }

  /// Every pickable path, for search: leaves, or every node when
  /// [WeCascader.checkStrictly].
  List<List<WeCascaderOption<T>>> get _allPaths {
    final List<List<WeCascaderOption<T>>> out = [];
    void walk(List<WeCascaderOption<T>> level, List<WeCascaderOption<T>> up) {
      for (final o in level) {
        if (o.disabled) continue;
        final List<WeCascaderOption<T>> path = [...up, o];
        if (o.isLeaf || widget.checkStrictly) out.add(path);
        walk(o.children, path);
      }
    }

    walk(widget.options, const []);
    return out;
  }

  List<List<WeCascaderOption<T>>> get _hits {
    final String q = _query.text.trim();
    final WeCascaderFilter<T>? f = widget.filterMethod;
    return [
      for (final p in _allPaths)
        if (f != null
            ? f(q, p)
            : p.any((o) => o.label.toLowerCase().contains(q.toLowerCase())))
          p,
    ];
  }

  // ---- open / close -------------------------------------------------------

  void _onOpenChanged(bool open) {
    setState(() {
      _open = open;
      if (open) _syncToValue();
    });
    if (open) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal());
    } else {
      if (_query.text.isNotEmpty) _query.clear();
      if (_queryFocus.hasFocus) _focus.requestFocus();
    }
  }

  /// Opens the columns down to the current value and highlights it.
  void _syncToValue() {
    final List<int>? idx = _indicesOf(widget.value);
    if (idx == null) {
      _expanded = const [];
      _col = 0;
      _row = _firstEnabled(widget.options);
      return;
    }
    final WeCascaderOption<T> last = _optionsOf(widget.value)!.last;
    _expanded = last.isLeaf ? idx.sublist(0, idx.length - 1) : idx;
    _col = idx.length - 1;
    _row = idx.last;
  }

  int _firstEnabled(List<WeCascaderOption<T>> col) =>
      col.indexWhere((o) => !o.disabled);

  void _openPanel() {
    if (!_enabled) return;
    _popper.show();
    (widget.filterable ? _queryFocus : _focus).requestFocus();
  }

  void _togglePanel() {
    if (!_enabled) return;
    if (_open) {
      _popper.hide();
    } else {
      _openPanel();
    }
  }

  void _reveal([bool down = true]) {
    final BuildContext? c = _highlightKey.currentContext;
    if (c == null) return;
    Scrollable.ensureVisible(
      c,
      alignmentPolicy: down
          ? ScrollPositionAlignmentPolicy.keepVisibleAtEnd
          : ScrollPositionAlignmentPolicy.keepVisibleAtStart,
    );
  }

  // ---- picking ------------------------------------------------------------

  /// Moves the highlight to [row] of [col] and shows its children.
  void _focusRow(int col, int row) {
    final cols = _columns;
    final WeCascaderOption<T> o = cols[col][row];
    setState(() {
      _col = col;
      _row = row;
      _expanded = [..._expanded.take(col), if (!o.isLeaf) row];
    });
  }

  void _tapRow(int col, int row) {
    final WeCascaderOption<T> o = _columns[col][row];
    if (o.disabled) return;
    _focusRow(col, row);
    if (o.isLeaf) _commit(_pathTo(col, row), close: true);
  }

  void _commit(List<T>? path, {required bool close}) {
    widget.onChanged!(path);
    _formItem?.onChange();
    if (close) _popper.hide();
  }

  void _pickHit(List<WeCascaderOption<T>> path) {
    _commit([for (final o in path) o.value], close: true);
  }

  void _clear() => _commit(null, close: false);

  // ---- keyboard -----------------------------------------------------------

  void _step(int delta) {
    if (_searching) {
      final int n = _hits.length;
      if (n == 0) return;
      setState(() => _hit = ((_hit + delta) % n + n) % n);
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal(delta > 0));
      return;
    }
    final List<WeCascaderOption<T>> col = _columns[_col];
    int i = _row;
    for (int n = 0; n < col.length; n++) {
      i = ((i + delta) % col.length + col.length) % col.length;
      if (!col[i].disabled) {
        _focusRow(_col, i);
        WidgetsBinding.instance.addPostFrameCallback((_) => _reveal(delta > 0));
        return;
      }
    }
  }

  void _enter() {
    if (_row < 0) return;
    final WeCascaderOption<T> o = _columns[_col][_row];
    if (o.isLeaf || o.disabled) return;
    _focusRow(_col, _row);
    final int first = _firstEnabled(o.children);
    if (first >= 0) _focusRow(_col + 1, first);
  }

  void _leave() {
    if (_col == 0) return;
    final int parent = _expanded[_col - 1];
    _focusRow(_col - 1, parent);
  }

  void _activate() {
    if (_searching) {
      final hits = _hits;
      if (_hit >= 0 && _hit < hits.length) _pickHit(hits[_hit]);
      return;
    }
    if (_row < 0) return;
    final WeCascaderOption<T> o = _columns[_col][_row];
    if (o.disabled) return;
    if (o.isLeaf) {
      _commit(_pathTo(_col, _row), close: true);
    } else if (widget.checkStrictly) {
      _commit(_pathTo(_col, _row), close: false);
    } else {
      _enter();
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!_enabled) return KeyEventResult.ignored;
    final LogicalKeyboardKey key = event.logicalKey;
    final bool typing = _queryFocus.hasFocus && _query.text.isNotEmpty;

    if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowUp) {
      if (!_open) {
        _openPanel();
      } else {
        _step(key == LogicalKeyboardKey.arrowDown ? 1 : -1);
      }
      return KeyEventResult.handled;
    }
    if (_open && !_searching && !typing) {
      if (key == LogicalKeyboardKey.arrowRight) {
        _enter();
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.arrowLeft) {
        _leave();
        return KeyEventResult.handled;
      }
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        (key == LogicalKeyboardKey.space && !_queryFocus.hasFocus)) {
      if (!_open) {
        _openPanel();
      } else {
        _activate();
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.tab && _open) _popper.hide();
    return KeyEventResult.ignored;
  }

  // ---- build --------------------------------------------------------------

  Widget _hint(String text) {
    final colors = context.weColors;
    return SizedBox(
      width: widget.columnWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: colors.secondaryText),
          ),
        ),
      ),
    );
  }

  /// Desktop text fields unfocus on taps outside them; claiming the panel
  /// for the search field keeps it focused, and so the panel open.
  Widget _buildPanel(BuildContext context) =>
      TextFieldTapRegion(child: _buildPanelBody(context));

  Widget _buildPanelBody(BuildContext context) {
    if (_searching) return _buildHits(context);
    if (widget.options.isEmpty) return _hint(widget.noDataText);
    final colors = context.weColors;
    final cols = _columns;
    final List<int>? picked = _indicesOf(widget.value);

    return SizedBox(
      height: widget.columnHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int c = 0; c < cols.length; c++) ...[
            if (c > 0) VerticalDivider(width: 1, color: colors.lighterBorder),
            SizedBox(
              width: widget.columnWidth,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: _listPadding),
                itemCount: cols[c].length,
                itemBuilder: (context, r) {
                  final WeCascaderOption<T> o = cols[c][r];
                  final bool inPath = c < _expanded.length && _expanded[c] == r;
                  final bool checked =
                      picked != null &&
                      picked.length == c + 1 &&
                      picked.last == r &&
                      _samePrefix(picked, c);
                  final bool highlighted = c == _col && r == _row;
                  return _CascaderRow(
                    key: highlighted ? _highlightKey : null,
                    label: o.label,
                    height: _rowHeight,
                    disabled: o.disabled,
                    hasChildren: !o.isLeaf,
                    active: inPath || checked,
                    checked: checked,
                    highlighted: highlighted,
                    radio: widget.checkStrictly,
                    onHover: () {
                      if (widget.expandTrigger == WeCascaderTrigger.hover &&
                          !o.isLeaf) {
                        _focusRow(c, r);
                      }
                    },
                    onTap: () => _tapRow(c, r),
                    onRadio: () {
                      _focusRow(c, r);
                      _commit(_pathTo(c, r), close: o.isLeaf);
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Whether the first [depth] levels of [picked] follow the open columns.
  bool _samePrefix(List<int> picked, int depth) {
    if (_expanded.length < depth) return false;
    for (int k = 0; k < depth; k++) {
      if (picked[k] != _expanded[k]) return false;
    }
    return true;
  }

  Widget _buildHits(BuildContext context) {
    final colors = context.weColors;
    final hits = _hits;
    if (hits.isEmpty) return _hint(widget.noMatchText);
    final List<T>? value = widget.value;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: math.max(widget.columnWidth, widget.width ?? 0),
      ).copyWith(maxHeight: widget.columnHeight),
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: _listPadding),
        itemCount: hits.length,
        itemBuilder: (context, i) {
          final path = hits[i];
          final bool checked =
              value != null &&
              value.length == path.length &&
              [for (int k = 0; k < value.length; k++) value[k] == path[k].value]
                  .every((same) => same);
          return MouseRegion(
            key: i == _hit ? _highlightKey : null,
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              if (_hit != i) setState(() => _hit = i);
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _pickHit(path),
              child: Container(
                height: _rowHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                color: i == _hit ? colors.lightFill : null,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        path.map((o) => o.label).join(widget.separator),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: checked
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: checked ? colors.primary : colors.regularText,
                        ),
                      ),
                    ),
                    if (checked)
                      Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: colors.primary,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final metrics = we.sizes.control(
      WeFieldBox.resolveSize(context, widget.size),
    );
    final bool enabled = _enabled;

    final List<WeCascaderOption<T>>? picked = _optionsOf(widget.value);
    final String? label = picked == null
        ? null
        : widget.showAllLevels
        ? picked.map((o) => o.label).join(widget.separator)
        : picked.last.label;

    final Widget content = widget.filterable && _open
        ? TextField(
            controller: _query,
            focusNode: _queryFocus,
            onChanged: (_) => setState(() => _hit = 0),
            enabled: enabled,
            cursorColor: colors.primary,
            cursorHeight: metrics.fontSize + 2,
            style: TextStyle(
              fontSize: metrics.fontSize,
              color: colors.primaryText,
            ),
            decoration: InputDecoration(
              isDense: true,
              isCollapsed: true,
              border: InputBorder.none,
              hintText: label ?? widget.hint,
              hintStyle: TextStyle(
                fontSize: metrics.fontSize,
                color: colors.placeholderText,
              ),
            ),
          )
        : Text(
            label ?? widget.hint ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: metrics.fontSize,
              color: !enabled
                  ? colors.disabledText
                  : label == null
                  ? colors.placeholderText
                  : colors.primaryText,
            ),
          );

    return WeFieldBox(
      focusNode: _focus,
      onKeyEvent: _onKey,
      open: _open,
      focused: _focused,
      enabled: enabled,
      size: widget.size,
      status: widget.status,
      onClear: widget.clearable && label != null ? _clear : null,
      onTap: _togglePanel,
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    WePlatform.debugCheckFit(
      context,
      'WeCascader',
      WePlatformFit.desktop,
      alternative: 'CascadeBottomSheet',
    );
    final Widget field = WePopper.builder(
      controller: _popper,
      placement: WePlacement.bottomStart,
      gap: 4,
      maxWidth: double.infinity,
      style: const WePopperStyle(padding: EdgeInsets.zero),
      disabled: !_enabled,
      onOpenChanged: _onOpenChanged,
      popupBuilder: _buildPanel,
      builder: (context, _) => _buildField(context),
    );
    return widget.width != null
        ? SizedBox(width: widget.width, child: field)
        : field;
  }
}

class _CascaderRow extends StatelessWidget {
  const _CascaderRow({
    super.key,
    required this.label,
    required this.height,
    required this.disabled,
    required this.hasChildren,
    required this.active,
    required this.checked,
    required this.highlighted,
    required this.radio,
    required this.onHover,
    required this.onTap,
    required this.onRadio,
  });

  final String label;
  final double height;
  final bool disabled;
  final bool hasChildren;

  /// On the open path or picked: coloured text.
  final bool active;
  final bool checked;
  final bool highlighted;
  final bool radio;
  final VoidCallback onHover;
  final VoidCallback onTap;
  final VoidCallback onRadio;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Color fg = disabled
        ? colors.disabledText
        : active
        ? colors.primary
        : colors.regularText;
    return MouseRegion(
      cursor: disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: disabled ? null : (_) => onHover(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.only(left: 12, right: 8),
          color: highlighted && !disabled ? colors.lightFill : null,
          child: Row(
            children: [
              if (radio) ...[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: disabled ? null : onRadio,
                  child: _Radio(checked: checked, disabled: disabled),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    color: fg,
                  ),
                ),
              ),
              if (hasChildren)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: disabled ? colors.disabledText : colors.secondaryText,
                )
              else if (checked && !radio)
                Icon(Icons.check_rounded, size: 15, color: colors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.checked, required this.disabled});

  final bool checked;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    return Container(
      width: 14,
      height: 14,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: checked ? colors.primary : colors.overlayBackground,
        border: Border.all(
          color: disabled
              ? colors.lightBorder
              : checked
              ? colors.primary
              : colors.baseBorder,
        ),
      ),
      child: checked
          ? Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.overlayBackground,
              ),
            )
          : null,
    );
  }
}
