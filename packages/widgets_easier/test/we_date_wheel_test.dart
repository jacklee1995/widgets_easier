import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(
    body: Center(child: SizedBox(width: 360, child: child)),
  ),
);

/// Hosts a wheel and keeps the last value it reported.
class _Host extends StatefulWidget {
  const _Host({
    required this.initial,
    this.firstDate,
    this.lastDate,
    this.disabledDate,
    this.locale = WeDateLocale.zh,
    this.type = WeDateWheelType.date,
  });

  final DateTime initial;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime)? disabledDate;
  final WeDateLocale locale;
  final WeDateWheelType type;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late DateTime value = widget.initial;
  final List<DateTime> reported = [];

  @override
  Widget build(BuildContext context) => WeDateWheel(
    value: value,
    firstDate: widget.firstDate,
    lastDate: widget.lastDate,
    disabledDate: widget.disabledDate,
    locale: widget.locale,
    type: widget.type,
    onChanged: (d) => setState(() {
      value = d;
      reported.add(d);
    }),
  );
}

_HostState _host(WidgetTester tester) => tester.state(find.byType(_Host));

Future<void> _key(
  WidgetTester tester,
  String onText,
  LogicalKeyboardKey key,
) async {
  Focus.of(tester.element(find.text(onText))).requestFocus();
  await tester.pump();
  await tester.sendKeyEvent(key);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the value sits on the middle row', (tester) async {
    await tester.pumpWidget(_app(_Host(initial: DateTime(2026, 9, 18))));
    final double band = tester.getCenter(find.byType(WeDateWheel)).dy;
    for (final t in ['2026年', '9月', '18日']) {
      expect(tester.getCenter(find.text(t)).dy, closeTo(band, 1), reason: t);
    }
  });

  testWidgets('dragging the day column up by one row picks the next day', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_Host(initial: DateTime(2026, 9, 18))));
    await tester.timedDrag(
      find.byType(ListWheelScrollView).at(2),
      const Offset(0, -44),
      const Duration(milliseconds: 800),
    );
    await tester.pumpAndSettle();
    expect(_host(tester).value, DateTime(2026, 9, 19));
  });

  testWidgets('31 January plus a month is the end of February', (tester) async {
    await tester.pumpWidget(_app(_Host(initial: DateTime(2026, 1, 31))));
    await _key(tester, '1月', LogicalKeyboardKey.arrowDown);
    expect(_host(tester).value, DateTime(2026, 2, 28));
    expect(find.text('28日'), findsOneWidget);
  });

  testWidgets('a leap year keeps 29 February', (tester) async {
    await tester.pumpWidget(_app(_Host(initial: DateTime(2024, 1, 31))));
    await _key(tester, '1月', LogicalKeyboardKey.arrowDown);
    expect(_host(tester).value, DateTime(2024, 2, 29));
  });

  testWidgets('nothing outside firstDate and lastDate is offered', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        _Host(
          initial: DateTime(2026, 9, 10),
          firstDate: DateTime(2026, 9, 10),
          lastDate: DateTime(2026, 10, 5),
        ),
      ),
    );
    expect(find.text('2025年'), findsNothing);
    expect(find.text('2027年'), findsNothing);
    expect(find.text('8月'), findsNothing);
    expect(find.text('9日'), findsNothing);
    expect(find.text('10日'), findsOneWidget);

    await _key(tester, '9月', LogicalKeyboardKey.arrowDown);
    expect(_host(tester).value, DateTime(2026, 10, 5));
    expect(find.text('6日'), findsNothing);
  });

  testWidgets('it does not stop on a disabled day', (tester) async {
    bool weekend(DateTime d) => d.weekday >= DateTime.saturday;
    // Friday 2 October 2026.
    await tester.pumpWidget(
      _app(_Host(initial: DateTime(2026, 10, 2), disabledDate: weekend)),
    );
    await _key(tester, '2日', LogicalKeyboardKey.arrowDown);
    final host = _host(tester);
    expect(weekend(host.value), isFalse);
    expect(host.reported.where(weekend), isEmpty);
  });

  testWidgets('English reads month, day, year', (tester) async {
    await tester.pumpWidget(
      _app(_Host(initial: DateTime(2026, 9, 18), locale: WeDateLocale.en)),
    );
    final double month = tester.getCenter(find.text('Sep')).dx;
    final double day = tester.getCenter(find.text('18')).dx;
    final double year = tester.getCenter(find.text('2026')).dx;
    expect(month, lessThan(day));
    expect(day, lessThan(year));
  });

  testWidgets('the month type has no day column', (tester) async {
    await tester.pumpWidget(
      _app(_Host(initial: DateTime(2026, 9, 18), type: WeDateWheelType.month)),
    );
    expect(find.byType(ListWheelScrollView), findsNWidgets(2));
    await _key(tester, '9月', LogicalKeyboardKey.arrowDown);
    expect(_host(tester).value, DateTime(2026, 10));
  });
}
