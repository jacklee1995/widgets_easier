import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

/// Finds the day cell showing [day], avoiding spill-over days of other
/// months that print the same number.
Finder _day(int day) => find.text('$day').first;

class _Picker extends StatefulWidget {
  const _Picker({this.initial});

  final DateTime? initial;

  @override
  State<_Picker> createState() => _PickerState();
}

class _PickerState extends State<_Picker> {
  late DateTime? value = widget.initial;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      WeDatePicker(value: value, onChanged: (d) => setState(() => value = d)),
      Text('value: ${value == null ? '-' : weFormatDate(value!)}'),
    ],
  );
}

void main() {
  group('format and parse', () {
    test('formats with the pattern tokens', () {
      final d = DateTime(2026, 9, 5);
      expect(weFormatDate(d), '2026-09-05');
      expect(weFormatDate(d, 'yyyy年M月d日'), '2026年9月5日');
      expect(weFormatDate(d, 'dd/MM/yyyy'), '05/09/2026');
    });

    test('reads any separator and bare digits', () {
      final expected = DateTime(2026, 9, 5);
      for (final text in [
        '2026-09-05',
        '2026-9-5',
        '2026/9/5',
        '2026.09.05',
        ' 2026 9 5 ',
        '20260905',
      ]) {
        expect(weParseDate(text), expected, reason: text);
      }
      expect(weParseDate('05/09/2026', 'dd/MM/yyyy'), expected);
    });

    test('rejects what is not a date', () {
      for (final text in [
        '',
        '2026-13-01',
        '2026-02-30',
        '2026-9',
        'abc',
        '26-9-5',
      ]) {
        expect(weParseDate(text), isNull, reason: text);
      }
      expect(weParseDate('2024-02-29'), DateTime(2024, 2, 29));
    });
  });

  group('WeDatePanel', () {
    testWidgets('clicking a day picks it', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        _app(
          WeDatePanel(
            value: null,
            initialMonth: DateTime(2026, 9),
            onChanged: (d) => picked = d,
          ),
        ),
      );
      expect(find.text('2026年'), findsOneWidget);
      expect(find.text('9月'), findsOneWidget);
      await tester.tap(_day(15));
      expect(picked, DateTime(2026, 9, 15));
    });

    testWidgets('weeks start on Monday in zh and Sunday in en', (tester) async {
      await tester.pumpWidget(
        _app(
          WeDatePanel(
            value: null,
            initialMonth: DateTime(2026, 9),
            onChanged: (_) {},
          ),
        ),
      );
      final double mon = tester.getTopLeft(find.text('一')).dx;
      final double sun = tester.getTopLeft(find.text('日')).dx;
      expect(mon, lessThan(sun));

      await tester.pumpWidget(
        _app(
          WeDatePanel(
            value: null,
            initialMonth: DateTime(2026, 9),
            locale: WeDateLocale.en,
            onChanged: (_) {},
          ),
        ),
      );
      expect(
        tester.getTopLeft(find.text('Sun')).dx,
        lessThan(tester.getTopLeft(find.text('Mon')).dx),
      );
      expect(find.text('September'), findsOneWidget);
    });

    testWidgets('disabled days and bounds cannot be picked', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        _app(
          WeDatePanel(
            value: null,
            initialMonth: DateTime(2026, 9),
            lastDate: DateTime(2026, 9, 20),
            disabledDate: (d) => d.weekday == DateTime.saturday,
            onChanged: (d) => picked = d,
          ),
        ),
      );
      await tester.tap(_day(19)); // a Saturday
      await tester.tap(find.text('25').first); // after lastDate
      expect(picked, isNull);
      await tester.tap(_day(18));
      expect(picked, DateTime(2026, 9, 18));
    });

    testWidgets('keyboard moves the cursor, pages and picks', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      DateTime? picked;
      await tester.pumpWidget(
        _app(
          WeDatePanel(
            value: DateTime(2026, 9, 30),
            focusNode: focus,
            onChanged: (d) => picked = d,
          ),
        ),
      );
      focus.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(
        find.text('10月'),
        findsOneWidget,
        reason: 'crossing into October pages the grid',
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(picked, DateTime(2026, 10, 1));

      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(picked, DateTime(2026, 11, 8));

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(picked, DateTime(2025, 11, 8));
      await tester.pumpAndSettle();
    });

    testWidgets('the title zooms out to months and years', (tester) async {
      DateTime? month;
      await tester.pumpWidget(
        _app(
          WeDatePanel(
            value: null,
            initialMonth: DateTime(2026, 9),
            onChanged: (_) {},
            onMonthChanged: (m) => month = m,
          ),
        ),
      );
      await tester.tap(find.text('2026年'));
      await tester.pumpAndSettle();
      expect(find.text('2020年 – 2029年'), findsOneWidget);
      await tester.tap(find.text('2027'));
      await tester.pumpAndSettle();
      expect(find.text('2027年'), findsOneWidget);
      await tester.tap(find.text('3月'));
      await tester.pumpAndSettle();
      expect(month, DateTime(2027, 3));
      expect(find.text('3月'), findsOneWidget);
      expect(find.text('31'), findsWidgets);
    });

    testWidgets('a range takes two clicks in either order', (tester) async {
      DateTimeRange? range;
      DateTime? started;
      await tester.pumpWidget(
        _app(
          WeDatePanel.range(
            range: null,
            initialMonth: DateTime(2026, 9),
            onRangeStart: (d) => started = d,
            onRangeChanged: (r) => range = r,
          ),
        ),
      );
      expect(find.text('2026年 9月'), findsOneWidget);
      expect(find.text('2026年 10月'), findsOneWidget);

      await tester.tap(_day(20));
      expect(started, DateTime(2026, 9, 20));
      expect(range, isNull);
      await tester.tap(_day(3));
      expect(
        range,
        DateTimeRange(start: DateTime(2026, 9, 3), end: DateTime(2026, 9, 20)),
      );
    });
  });

  group('WeCalendar', () {
    testWidgets('lays out events and reports taps', (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      DateTime? picked;
      WeCalendarEvent? tapped;
      await tester.pumpWidget(
        _app(
          SizedBox(
            width: 900,
            child: WeCalendar(
              initialMonth: DateTime(2026, 9),
              onChanged: (d) => picked = d,
              events: (d) => d == DateTime(2026, 9, 10)
                  ? const [
                      WeCalendarEvent('周会', time: '09:30'),
                      WeCalendarEvent('上线', type: SemanticEnum.success),
                      WeCalendarEvent('复盘'),
                      WeCalendarEvent('团建'),
                      WeCalendarEvent('面试'),
                    ]
                  : const [],
              onEventTap: (e, _) => tapped = e,
            ),
          ),
        ),
      );

      expect(find.text('周会', findRichText: true), findsNothing);
      expect(find.textContaining('周会', findRichText: true), findsOneWidget);
      expect(
        find.textContaining('还有'),
        findsOneWidget,
        reason: 'five events do not fit',
      );

      await tester.tap(find.textContaining('上线', findRichText: true));
      expect(tapped?.title, '上线');

      await tester.tap(find.text('17'));
      expect(picked, DateTime(2026, 9, 17));
    });

    testWidgets('pages with the header buttons', (tester) async {
      DateTime? month;
      await tester.pumpWidget(
        _app(
          SizedBox(
            width: 700,
            child: WeCalendar(
              initialMonth: DateTime(2026, 1),
              onMonthChanged: (m) => month = m,
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(month, DateTime(2025, 12));
      expect(find.text('2025年'), findsOneWidget);
    });
  });

  group('WeDatePicker', () {
    testWidgets('typing a date and pressing Enter commits it', (tester) async {
      await tester.pumpWidget(_app(const _Picker()));
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.byType(WeDatePanel), findsOneWidget);

      await tester.enterText(find.byType(TextField), '20260905');
      await tester.pumpAndSettle();
      expect(
        find.text('2026年'),
        findsOneWidget,
        reason: 'the panel follows the typing',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('value: 2026-09-05'), findsOneWidget);
      expect(
        find.text('2026-09-05'),
        findsOneWidget,
        reason: 'the field is reformatted',
      );
      expect(find.byType(WeDatePanel), findsNothing);
    }, variant: _desktop);

    testWidgets('an unreadable entry reverts', (tester) async {
      await tester.pumpWidget(_app(_Picker(initial: DateTime(2026, 9, 5))));
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '2026-02-31');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('2026-09-05'), findsOneWidget);
      expect(find.text('value: 2026-09-05'), findsOneWidget);
    }, variant: _desktop);

    testWidgets('clicking a day in the panel picks it and closes', (
      tester,
    ) async {
      await tester.pumpWidget(_app(_Picker(initial: DateTime(2026, 9, 5))));
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('23'));
      await tester.pumpAndSettle();
      expect(find.text('value: 2026-09-23'), findsOneWidget);
      expect(find.byType(WeDatePanel), findsNothing);
    }, variant: _desktop);

    testWidgets('arrow down moves into the panel', (tester) async {
      await tester.pumpWidget(_app(_Picker(initial: DateTime(2026, 9, 5))));
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('value: 2026-09-06'), findsOneWidget);
    }, variant: _desktop);

    testWidgets('a range shortcut applies in one click', (tester) async {
      DateTimeRange? range;
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (context, setState) => WeDatePicker.range(
              range: range,
              onChanged: (r) => setState(() => range = r),
              shortcuts: [
                WeDateShortcut(
                  '九月上旬',
                  () => DateTimeRange(
                    start: DateTime(2026, 9, 1),
                    end: DateTime(2026, 9, 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('九月上旬'));
      await tester.pumpAndSettle();
      expect(
        range,
        DateTimeRange(start: DateTime(2026, 9, 1), end: DateTime(2026, 9, 10)),
      );
      expect(find.text('2026-09-01'), findsOneWidget);
      expect(find.text('2026-09-10'), findsOneWidget);
    }, variant: _desktop);
  });

  group('WeDatePicker on touch', () {
    testWidgets('opens the wheel sheet and a read-only field', (tester) async {
      await tester.pumpWidget(_app(_Picker(initial: DateTime(2026, 9, 5))));
      expect(tester.widget<TextField>(find.byType(TextField)).readOnly, isTrue);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.byType(WeDateWheel), findsOneWidget);
      expect(find.byType(WeDatePanel), findsNothing);

      Focus.of(tester.element(find.text('5日'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(find.text('value: 2026-09-06'), findsOneWidget);
      expect(find.byType(WeDateWheel), findsNothing);
    });

    testWidgets('取消 leaves the value alone', (tester) async {
      await tester.pumpWidget(_app(_Picker(initial: DateTime(2026, 9, 5))));
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(find.text('value: 2026-09-05'), findsOneWidget);
    });

    testWidgets('a range opens the sheet with a start / end switch', (
      tester,
    ) async {
      DateTimeRange? range;
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (context, setState) => WeDatePicker.range(
              range: DateTimeRange(
                start: DateTime(2026, 9, 1),
                end: DateTime(2026, 9, 10),
              ),
              onChanged: (r) => setState(() => range = r),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();
      expect(find.text('开始 2026-09-01'), findsOneWidget);
      await tester.tap(find.text('结束 2026-09-10'));
      await tester.pumpAndSettle();
      Focus.of(tester.element(find.text('10日'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(
        range,
        DateTimeRange(start: DateTime(2026, 9, 1), end: DateTime(2026, 9, 11)),
      );
    });

    testWidgets('touchMode: panel keeps the calendar panel', (tester) async {
      await tester.pumpWidget(
        _app(
          WeDatePicker(
            value: DateTime(2026, 9, 5),
            touchMode: WeDatePickerTouchMode.panel,
            onChanged: (_) {},
          ),
        ),
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).readOnly,
        isFalse,
      );
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.byType(WeDatePanel), findsOneWidget);
      expect(find.byType(WeDateWheel), findsNothing);
    });

    testWidgets('the picker gives no desktop hint, the bare panel does', (
      tester,
    ) async {
      WePlatform.debugResetHints();
      final List<String> printed = [];
      final saved = debugPrint;
      debugPrint = (m, {wrapWidth}) => printed.add(m ?? '');
      await tester.pumpWidget(
        _app(WeDatePicker(value: DateTime(2026, 9, 5), onChanged: (_) {})),
      );
      final bool pickerQuiet = printed.isEmpty;
      await tester.pumpWidget(
        _app(WeDatePanel(value: DateTime(2026, 9, 5), onChanged: (_) {})),
      );
      debugPrint = saved;
      WePlatform.debugResetHints();
      expect(pickerQuiet, isTrue);
      expect(printed.single, contains('WeDateSheet'));
    });
  });
}

final TargetPlatformVariant _desktop = TargetPlatformVariant.only(
  TargetPlatform.windows,
);
