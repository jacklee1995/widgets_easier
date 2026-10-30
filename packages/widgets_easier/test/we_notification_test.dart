import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Future<BuildContext> _pump(WidgetTester tester) async {
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
  testWidgets('show 后出现标题和正文，duration 到期后消失', (tester) async {
    final ctx = await _pump(tester);
    WeNotification.show(
      ctx,
      title: '导出完成',
      message: '文件已保存',
      duration: const Duration(milliseconds: 80),
    );
    await tester.pump();
    expect(find.text('导出完成'), findsOneWidget);
    expect(find.text('文件已保存'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('导出完成'), findsNothing);
  });

  testWidgets('handle.close 立刻关掉这一条', (tester) async {
    final ctx = await _pump(tester);
    final handle = WeNotification.info(
      ctx,
      title: '可关',
      message: '点关闭',
      duration: Duration.zero,
    );
    await tester.pump();
    expect(find.text('可关'), findsOneWidget);
    handle.close();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('可关'), findsNothing);
  });

  testWidgets('四个角各一条互不影响，closeAll 清空', (tester) async {
    final ctx = await _pump(tester);
    for (final p in WeNotificationPosition.values) {
      WeNotification.show(
        ctx,
        title: p.name,
        duration: Duration.zero,
        position: p,
      );
    }
    await tester.pump();
    expect(find.text('topRight'), findsOneWidget);
    expect(find.text('bottomLeft'), findsOneWidget);
    WeNotification.closeAll();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('topRight'), findsNothing);
    expect(find.text('bottomLeft'), findsNothing);
  });

  testWidgets('点卡片触发 onClick', (tester) async {
    final ctx = await _pump(tester);
    var tapped = false;
    WeNotification.warning(
      ctx,
      title: '库存告急',
      message: '仅剩 46 件',
      duration: Duration.zero,
      position: WeNotificationPosition.topLeft,
      onClick: () => tapped = true,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.tap(find.text('库存告急'));
    expect(tapped, isTrue);
    WeNotification.closeAll();
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('同一个角的第二条排在第一条下面；前一条关掉后后一条补位', (tester) async {
    final ctx = await _pump(tester);
    final first = WeNotification.info(
      ctx,
      title: '第一条',
      duration: Duration.zero,
    );
    WeNotification.info(ctx, title: '第二条', duration: Duration.zero);
    await tester.pumpAndSettle();
    final double y1 = tester.getTopLeft(find.text('第一条')).dy;
    final double y2 = tester.getTopLeft(find.text('第二条')).dy;
    expect(y2, greaterThan(y1));

    first.close();
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('第二条')).dy, closeTo(y1, 1));
    WeNotification.closeAll();
    await tester.pumpAndSettle();
  });

  testWidgets('点右上角 × 关闭，done 完成', (tester) async {
    final ctx = await _pump(tester);
    final h = WeNotification.success(
      ctx,
      title: '已保存',
      duration: Duration.zero,
    );
    var done = false;
    h.done.then((_) => done = true);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('已保存'), findsNothing);
    expect(done, isTrue);
  });

  testWidgets('鼠标悬停时暂停倒计时，移开后重新计时', (tester) async {
    final ctx = await _pump(tester);
    WeNotification.info(
      ctx,
      title: '悬停别走',
      duration: const Duration(milliseconds: 1500),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('悬停别走')));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('悬停别走'), findsOneWidget);

    await mouse.moveTo(Offset.zero);
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('悬停别走'), findsOneWidget, reason: '移开后重新计满 1.5 秒');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('悬停别走'), findsNothing);
  });
}
