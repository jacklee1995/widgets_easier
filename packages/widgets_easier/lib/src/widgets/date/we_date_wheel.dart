part of 'we_date.dart';

/// Which columns a [WeDateWheel] shows.
enum WeDateWheelType {
  /// Year, month and day.
  date,

  /// Year and month; the value is always the 1st.
  month,
}

enum _WheelPart { year, month, day }

/// Spinning columns for year, month and day, the way phones pick a date.
///
/// ```dart
/// WeDateWheel(
///   value: birthday,
///   lastDate: DateTime.now(),
///   onChanged: (d) => setState(() => birthday = d),
/// )
/// ```
///
/// The columns follow the [locale]: year, month, day in Chinese and month,
/// day, year in English. Moving from 31 January to February lands on the
/// last day of February. Years, months and days outside [firstDate] and
/// [lastDate] are left out. Days hit by [disabledDate] are greyed, and the
/// wheel moves off them once it stops. A focused column also steps with the
/// up and down arrow keys.
///
/// [WeDateSheet] puts one in a bottom sheet with cancel and confirm.
///
/// Platform: mobile (large touch targets).
class WeDateWheel extends StatefulWidget {
  const WeDateWheel({
    super.key,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.disabledDate,
    this.type = WeDateWheelType.date,
    this.locale = WeDateLocale.zh,
    this.itemExtent = 44,
    this.visibleItems = 5,
  }) : assert(visibleItems % 2 == 1, 'visibleItems must be odd.');

  final DateTime value;

  /// Receives every day the wheel lands on, while it spins. Disabled days
  /// are not reported.
  final ValueChanged<DateTime> onChanged;

  /// Defaults to 1 January 1900.
  final DateTime? firstDate;

  /// Defaults to 31 December 2100.
  final DateTime? lastDate;
  final bool Function(DateTime day)? disabledDate;
  final WeDateWheelType type;
  final WeDateLocale locale;

  /// Height of one row.
  final double itemExtent;

  /// Rows on screen, the middle one being the value.
  final int visibleItems;

  @override
  State<WeDateWheel> createState() => _WeDateWheelState();
}

class _WeDateWheelState extends State<WeDateWheel> {
  late DateTime _value;

  /// Bumped to rebuild every column on the value, e.g. after an outside
  /// change; a column is also rebuilt when its range changes.
  int _generation = 0;
  final Map<_WheelPart, (String, FixedExtentScrollController)> _wheels = {};
  _WheelPart? _focused;

  bool get _monthOnly => widget.type == WeDateWheelType.month;

  DateTime get _first => _day(widget.firstDate ?? DateTime(1900));
  DateTime get _last => _day(widget.lastDate ?? DateTime(2100, 12, 31));

  List<_WheelPart> get _parts {
    final List<_WheelPart> parts = widget.locale.yearFirst
        ? [_WheelPart.year, _WheelPart.month, _WheelPart.day]
        : [_WheelPart.month, _WheelPart.day, _WheelPart.year];
    if (_monthOnly) parts.remove(_WheelPart.day);
    return parts;
  }

  @override
  void initState() {
    super.initState();
    _value = _normalize(widget.value);
  }

  @override
  void didUpdateWidget(WeDateWheel old) {
    super.didUpdateWidget(old);
    final DateTime next = _normalize(widget.value);
    final bool moved = !_sameDay(widget.value, old.value) && next != _value;
    if (moved ||
        widget.firstDate != old.firstDate ||
        widget.lastDate != old.lastDate ||
        widget.type != old.type) {
      _value = next;
      _generation++;
    }
  }

