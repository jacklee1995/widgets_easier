part of 'we_date.dart';

/// Something that happens on a day of a [WeCalendar].
@immutable
class WeCalendarEvent {
  const WeCalendarEvent(
    this.title, {
    this.type = SemanticEnum.primary,
    this.color,
    this.time,
    this.data,
  });

  final String title;

  /// Semantic colour of the event's bar; [color] overrides it.
  final SemanticEnum type;
  final Color? color;

  /// A short time shown before the title, such as `09:30`.
  final String? time;

  /// Anything you want back in [WeCalendar.onEventTap].
  final Object? data;
}

/// A day as [WeCalendar.cellBuilder] sees it.
@immutable
class WeCalendarDay {
  const WeCalendarDay({
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.isOutside,
    required this.isDisabled,
    required this.events,
  });

  final DateTime date;
  final bool isToday;
  final bool isSelected;

  /// Spills over from the previous or next month.
  final bool isOutside;
  final bool isDisabled;
  final List<WeCalendarEvent> events;
}

/// A month board for schedules and bookings, after `el-calendar`.
///
/// Hand it the events of each day and it lays them out as coloured bars,
/// with a "+3 more" line when a cell runs out of room; when the board gets
/// narrow the bars fold into dots. For anything else, [cellBuilder] draws
/// the body of each cell.
///
/// ```dart
/// WeCalendar(
///   value: day,
///   onChanged: (d) => setState(() => day = d),
///   events: (d) => schedule[DateUtils.dateOnly(d)] ?? const [],
///   onEventTap: (e, d) => open(e.data),
/// )
/// ```
///
/// Given a bounded height the six rows share it; otherwise each row is
/// [cellHeight] tall. Clicking the title zooms out to months, then years.
/// Once clicked the board takes keyboard focus: arrows move the day,
/// PageUp / PageDown page months (Shift for years), Home / End jump along
/// the week, T returns to today and Enter picks.
///
/// Platform: desktop and web (pointer + keyboard, wide screen). On phones
/// pick days with [WeDateSheet].
class WeCalendar extends StatefulWidget {
  const WeCalendar({
    super.key,
    this.value,
    this.onChanged,
    this.initialMonth,
    this.onMonthChanged,
    this.firstDate,
    this.lastDate,
    this.disabledDate,
    this.events,
    this.onEventTap,
    this.cellBuilder,
    this.firstDayOfWeek,
    this.showWeekNumber = false,
    this.locale = WeDateLocale.zh,
    this.cellHeight = 104,
    this.headerTrailing,
    this.focusNode,
    this.autofocus = false,
  });

  /// The selected day, drawn tinted. `null` for none.
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;

  /// The month shown first. Defaults to [value]'s month, else today's.
  final DateTime? initialMonth;
  final ValueChanged<DateTime>? onMonthChanged;

  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime day)? disabledDate;

  /// The events of a day, called for each of the 42 visible days.
  final List<WeCalendarEvent> Function(DateTime day)? events;
  final void Function(WeCalendarEvent event, DateTime day)? onEventTap;

  /// Replaces the event bars of each cell. Return `null` to keep them.
  final Widget? Function(BuildContext context, WeCalendarDay day)? cellBuilder;

  final int? firstDayOfWeek;
  final bool showWeekNumber;
  final WeDateLocale locale;

  /// Row height when the board is not given a bounded height.
  final double cellHeight;

  /// Extra controls before the paging buttons, e.g. a "New event" button.
  final Widget? headerTrailing;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<WeCalendar> createState() => _WeCalendarState();
}

