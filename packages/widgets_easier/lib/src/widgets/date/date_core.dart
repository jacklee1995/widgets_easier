part of 'we_date.dart';

/// Which grid a calendar is showing: days of a month, months of a year, or
/// years of a decade.
enum WeCalendarView { day, month, year }

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime _monthOf(DateTime d) => DateTime(d.year, d.month);
DateTime _addMonths(DateTime month, int n) =>
    DateTime(month.year, month.month + n);

/// Calendar arithmetic, so a DST change never lands on 23:00 the day before.
DateTime _addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

bool _sameDay(DateTime? a, DateTime? b) =>
    a != null &&
    b != null &&
    a.year == b.year &&
    a.month == b.month &&
    a.day == b.day;

/// [d] moved by [n] months, keeping the day of month where it exists:
/// 31 January plus one month is 28 or 29 February.
DateTime _shiftMonths(DateTime d, int n) {
  final DateTime target = DateTime(d.year, d.month + n);
  final int last = DateUtils.getDaysInMonth(target.year, target.month);
  return DateTime(target.year, target.month, d.day > last ? last : d.day);
}

/// The 42 days a month grid shows, the first row starting on
/// [firstDayOfWeek].
List<DateTime> _gridDays(DateTime month, int firstDayOfWeek) {
  final int lead = (month.weekday - firstDayOfWeek + 7) % 7;
  return [
    for (int i = 0; i < 42; i++)
      DateTime(month.year, month.month, 1 - lead + i),
  ];
}

/// ISO 8601 week number. A grid row always holds exactly one Thursday, and
/// the row's week is the Thursday's week, whatever day the row starts on.
int _isoWeek(DateTime d) {
  final DateTime thursday = DateTime.utc(
    d.year,
    d.month,
    d.day + 4 - d.weekday,
  );
  return 1 + thursday.difference(DateTime.utc(thursday.year)).inDays ~/ 7;
}

final RegExp _formatTokens = RegExp(r'yyyy|MM|M|dd|d');

/// Formats [d] with a small pattern language: `yyyy`, `MM` / `M`, `dd` / `d`;
/// anything else is copied as is, so `yyyy年M月d日` works too.
String weFormatDate(DateTime d, [String pattern = 'yyyy-MM-dd']) =>
    pattern.replaceAllMapped(
      _formatTokens,
      (m) => switch (m[0]) {
        'yyyy' => d.year.toString().padLeft(4, '0'),
        'MM' => d.month.toString().padLeft(2, '0'),
        'M' => '${d.month}',
        'dd' => d.day.toString().padLeft(2, '0'),
        _ => '${d.day}',
      },
    );

/// Reads what a user typed back into a date, or `null` if it is not one.
///
/// It is forgiving on purpose: any separator goes (`2026-9-5`, `2026/09/05`,
/// `2026.9.5`, `2026 9 5`), and eight bare digits (`20260905`) are read as
/// year, month, day. The field order comes from [pattern].
DateTime? weParseDate(String text, [String pattern = 'yyyy-MM-dd']) {
  final List<String> order = [
    for (final m in RegExp(r'y+|M+|d+').allMatches(pattern)) m[0]![0],
  ];
  if (order.length != 3 || order.toSet().length != 3) return null;

  List<String> parts = [for (final m in RegExp(r'\d+').allMatches(text)) m[0]!];
  if (parts.length == 1 && parts.single.length == 8) {
    final String s = parts.single;
    parts = [s.substring(0, 4), s.substring(4, 6), s.substring(6)];
    order
      ..clear()
      ..addAll(['y', 'M', 'd']);
  }
  if (parts.length != 3) return null;

  final Map<String, int> v = {
    for (int i = 0; i < 3; i++) order[i]: int.parse(parts[i]),
  };
  final int y = v['y']!, m = v['M']!, d = v['d']!;
  if (y < 1000 || y > 9999 || m < 1 || m > 12) return null;
  if (d < 1 || d > DateUtils.getDaysInMonth(y, m)) return null;
  return DateTime(y, m, d);
}

