part of 'we_date.dart';

/// Picks a day, or a range of days, from a sheet that slides up from the
/// bottom, with a [WeDateWheel] inside.
///
/// ```dart
/// final DateTime? day = await WeDateSheet.show(context, initial: day);
/// final DateTimeRange? stay = await WeDateSheet.showRange(context);
/// ```
///
/// Both return `null` when the user cancels or swipes the sheet away. On
/// touch, [WeDatePicker] opens this sheet instead of its panel. The sheet is
/// at most 640 wide, so it does not stretch across a tablet or desktop.
///
/// Platform: mobile.
abstract final class WeDateSheet {
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initial,
    DateTime? firstDate,
    DateTime? lastDate,
    bool Function(DateTime day)? disabledDate,
    WeDateWheelType type = WeDateWheelType.date,
    String? title,
    WeDateLocale locale = WeDateLocale.zh,
    List<WeDateShortcut<DateTime>> shortcuts = const [],
  }) {
    return _open<DateTime>(
      context,
      _DateSheet(
        range: false,
        start: initial ?? DateTime.now(),
        end: initial ?? DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate,
        disabledDate: disabledDate,
        type: type,
        title: title ?? locale.placeholder,
        locale: locale,
        format: 'yyyy-MM-dd',
        shortcuts: [
          for (final s in shortcuts) (s.label, () => _day(s.value())),
        ],
      ),
    );
  }

  /// Picks a start and an end day. If the end is set before the start, the
  /// two are swapped on confirm.
  static Future<DateTimeRange?> showRange(
    BuildContext context, {
    DateTimeRange? initial,
    DateTime? firstDate,
    DateTime? lastDate,
    bool Function(DateTime day)? disabledDate,
    String? title,
    String format = 'yyyy-MM-dd',
    WeDateLocale locale = WeDateLocale.zh,
    List<WeDateShortcut<DateTimeRange>> shortcuts = const [],
  }) {
    final DateTime today = _day(DateTime.now());
    return _open<DateTimeRange>(
      context,
      _DateSheet(
        range: true,
        start: initial?.start ?? today,
        end: initial?.end ?? today,
        firstDate: firstDate,
        lastDate: lastDate,
        disabledDate: disabledDate,
        type: WeDateWheelType.date,
        title: title ?? locale.placeholder,
        locale: locale,
        format: format,
        shortcuts: [
          for (final s in shortcuts)
            (
              s.label,
              () {
                final DateTimeRange r = s.value();
                return DateTimeRange(start: _day(r.start), end: _day(r.end));
              },
            ),
        ],
      ),
    );
  }

  static Future<T?> _open<T>(BuildContext context, Widget sheet) {
    final WeTheme we = WeTheme.of(context);
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 640),
      backgroundColor: we.colors.overlayBackground,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(we.radius.base * 3),
        ),
      ),
      builder: (_) => sheet,
    );
  }
}

class _DateSheet extends StatefulWidget {
  const _DateSheet({
    required this.range,
    required this.start,
    required this.end,
    required this.firstDate,
    required this.lastDate,
    required this.disabledDate,
    required this.type,
    required this.title,
    required this.locale,
    required this.format,
    required this.shortcuts,
  });

  final bool range;
  final DateTime start;
  final DateTime end;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime day)? disabledDate;
  final WeDateWheelType type;
  final String title;
  final WeDateLocale locale;
  final String format;

  /// Label and the value it pops with: a [DateTime] or a [DateTimeRange].
  final List<(String, Object Function())> shortcuts;

  @override
  State<_DateSheet> createState() => _DateSheetState();
}

class _DateSheetState extends State<_DateSheet> {
  late DateTime _start = _day(widget.start);
  late DateTime _end = _day(widget.end);

  /// 0 while the start is on the wheel, 1 for the end.
  int _editing = 0;

  void _confirm() {
    if (!widget.range) {
      Navigator.pop(context, _start);
      return;
    }
    Navigator.pop(
      context,
      _end.isBefore(_start)
          ? DateTimeRange(start: _end, end: _start)
          : DateTimeRange(start: _start, end: _end),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final WeDateLocale l = widget.locale;
    final double bottom = MediaQuery.paddingOf(context).bottom;

    // Landscape phones are shorter than the sheet, so it scrolls there.
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Row(
              children: [
                WeButton(
                  text: l.cancel,
                  variant: WeButtonVariant.text,
                  type: SemanticEnum.info,
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                ),
                WeButton(
                  text: l.confirm,
                  variant: WeButtonVariant.text,
                  type: SemanticEnum.primary,
                  onPressed: _confirm,
                ),
              ],
            ),
          ),
          if (widget.range)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: WeSegmented<int>(
                block: true,
                value: _editing,
                onChanged: (i) => setState(() => _editing = i),
                options: [
                  WeSegmentedOption(
                    0,
                    '${l.start} ${weFormatDate(_start, widget.format)}',
                  ),
                  WeSegmentedOption(
                    1,
                    '${l.end} ${weFormatDate(_end, widget.format)}',
                  ),
                ],
              ),
            ),
          if (widget.shortcuts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (label, value) in widget.shortcuts)
                    WeButton(
                      text: label,
                      size: SizeEnum.small,
                      variant: WeButtonVariant.plain,
                      round: true,
                      onPressed: () => Navigator.pop(context, value()),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: WeDateWheel(
              key: ValueKey(_editing),
              value: _editing == 0 ? _start : _end,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              disabledDate: widget.disabledDate,
              type: widget.type,
              locale: l,
              onChanged: (d) =>
                  setState(() => _editing == 0 ? _start = d : _end = d),
            ),
          ),
          SizedBox(height: 12 + bottom),
        ],
      ),
    );
  }
}