class _WeCalendarState extends State<WeCalendar>
    with _DateNavigation<WeCalendar>, _PeriodViews<WeCalendar> {
  static const double _weekColumn = 36;
  static const double _weekdayHeight = 36;

  /// Below this cell width, event bars turn into dots.
  static const double _barsFrom = 84;

  FocusNode? _ownFocus;
  FocusNode get _focus =>
      widget.focusNode ?? (_ownFocus ??= FocusNode(debugLabel: 'WeCalendar'));

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
  void initState() {
    super.initState();
    _initNavigation(widget.initialMonth ?? widget.value ?? DateTime.now());
    if (widget.value != null) _cursor = _day(widget.value!);
  }

  @override
  void didUpdateWidget(WeCalendar old) {
    super.didUpdateWidget(old);
    final DateTime? v = widget.value;
    if (v != null && !_sameDay(v, old.value)) {
      _cursor = _clamp(_day(v));
      if (_view == WeCalendarView.day && !_onScreen(_cursor)) _setMonth(v);
    }
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
    if (!_onScreen(day)) _setMonth(day);
    widget.onChanged?.call(day);
  }

  void _goToday() {
    final DateTime today = DateUtils.dateOnly(DateTime.now());
    if (_view != WeCalendarView.day) {
      _openMonth(today);
    } else {
      _setMonth(today);
    }
    setState(() => _cursor = _clamp(today));
  }

  @override
  Widget build(BuildContext context) {
    WePlatform.debugCheckFit(
      context,
      'WeCalendar',
      WePlatformFit.desktop,
      alternative: 'WeDateSheet（底部滚轮选日期）',
    );
    final colors = context.weColors;
    return Focus(
      focusNode: _focus,
      autofocus: widget.autofocus,
      onKeyEvent: _onKey,
      onFocusChange: _onFocusChange,
      child: Listener(
        onPointerDown: (_) {
          _onPointer();
          if (!_focus.hasFocus) _focus.requestFocus();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool bounded = constraints.hasBoundedHeight;
            final Widget board = Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colors.lighterBorder),
                  left: BorderSide(color: colors.lighterBorder),
                ),
              ),
              child: _Flip(
                id: (
                  _view,
                  _view == WeCalendarView.year ? _decadeStart : _month,
                ),
                direction: _direction,
                zoom: _zoom,
                child: _view == WeCalendarView.day
                    ? _days(bounded)
                    : _periods(bounded),
              ),
            );
            return Column(
              mainAxisSize: bounded ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                const SizedBox(height: 12),
                bounded ? Expanded(child: board) : board,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        ..._titleParts(fontSize: 18),
        const Spacer(),
        if (widget.headerTrailing != null) ...[
          widget.headerTrailing!,
          const SizedBox(width: 12),
        ],
        _PagingStrip(
          children: [
            _BoardButton(
              icon: Icons.chevron_left,
              onTap: _canPage(-1) ? () => _page(-1) : null,
            ),
            _BoardButton(
              label: widget.locale.today,
              onTap: _blocked(DateUtils.dateOnly(DateTime.now()))
                  ? null
                  : _goToday,
            ),
            _BoardButton(
              icon: Icons.chevron_right,
              onTap: _canPage(1) ? () => _page(1) : null,
            ),
          ],
        ),
      ],
    );
  }

  Border _cellBorder(WeColorScheme colors) => Border(
    right: BorderSide(color: colors.lighterBorder),
    bottom: BorderSide(color: colors.lighterBorder),
  );

  Widget _periods(bool bounded) {
    final colors = context.weColors;
    return Container(
      height: bounded ? null : _weekdayHeight + widget.cellHeight * 6,
      decoration: BoxDecoration(border: _cellBorder(colors)),
      child: _periodGrid(large: true),
    );
  }

  Widget _days(bool bounded) {
    final colors = context.weColors;
    final List<DateTime> days = _gridDays(_month, _firstDayOfWeek);
    final DateTime today = DateUtils.dateOnly(DateTime.now());

    Widget row(int r) => Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showWeekNumber)
          Container(
            width: _weekColumn,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: colors.lighterFill,
              border: _cellBorder(colors),
            ),
            child: Text(
              '${_isoWeek(days[r * 7])}',
              style: TextStyle(fontSize: 12, color: colors.placeholderText),
            ),
          ),
        for (final DateTime d in days.sublist(r * 7, r * 7 + 7))
          Expanded(child: _cell(d, today)),
      ],
    );

    return Column(
      mainAxisSize: bounded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        _WeekdayRow(
          locale: widget.locale,
          firstDayOfWeek: _firstDayOfWeek,
          height: _weekdayHeight,
          fontSize: 13,
          weekColumn: widget.showWeekNumber ? _weekColumn : null,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: colors.lighterFill,
            border: _cellBorder(colors),
          ),
        ),
        for (int r = 0; r < 6; r++)
          bounded
              ? Expanded(child: row(r))
              : SizedBox(height: widget.cellHeight, child: row(r)),
      ],
    );
  }

  Widget _cell(DateTime d, DateTime today) {
    final List<WeCalendarEvent> events = widget.events?.call(d) ?? const [];
    final WeCalendarDay info = WeCalendarDay(
      date: d,
      isToday: _sameDay(d, today),
      isSelected: _sameDay(d, widget.value),
      isOutside: d.month != _month.month,
      isDisabled: _blocked(d),
      events: events,
    );
    return _BoardCell(
      info: info,
      locale: widget.locale,
      cursor: _showCursor && _sameDay(d, _cursor),
      barsFrom: _barsFrom,
      custom: widget.cellBuilder?.call(context, info),
      onTap: info.isDisabled
          ? null
          : () {
              _onPointer();
              _pickDay(d);
            },
      onEventTap: widget.onEventTap == null
          ? null
          : (e) => widget.onEventTap!(e, d),
    );
  }
}