/// Keyboard cursor, displayed period and view switching, shared by every
/// calendar surface in this library.
///
/// The grid is a single focus stop. Inside it:
///
/// * arrows move the cursor by a day / a week (a month / a row of months in
///   the month view, a year / a row of years in the year view),
/// * <kbd>Home</kbd> / <kbd>End</kbd> jump to the start / end of the week,
/// * <kbd>PageUp</kbd> / <kbd>PageDown</kbd> page by a month, with
///   <kbd>Shift</kbd> by a year (a year / a decade in the other views),
/// * <kbd>T</kbd> jumps to today,
/// * <kbd>Enter</kbd> / <kbd>Space</kbd> pick the day, or drill down from a
///   year to its months and from a month to its days,
/// * <kbd>Escape</kbd> backs out of the month and year views.
mixin _DateNavigation<W extends StatefulWidget> on State<W> {
  /// First day of the leftmost month on screen.
  late DateTime _month;

  /// The day the keyboard is on.
  late DateTime _cursor;

  WeCalendarView _view = WeCalendarView.day;

  /// `1` after moving forward in time, `-1` after moving back.
  int _direction = 0;

  /// The last change switched views rather than periods.
  bool _zoom = false;

  /// Whether the cursor ring is worth drawing: the grid has focus and the
  /// user is driving it with keys.
  bool _keyboard = false;
  bool _hasFocus = false;

  bool get _showCursor => _keyboard && _hasFocus;

  int get _monthsShown => 1;
  DateTime? get _firstDate;
  DateTime? get _lastDate;
  bool Function(DateTime day)? get _disabledDate;
  int get _firstDayOfWeek;

  /// Month and year views are reachable from this surface.
  bool get _canZoom => true;

  void _pickDay(DateTime day);

  /// Called whenever [_month] changes.
  void _monthChanged(DateTime month) {}

  void _initNavigation(DateTime anchor) {
    _cursor = _clamp(_day(anchor));
    _month = _monthOf(_cursor);
  }

  DateTime _clamp(DateTime day) {
    final DateTime? first = _firstDate, last = _lastDate;
    if (first != null && day.isBefore(_day(first))) return _day(first);
    if (last != null && day.isAfter(_day(last))) return _day(last);
    return day;
  }

  bool _blocked(DateTime day) {
    final DateTime? first = _firstDate, last = _lastDate;
    if (first != null && day.isBefore(_day(first))) return true;
    if (last != null && day.isAfter(_day(last))) return true;
    return _disabledDate?.call(day) ?? false;
  }

  bool _monthBlocked(int year, int month) {
    final int days = DateUtils.getDaysInMonth(year, month);
    for (int d = 1; d <= days; d++) {
      if (!_blocked(DateTime(year, month, d))) return false;
    }
    return true;
  }

  bool _yearBlocked(int year) {
    final DateTime? first = _firstDate, last = _lastDate;
    return (first != null && year < first.year) ||
        (last != null && year > last.year);
  }

  /// Whether [_page] with [step] would still show a pickable period.
  bool _canPage(int step) {
    final DateTime? first = _firstDate, last = _lastDate;
    switch (_view) {
      case WeCalendarView.day:
        final DateTime start = _addMonths(_month, step);
        final DateTime end = _addMonths(start, _monthsShown - 1);
        return !(first != null && end.isBefore(_monthOf(first))) &&
            !(last != null && start.isAfter(_monthOf(last)));
      case WeCalendarView.month:
        final int y = _month.year + step;
        return !(first != null && y < first.year) &&
            !(last != null && y > last.year);
      case WeCalendarView.year:
        final int d = _decadeStart + step * 10;
        return !(first != null && d + 9 < first.year) &&
            !(last != null && d > last.year);
    }
  }

  int get _decadeStart => _month.year - _month.year % 10;

  void _setMonth(DateTime month) {
    final DateTime m = _monthOf(month);
    if (m == _month) return;
    setState(() {
      _direction = m.isAfter(_month) ? 1 : -1;
      _zoom = false;
      _month = m;
    });
    _monthChanged(m);
  }

  /// Pages the day view by [months], the month view by years, the year view
  /// by decades.
  void _page(int step) {
    final int months = switch (_view) {
      WeCalendarView.day => step,
      WeCalendarView.month => step * 12,
      WeCalendarView.year => step * 120,
    };
    _setMonth(_addMonths(_month, months));
  }

  void _setView(WeCalendarView view) {
    if (view == _view) return;
    setState(() {
      _direction = view.index < _view.index ? 1 : -1;
      _zoom = true;
      _view = view;
    });
  }

  bool _onScreen(DateTime day) => switch (_view) {
    WeCalendarView.day =>
      !_monthOf(day).isBefore(_month) &&
          !_monthOf(day).isAfter(_addMonths(_month, _monthsShown - 1)),
    WeCalendarView.month => day.year == _month.year,
    WeCalendarView.year => day.year ~/ 10 == _month.year ~/ 10,
  };

  void _moveCursor(DateTime day) {
    final DateTime next = _clamp(day);
    setState(() => _cursor = next);
    if (_onScreen(next)) return;
    if (_view == WeCalendarView.day) {
      _setMonth(
        next.isBefore(_month)
            ? _monthOf(next)
            : _addMonths(_monthOf(next), 1 - _monthsShown),
      );
    } else {
      _setMonth(DateTime(next.year, _month.month));
    }
  }

  /// Opens the day view on [month], e.g. after a click in the month view.
  void _openMonth(DateTime month) {
    final DateTime m = _monthOf(month);
    setState(() {
      _direction = 1;
      _zoom = true;
      _view = WeCalendarView.day;
      _month = m;
      if (_monthOf(_cursor) != m) {
        _cursor = _clamp(
          _shiftMonths(
            _cursor,
            (m.year - _cursor.year) * 12 + m.month - _cursor.month,
          ),
        );
      }
    });
    _monthChanged(m);
  }

  /// Opens the month view on [year], e.g. after a click in the year view.
  void _openYear(int year) {
    setState(() {
      _direction = 1;
      _zoom = true;
      _view = WeCalendarView.month;
      _month = DateTime(year, _month.month);
      _cursor = _clamp(_shiftMonths(_cursor, (year - _cursor.year) * 12));
    });
    _monthChanged(_month);
  }

  void _onFocusChange(bool focused) {
    setState(() {
      _hasFocus = focused;
      if (!focused) _keyboard = false;
    });
  }

  /// Pointer use hides the cursor ring until the next key.
  void _onPointer() {
    if (_keyboard) setState(() => _keyboard = false);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final LogicalKeyboardKey key = event.logicalKey;
    final bool shift = HardwareKeyboard.instance.isShiftPressed;
    final DateTime c = _cursor;

    DateTime? target;
    bool activate = false;
    switch (_view) {
      case WeCalendarView.day:
        if (key == LogicalKeyboardKey.arrowLeft) target = _addDays(c, -1);
        if (key == LogicalKeyboardKey.arrowRight) target = _addDays(c, 1);
        if (key == LogicalKeyboardKey.arrowUp) target = _addDays(c, -7);
        if (key == LogicalKeyboardKey.arrowDown) target = _addDays(c, 7);
        final int intoWeek = (c.weekday - _firstDayOfWeek + 7) % 7;
        if (key == LogicalKeyboardKey.home) target = _addDays(c, -intoWeek);
        if (key == LogicalKeyboardKey.end) target = _addDays(c, 6 - intoWeek);
        if (key == LogicalKeyboardKey.pageUp) {
          target = _shiftMonths(c, shift ? -12 : -1);
        }
        if (key == LogicalKeyboardKey.pageDown) {
          target = _shiftMonths(c, shift ? 12 : 1);
        }
      case WeCalendarView.month:
        if (key == LogicalKeyboardKey.arrowLeft) target = _shiftMonths(c, -1);
        if (key == LogicalKeyboardKey.arrowRight) target = _shiftMonths(c, 1);
        if (key == LogicalKeyboardKey.arrowUp) target = _shiftMonths(c, -4);
        if (key == LogicalKeyboardKey.arrowDown) target = _shiftMonths(c, 4);
        if (key == LogicalKeyboardKey.pageUp) target = _shiftMonths(c, -12);
        if (key == LogicalKeyboardKey.pageDown) target = _shiftMonths(c, 12);
      case WeCalendarView.year:
        if (key == LogicalKeyboardKey.arrowLeft) target = _shiftMonths(c, -12);
        if (key == LogicalKeyboardKey.arrowRight) target = _shiftMonths(c, 12);
        if (key == LogicalKeyboardKey.arrowUp) target = _shiftMonths(c, -48);
        if (key == LogicalKeyboardKey.arrowDown) target = _shiftMonths(c, 48);
        if (key == LogicalKeyboardKey.pageUp) target = _shiftMonths(c, -120);
        if (key == LogicalKeyboardKey.pageDown) target = _shiftMonths(c, 120);
    }
    if (key == LogicalKeyboardKey.keyT) {
      target = DateUtils.dateOnly(DateTime.now());
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      activate = true;
    }

    if (target != null) {
      setState(() => _keyboard = true);
      _moveCursor(target);
      return KeyEventResult.handled;
    }
    if (activate) {
      setState(() => _keyboard = true);
      switch (_view) {
        case WeCalendarView.day:
          if (!_blocked(c)) _pickDay(c);
        case WeCalendarView.month:
          if (!_monthBlocked(c.year, c.month)) _openMonth(c);
        case WeCalendarView.year:
          if (!_yearBlocked(c.year)) _openYear(c.year);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape && _view != WeCalendarView.day) {
      _view == WeCalendarView.year
          ? _openYear(_cursor.year)
          : _openMonth(_cursor);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