  @override
  void dispose() {
    for (final (_, c) in _wheels.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ---- ranges -------------------------------------------------------------

  (int, int) _monthRange(int year) => (
    year == _first.year ? _first.month : 1,
    year == _last.year ? _last.month : 12,
  );

  (int, int) _dayRange(int year, int month) {
    final int days = DateUtils.getDaysInMonth(year, month);
    final bool firstMonth = year == _first.year && month == _first.month;
    final bool lastMonth = year == _last.year && month == _last.month;
    return (firstMonth ? _first.day : 1, lastMonth ? _last.day : days);
  }

  (int, int) _range(_WheelPart part) => switch (part) {
    _WheelPart.year => (_first.year, _last.year),
    _WheelPart.month => _monthRange(_value.year),
    _WheelPart.day => _dayRange(_value.year, _value.month),
  };

  int _valueOf(_WheelPart part) => switch (part) {
    _WheelPart.year => _value.year,
    _WheelPart.month => _value.month,
    _WheelPart.day => _value.day,
  };

  bool _blocked(DateTime d) => widget.disabledDate?.call(d) ?? false;

  /// [part] set to [n], the other parts pulled back into range.
  DateTime _compose(_WheelPart part, int n) {
    int y = _value.year, m = _value.month, d = _value.day;
    switch (part) {
      case _WheelPart.year:
        y = n;
      case _WheelPart.month:
        m = n;
      case _WheelPart.day:
        d = n;
    }
    final (int mlo, int mhi) = _monthRange(y);
    m = m.clamp(mlo, mhi);
    if (_monthOnly) return DateTime(y, m);
    final (int dlo, int dhi) = _dayRange(y, m);
    return DateTime(y, m, d.clamp(dlo, dhi));
  }

  DateTime _normalize(DateTime d) {
    DateTime v = _day(d);
    if (v.isBefore(_first)) v = _first;
    if (v.isAfter(_last)) v = _last;
    if (_monthOnly) return DateTime(v.year, v.month);
    return _nearestOpen(v) ?? v;
  }

  /// The closest pickable day to [d] within its month, or `null` if the
  /// whole month is disabled.
  DateTime? _nearestOpen(DateTime d) {
    if (!_blocked(d)) return d;
    final (int lo, int hi) = _dayRange(d.year, d.month);
    for (int step = 1; step <= hi - lo; step++) {
      for (final int n in [d.day + step, d.day - step]) {
        if (n < lo || n > hi) continue;
        final DateTime c = DateTime(d.year, d.month, n);
        if (!_blocked(c)) return c;
      }
    }
    return null;
  }

  // ---- changes ------------------------------------------------------------

  void _onSelected(_WheelPart part, int n) {
    final DateTime v = _compose(part, n);
    if (v == _value) return;
    HapticFeedback.selectionClick();
    setState(() => _value = v);
    if (_monthOnly || !_blocked(v)) widget.onChanged(v);
  }

  /// Once the wheel stops, it does not stay on a disabled day.
  void _onSettled() {
    if (_monthOnly || !_blocked(_value)) return;
    final DateTime? open = _nearestOpen(_value);
    if (open == null) return;
    setState(() {
      _value = open;
      _generation++;
    });
    widget.onChanged(open);
  }

  void _step(_WheelPart part, int delta) {
    final FixedExtentScrollController? c = _wheels[part]?.$2;
    if (c == null || !c.hasClients) return;
    final (int lo, int hi) = _range(part);
    final int target = (c.selectedItem + delta).clamp(0, hi - lo);
    c.animateToItem(
      target,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
    );
  }

  // ---- build --------------------------------------------------------------

  String _label(_WheelPart part, int n) => switch (part) {
    _WheelPart.year => widget.locale.yearLabel(n),
    _WheelPart.month => widget.locale.monthsShort[n - 1],
    _WheelPart.day => '$n${widget.locale.daySuffix}',
  };

  /// A column gets a fresh controller whenever its range or the generation
  /// changes, so it opens on the right row without jumping a live wheel.
  FixedExtentScrollController _controllerFor(
    _WheelPart part,
    String key,
    int initial,
  ) {
    final (String, FixedExtentScrollController)? current = _wheels[part];
    if (current != null && current.$1 == key) return current.$2;
    if (current != null) {
      final FixedExtentScrollController old = current.$2;
      WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    }
    final FixedExtentScrollController c = FixedExtentScrollController(
      initialItem: initial,
    );
    _wheels[part] = (key, c);
    return c;
  }

  Widget _column(_WheelPart part, WeColorScheme colors) {
    final (int lo, int hi) = _range(part);
    final int value = _valueOf(part);
    final String key = '${part.name}-$lo-$hi-$_generation';
    final FixedExtentScrollController controller = _controllerFor(
      part,
      key,
      value - lo,
    );
    final bool focused = _focused == part;

    Widget wheel = ListWheelScrollView.useDelegate(
      key: ValueKey(key),
      controller: controller,
      itemExtent: widget.itemExtent,
      diameterRatio: 1.8,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (i) => _onSelected(part, lo + i),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: hi - lo + 1,
        builder: (context, i) {
          final int n = lo + i;
          final bool selected = n == value;
          final bool disabled =
              part == _WheelPart.day &&
              _blocked(DateTime(_value.year, _value.month, n));
          return Center(
            child: Text(
              _label(part, n),
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: disabled
                    ? colors.disabledText
                    : selected
                    ? (focused ? colors.primary : colors.primaryText)
                    : colors.regularText,
              ),
            ),
          );
        },
      ),
    );

    wheel = NotificationListener<ScrollEndNotification>(
      onNotification: (_) {
        _onSettled();
        return false;
      },
      child: wheel,
    );

    return Expanded(
      child: Focus(
        onFocusChange: (f) => setState(() => _focused = f ? part : null),
        onKeyEvent: (node, event) {
          if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
            return KeyEventResult.ignored;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _step(part, -1);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _step(part, 1);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Semantics(
          container: true,
          value: _label(part, value),
          increasedValue: value < hi ? _label(part, value + 1) : null,
          decreasedValue: value > lo ? _label(part, value - 1) : null,
          onIncrease: value < hi ? () => _step(part, 1) : null,
          onDecrease: value > lo ? () => _step(part, -1) : null,
          child: ExcludeSemantics(child: wheel),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final double extent = widget.itemExtent;
    return SizedBox(
      height: extent * widget.visibleItems,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: extent * (widget.visibleItems - 1) / 2,
            height: extent,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.lightFill,
                borderRadius: BorderRadius.circular(we.radius.base * 2),
              ),
            ),
          ),
          Row(children: [for (final p in _parts) _column(p, colors)]),
        ],
      ),
    );
  }
}