/// Buttons joined into one outlined strip, the calendar's paging control.
class _PagingStrip extends StatelessWidget {
  const _PagingStrip({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    return Container(
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: colors.baseBorder),
        borderRadius: BorderRadius.circular(we.radius.base),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) Container(width: 1, color: colors.baseBorder),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _BoardButton extends StatefulWidget {
  const _BoardButton({this.icon, this.label, required this.onTap});

  final IconData? icon;
  final String? label;
  final VoidCallback? onTap;

  @override
  State<_BoardButton> createState() => _BoardButtonState();
}

class _BoardButtonState extends State<_BoardButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final bool enabled = widget.onTap != null;
    final Color fg = !enabled
        ? colors.disabledText
        : _hover
        ? colors.primary
        : colors.regularText;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.label != null ? 14 : 7,
          ),
          alignment: Alignment.center,
          color: _hover && enabled
              ? colors.lighten(colors.primary, 9)
              : colors.overlayBackground,
          child: widget.label != null
              ? Text(widget.label!, style: TextStyle(fontSize: 13, color: fg))
              : Icon(widget.icon, size: 16, color: fg),
        ),
      ),
    );
  }
}

class _BoardCell extends StatefulWidget {
  const _BoardCell({
    required this.info,
    required this.locale,
    required this.cursor,
    required this.barsFrom,
    required this.custom,
    required this.onTap,
    required this.onEventTap,
  });

  final WeCalendarDay info;
  final WeDateLocale locale;
  final bool cursor;
  final double barsFrom;
  final Widget? custom;
  final VoidCallback? onTap;
  final ValueChanged<WeCalendarEvent>? onEventTap;

  @override
  State<_BoardCell> createState() => _BoardCellState();
}

class _BoardCellState extends State<_BoardCell> {
  static const double _barHeight = 20;
  static const double _barGap = 2;

  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final WeCalendarDay d = widget.info;

    final Color? bg = d.isSelected
        ? colors.lighten(colors.primary, 9)
        : d.isDisabled
        ? colors.lightFill
        : _hover && widget.onTap != null
        ? colors.lighterFill
        : null;

    final Color numberColor = d.isToday
        ? colors.onSemantic
        : d.isDisabled
        ? colors.disabledText
        : d.isSelected
        ? colors.primary
        : d.isOutside
        ? colors.placeholderText
        : colors.primaryText;

