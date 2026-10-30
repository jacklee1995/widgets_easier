import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';
import '../data/we_tree.dart';
import '../overlay/we_popper.dart';
import 'we_field_box.dart';
import 'we_form.dart';

/// A dropdown that picks from a [WeTree], after `el-tree-select`.
///
/// Single choice picks leaves, or any node with [checkStrictly]. The
/// [WeTreeSelect.multiple] constructor ticks nodes with linked checkboxes and
/// shows the topmost fully checked nodes as tags.
///
/// ```dart
/// WeTreeSelect<String>(
///   nodes: categories,
///   value: _category,
///   onChanged: (v) => setState(() => _category = v),
///   filterable: true,
/// )
///
/// WeTreeSelect<String>.multiple(
///   nodes: categories,
///   values: _categories,
///   onValuesChanged: (s) => setState(() => _categories = s),
///   collapseTags: true,
/// )
/// ```
///
/// Arrow Down moves into the tree, where the tree's own keys apply.
class WeTreeSelect<T> extends StatefulWidget {
  const WeTreeSelect({
    super.key,
    required this.nodes,
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
    this.defaultExpandAll = false,
    this.maxHeight = 274,
    this.noMatchText = '无匹配数据',
    this.prefixIcon,
  }) : multiple = false,
       values = null,
       onValuesChanged = null,
       collapseTags = false,
       maxCollapseTags = 1;

  const WeTreeSelect.multiple({
    super.key,
    required this.nodes,
    required this.values,
    required this.onValuesChanged,
    this.hint = '请选择',
    this.clearable = false,
    this.disabled = false,
    this.size = SizeEnum.defaultSize,
    this.width = 240,
    this.status,
    this.filterable = false,
    this.filterMethod,
    this.checkStrictly = false,
    this.defaultExpandAll = false,
    this.collapseTags = false,
    this.maxCollapseTags = 1,
    this.maxHeight = 274,
    this.noMatchText = '无匹配数据',
    this.prefixIcon,
  }) : multiple = true,
       value = null,
       onChanged = null;

  final List<WeTreeNode<T>> nodes;
  final bool multiple;

  final T? value;
  final ValueChanged<T?>? onChanged;

  /// Every fully checked node, parents included unless [checkStrictly].
  final Set<T>? values;
  final ValueChanged<Set<T>>? onValuesChanged;

  final String? hint;
  final bool clearable;
  final bool disabled;
  final SizeEnum size;
  final double? width;

  /// Colours the border; a surrounding [WeFormItem] sets it on error.
  final SemanticEnum? status;

  /// Type into the field to filter the tree by label.
  final bool filterable;
  final WeTreeFilter<T>? filterMethod;

  /// Single choice may pick any node; multiple choice checks nodes
  /// independently.
  final bool checkStrictly;
  final bool defaultExpandAll;

  /// Folds the tags past [maxCollapseTags] into a `+N` tag.
  final bool collapseTags;
  final int maxCollapseTags;
  final double maxHeight;
  final String noMatchText;
  final IconData? prefixIcon;

  @override
  State<WeTreeSelect<T>> createState() => _WeTreeSelectState<T>();
}

class _WeTreeSelectState<T> extends State<WeTreeSelect<T>> {
  final WePopperController _popper = WePopperController();
  final FocusNode _focus = FocusNode(debugLabel: 'WeTreeSelect');
  final FocusNode _queryFocus = FocusNode(debugLabel: 'WeTreeSelect.query');
  final FocusNode _treeFocus = FocusNode(debugLabel: 'WeTreeSelect.tree');
  final TextEditingController _query = TextEditingController();

  bool _open = false;
  bool _focused = false;
  WeFormItemState? _formItem;

  bool get _enabled =>
      !widget.disabled &&
      !(_formItem?.disabled ?? false) &&
      (widget.multiple
          ? widget.onValuesChanged != null
          : widget.onChanged != null);

  Set<T> get _values => widget.values ?? const {};

