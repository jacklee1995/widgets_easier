part of 'we_date.dart';

/// A compact calendar for picking a day or a range of days, after the panel
/// of `el-date-picker`.
///
/// This is the panel [WeDatePicker] drops down, usable on its own in a
/// sidebar, a popover or a filter bar.
///
/// ```dart
/// WeDatePanel(
///   value: day,
///   onChanged: (d) => setState(() => day = d),
/// )
///
/// WeDatePanel.range(
///   range: stay,
///   onRangeChanged: (r) => setState(() => stay = r),
/// )
/// ```
///
/// It is built for a pointer and a keyboard. Days highlight on hover, and in
/// a range the band follows the pointer after the first click. Clicking the
/// year or month in the title zooms out to a year or month grid. The grid is
/// one focus stop driven entirely from the keyboard: arrows, Home / End,
/// PageUp / PageDown (with Shift for years), T for today, Enter to pick and
/// Escape to back out of a zoomed view.
///
/// Platform: desktop and web (pointer + keyboard, wide screen). On phones
/// prefer [WeDateWheel] or [WeDateSheet].
class WeDatePanel extends StatefulWidget {
  /// Picks a single day.
  const WeDatePanel({
    super.key,
    required this.value,
    required this.onChanged,
    this.initialMonth,
    this.firstDate,
    this.lastDate,
    this.disabledDate,
    this.firstDayOfWeek,
    this.showWeekNumber = false,
    this.showToday = true,
    this.locale = WeDateLocale.zh,
    this.focusNode,
    this.autofocus = false,
    this.onMonthChanged,
  }) : isRange = false,
       range = null,
       onRangeChanged = null,
       onRangeStart = null;

  /// Picks a start and an end day, over two months side by side.
  const WeDatePanel.range({
    super.key,
    required this.range,
    required this.onRangeChanged,
    this.onRangeStart,
    this.initialMonth,
    this.firstDate,
    this.lastDate,
    this.disabledDate,
    this.firstDayOfWeek,
    this.showWeekNumber = false,
    this.locale = WeDateLocale.zh,
    this.focusNode,
    this.autofocus = false,
    this.onMonthChanged,
  }) : isRange = true,
       value = null,
       onChanged = null,
       showToday = false;

  final bool isRange;

  /// The picked day, single mode.
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;

  /// The picked range, range mode.
  final DateTimeRange? range;

  /// Called once both ends are picked, earlier end first.
  final ValueChanged<DateTimeRange>? onRangeChanged;

  /// Called when the first end of a new range is picked.
  final ValueChanged<DateTime>? onRangeStart;

  /// The month shown first. Defaults to the value's month, else today's.
  final DateTime? initialMonth;

  /// Days before [firstDate] or after [lastDate] cannot be picked, and the
  /// panel does not page past them.
  final DateTime? firstDate;
  final DateTime? lastDate;

  /// Blocks individual days, e.g. weekends or sold-out dates.
  final bool Function(DateTime day)? disabledDate;

  /// [DateTime.monday] … [DateTime.sunday]; defaults to the locale's.
  final int? firstDayOfWeek;

  /// Adds an ISO week-number column.
  final bool showWeekNumber;

  /// Adds a "Today" link under the grid. Single mode only.
  final bool showToday;

  final WeDateLocale locale;
  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<DateTime>? onMonthChanged;

  @override
  State<WeDatePanel> createState() => _WeDatePanelState();
}

