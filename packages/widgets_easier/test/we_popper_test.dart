import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child, {Alignment align = Alignment.center}) {
  return MaterialApp(
    theme: ThemeData(
      extensions: const [WeTheme.light(interaction: WeInteraction.pointer)],
    ),
    home: Scaffold(
      body: Align(alignment: align, child: child),
    ),
  );
}

void main() {
  group('WePopper', () {
    testWidgets('点击触发器打开，点外面关闭', (tester) async {
      await tester.pumpWidget(
        _app(
          WePopper(
            popupBuilder: (_) => const Text('浮层内容'),
            child: const Text('触发器'),
          ),
        ),
      );

      await tester.tap(find.text('触发器'));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsOneWidget);

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsNothing);
    });

    testWidgets('点浮层内部不会关闭', (tester) async {
      await tester.pumpWidget(
        _app(
          WePopper(
            popupBuilder: (_) =>
                const SizedBox(width: 120, height: 60, child: Text('浮层内容')),
            child: const Text('触发器'),
          ),
        ),
      );
      await tester.tap(find.text('触发器'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('浮层内容'));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsOneWidget);
    });

    testWidgets('下方放不下时翻到上方', (tester) async {
      await tester.pumpWidget(
        _app(
          WePopper(
            placement: WePlacement.bottom,
            popupBuilder: (_) =>
                const SizedBox(width: 100, height: 200, child: Text('浮层内容')),
            child: const Text('触发器'),
          ),
          align: Alignment.bottomCenter,
        ),
      );
      await tester.tap(find.text('触发器'));
      await tester.pumpAndSettle();

      final double popupBottom = tester.getBottomLeft(find.text('浮层内容')).dy;
      final double triggerTop = tester.getTopLeft(find.text('触发器')).dy;
      expect(popupBottom, lessThanOrEqualTo(triggerTop));
    });

    testWidgets('贴右边时沿交叉轴平移回视口', (tester) async {
      await tester.pumpWidget(
        _app(
          WePopper(
            placement: WePlacement.bottomStart,
            popupBuilder: (_) =>
                const SizedBox(width: 300, height: 40, child: Text('浮层内容')),
            child: const Text('触发器'),
          ),
          align: Alignment.topRight,
        ),
      );
      await tester.tap(find.text('触发器'));
      await tester.pumpAndSettle();

      final double width =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;
      final Rect rect = tester.getRect(
        find
            .ancestor(of: find.text('浮层内容'), matching: find.byType(Container))
            .first,
      );
      expect(rect.right, lessThanOrEqualTo(width));
    });

    testWidgets('hover 触发：移入打开，移出关闭', (tester) async {
      await tester.pumpWidget(
        _app(
          WePopper(
            trigger: WePopperTrigger.hover,
            hideAfter: Duration.zero,
            popupBuilder: (_) => const Text('浮层内容'),
            child: const SizedBox(width: 80, height: 30, child: Text('触发器')),
          ),
        ),
      );
      final TestGesture mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.text('触发器')));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsOneWidget);

      await mouse.moveTo(const Offset(2, 2));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsNothing);
      await mouse.removePointer();
    });

    testWidgets('controller 控制显示，Esc 关闭', (tester) async {
      final controller = WePopperController();
      await tester.pumpWidget(
        _app(
          WePopper(
            controller: controller,
            trigger: WePopperTrigger.manual,
            popupBuilder: (_) => const Text('浮层内容'),
            child: const Text('触发器'),
          ),
        ),
      );

      controller.show();
      await tester.pumpAndSettle();
      expect(controller.isOpen, isTrue);
      expect(find.text('浮层内容'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(controller.isOpen, isFalse);
      expect(find.text('浮层内容'), findsNothing);
    });

    testWidgets('弹窗里的浮层：Esc 只关浮层，不关弹窗', (tester) async {
      final controller = WePopperController();
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => WeDialog.show<void>(
                context,
                title: '弹窗',
                child: WePopper(
                  controller: controller,
                  trigger: WePopperTrigger.manual,
                  popupBuilder: (_) => const Text('浮层内容'),
                  child: const Text('触发器'),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      controller.show();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsNothing);
      expect(find.text('弹窗'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('弹窗'), findsNothing);
    });

    testWidgets('builder 形态：按钮自己的 onPressed 负责开关', (tester) async {
      await tester.pumpWidget(
        _app(
          WePopper.builder(
            popupBuilder: (_) => const Text('浮层内容'),
            builder: (context, toggle) =>
                WeButton(text: '更多', onPressed: toggle),
          ),
        ),
      );
      await tester.tap(find.text('更多'));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsOneWidget);

      await tester.tap(find.text('更多'));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsNothing);
    });
  });

  group('WeTooltip / WePopover / WePopconfirm', () {
    testWidgets('WeTooltip 悬停显示文字', (tester) async {
      await tester.pumpWidget(
        _app(
          const WeTooltip(
            content: '编辑商品',
            hideAfter: Duration.zero,
            child: SizedBox(width: 40, height: 40, child: Icon(Icons.edit)),
          ),
        ),
      );
      final TestGesture mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byIcon(Icons.edit)));
      await tester.pumpAndSettle();
      expect(find.text('编辑商品'), findsOneWidget);

      await mouse.moveTo(const Offset(1, 1));
      await tester.pumpAndSettle();
      expect(find.text('编辑商品'), findsNothing);
      await mouse.removePointer();
    });

    testWidgets('WeButton.tooltip 走 WeTooltip', (tester) async {
      await tester.pumpWidget(
        _app(WeButton.icon(Icons.delete, tooltip: '删除', onPressed: () {})),
      );
      expect(find.byType(WeTooltip), findsOneWidget);
    });

    testWidgets('WePopover 点击显示标题和内容', (tester) async {
      await tester.pumpWidget(
        _app(
          const WePopover(title: '库存', content: '剩余 12 件', child: Text('查看')),
        ),
      );
      await tester.tap(find.text('查看'));
      await tester.pumpAndSettle();
      expect(find.text('库存'), findsOneWidget);
      expect(find.text('剩余 12 件'), findsOneWidget);
    });

    testWidgets('WePopconfirm 确认时等待 Future 并显示 loading', (tester) async {
      final done = Completer<void>();
      int confirmed = 0;
      await tester.pumpWidget(
        _app(
          WePopconfirm.builder(
            title: '确定删除吗？',
            onConfirm: () {
              confirmed++;
              return done.future;
            },
            builder: (context, open) => WeButton(text: '删除', onPressed: open),
          ),
        ),
      );
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(find.text('确定删除吗？'), findsOneWidget);

      await tester.tap(find.text('确定'));
      await tester.pump();
      expect(confirmed, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('确定删除吗？'), findsOneWidget);

      done.complete();
      await tester.pumpAndSettle();
      expect(find.text('确定删除吗？'), findsNothing);
    });

    testWidgets('WePopconfirm 取消只关闭', (tester) async {
      int confirmed = 0;
      int cancelled = 0;
      await tester.pumpWidget(
        _app(
          WePopconfirm(
            title: '确定吗？',
            onConfirm: () => confirmed++,
            onCancel: () => cancelled++,
            child: const Text('操作'),
          ),
        ),
      );
      await tester.tap(find.text('操作'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(find.text('确定吗？'), findsNothing);
      expect(confirmed, 0);
      expect(cancelled, 1);
    });
  });
}
