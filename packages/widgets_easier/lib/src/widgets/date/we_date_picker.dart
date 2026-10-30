part of 'we_date.dart';

/// A one-click preset beside a [WeDatePicker]'s panel, such as "Today" or
/// "Last 7 days". [value] runs when the preset is clicked, so relative
/// presets stay correct however long the page has been open.
@immutable
class WeDateShortcut<T> {
  const WeDateShortcut(this.label, this.value);

  final String label;
  final T Function() value;
}

/// What a [WeDatePicker] opens on touch.
enum WeDatePickerTouchMode {
  /// A [WeDateSheet] from the bottom. The default.
  sheet,

  /// The same drop-down panel as on desktop.
  panel,
}

/// A date field with a drop-down calendar, after `el-date-picker`.
///
/// ```dart
/// WeDatePicker(
///   value: due,
///   onChanged: (d) => setState(() => due = d),
/// )
///
/// WeDatePicker.range(
///   range: period,
///   onChanged: (r) => setState(() => period = r),
///   shortcuts: [
///     WeDateShortcut('最近一周', () => DateTimeRange(
///       start: DateTime.now().subtract(const Duration(days: 6)),
///       end: DateTime.now(),
///     )),
///   ],
/// )
/// ```
///
/// Made for a keyboard as much as for a mouse. The field takes typing:
/// `2026-9-5`, `2026/09/05` or `20260905` all work, the panel follows as you
/// type, Enter commits and an unreadable entry reverts when the field loses
/// focus. ↓ moves into the panel, which then works like [WeDatePanel]; Escape
/// closes it. In a range, Enter in the start field moves on to the end field.
///
/// Inside a [WeFormItem] it picks up the item's size, disabled state and
/// error colour, and reports changes and blur for validation.
///
/// On touch it opens a [WeDateSheet] (spinning year, month and day columns
/// from the bottom) instead of the panel, and the field stops taking typing
/// so no keyboard pops up. Set [touchMode] to [WeDatePickerTouchMode.panel]
/// to keep the panel.
///
/// Platform: universal; desktop gets the panel, touch gets the sheet.
class WeDatePicker extends StatefulWidget {
  /// Picks one day.
  const WeDatePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint,
    this.format = 'yyyy-MM-dd',
    this.editable = true,
    this.clearable = true,
    this.disabled = false,
    this.size = SizeEnum.defaultSize,
    this.width = 220,
    this.status,
    this.firstDate,
    this.lastDate,
    this.disabledDate,
    this.firstDayOfWeek,
    this.showWeekNumber = false,
    this.locale = WeDateLocale.zh,
    this.shortcuts = const [],
    this.placement = WePlacement.bottomStart,
    this.touchMode = WeDatePickerTouchMode.sheet,
  }) : isRange = false,
       range = null,
       onRangeChanged = null,
       rangeShortcuts = const [],
       startHint = null,
       endHint = null;

  /// Picks a start and an end day.
  const WeDatePicker.range({
    super.key,
    required this.range,
    required ValueChanged<DateTimeRange?>? onChanged,
    this.startHint,
    this.endHint,
    this.format = 'yyyy-MM-dd',
    this.editable = true,
    this.clearable = true,
    this.disabled = false,
    this.size = SizeEnum.defaultSize,
    this.width = 360,
    this.status,
    this.firstDate,
    this.lastDate,
    this.disabledDate,
    this.firstDayOfWeek,
    this.showWeekNumber = false,
    this.locale = WeDateLocale.zh,
    List<WeDateShortcut<DateTimeRange>> shortcuts = const [],
    this.placement = WePlacement.bottomStart,
    this.touchMode = WeDatePickerTouchMode.sheet,
  }) : isRange = true,
       value = null,
       onChanged = null,
       onRangeChanged = onChanged,
       rangeShortcuts = shortcuts,
       shortcuts = const [],
       hint = null;

  final bool isRange;

  final DateTime? value;

  /// Receives the new day, or `null` when cleared.
  final ValueChanged<DateTime?>? onChanged;

  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?>? onRangeChanged;

  /// Placeholder; defaults to the locale's.
  final String? hint;
  final String? startHint;
  final String? endHint;

  /// How the field shows a day and reads it back; see [weFormatDate].
  final String format;

  /// Allow typing a date into the field. When `false` the field only opens
  /// the panel.
  final bool editable;
  final bool clearable;
  final bool disabled;
  final SizeEnum size;
  final double? width;

  /// Colours the border; a surrounding [WeFormItem] sets it on error.
  final SemanticEnum? status;

  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime day)? disabledDate;
  final int? firstDayOfWeek;
  final bool showWeekNumber;
  final WeDateLocale locale;

  /// Presets listed beside the panel.
  final List<WeDateShortcut<DateTime>> shortcuts;
  final List<WeDateShortcut<DateTimeRange>> rangeShortcuts;

  final WePlacement placement;

  /// What a tap opens on touch platforms; see [WePlatform.isTouch].
  final WeDatePickerTouchMode touchMode;

  @override
  State<WeDatePicker> createState() => _WeDatePickerState();
}