class _WeDatePanelState extends State<WeDatePanel>
    with _DateNavigation<WeDatePanel>, _PeriodViews<WeDatePanel> {
  static const double _cellWidth = 36;
  static const double _cellHeight = 32;
  static const double _boxSize = 28;
  static const double _weekdayHeight = 30;
  static const double _weekColumn = 28;
  static const double _monthGap = 24;

  FocusNode? _ownFocus;
  FocusNode get _focus =>
      widget.focusNode ?? (_ownFocus ??= FocusNode(debugLabel: 'WeDatePanel'));

  /// The first end of a range being picked.
  DateTime? _draftStart;
  DateTime? _hover;

  @override
  int get _monthsShown => widget.isRange ? 2 : 1;
  @override
  DateTime? get _firstDate => widget.firstDate;
  @override
  DateTime? get _lastDate => widget.lastDate;
  @override
  bool Function(DateTime day)? get _disabledDate => widget.disabledDate;
  @override
  int get _firstDayOfWeek =>
      widget.firstDayOfWeek ?? widget.locale.firstDayOfWeek;
  @override
  WeDateLocale get _locale => widget.locale;
  @override
  bool get _canZoom => !widget.isRange;

  DateTime? get _anchor => widget.isRange ? widget.range?.start : widget.value;

  @override
  void initState() {
    super.initState();
    _initNavigation(widget.initialMonth ?? _anchor ?? DateTime.now());
    final DateTime? anchor = _anchor;
    if (anchor != null && widget.initialMonth == null) _cursor = _day(anchor);
  }

  @override
  void didUpdateWidget(WeDatePanel old) {
    super.didUpdateWidget(old);
    final DateTime? now = _anchor;
    final DateTime? before = old.isRange ? old.range?.start : old.value;
    if (now != null && !_sameDay(now, before)) {
      // A value set from outside, e.g. typed into a picker field: follow it.
      _cursor = _clamp(_day(now));
      if (!_onScreen(_cursor)) {
        _view = WeCalendarView.day;
        _setMonth(_cursor);
      }
    }
    if (widget.isRange && widget.range != old.range) _draftStart = null;
  }

  @override
  void dispose() {
    _ownFocus?.dispose();
    super.dispose();
  }

  @override
  void _monthChanged(DateTime month) => widget.onMonthChanged?.call(month);

  @override
  bool _isSelectedMonth(int year, int month) {
    final DateTime? v = widget.value;
    return v != null && v.year == year && v.month == month;
  }

  @override
  bool _isSelectedYear(int year) => widget.value?.year == year;

  @override
  void _pickDay(DateTime day) {
    setState(() => _cursor = day);
    if (!widget.isRange) {
      if (!_onScreen(day)) _setMonth(day);
      widget.onChanged?.call(day);
      return;
    }
    final DateTime? start = _draftStart;
    if (start == null) {
      setState(() => _draftStart = day);
      widget.onRangeStart?.call(day);
      return;
    }
    setState(() {
      _draftStart = null;
      _hover = null;
    });
    widget.onRangeChanged?.call(
      day.isBefore(start)
          ? DateTimeRange(start: day, end: start)
          : DateTimeRange(start: start, end: day),
    );
  }

  /// The range to paint: the one being picked, following the pointer or the
  /// keyboard cursor, else the committed one.
  (DateTime, DateTime?)? get _paintedRange {
    final DateTime? start = _draftStart;
    if (start != null) {
      final DateTime other = _hover ?? (_showCursor ? _cursor : start);
      return other.isBefore(start) ? (other, start) : (start, other);
    }
    final DateTimeRange? r = widget.range;
    return r == null ? null : (_day(r.start), _day(r.end));
  }

  double get _gridWidth =>
      _cellWidth * 7 + (widget.showWeekNumber ? _weekColumn : 0);
  double get _bodyHeight => _weekdayHeight + _cellHeight * 6;

  @override
  Widget build(BuildContext context) {
    WePlatform.debugCheckFit(
      context,
      'WeDatePanel',
      WePlatformFit.desktop,
      alternative: 'WeDateWheel 或 WeDateSheet（底部滚轮选日期）',
    );
    final colors = context.weColors;
    final double width = widget.isRange
        ? _gridWidth * 2 + _monthGap
        : _gridWidth;

    final Widget body = SizedBox(
      width: width,
      height: _bodyHeight,
      child: _Flip(
        id: (_view, _view == WeCalendarView.year ? _decadeStart : _month),
        direction: _direction,
        zoom: _zoom,
        child: _view == WeCalendarView.day
            ? Row(
                children: [
                  _monthGrid(_month),
                  if (widget.isRange) ...[
                    const SizedBox(width: _monthGap),
                    _monthGrid(_addMonths(_month, 1)),
                  ],
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _periodGrid(large: false),
              ),
      ),
    );

    final DateTime today = DateUtils.dateOnly(DateTime.now());
    return Focus(
      focusNode: _focus,
      autofocus: widget.autofocus,
      onKeyEvent: _onKey,
      onFocusChange: _onFocusChange,
      child: Listener(
        onPointerDown: (_) => _onPointer(),
        child: MouseRegion(
          onExit: (_) {
            if (_hover != null) setState(() => _hover = null);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: width, child: _header()),
                const SizedBox(height: 4),
                body,
                if (widget.showToday && !widget.isRange) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: width,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: colors.lighterBorder),
                      ),
                    ),
                    child: _TodayLink(
                      label: widget.locale.today,
                      onTap: _blocked(today)
                          ? null
                          : () {
                              if (_view != WeCalendarView.day) {
                                _openMonth(today);
                              }
                              _pickDay(today);
                            },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final bool day = _view == WeCalendarView.day;
    final Widget back = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavButton(
          icon: Icons.keyboard_double_arrow_left,
          onTap: _canPage(day ? -12 : -1) ? () => _page(day ? -12 : -1) : null,
        ),
        if (day)
          _NavButton(
            icon: Icons.chevron_left,
            onTap: _canPage(-1) ? () => _page(-1) : null,
          ),
      ],
    );
    final Widget forward = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (day)
          _NavButton(
            icon: Icons.chevron_right,
            onTap: _canPage(1) ? () => _page(1) : null,
          ),
        _NavButton(
          icon: Icons.keyboard_double_arrow_right,
          onTap: _canPage(day ? 12 : 1) ? () => _page(day ? 12 : 1) : null,
        ),
      ],
    );
    // Equal slots on both sides keep each title centred over its grid.
    final double slot = day ? 56 : 28;

    Widget title(List<Widget> parts) => Expanded(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(mainAxisSize: MainAxisSize.min, children: parts),
      ),
    );

    if (!widget.isRange) {
      return SizedBox(
        height: 32,
        child: Row(
          children: [
            SizedBox(width: slot, child: back),
            title(_titleParts()),
            SizedBox(
              width: slot,
              child: Align(alignment: Alignment.centerRight, child: forward),
            ),
          ],
        ),
      );
    }
    final TextStyle style = TextStyle(
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: context.weColors.primaryText,
    );
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          SizedBox(
            width: _gridWidth,
            child: Row(
              children: [
                SizedBox(width: slot, child: back),
                title([Text(widget.locale.title(_month), style: style)]),
                SizedBox(width: slot),
              ],
            ),
          ),
          const SizedBox(width: _monthGap),
          SizedBox(
            width: _gridWidth,
            child: Row(
              children: [
                SizedBox(width: slot),
                title([
                  Text(
                    widget.locale.title(_addMonths(_month, 1)),
                    style: style,
                  ),
                ]),
                SizedBox(
                  width: slot,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: forward,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthGrid(DateTime month) {
    final colors = context.weColors;
    final List<DateTime> days = _gridDays(month, _firstDayOfWeek);
    final DateTime today = DateUtils.dateOnly(DateTime.now());
    final (DateTime, DateTime?)? range = _paintedRange;

    return SizedBox(
      width: _gridWidth,
      child: Column(
        children: [
          _WeekdayRow(
            locale: widget.locale,
            firstDayOfWeek: _firstDayOfWeek,
            height: _weekdayHeight,
            fontSize: 12,
            weekColumn: widget.showWeekNumber ? _weekColumn : null,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.lighterBorder)),
            ),
          ),
          for (int r = 0; r < 6; r++)
            SizedBox(
              height: _cellHeight,
              child: Row(
                children: [
                  if (widget.showWeekNumber)
                    SizedBox(
                      width: _weekColumn,
                      child: Center(
                        child: Text(
                          '${_isoWeek(days[r * 7])}',
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.placeholderText,
                          ),
                        ),
                      ),
                    ),
                  for (final DateTime d in days.sublist(r * 7, r * 7 + 7))
                    _dayCell(d, month, today, range),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _dayCell(
    DateTime d,
    DateTime month,
    DateTime today,
    (DateTime, DateTime?)? range,
  ) {
    final bool outside = d.month != month.month;
    // Two months side by side would show the same spill-over days twice.
    if (outside && widget.isRange) {
      return const SizedBox(width: _cellWidth, height: _cellHeight);
    }

    bool selected = false, inside = false, isStart = false, isEnd = false;
    if (widget.isRange) {
      if (range != null) {
        final (DateTime start, DateTime? end) = range;
        isStart = _sameDay(d, start);
        isEnd = end != null && _sameDay(d, end);
        selected = isStart || isEnd;
        inside = end != null && d.isAfter(start) && d.isBefore(end);
      }
    } else {
      selected = _sameDay(d, widget.value);
    }
    final bool band =
        inside ||
        (range?.$2 != null && !_sameDay(range!.$1, range.$2) && selected);

    return _DayCell(
      day: d,
      width: _cellWidth,
      height: _cellHeight,
      boxSize: _boxSize,
      outside: outside,
      today: _sameDay(d, today),
      selected: selected,
      band: band,
      bandFromCentre: isStart,
      bandToCentre: isEnd,
      cursor: _showCursor && _sameDay(d, _cursor),
      hovered: _sameDay(d, _hover),
      disabled: _blocked(d),
      onHover: () {
        if (!_sameDay(_hover, d)) setState(() => _hover = d);
      },
      onTap: () {
        _onPointer();
        _pickDay(d);
      },
    );
  }
}

/// A day of the compact grid.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.width,
    required this.height,
    required this.boxSize,
    required this.outside,
    required this.today,
    required this.selected,
    required this.band,
    required this.bandFromCentre,
    required this.bandToCentre,
    required this.cursor,
    required this.hovered,
    required this.disabled,
    required this.onHover,
    required this.onTap,
  });

  final DateTime day;
  final double width;
  final double height;
  final double boxSize;
  final bool outside;
  final bool today;
  final bool selected;

  /// Part of a range: a tinted strip runs through the cell.
  final bool band;

  /// The strip starts or stops at the centre, for the range's two ends.
  final bool bandFromCentre;
  final bool bandToCentre;
  final bool cursor;
  final bool hovered;
  final bool disabled;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final double inset = (height - boxSize) / 2;

    final Color fg = selected
        ? colors.onSemantic
        : disabled
        ? colors.disabledText
        : outside
        ? colors.placeholderText
        : today
        ? colors.primary
        : colors.regularText;
    final Color? box = selected
        ? colors.primary
        : hovered && !disabled
        ? colors.lightFill
        : null;

    return MouseRegion(
      cursor: disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => onHover(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : onTap,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              if (disabled)
                Positioned.fill(
                  top: inset,
                  bottom: inset,
                  child: ColoredBox(color: colors.lightFill),
                ),
              if (band)
                Positioned(
                  top: inset,
                  bottom: inset,
                  left: bandFromCentre ? width / 2 : 0,
                  right: bandToCentre ? width / 2 : 0,
                  child: ColoredBox(color: colors.lighten(colors.primary, 9)),
                ),
              Center(
                child: Container(
                  width: boxSize,
                  height: boxSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: box,
                    borderRadius: BorderRadius.circular(we.radius.small),
                    border: cursor
                        ? Border.all(color: colors.primary, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.2,
                      fontWeight: today || selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: fg,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayLink extends StatefulWidget {
  const _TodayLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  State<_TodayLink> createState() => _TodayLinkState();
}

class _TodayLinkState extends State<_TodayLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final bool enabled = widget.onTap != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              color: !enabled
                  ? colors.disabledText
                  : _hover
                  ? colors.lighten(colors.primary, 3)
                  : colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