    final Widget number = Container(
      height: 22,
      constraints: const BoxConstraints(minWidth: 22),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: d.isToday
          ? BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(we.radius.small),
            )
          : null,
      child: Text(
        '${d.date.day}',
        style: TextStyle(
          fontSize: 13,
          height: 1.2,
          fontWeight: d.isToday || d.isSelected
              ? FontWeight.w600
              : FontWeight.w400,
          color: numberColor,
        ),
      ),
    );

    return MouseRegion(
      cursor: widget.onTap == null
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            border: Border(
              right: BorderSide(color: colors.lighterBorder),
              bottom: BorderSide(color: colors.lighterBorder),
            ),
          ),
          foregroundDecoration: widget.cursor
              ? BoxDecoration(
                  border: Border.all(color: colors.primary, width: 1.5),
                )
              : d.isSelected
              ? BoxDecoration(
                  border: Border(
                    top: BorderSide(color: colors.primary, width: 2),
                  ),
                )
              : null,
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 4),
          child: LayoutBuilder(
            builder: (context, box) {
              final bool bars = box.maxWidth >= widget.barsFrom - 12;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      number,
                      if (d.date.day == 1 && bars) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.locale.monthLabel(d.date.month),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child:
                        widget.custom ??
                        (bars ? _bars(d.events) : _dots(d.events)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _bars(List<WeCalendarEvent> events) {
    if (events.isEmpty) return const SizedBox.shrink();
    final colors = context.weColors;
    return LayoutBuilder(
      builder: (context, box) {
        // Every bar carries its gap below it; the "+N" line has none.
        const double step = _barHeight + _barGap;
        final double h = box.maxHeight;
        final int fit = events.length * step <= h
            ? events.length
            : ((h - _barHeight) / step).floor().clamp(0, events.length);
        final int hidden = events.length - fit;
        return ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final e in events.take(fit))
                Padding(
                  padding: const EdgeInsets.only(bottom: _barGap),
                  child: _EventBar(
                    event: e,
                    height: _barHeight,
                    muted: widget.info.isOutside,
                    onTap: widget.onEventTap == null
                        ? null
                        : () => widget.onEventTap!(e),
                  ),
                ),
              if (hidden > 0)
                SizedBox(
                  height: _barHeight,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        widget.locale.more(hidden),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.secondaryText,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _dots(List<WeCalendarEvent> events) {
    if (events.isEmpty) return const SizedBox.shrink();
    final colors = context.weColors;
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 3,
        runSpacing: 3,
        children: [
          for (final e in events.take(6))
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: e.color ?? colors.semantic(e.type),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _EventBar extends StatefulWidget {
  const _EventBar({
    required this.event,
    required this.height,
    required this.muted,
    required this.onTap,
  });

  final WeCalendarEvent event;
  final double height;
  final bool muted;
  final VoidCallback? onTap;

  @override
  State<_EventBar> createState() => _EventBarState();
}

class _EventBarState extends State<_EventBar> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final WeCalendarEvent e = widget.event;
    final Color accent = e.color ?? colors.semantic(e.type);
    final double alpha = widget.muted ? 0.06 : (_hover ? 0.2 : 0.12);

    final Widget bar = Container(
      height: widget.height,
      padding: const EdgeInsets.only(left: 6, right: 4),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: alpha),
        border: Border(
          left: BorderSide(
            color: widget.muted ? accent.withValues(alpha: 0.5) : accent,
            width: 3,
          ),
        ),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            if (e.time != null)
              TextSpan(
                text: '${e.time} ',
                style: TextStyle(color: colors.secondaryText),
              ),
            TextSpan(text: e.title),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          height: 1.2,
          color: widget.muted ? colors.placeholderText : colors.primaryText,
        ),
      ),
    );

    if (widget.onTap == null) return bar;
    return Tooltip(
      message: e.time == null ? e.title : '${e.time}  ${e.title}',
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: bar,
        ),
      ),
    );
  }
}
