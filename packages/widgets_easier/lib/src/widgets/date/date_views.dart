part of 'we_date.dart';

/// A square icon button for calendar headers. Not a focus stop: the grid
/// already pages with <kbd>PageUp</kbd> / <kbd>PageDown</kbd>.
class _NavButton extends StatefulWidget {
  const _NavButton({required this.icon, required this.onTap});

  static const double _size = 28;

  final IconData icon;
  final VoidCallback? onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final bool enabled = widget.onTap != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          width: _NavButton._size,
          height: _NavButton._size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _hover && enabled ? colors.lightFill : null,
            borderRadius: BorderRadius.circular(we.radius.small),
          ),
          child: Icon(
            widget.icon,
            size: 16,
            color: !enabled
                ? colors.disabledText
                : _hover
                ? colors.primary
                : colors.secondaryText,
          ),
        ),
      ),
    );
  }
}

/// A header title, or one part of it, that zooms out when clicked.
class _TitleButton extends StatefulWidget {
  const _TitleButton({required this.text, this.onTap, this.fontSize = 14});

  final String text;
  final VoidCallback? onTap;
  final double fontSize;

  @override
  State<_TitleButton> createState() => _TitleButtonState();
}

class _TitleButtonState extends State<_TitleButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final bool enabled = widget.onTap != null;
    final Widget text = Text(
      widget.text,
      maxLines: 1,
      style: TextStyle(
        fontSize: widget.fontSize,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: enabled && _hover ? colors.primary : colors.primaryText,
      ),
    );
    if (!enabled) return text;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: text,
        ),
      ),
    );
  }
}

/// Swaps periods with a short slide and views with a short zoom.
class _Flip extends StatelessWidget {
  const _Flip({
    required this.id,
    required this.direction,
    required this.zoom,
    required this.child,
  });

  /// Identifies what [child] shows; a new id animates the swap.
  final Object id;
  final int direction;
  final bool zoom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Key key = ValueKey(id);
    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (current, previous) =>
            Stack(fit: StackFit.passthrough, children: [...previous, ?current]),
        transitionBuilder: (child, animation) {
          final bool incoming = child.key == key;
          final double sign = incoming ? 1 : -1;
          final Widget faded = FadeTransition(opacity: animation, child: child);
          if (zoom) {
            final double from = 1 + 0.06 * direction * sign;
            return ScaleTransition(
              scale: Tween<double>(begin: from, end: 1).animate(animation),
              child: faded,
            );
          }
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.08 * direction * sign, 0),
              end: Offset.zero,
            ).animate(animation),
            child: faded,
          );
        },
        child: KeyedSubtree(key: key, child: child),
      ),
    );
  }
}