class _WeDatePickerState extends State<WeDatePicker> {
  final WePopperController _popper = WePopperController();
  late final FocusNode _startFocus = FocusNode(
    debugLabel: 'WeDatePicker.start',
    onKeyEvent: _onFieldKey,
  );
  late final FocusNode _endFocus = FocusNode(
    debugLabel: 'WeDatePicker.end',
    onKeyEvent: _onFieldKey,
  );
  final FocusNode _panelFocus = FocusNode(debugLabel: 'WeDatePicker.panel');
  final TextEditingController _start = TextEditingController();
  final TextEditingController _end = TextEditingController();
  final GlobalKey _panelKey = GlobalKey();

  bool _hover = false;
  bool _open = false;
  bool _focused = false;

  /// What the fields read as while the user types, previewed in the panel.
  DateTime? _typedStart;
  DateTime? _typedEnd;

  WeFormItemState? _formItem;

  bool get _enabled =>
      !widget.disabled &&
      !(_formItem?.disabled ?? false) &&
      (widget.isRange
          ? widget.onRangeChanged != null
          : widget.onChanged != null);

  bool get _hasValue =>
      widget.isRange ? widget.range != null : widget.value != null;

  @override
  void initState() {
    super.initState();
    _startFocus.addListener(_onFocus);
    _endFocus.addListener(_onFocus);
    _panelFocus.addListener(_onFocus);
    _syncText();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formItem = WeFormItem.maybeOf(context);
  }

  @override
  void didUpdateWidget(WeDatePicker old) {
    super.didUpdateWidget(old);
    if (!_sameDay(widget.value, old.value) ||
        widget.range != old.range ||
        widget.format != old.format) {
      _syncText();
    }
    if (!_enabled && _open) _popper.hide();
  }

  @override
  void dispose() {
    _popper.dispose();
    _startFocus.dispose();
    _endFocus.dispose();
    _panelFocus.dispose();
    _start.dispose();
    _end.dispose();
    super.dispose();
  }

  String _text(DateTime? d) => d == null ? '' : weFormatDate(d, widget.format);

  void _syncText() {
    if (widget.isRange) {
      _start.text = _text(widget.range?.start);
      _end.text = _text(widget.range?.end);
    } else {
      _start.text = _text(widget.value);
    }
    _typedStart = null;
    _typedEnd = null;
  }

  bool _blocked(DateTime d) {
    final DateTime? first = widget.firstDate, last = widget.lastDate;
    if (first != null && d.isBefore(_day(first))) return true;
    if (last != null && d.isAfter(_day(last))) return true;
    return widget.disabledDate?.call(d) ?? false;
  }

  DateTime? _read(TextEditingController c) {
    final DateTime? d = weParseDate(c.text, widget.format);
    return d == null || _blocked(d) ? null : d;
  }

  // ---- focus & keys -------------------------------------------------------

  void _onFocus() {
    final bool focused =
        _startFocus.hasFocus || _endFocus.hasFocus || _panelFocus.hasFocus;
    if (focused == _focused) return;
    setState(() => _focused = focused);
    if (!focused) {
      _commit();
      if (_open) _popper.hide();
      _formItem?.onBlur();
    }
  }

