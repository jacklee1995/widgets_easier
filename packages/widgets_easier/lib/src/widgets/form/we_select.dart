import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';
import '../feedback/we_tooltip.dart';
import '../overlay/we_popper.dart';
import 'we_field_box.dart';
import 'we_form.dart';

/// One choice of a [WeSelect].
class WeSelectOption<T> {
  const WeSelectOption(
    this.value,
    this.label, {
    this.icon,
    this.disabled = false,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool disabled;
}

/// A titled group of options, after `el-option-group`.
class WeSelectGroup<T> {
  const WeSelectGroup(this.label, this.options);

  final String label;
  final List<WeSelectOption<T>> options;
}

/// Decides whether [option] matches what the user typed.
typedef WeSelectFilter<T> =
    bool Function(String query, WeSelectOption<T> option);

/// Loads the options for [query] from somewhere else, e.g. a search API.
typedef WeSelectRemote<T> =
    Future<List<WeSelectOption<T>>> Function(String query);

/// A picker with a drop-down list, after `el-select`.
///
/// Single choice:
///
/// ```dart
/// WeSelect<String>(
///   value: status,
///   hint: '状态',
///   options: const [WeSelectOption('paid', '已付款'), WeSelectOption('shipped', '已发货')],
///   onChanged: (v) => setState(() => status = v),
///   clearable: true,
/// )
/// ```
///
/// Several choices shown as tags, searchable, at most three:
///
/// ```dart
/// WeSelect<String>.multiple(
///   values: tags,
///   options: allTags,
///   filterable: true,
///   collapseTags: true,
///   multipleLimit: 3,
///   onChanged: (v) => setState(() => tags = v),
/// )
/// ```
///
/// Pass [remoteMethod] to search a server as the user types; the panel shows
/// a loading line while the future runs.
///
/// Keyboard: ↓ / ↑ move the highlight (and open the panel), Enter picks,
/// Escape closes, Backspace in an empty multi-select search removes the last
/// tag.
class WeSelect<T> extends StatefulWidget {
  const WeSelect({
    super.key,
    this.options = const <Never>[],
    this.groups = const <Never>[],
    required this.value,
    required this.onChanged,
    this.hint,
    this.clearable = false,
    this.disabled = false,
    this.size = SizeEnum.defaultSize,
    this.width,
    this.prefixIcon,
    this.status,
    this.filterable = false,
    this.filterMethod,
    this.remoteMethod,
    this.remoteDebounce = const Duration(milliseconds: 300),
    this.noDataText = '无数据',
    this.noMatchText = '无匹配数据',
    this.loadingText = '加载中',
    this.maxHeight = 274,
  }) : multiple = false,
       values = null,
       onValuesChanged = null,
       collapseTags = false,
       collapseTagsTooltip = false,
       maxCollapseTags = 1,
       multipleLimit = 0;

  /// Picks any number of values, shown as tags in the field.
  const WeSelect.multiple({
    super.key,
    this.options = const <Never>[],
    this.groups = const <Never>[],
    required Set<T> this.values,
    required ValueChanged<Set<T>>? onChanged,
    this.collapseTags = false,
    this.collapseTagsTooltip = false,
    this.maxCollapseTags = 1,
    this.multipleLimit = 0,
    this.hint,
    this.clearable = false,
    this.disabled = false,
    this.size = SizeEnum.defaultSize,
    this.width,
    this.prefixIcon,
    this.status,
    this.filterable = false,
    this.filterMethod,
    this.remoteMethod,
    this.remoteDebounce = const Duration(milliseconds: 300),
    this.noDataText = '无数据',
    this.noMatchText = '无匹配数据',
    this.loadingText = '加载中',
    this.maxHeight = 274,
  }) : multiple = true,
       value = null,
       onValuesChanged = onChanged,
       onChanged = null;

  /// Flat options. Shown above [groups] when both are given.
  final List<WeSelectOption<T>> options;

  /// Options under group titles.
  final List<WeSelectGroup<T>> groups;

  final bool multiple;

  /// The single-choice value.
  final T? value;

  /// Receives the picked value, or `null` when cleared.
  final ValueChanged<T?>? onChanged;

  /// The multi-choice values.
  final Set<T>? values;
  final ValueChanged<Set<T>>? onValuesChanged;

  /// Show only the first [maxCollapseTags] tags and a `+N` tag for the rest.
  final bool collapseTags;

  /// Hovering the `+N` tag lists the hidden ones.
  final bool collapseTagsTooltip;
  final int maxCollapseTags;

  /// How many values can be picked; `0` means no limit.
  final int multipleLimit;

  final String? hint;
  final bool clearable;
  final bool disabled;
  final SizeEnum size;
  final double? width;
  final IconData? prefixIcon;

  /// Colours the border; a surrounding [WeFormItem] sets it on error.
  final SemanticEnum? status;

  /// Type in the field to narrow the options.
  final bool filterable;

  /// Custom match; defaults to a case-insensitive "label contains".
  final WeSelectFilter<T>? filterMethod;

  /// Loads options from elsewhere; implies [filterable].
  final WeSelectRemote<T>? remoteMethod;
  final Duration remoteDebounce;

  final String noDataText;
  final String noMatchText;
  final String loadingText;

  /// Height cap of the option list.
  final double maxHeight;

  @override
  State<WeSelect<T>> createState() => _WeSelectState<T>();
}

/// A row of the panel: a group title or an option.
class _Row<T> {
  const _Row.header(this.label) : option = null;
  const _Row.option(WeSelectOption<T> this.option) : label = null;

  final String? label;
  final WeSelectOption<T>? option;

  bool get isHeader => option == null;
}

class _WeSelectState<T> extends State<WeSelect<T>> {
  static const double _rowHeight = 34;
  static const double _headerHeight = 30;
  static const double _listPadding = 6;

  final WePopperController _popper = WePopperController();
  final FocusNode _focus = FocusNode(debugLabel: 'WeSelect');
  final FocusNode _queryFocus = FocusNode(debugLabel: 'WeSelect.query');
  final TextEditingController _query = TextEditingController();
  final ScrollController _scroll = ScrollController();

  /// Labels of values seen before, so remote picks still show a label.
  final Map<T, WeSelectOption<T>> _known = {};

  bool _open = false;
  bool _focused = false;
  int _highlight = -1;

  List<WeSelectOption<T>>? _remoteOptions;
  bool _loading = false;
  Timer? _debounce;
  int _remoteSeq = 0;

  WeFormItemState? _formItem;

  bool get _enabled =>
      !widget.disabled &&
      !(_formItem?.disabled ?? false) &&
      (widget.multiple
          ? widget.onValuesChanged != null
          : widget.onChanged != null);

  bool get _remote => widget.remoteMethod != null;
  bool get _filterable => widget.filterable || _remote;
  Set<T> get _values => widget.values ?? const {};

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
    _queryFocus.addListener(_onFocus);
    _remember();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formItem = WeFormItem.maybeOf(context);
  }

  @override
  void didUpdateWidget(WeSelect<T> old) {
    super.didUpdateWidget(old);
    _remember();
    if (!_enabled && _open) _popper.hide();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _popper.dispose();
    _focus.dispose();
    _queryFocus.dispose();
    _query.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _remember() {
    for (final o in _localOptions) {
      _known[o.value] = o;
    }
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

  Iterable<WeSelectOption<T>> get _localOptions sync* {
    yield* widget.options;
    for (final g in widget.groups) {
      yield* g.options;
    }
  }

  WeSelectOption<T>? _optionOf(T value) {
    for (final o in _remoteOptions ?? const []) {
      if (o.value == value) return o;
    }
    for (final o in _localOptions) {
      if (o.value == value) return o;
    }
    return _known[value];
  }

  /// The single-choice option; `null` values count when `T` is nullable, so
  /// an "all" option with a `null` value still shows its label.
  WeSelectOption<T>? get _selected {
    final Object? v = widget.value;
    return v is T ? _optionOf(v) : null;
  }

  bool _matches(WeSelectOption<T> o, String q) {
    if (q.isEmpty) return true;
    final WeSelectFilter<T>? f = widget.filterMethod;
    if (f != null) return f(q, o);
    return o.label.toLowerCase().contains(q.toLowerCase());
  }

  List<_Row<T>> get _rows {
    if (_remote) {
      return [for (final o in _remoteOptions ?? const []) _Row.option(o)];
    }
    final String q = _filterable ? _query.text.trim() : '';
    return [
      for (final o in widget.options)
        if (_matches(o, q)) _Row.option(o),
      for (final g in widget.groups)
        ...() {
          final List<WeSelectOption<T>> hits = [
            for (final o in g.options)
              if (_matches(o, q)) o,
          ];
          return hits.isEmpty
              ? const <Never>[]
              : [_Row<T>.header(g.label), for (final o in hits) _Row.option(o)];
        }(),
    ];
  }

  bool _isSelected(T v) =>
      widget.multiple ? _values.contains(v) : widget.value == v;

  bool _isBlocked(WeSelectOption<T> o) {
    if (o.disabled) return true;
    return widget.multiple &&
        widget.multipleLimit > 0 &&
        _values.length >= widget.multipleLimit &&
        !_values.contains(o.value);
  }

  // ---- open / close -------------------------------------------------------

  void _onOpenChanged(bool open) {
    setState(() => _open = open);
    if (open) {
      _resetHighlight();
      if (_remote && _remoteOptions == null) _search('');
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToHighlight());
    } else {
      _debounce?.cancel();
      if (_query.text.isNotEmpty) _query.clear();
      if (_queryFocus.hasFocus) _focus.requestFocus();
    }
  }

  void _openPanel() {
    if (!_enabled) return;
    _popper.show();
    (_filterable ? _queryFocus : _focus).requestFocus();
  }

  void _togglePanel() {
    if (!_enabled) return;
    if (_open) {
      _popper.hide();
    } else {
      _openPanel();
    }
  }

  // ---- search -------------------------------------------------------------

  void _onQuery(String q) {
    if (!_open) _popper.show();
    _search(q);
  }

  void _search(String q) {
    if (!_remote) {
      setState(_resetHighlight);
      return;
    }
    _debounce?.cancel();
    setState(() => _loading = true);
    final int seq = ++_remoteSeq;
    _debounce = Timer(
      q.isEmpty ? Duration.zero : widget.remoteDebounce,
      () async {
        List<WeSelectOption<T>> result;
        try {
          result = await widget.remoteMethod!(q.trim());
        } catch (error, stack) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: stack,
              library: 'widgets_easier',
              context: ErrorDescription('while running WeSelect.remoteMethod'),
            ),
          );
          result = const [];
        }
        if (!mounted || seq != _remoteSeq) return;
        setState(() {
          _remoteOptions = result;
          _loading = false;
          _resetHighlight();
        });
      },
    );
  }

  // ---- highlight / keyboard ----------------------------------------------

  void _resetHighlight() {
    final rows = _rows;
    int target = -1;
    for (int i = 0; i < rows.length; i++) {
      final o = rows[i].option;
      if (o == null || _isBlocked(o)) continue;
      if (target < 0) target = i;
      if (!widget.multiple && _isSelected(o.value)) {
        target = i;
        break;
      }
    }
    _highlight = target;
  }

  void _move(int step) {
    final rows = _rows;
    if (rows.isEmpty) return;
    int i = _highlight;
    for (int n = 0; n < rows.length; n++) {
      i = (i + step) % rows.length;
      if (i < 0) i += rows.length;
      final o = rows[i].option;
      if (o != null && !_isBlocked(o)) {
        setState(() => _highlight = i);
        _scrollToHighlight();
        return;
      }
    }
  }

  void _scrollToHighlight() {
    if (!_scroll.hasClients || _highlight < 0) return;
    final rows = _rows;
    double top = _listPadding;
    for (int i = 0; i < _highlight && i < rows.length; i++) {
      top += rows[i].isHeader ? _headerHeight : _rowHeight;
    }
    final double bottom = top + _rowHeight;
    final ScrollPosition p = _scroll.position;
    if (top < p.pixels) {
      _scroll.jumpTo(top - _listPadding);
    } else if (bottom > p.pixels + p.viewportDimension) {
      _scroll.jumpTo(
        (bottom + _listPadding - p.viewportDimension).clamp(
          0.0,
          p.maxScrollExtent,
        ),
      );
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!_enabled) return KeyEventResult.ignored;
    final LogicalKeyboardKey key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowUp) {
      if (!_open) {
        _openPanel();
      } else {
        _move(key == LogicalKeyboardKey.arrowDown ? 1 : -1);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        (key == LogicalKeyboardKey.space && !_queryFocus.hasFocus)) {
      if (!_open) {
        _openPanel();
      } else {
        final rows = _rows;
        if (_highlight >= 0 && _highlight < rows.length) {
          final o = rows[_highlight].option;
          if (o != null) _pick(o);
        }
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace &&
        widget.multiple &&
        _query.text.isEmpty &&
        _values.isNotEmpty) {
      _remove(_values.last);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.tab && _open) {
      _popper.hide();
    }
    return KeyEventResult.ignored;
  }

  // ---- changes ------------------------------------------------------------

  void _pick(WeSelectOption<T> o) {
    if (_isBlocked(o)) return;
    _known[o.value] = o;
    if (!widget.multiple) {
      widget.onChanged!(o.value);
      _popper.hide();
      _formItem?.onChange();
      return;
    }
    final Set<T> next = {..._values};
    if (!next.remove(o.value)) next.add(o.value);
    widget.onValuesChanged!(next);
    if (_query.text.isNotEmpty) {
      _query.clear();
      _search('');
    }
    _formItem?.onChange();
  }

  void _remove(T v) {
    widget.onValuesChanged!({..._values}..remove(v));
    _formItem?.onChange();
  }

  void _clear() {
    if (widget.multiple) {
      widget.onValuesChanged!(<T>{});
    } else {
      widget.onChanged!(null);
    }
    _formItem?.onChange();
  }

  // ---- build --------------------------------------------------------------

  /// Desktop text fields unfocus on taps outside them; claiming the panel
  /// for the search field keeps it focused, and so the panel open.
  Widget _buildPanel(BuildContext context) =>
      TextFieldTapRegion(child: _buildPanelBody(context));

  Widget _buildPanelBody(BuildContext context) {
    final colors = context.weColors;
    final rows = _rows;

    Widget hint(String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 13, color: colors.secondaryText),
        ),
      ),
    );

    if (_loading) return hint(widget.loadingText);
    if (rows.isEmpty) {
      final bool noData = _remote
          ? _query.text.isEmpty && (_remoteOptions?.isEmpty ?? true)
          : _localOptions.isEmpty;
      return hint(noData ? widget.noDataText : widget.noMatchText);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: ListView.builder(
            controller: _scroll,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: _listPadding),
            itemCount: rows.length,
            itemBuilder: (context, i) {
              final row = rows[i];
              if (row.isHeader) {
                return Container(
                  height: _headerHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    row.label!,
                    style: TextStyle(fontSize: 12, color: colors.secondaryText),
                  ),
                );
              }
              final o = row.option!;
              return _OptionRow(
                label: o.label,
                icon: o.icon,
                height: _rowHeight,
                selected: _isSelected(o.value),
                checkmark: widget.multiple,
                highlighted: i == _highlight,
                disabled: _isBlocked(o),
                onHover: () {
                  if (_highlight != i) setState(() => _highlight = i);
                },
                onTap: () => _pick(o),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuery(double fontSize, String? hint, {double? width}) {
    final colors = context.weColors;
    final Widget field = TextField(
      controller: _query,
      focusNode: _queryFocus,
      onChanged: _onQuery,
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

  Widget _buildTags(WeControlSize metrics) {
    final colors = context.weColors;
    final List<T> all = _values.toList();
    final int shown = widget.collapseTags
        ? all.length.clamp(0, widget.maxCollapseTags)
        : all.length;
    final List<T> hidden = all.sublist(shown);

    final List<Widget> children = [
      for (final v in all.take(shown))
        _SelectTag(
          label: _optionOf(v)?.label ?? '$v',
          onClose: _enabled ? () => _remove(v) : null,
        ),
      if (hidden.isNotEmpty)
        widget.collapseTagsTooltip
            ? WeTooltip(
                effect: WeTooltipEffect.light,
                contentBuilder: (_) => Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final v in hidden)
                      _SelectTag(
                        label: _optionOf(v)?.label ?? '$v',
                        onClose: _enabled ? () => _remove(v) : null,
                      ),
                  ],
                ),
                child: _SelectTag(label: '+ ${hidden.length}'),
              )
            : _SelectTag(label: '+ ${hidden.length}'),
    ];

    final bool showHint = all.isEmpty && _query.text.isEmpty;
    if (_filterable) {
      children.add(
        _buildQuery(
          metrics.fontSize,
          showHint ? widget.hint : null,
          width: showHint ? 160 : 60,
        ),
      );
    } else if (showHint) {
      children.add(
        Text(
          widget.hint ?? '',
          style: TextStyle(
            fontSize: metrics.fontSize,
            color: colors.placeholderText,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }

  Widget _buildField(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final metrics = we.sizes.control(
      WeFieldBox.resolveSize(context, widget.size),
    );
    final bool enabled = _enabled;
    final WeSelectOption<T>? selected = _selected;
    final bool hasValue = widget.multiple
        ? _values.isNotEmpty
        : selected != null && widget.value != null;

    Widget content;
    if (widget.multiple) {
      content = _buildTags(metrics);
    } else {
      final String? label = selected?.label;
      if (_filterable && _open) {
        content = _buildQuery(metrics.fontSize, label ?? widget.hint);
      } else {
        content = Text(
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
      }
    }

    return WeFieldBox(
      focusNode: _focus,
      onKeyEvent: _onKey,
      open: _open,
      focused: _focused,
      enabled: enabled,
      size: widget.size,
      status: widget.status,
      prefixIcon: widget.prefixIcon,
      multiline: widget.multiple,
      onClear: widget.clearable && hasValue ? _clear : null,
      onTap: _togglePanel,
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget field = WePopper.builder(
      controller: _popper,
      placement: WePlacement.bottomStart,
      matchTriggerWidth: true,
      gap: 4,
      maxHeight: widget.maxHeight,
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

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.icon,
    required this.height,
    required this.selected,
    required this.checkmark,
    required this.highlighted,
    required this.disabled,
    required this.onHover,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final double height;
  final bool selected;
  final bool checkmark;
  final bool highlighted;
  final bool disabled;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Color fg = disabled
        ? colors.disabledText
        : selected
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: highlighted && !disabled ? colors.lightFill : null,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 15,
                  color: disabled ? colors.disabledText : colors.secondaryText,
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
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: fg,
                  ),
                ),
              ),
              if (selected && (checkmark || !disabled))
                Icon(Icons.check_rounded, size: 15, color: colors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

/// The compact info-coloured tag used inside a multi-select field.
class _SelectTag extends StatelessWidget {
  const _SelectTag({required this.label, this.onClose});

  final String label;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    return Container(
      height: 22,
      padding: EdgeInsets.only(left: 8, right: onClose == null ? 8 : 4),
      decoration: BoxDecoration(
        color: colors.lightFill,
        borderRadius: BorderRadius.circular(4),
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
