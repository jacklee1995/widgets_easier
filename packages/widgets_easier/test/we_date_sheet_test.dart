import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Future<BuildContext> _pump(WidgetTester tester, {Size? size}) async {
  if (size != null) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }
  late BuildContext ctx;
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: const [WeTheme.light()]),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox.expand();
          },
        ),
      ),
    ),
  );
  return ctx;
}

void main() {
  testWidgets('确定 returns the day on the wheel, 取消 returns null', (
    tester,
  ) async {
    final ctx = await _pump(tester);
    DateTime? picked = DateTime(2000);
    WeDateSheet.show(
      ctx,
      initial: DateTime(2026, 9, 18),
    ).then((d) => picked = d);
    await tester.pumpAndSettle();
    expect(find.byType(WeDateWheel), findsOneWidget);
    expect(find.text('选择日期'), findsOneWidget);
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(picked, DateTime(2026, 9, 18));

    WeDateSheet.show(
      ctx,
      initial: DateTime(2026, 9, 18),
    ).then((d) => picked = d);
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(picked, isNull);
    expect(find.byType(WeDateWheel), findsNothing);
  });

  testWidgets('a shortcut picks at once', (tester) async {
    final ctx = await _pump(tester);
    DateTime? picked;
    WeDateSheet.show(
      ctx,
      initial: DateTime(2026, 9, 18),
      shortcuts: [WeDateShortcut('元旦', () => DateTime(2027, 1, 1, 9, 30))],
    ).then((d) => picked = d);
    await tester.pumpAndSettle();
    await tester.tap(find.text('元旦'));
    await tester.pumpAndSettle();
    expect(picked, DateTime(2027, 1, 1));
  });

  testWidgets('a range set backwards is swapped on confirm', (tester) async {
    final ctx = await _pump(tester);
    DateTimeRange? picked;
    WeDateSheet.showRange(
      ctx,
      initial: DateTimeRange(
        start: DateTime(2026, 9, 10),
        end: DateTime(2026, 9, 20),
      ),
    ).then((r) => picked = r);
    await tester.pumpAndSettle();
    expect(find.text('开始 2026-09-10'), findsOneWidget);

    // Move the end back to August, before the start.
    await tester.tap(find.text('结束 2026-09-20'));
    await tester.pumpAndSettle();
    Focus.of(tester.element(find.text('9月'))).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    expect(find.text('结束 2026-08-20'), findsOneWidget);

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(picked!.start, DateTime(2026, 8, 20));
    expect(picked!.end, DateTime(2026, 9, 10));
  });

  testWidgets('the sheet is at most 640 wide on a desktop screen', (
    tester,
  ) async {
    final ctx = await _pump(tester, size: const Size(1280, 800));
    WeDateSheet.show(ctx);
    await tester.pumpAndSettle();
    final card = find
        .descendant(
          of: find.byType(BottomSheet),
          matching: find.byType(Material),
        )
        .first;
    expect(tester.getSize(card).width, 640);
  });

  testWidgets('the range sheet fits a landscape phone', (tester) async {
    final ctx = await _pump(tester, size: const Size(844, 390));
    WeDateSheet.showRange(ctx);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('确定'), findsOneWidget);
  });
}