  KeyEventResult _onFieldKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowDown && _enabled) {
      if (_open) {
        _panelFocus.requestFocus();
      } else {
        // The panel's focus node attaches once the panel has been built.
        _openPanel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_open) _panelFocus.requestFocus();
        });
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.tab && _open) _popper.hide();
    return KeyEventResult.ignored;
  }

  /// Taps in the panel must not blur the field the user is typing in.
  void _onTapOutside(PointerDownEvent event, FocusNode node) {
    final RenderBox? box =
        _panelKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.attached && box.hasSize) {
      final Rect rect = box.localToGlobal(Offset.zero) & box.size;
      if (rect.contains(event.position)) return;
    }
    node.unfocus();
  }

  bool get _useSheet =>
      widget.touchMode == WeDatePickerTouchMode.sheet &&
      WePlatform.isTouch(context);

  bool _sheetOpen = false;

  void _openPanel() {
    if (!_enabled || _open) return;
    if (_useSheet) {
      _openSheet();
      return;
    }
    _popper.show();
  }

  Future<void> _openSheet() async {
    if (_sheetOpen) return;
    _sheetOpen = true;
    try {
      if (widget.isRange) {
        final DateTimeRange? r = await WeDateSheet.showRange(
          context,
          initial: widget.range,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          disabledDate: widget.disabledDate,
          format: widget.format,
          locale: widget.locale,
          shortcuts: widget.rangeShortcuts,
        );
        if (r != null && mounted) _emitRange(r);
      } else {
        final DateTime? d = await WeDateSheet.show(
          context,
          initial: widget.value,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          disabledDate: widget.disabledDate,
          locale: widget.locale,
          shortcuts: widget.shortcuts,
        );
        if (d != null && mounted) _emitSingle(d);
      }
    } finally {
      _sheetOpen = false;
    }
  }

  void _onOpenChanged(bool open) {
    setState(() => _open = open);
    if (!open && _panelFocus.hasFocus) _startFocus.requestFocus();
    if (!open &&
        widget.isRange &&
        !_startFocus.hasFocus &&
        !_endFocus.hasFocus) {
      // A range left half-picked does not stick.
      _syncText();
    }
  }

  // ---- changes ------------------------------------------------------------

  void _emitSingle(DateTime? d) {
    if (_sameDay(d, widget.value) || (d == null && widget.value == null)) {
      _syncText();
      return;
    }
    widget.onChanged?.call(d);
    _formItem?.onChange();
  }

  void _emitRange(DateTimeRange? r) {
    final DateTimeRange? now = widget.range;
    final bool same = r == null
        ? now == null
        : now != null &&
              _sameDay(r.start, now.start) &&
              _sameDay(r.end, now.end);
    if (same) {
      _syncText();
      return;
    }
    widget.onRangeChanged?.call(r);
    _formItem?.onChange();
  }

  /// Takes what is typed, if it reads as a date; otherwise puts the value
  /// back into the field.
  void _commit() {
    if (!_enabled) return;
    if (!widget.isRange) {
      if (_start.text.trim().isEmpty) {
        _emitSingle(null);
        return;
      }
      final DateTime? d = _read(_start);
      d == null ? setState(_syncText) : _emitSingle(d);
      return;
    }
    if (_start.text.trim().isEmpty && _end.text.trim().isEmpty) {
      _emitRange(null);
      return;
    }
    final DateTime? a = _read(_start), b = _read(_end);
    if (a == null || b == null) {
      setState(_syncText);
      return;
    }
    _emitRange(
      b.isBefore(a)
          ? DateTimeRange(start: b, end: a)
          : DateTimeRange(start: a, end: b),
    );
  }

  void _onTyped(bool start, String text) {
    final DateTime? d = weParseDate(text, widget.format);
    setState(() => start ? _typedStart = d : _typedEnd = d);
    _openPanel();
  }

  void _onSubmitted(bool start) {
    if (widget.isRange && start) {
      _endFocus.requestFocus();
      return;
    }
    _commit();
    _popper.hide();
  }

  void _pickedDay(DateTime d) {
    _emitSingle(d);
    _popper.hide();
  }

  void _pickedRange(DateTimeRange r) {
    _emitRange(r);
    _popper.hide();
  }

  void _clear() {
    widget.isRange ? _emitRange(null) : _emitSingle(null);
    setState(_syncText);
  }

  // ---- build --------------------------------------------------------------

  DateTimeRange? get _previewRange {
    final DateTime? a = _typedStart ?? widget.range?.start;
    final DateTime? b = _typedEnd ?? widget.range?.end;
    if (a == null || b == null) return widget.range;
    return b.isBefore(a)
        ? DateTimeRange(start: b, end: a)
        : DateTimeRange(start: a, end: b);
  }

  Widget _buildPanel(BuildContext context) {
    final colors = context.weColors;
    final Widget panel = widget.isRange
        ? WeDatePanel.range(
            range: _previewRange,
            focusNode: _panelFocus,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            disabledDate: widget.disabledDate,
            firstDayOfWeek: widget.firstDayOfWeek,
            showWeekNumber: widget.showWeekNumber,
            locale: widget.locale,
            onRangeStart: (d) => setState(() {
              _start.text = _text(d);
              _end.text = '';
            }),
            onRangeChanged: _pickedRange,
          )
        : WeDatePanel(
            value: _typedStart ?? widget.value,
            focusNode: _panelFocus,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            disabledDate: widget.disabledDate,
            firstDayOfWeek: widget.firstDayOfWeek,
            showWeekNumber: widget.showWeekNumber,
            locale: widget.locale,
            onChanged: _pickedDay,
          );

    final List<(String, VoidCallback)> presets = widget.isRange
        ? [
            for (final s in widget.rangeShortcuts)
              (
                s.label,
                () {
                  final DateTimeRange r = s.value();
                  _pickedRange(
                    DateTimeRange(start: _day(r.start), end: _day(r.end)),
                  );
                },
              ),
          ]
        : [
            for (final s in widget.shortcuts)
              (s.label, () => _pickedDay(_day(s.value()))),
          ];

    return KeyedSubtree(
      key: _panelKey,
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (presets.isNotEmpty)
              Container(
                width: 112,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: colors.lighterBorder),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (label, apply) in presets)
                      _ShortcutRow(label: label, onTap: apply),
                  ],
                ),
              ),
            panel,
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    FocusNode node,
    String hint,
    double fontSize, {
    required bool start,
    TextAlign align = TextAlign.start,
  }) {
    final colors = context.weColors;
    final bool editable = widget.editable && !_useSheet;
    return TextField(
      controller: controller,
      focusNode: node,
      enabled: _enabled,
      readOnly: !editable,
      showCursor: editable,
      textAlign: align,
      maxLines: 1,
      cursorColor: colors.primary,
      cursorHeight: fontSize + 2,
      mouseCursor: editable
          ? SystemMouseCursors.text
          : SystemMouseCursors.click,
      style: TextStyle(fontSize: fontSize, color: colors.primaryText),
      decoration: InputDecoration(
        isDense: true,
        isCollapsed: true,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(fontSize: fontSize, color: colors.placeholderText),
      ),
      onTap: _openPanel,
      onTapOutside: (e) => _onTapOutside(e, node),
      onChanged: (t) => _onTyped(start, t),
      onSubmitted: (_) => _onSubmitted(start),
    );
  }

  Widget _buildField(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final SizeEnum size = widget.size == SizeEnum.defaultSize
        ? _formItem?.size ?? widget.size
        : widget.size;
    final metrics = we.sizes.control(size);
    final bool enabled = _enabled;
    final SemanticEnum? status = widget.status ?? _formItem?.status;
    final Color accent = status != null
        ? colors.semantic(status)
        : colors.primary;
    final bool active = _open || _focused;
    final Color border = !enabled
        ? colors.lightBorder
        : active || status != null
        ? accent
        : _hover
        ? colors.darkBorder
        : colors.baseBorder;
    final bool showClear = widget.clearable && _hasValue && _hover && enabled;
    final WeDateLocale l = widget.locale;

    final Widget content = widget.isRange
        ? Row(
            children: [
              Expanded(
                child: _field(
                  _start,
                  _startFocus,
                  widget.startHint ?? l.startPlaceholder,
                  metrics.fontSize,
                  start: true,
                  align: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: metrics.spacing),
                child: Text(
                  l.rangeSeparator,
                  style: TextStyle(
                    fontSize: metrics.fontSize,
                    color: enabled ? colors.regularText : colors.disabledText,
                  ),
                ),
              ),
              Expanded(
                child: _field(
                  _end,
                  _endFocus,
                  widget.endHint ?? l.endPlaceholder,
                  metrics.fontSize,
                  start: false,
                  align: TextAlign.center,
                ),
              ),
            ],
          )
        : _field(
            _start,
            _startFocus,
            widget.hint ?? l.placeholder,
            metrics.fontSize,
            start: true,
          );

    final Widget box = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: widget.width,
      height: metrics.height,
      padding: EdgeInsets.symmetric(
        horizontal: metrics.horizontalPadding * 0.7,
      ),
      decoration: BoxDecoration(
        color: enabled ? colors.overlayBackground : colors.lightFill,
        borderRadius: BorderRadius.circular(we.radius.base),
        border: Border.all(color: border),
        boxShadow: active && enabled
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.18),
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: metrics.iconSize,
            color: colors.placeholderText,
          ),
          SizedBox(width: metrics.spacing),
          Expanded(child: content),
          SizedBox(width: metrics.spacing),
          SizedBox(
            width: metrics.iconSize,
            child: showClear
                ? MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _clear,
                      child: Icon(
                        Icons.cancel_rounded,
                        size: metrics.iconSize,
                        color: colors.placeholderText,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled
            ? () {
                if (!_startFocus.hasFocus && !_endFocus.hasFocus) {
                  _startFocus.requestFocus();
                }
                _openPanel();
              }
            : null,
        child: box,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WePopper.builder(
      controller: _popper,
      placement: widget.placement,
      gap: 4,
      maxWidth: 900,
      style: const WePopperStyle(padding: EdgeInsets.zero),
      disabled: !_enabled,
      onOpenChanged: _onOpenChanged,
      popupBuilder: _buildPanel,
      builder: (context, _) => _buildField(context),
    );
  }
}

class _ShortcutRow extends StatefulWidget {
  const _ShortcutRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_ShortcutRow> createState() => _ShortcutRowState();
}

class _ShortcutRowState extends State<_ShortcutRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          color: _hover ? colors.lightFill : null,
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: _hover ? colors.primary : colors.regularText,
            ),
          ),
        ),
      ),
    );
  }
}
