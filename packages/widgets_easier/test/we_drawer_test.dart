import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Future<void> _pumpHost(
  WidgetTester tester,
  void Function(BuildContext) open,
) async {
  tester.view.physicalSize = const Size(1200, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: const [WeTheme.light()]),
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => open(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

Rect _panelRect(WidgetTester tester) => tester.getRect(
  find
      .descendant(of: find.byType(WeDrawer), matching: find.byType(Material))
      .first,
);

void main() {
  testWidgets('默认从右侧滑出，宽度是屏幕的 30%', (tester) async {
    await _pumpHost(
      tester,
      (c) => WeDrawer.show<void>(c, title: '详情', child: const Text('内容')),
    );
    expect(find.text('详情'), findsOneWidget);
    final Rect r = _panelRect(tester);
    expect(r.right, 1200);
    expect(r.width, closeTo(360, 0.5));
  });

  testWidgets('四个方向与像素尺寸', (tester) async {
    for (final (dir, check) in <(WeDrawerDirection, bool Function(Rect))>[
      (WeDrawerDirection.ltr, (r) => r.left == 0 && r.width == 300),
      (WeDrawerDirection.ttb, (r) => r.top == 0 && r.height == 300),
      (WeDrawerDirection.btt, (r) => r.bottom == 800 && r.height == 300),
    ]) {
      await _pumpHost(
        tester,
        (c) => WeDrawer.show<void>(
          c,
          direction: dir,
          size: 300,
          child: const Text('内容'),
        ),
      );
      expect(check(_panelRect(tester)), isTrue, reason: '$dir');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(WeDrawer), findsNothing);
    }
  });

  testWidgets('点遮罩、关闭按钮关闭', (tester) async {
    await _pumpHost(
      tester,
      (c) => WeDrawer.show<void>(c, title: '详情', child: const Text('内容')),
    );
    await tester.tapAt(const Offset(20, 400));
    await tester.pumpAndSettle();
    expect(find.byType(WeDrawer), findsNothing);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(WeDrawer), findsNothing);
  });

  testWidgets('beforeClose 返回 false 时拦住遮罩和 Esc，true 时放行', (tester) async {
    bool allow = false;
    int asked = 0;
    await _pumpHost(
      tester,
      (c) => WeDrawer.show<void>(
        c,
        title: '编辑',
        beforeClose: () async {
          asked++;
          return allow;
        },
        child: const Text('内容'),
      ),
    );
    await tester.tapAt(const Offset(20, 400));
    await tester.pumpAndSettle();
    expect(find.byType(WeDrawer), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(WeDrawer), findsOneWidget);
    expect(asked, 2);

    allow = true;
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(WeDrawer), findsNothing);
  });

  testWidgets('actions 里 Navigator.pop 带回结果', (tester) async {
    String? result;
    await _pumpHost(tester, (c) async {
      result = await WeDrawer.show<String>(
        c,
        child: const Text('内容'),
        actions: (context) => [
          WeButton(
            text: '保存',
            onPressed: () => Navigator.pop(context, 'saved'),
          ),
        ],
      );
    });
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();
    expect(result, 'saved');
  });

  testWidgets('resizable：拖内侧边改变宽度', (tester) async {
    await _pumpHost(
      tester,
      (c) => WeDrawer.show<void>(
        c,
        size: 400,
        resizable: true,
        child: const Text('内容'),
      ),
    );
    final Rect before = _panelRect(tester);
    final TestGesture g = await tester.startGesture(
      Offset(before.left + 3, 400),
    );
    await g.moveBy(const Offset(-20, 0));
    await g.moveBy(const Offset(-100, 0));
    await g.up();
    await tester.pumpAndSettle();
    expect(_panelRect(tester).width, greaterThan(before.width + 90));
  });

  testWidgets('withHeader: false 不显示标题栏', (tester) async {
    await _pumpHost(
      tester,
      (c) => WeDrawer.show<void>(
        c,
        title: '看不见',
        withHeader: false,
        child: const Text('内容'),
      ),
    );
    expect(find.text('看不见'), findsNothing);
    expect(find.text('内容'), findsOneWidget);
  });
}