  @override
  void initState() {
    super.initState();
    for (final f in [_focus, _queryFocus, _treeFocus]) {
      f.addListener(_onFocus);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formItem = WeFormItem.maybeOf(context);
  }

  @override
  void didUpdateWidget(WeTreeSelect<T> old) {
    super.didUpdateWidget(old);
    if (!_enabled && _open) _popper.hide();
  }

  @override
  void dispose() {
    _popper.dispose();
    _focus.dispose();
    _queryFocus.dispose();
    _treeFocus.dispose();
    _query.dispose();
    super.dispose();
  }

  void _onFocus() {
    final bool focused =
        _focus.hasFocus || _queryFocus.hasFocus || _treeFocus.hasFocus;
    if (focused == _focused) return;
    setState(() => _focused = focused);
    if (!focused) {
      if (_open) _popper.hide();
      _formItem?.onBlur();
    }
  }

  // ---- open / close -------------------------------------------------------

  void _onOpenChanged(bool open) {
    setState(() => _open = open);
    if (!open) {
      if (_query.text.isNotEmpty) _query.clear();
      if (_queryFocus.hasFocus || _treeFocus.hasFocus) _focus.requestFocus();
    }
  }

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

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!_enabled || _treeFocus.hasFocus) return KeyEventResult.ignored;
    final LogicalKeyboardKey key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) {
      if (!_open) {
        _openPanel();
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _treeFocus.requestFocus(),
        );
      } else {
        _treeFocus.requestFocus();
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        (key == LogicalKeyboardKey.space && !_queryFocus.hasFocus)) {
      if (!_open) _openPanel();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace &&
        widget.multiple &&
        _query.text.isEmpty &&
        _values.isNotEmpty) {
      final tags = _tags;
      if (tags.isNotEmpty) _uncheck(tags.last.value);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.tab && _open) _popper.hide();
    return KeyEventResult.ignored;
  }

  // ---- values -------------------------------------------------------------

  void _pick(T v) {
    final WeTreeNode<T>? n = WeTree.find(widget.nodes, v);
    if (n == null || n.disabled) return;
    if (widget.multiple) {
      final bool on = !_values.contains(v);
      _setValues(
        WeTree.toggleChecked(
          widget.nodes,
          _values,
          v,
          on,
          strict: widget.checkStrictly,
        ),
      );
      return;
    }
    if (n.children.isNotEmpty && !widget.checkStrictly) return;
    widget.onChanged!(v);
    _formItem?.onChange();
    _popper.hide();
  }

  void _setValues(Set<T> next) {
    widget.onValuesChanged!(next);
    _formItem?.onChange();
  }

  void _uncheck(T v) => _setValues(
    WeTree.toggleChecked(
      widget.nodes,
      _values,
      v,
      false,
      strict: widget.checkStrictly,
    ),
  );

  void _clear() {
    if (widget.multiple) {
      _setValues(<T>{});
    } else {
      widget.onChanged!(null);
      _formItem?.onChange();
    }
  }

  /// The topmost checked nodes: a fully checked parent stands for its
  /// subtree.
  List<WeTreeNode<T>> get _tags {
    final Set<T> values = _values;
    if (widget.checkStrictly) {
      return [for (final v in values) ?WeTree.find(widget.nodes, v)];
    }
    final List<WeTreeNode<T>> out = [];
    void walk(List<WeTreeNode<T>> level) {
      for (final n in level) {
        if (values.contains(n.value)) {
          out.add(n);
        } else {
          walk(n.children);
        }
      }
    }

    walk(widget.nodes);
    return out;
  }

  // ---- build --------------------------------------------------------------

  Widget _buildPanel(BuildContext context) => TextFieldTapRegion(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: WeTree<T>(
          nodes: widget.nodes,
          focusNode: _treeFocus,
          selected: widget.multiple ? null : widget.value,
          onSelect: _pick,
          showCheckbox: widget.multiple,
          checked: _values,
          onCheck: widget.multiple ? _setValues : null,
          checkStrictly: widget.checkStrictly,
          defaultExpandAll: widget.defaultExpandAll,
          defaultExpanded: _ancestorsOfValue(),
          expandOnClickNode: !widget.multiple,
          filter: widget.filterable ? _query.text : '',
          filterMethod: widget.filterMethod,
          emptyText: widget.noMatchText,
        ),
      ),
    ),
  );

  /// Opens the tree down to the picked node(s).
  Set<T> _ancestorsOfValue() {
    final Set<T> targets = widget.multiple
        ? _values
        : {if (widget.value != null) widget.value as T};
    final Set<T> out = {};
    bool walk(List<WeTreeNode<T>> level) {
      bool hit = false;
      for (final n in level) {
        final bool below = walk(n.children);
        if (below) out.add(n.value);
        if (below || targets.contains(n.value)) hit = true;
      }
      return hit;
    }

    walk(widget.nodes);
    return out;
  }

  Widget _buildQuery(double fontSize, String? hint, {double? width}) {
    final colors = context.weColors;
    final Widget field = TextField(
      controller: _query,
      focusNode: _queryFocus,
      onChanged: (_) {
        if (!_open) _popper.show();
        setState(() {});
      },
      onTap: () {
        if (!_open) _openPanel();
      },
      enabled: _enabled,
      cursorColor: colors.primary,
      cursorHeight: fontSize + 2,
      style: TextStyle(fontSize: fontSize, color: colors.primaryText),
      decoration: InputDecoration(
        isDense: true,
        isCollapsed: true,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(fontSize: fontSize, color: colors.placeholderText),
      ),
    );
    return width == null ? field : SizedBox(width: width, child: field);
  }

  Widget _buildContent(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final metrics = we.sizes.control(
      WeFieldBox.resolveSize(context, widget.size),
    );

    if (!widget.multiple) {
      final String? label = widget.value == null
          ? null
          : WeTree.find(widget.nodes, widget.value as T)?.label;
      if (widget.filterable && _open) {
        return _buildQuery(metrics.fontSize, label ?? widget.hint);
      }
      return Text(
        label ?? widget.hint ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: metrics.fontSize,
          color: !_enabled
              ? colors.disabledText
              : label == null
              ? colors.placeholderText
              : colors.primaryText,
        ),
      );
    }

    final tags = _tags;
    final int shown = widget.collapseTags
        ? tags.length.clamp(0, widget.maxCollapseTags)
        : tags.length;
    final bool showHint = tags.isEmpty && _query.text.isEmpty;
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final n in tags.take(shown))
          _Tag(
            label: n.label,
            onClose: _enabled ? () => _uncheck(n.value) : null,
          ),
        if (tags.length > shown) _Tag(label: '+ ${tags.length - shown}'),
        if (widget.filterable)
          _buildQuery(
            metrics.fontSize,
            showHint ? widget.hint : null,
            width: showHint ? 160 : 60,
          )
        else if (showHint)
          Text(
            widget.hint ?? '',
            style: TextStyle(
              fontSize: metrics.fontSize,
              color: colors.placeholderText,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = widget.multiple
        ? _values.isNotEmpty
        : widget.value != null;
    final Widget field = WePopper.builder(
      controller: _popper,
      placement: WePlacement.bottomStart,
      matchTriggerWidth: true,
      minWidth: 200,
      gap: 4,
      style: const WePopperStyle(padding: EdgeInsets.zero),
      disabled: !_enabled,
      onOpenChanged: _onOpenChanged,
      popupBuilder: _buildPanel,
      builder: (context, _) => WeFieldBox(
        focusNode: _focus,
        onKeyEvent: _onKey,
        open: _open,
        focused: _focused,
        enabled: _enabled,
        size: widget.size,
        status: widget.status,
        multiline: widget.multiple,
        prefixIcon: widget.prefixIcon,
        onClear: widget.clearable && hasValue ? _clear : null,
        onTap: _togglePanel,
        child: _buildContent(context),
      ),
    );
    return widget.width != null
        ? SizedBox(width: widget.width, child: field)
        : field;
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, this.onClose});

  final String label;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    return Container(
      height: 22,
      padding: EdgeInsets.only(left: 8, right: onClose == null ? 8 : 4),
      decoration: BoxDecoration(
        color: colors.lightFill,
        borderRadius: BorderRadius.circular(we.radius.small),
        border: Border.all(color: colors.lighterBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                height: 1.2,
                color: colors.regularText,
              ),
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 2),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
                child: Icon(
                  Icons.close_rounded,
                  size: 13,
                  color: colors.secondaryText,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
