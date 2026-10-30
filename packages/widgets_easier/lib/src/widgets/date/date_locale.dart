part of 'we_date.dart';

/// The words and conventions a calendar speaks.
///
/// Two locales ship with the library, [zh] (the default, weeks start on
/// Monday) and [en] (weeks start on Sunday). Build your own for anything
/// else:
///
/// ```dart
/// const de = WeDateLocale(
///   weekdays: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
///   months: ['Januar', 'Februar', /* … */ 'Dezember'],
///   monthsShort: ['Jan', 'Feb', /* … */ 'Dez'],
///   firstDayOfWeek: DateTime.monday,
///   today: 'Heute',
/// );
/// ```
@immutable
class WeDateLocale {
  const WeDateLocale({
    required this.weekdays,
    required this.months,
    required this.monthsShort,
    this.yearSuffix = '',
    this.yearFirst = false,
    this.firstDayOfWeek = DateTime.sunday,
    this.today = 'Today',
    this.placeholder = 'Select date',
    this.startPlaceholder = 'Start date',
    this.endPlaceholder = 'End date',
    this.rangeSeparator = 'To',
    this.week = 'Wk',
    this.more = _enMore,
    this.confirm = 'OK',
    this.cancel = 'Cancel',
    this.daySuffix = '',
    this.start = 'Start',
    this.end = 'End',
  });

  /// Seven short weekday names, Monday first, the way [DateTime.weekday]
  /// counts.
  final List<String> weekdays;

  /// Twelve month names, used in the month view and in titles.
  final List<String> months;
  final List<String> monthsShort;

  /// Appended to a year number, `年` in Chinese.
  final String yearSuffix;

  /// Whether a title reads "2026年 9月" rather than "September 2026".
  final bool yearFirst;

  /// [DateTime.monday] … [DateTime.sunday].
  final int firstDayOfWeek;

  final String today;
  final String placeholder;
  final String startPlaceholder;
  final String endPlaceholder;
  final String rangeSeparator;

  /// Heading of the week-number column.
  final String week;

  /// The "+3 more" line under a crowded calendar cell.
  final String Function(int hidden) more;

  /// Buttons of [WeDateSheet].
  final String confirm;
  final String cancel;

  /// Appended to a day number in [WeDateWheel], `日` in Chinese.
  final String daySuffix;

  /// The two ends of a range in [WeDateSheet.showRange].
  final String start;
  final String end;

  static String _enMore(int n) => '+$n more';
  static String _zhMore(int n) => '还有 $n 项';

  static const WeDateLocale zh = WeDateLocale(
    weekdays: ['一', '二', '三', '四', '五', '六', '日'],
    months: [
      '1月', '2月', '3月', '4月', '5月', '6月', //
      '7月', '8月', '9月', '10月', '11月', '12月',
    ],
    monthsShort: [
      '1月', '2月', '3月', '4月', '5月', '6月', //
      '7月', '8月', '9月', '10月', '11月', '12月',
    ],
    yearSuffix: '年',
    yearFirst: true,
    firstDayOfWeek: DateTime.monday,
    today: '今天',
    placeholder: '选择日期',
    startPlaceholder: '开始日期',
    endPlaceholder: '结束日期',
    rangeSeparator: '至',
    week: '周',
    more: _zhMore,
    confirm: '确定',
    cancel: '取消',
    daySuffix: '日',
    start: '开始',
    end: '结束',
  );

  static const WeDateLocale en = WeDateLocale(
    weekdays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    months: [
      'January', 'February', 'March', 'April', 'May', 'June', //
      'July', 'August', 'September', 'October', 'November', 'December',
    ],
    monthsShort: [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ],
  );

  String weekdayOf(int weekday) => weekdays[weekday - 1];

  String yearLabel(int year) => '$year$yearSuffix';

  String monthLabel(int month) => monthsShort[month - 1];

  /// "2026年 9月" / "September 2026".
  String title(DateTime month) => yearFirst
      ? '${yearLabel(month.year)} ${monthLabel(month.month)}'
      : '${months[month.month - 1]} ${month.year}';
}