/// The weekday names above a day grid.
class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow({
    required this.locale,
    required this.firstDayOfWeek,
    required this.height,
    required this.fontSize,
    this.weekColumn,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.decoration,
  });

  final WeDateLocale locale;
  final int firstDayOfWeek;
  final double height;
  final double fontSize;

  /// Width of the week-number column, `null` for none.
  final double? weekColumn;
  final Alignment alignment;
  final EdgeInsets padding;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final TextStyle style = TextStyle(
      fontSize: fontSize,
      height: 1.2,
      color: colors.secondaryText,
    );
    return Container(
      height: height,
      decoration: decoration,
      child: Row(
        children: [
          if (weekColumn != null)
            SizedBox(
              width: weekColumn,
              child: Center(
                child: Text(
                  locale.week,
                  style: style.copyWith(color: colors.placeholderText),
                ),
              ),
            ),
          for (int i = 0; i < 7; i++)
            Expanded(
              child: Container(
                alignment: alignment,
                padding: padding,
                child: Text(
                  locale.weekdayOf((firstDayOfWeek - 1 + i) % 7 + 1),
                  style: style,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One month of a month view or one year of a year view.
@immutable
class _PeriodCell {
  const _PeriodCell({
    required this.label,
    required this.value,
    this.current = false,
    this.selected = false,
    this.cursor = false,
    this.disabled = false,
    this.outside = false,
  });

  final String label;
  final DateTime value;

  /// The month or year we are in right now.
  final bool current;
  final bool selected;
  final bool cursor;
  final bool disabled;

  /// A year from the neighbouring decade, shown to fill the grid.
  final bool outside;
}

/// Twelve periods in four columns and three rows.
class _PeriodGrid extends StatelessWidget {
  const _PeriodGrid({
    required this.cells,
    required this.onTap,
    required this.large,
  });

  final List<_PeriodCell> cells;
  final ValueChanged<DateTime> onTap;

  /// Board-sized cells for [WeCalendar] instead of panel-sized ones.
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int r = 0; r < 3; r++)
          Expanded(
            child: Row(
              children: [
                for (int c = 0; c < 4; c++)
                  Expanded(
                    child: _PeriodTile(
                      cell: cells[r * 4 + c],
                      large: large,
                      onTap: onTap,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PeriodTile extends StatefulWidget {
  const _PeriodTile({
    required this.cell,
    required this.large,
    required this.onTap,
  });

  final _PeriodCell cell;
  final bool large;
  final ValueChanged<DateTime> onTap;

  @override
  State<_PeriodTile> createState() => _PeriodTileState();
}

class _PeriodTileState extends State<_PeriodTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final _PeriodCell cell = widget.cell;
    final bool enabled = !cell.disabled;

    final Color fg = cell.selected
        ? colors.onSemantic
        : cell.disabled
        ? colors.disabledText
        : cell.outside
        ? colors.placeholderText
        : cell.current
        ? colors.primary
        : colors.regularText;
    final Color? bg = cell.selected
        ? colors.primary
        : cell.disabled
        ? colors.lightFill
        : _hover
        ? colors.lightFill
        : null;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => widget.onTap(cell.value) : null,
        child: Center(
          child: Container(
            width: widget.large ? 96 : 56,
            height: widget.large ? 40 : 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(we.radius.small),
              border: cell.cursor
                  ? Border.all(color: colors.primary, width: 1.5)
                  : null,
            ),
            child: Text(
              cell.label,
              style: TextStyle(
                fontSize: widget.large ? 14 : 13,
                height: 1.2,
                fontWeight: cell.selected || cell.current
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Month and year grids and header titles, on top of [_DateNavigation].
mixin _PeriodViews<W extends StatefulWidget> on _DateNavigation<W> {
  WeDateLocale get _locale;

  bool _isSelectedMonth(int year, int month) => false;
  bool _isSelectedYear(int year) => false;

  Widget _periodGrid({required bool large}) {
    final DateTime now = DateTime.now();
    final List<_PeriodCell> cells;
    if (_view == WeCalendarView.month) {
      final int y = _month.year;
      cells = [
        for (int m = 1; m <= 12; m++)
          _PeriodCell(
            label: _locale.months[m - 1],
            value: DateTime(y, m),
            current: now.year == y && now.month == m,
            selected: _isSelectedMonth(y, m),
            cursor: _showCursor && _cursor.year == y && _cursor.month == m,
            disabled: _monthBlocked(y, m),
          ),
      ];
    } else {
      final int start = _decadeStart;
      cells = [
        for (int i = 0; i < 12; i++)
          _PeriodCell(
            label: '${start - 1 + i}',
            value: DateTime(start - 1 + i, _month.month),
            outside: i == 0 || i == 11,
            current: now.year == start - 1 + i,
            selected: _isSelectedYear(start - 1 + i),
            cursor: _showCursor && _cursor.year == start - 1 + i,
            disabled: _yearBlocked(start - 1 + i),
          ),
      ];
    }
    return _PeriodGrid(
      cells: cells,
      large: large,
      onTap: (v) {
        _onPointer();
        _view == WeCalendarView.month ? _openMonth(v) : _openYear(v.year);
      },
    );
  }

  /// "2026年 9月" as two clickable parts, or the year, or the decade.
  List<Widget> _titleParts({double fontSize = 14}) {
    switch (_view) {
      case WeCalendarView.day:
        final Widget year = _TitleButton(
          text: _locale.yearLabel(_month.year),
          fontSize: fontSize,
          onTap: _canZoom ? () => _setView(WeCalendarView.year) : null,
        );
        final Widget month = _TitleButton(
          text: _locale.yearFirst
              ? _locale.monthLabel(_month.month)
              : _locale.months[_month.month - 1],
          fontSize: fontSize,
          onTap: _canZoom ? () => _setView(WeCalendarView.month) : null,
        );
        return _locale.yearFirst
            ? [year, const SizedBox(width: 6), month]
            : [month, const SizedBox(width: 6), year];
      case WeCalendarView.month:
        return [
          _TitleButton(
            text: _locale.yearLabel(_month.year),
            fontSize: fontSize,
            onTap: () => _setView(WeCalendarView.year),
          ),
        ];
      case WeCalendarView.year:
        return [
          _TitleButton(
            text:
                '${_locale.yearLabel(_decadeStart)} – '
                '${_locale.yearLabel(_decadeStart + 9)}',
            fontSize: fontSize,
          ),
        ];
    }
  }
}
