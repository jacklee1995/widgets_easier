import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

/// 缺口位置是随机的，测试里靠 pumpWidget 后读控制器状态来断言行为，
/// 需要精确命中时用 [_dragTo] 把滑块一路拖到底再回退。
Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  double width = 400,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: const [WeTheme.light()]),
      home: Scaffold(
        body: Center(
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  );
  await tester.pump();
}

/// 拖动滑块，途中分成 [steps] 段并留出时间，绕过「像不像人」的判断。
Future<void> _drag(
  WidgetTester tester,
  double dx, {
  int steps = 8,
  bool slow = true,
}) async {
  final Offset handle = tester.getCenter(
    find.byIcon(Icons.keyboard_double_arrow_right_rounded),
  );
  final TestGesture gesture = await tester.startGesture(handle);
  for (int i = 0; i < steps; i++) {
    await gesture.moveBy(Offset(dx / steps, 0));
    if (slow) await tester.pump(const Duration(milliseconds: 40));
  }
  await gesture.up();
  await tester.pump();
}

void main() {
  group('WeCaptcha', () {
    testWidgets('没有底图时也能渲染，不需要联网', (tester) async {
      await _pump(tester, const WeCaptcha());

      expect(find.byType(WeCaptcha), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('初始状态是 idle，提示文案可见', (tester) async {
      final controller = WeCaptchaController();
      addTearDown(controller.dispose);

      await _pump(tester, WeCaptcha(controller: controller, hint: '拖一下'));

      expect(controller.status, WeCaptchaStatus.idle);
      expect(controller.solved, isFalse);
      expect(find.text('拖一下'), findsWidgets);
    });

    testWidgets('对不上缺口算失败，滑块回到起点并保持可重试', (tester) async {
      final controller = WeCaptchaController();
      addTearDown(controller.dispose);
      int fails = 0;

      await _pump(
        tester,
        WeCaptcha(controller: controller, tolerance: 2, onFail: () => fails++),
      );

      // 缺口最靠左也在 40% 处，挪 6 像素必然对不上。
      await _drag(tester, 6);
      expect(fails, 1);
      expect(controller.status, WeCaptchaStatus.failure);

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(controller.status, WeCaptchaStatus.idle);
    });

    testWidgets('一步到位的拖动被当成机器人', (tester) async {
      final controller = WeCaptchaController();
      addTearDown(controller.dispose);

      await _pump(tester, WeCaptcha(controller: controller));

      await _drag(tester, 200, steps: 1, slow: false);
      expect(controller.status, WeCaptchaStatus.failure);

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
    });

    testWidgets('关掉 humanCheck 后，onVerify 说通过就通过', (tester) async {
      final controller = WeCaptchaController();
      addTearDown(controller.dispose);
      int ok = 0;

      await _pump(
        tester,
        WeCaptcha(
          controller: controller,
          humanCheck: false,
          // 本地永远算命中，把判定完全交给 onVerify。
          tolerance: 10000,
          onVerify: (_) async => true,
          onSuccess: () => ok++,
        ),
      );

      await _drag(tester, 120, steps: 1, slow: false);
      await tester.pumpAndSettle();

      expect(ok, 1);
      expect(controller.status, WeCaptchaStatus.success);
      expect(controller.solved, isTrue);
    });

    testWidgets('onVerify 返回 false 时算失败', (tester) async {
      final controller = WeCaptchaController();
      addTearDown(controller.dispose);

      await _pump(
        tester,
        WeCaptcha(
          controller: controller,
          humanCheck: false,
          tolerance: 10000,
          onVerify: (_) async => false,
        ),
      );

      await _drag(tester, 120, steps: 1, slow: false);
      await tester.pumpAndSettle();

      expect(controller.status, isNot(WeCaptchaStatus.success));
    });

    testWidgets('通过后不再接受拖动', (tester) async {
      final controller = WeCaptchaController();
      addTearDown(controller.dispose);
      int ok = 0;

      await _pump(
        tester,
        WeCaptcha(
          controller: controller,
          humanCheck: false,
          tolerance: 10000,
          onSuccess: () => ok++,
        ),
      );

      await _drag(tester, 120, steps: 1, slow: false);
      await tester.pumpAndSettle();
      expect(ok, 1);

      // 成功后滑块换成对勾，原来的箭头图标已经不在了。
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(
        find.byIcon(Icons.keyboard_double_arrow_right_rounded),
        findsNothing,
      );
      expect(ok, 1);
    });

    testWidgets('用完 maxAttempts 之后锁定，刷新可以解锁', (tester) async {
      final controller = WeCaptchaController();
      addTearDown(controller.dispose);

      await _pump(
        tester,
        WeCaptcha(controller: controller, tolerance: 2, maxAttempts: 2),
      );

      for (int i = 0; i < 2; i++) {
        await _drag(tester, 6);
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pumpAndSettle();
      }
      expect(controller.status, WeCaptchaStatus.locked);

      controller.refresh();
      await tester.pumpAndSettle();
      expect(controller.status, WeCaptchaStatus.idle);
    });

    testWidgets('controller.reset 把滑块送回起点', (tester) async {
      final controller = WeCaptchaController();
      addTearDown(controller.dispose);

      await _pump(tester, WeCaptcha(controller: controller));

      final double start = tester
          .getTopLeft(find.byIcon(Icons.keyboard_double_arrow_right_rounded))
          .dx;

      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(
          find.byIcon(Icons.keyboard_double_arrow_right_rounded),
        ),
      );
      await gesture.moveBy(const Offset(90, 0));
      await tester.pump();
      expect(
        tester
            .getTopLeft(find.byIcon(Icons.keyboard_double_arrow_right_rounded))
            .dx,
        greaterThan(start),
      );

      await gesture.up();
      controller.reset();
      await tester.pumpAndSettle();
      expect(
        tester
            .getTopLeft(find.byIcon(Icons.keyboard_double_arrow_right_rounded))
            .dx,
        start,
      );
    });

    testWidgets('滑块不会被拖出轨道', (tester) async {
      await _pump(tester, const WeCaptcha(), width: 400);

      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(
          find.byIcon(Icons.keyboard_double_arrow_right_rounded),
        ),
      );
      await gesture.moveBy(const Offset(9999, 0));
      await tester.pump();

      final Rect handle = tester.getRect(
        find.byIcon(Icons.keyboard_double_arrow_right_rounded),
      );
      final Rect board = tester.getRect(find.byType(WeCaptcha));
      expect(handle.right, lessThanOrEqualTo(board.right + 0.5));

      await gesture.moveBy(const Offset(-9999, 0));
      await tester.pump();
      expect(
        tester
            .getRect(find.byIcon(Icons.keyboard_double_arrow_right_rounded))
            .left,
        greaterThanOrEqualTo(board.left - 0.5),
      );

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('禁用时拖不动', (tester) async {
      final controller = WeCaptchaController();
      addTearDown(controller.dispose);

      await _pump(tester, WeCaptcha(controller: controller, enabled: false));

      await _drag(tester, 120);
      expect(controller.status, WeCaptchaStatus.idle);
    });

    testWidgets('dispose 后没有残留的定时器或监听', (tester) async {
      await _pump(tester, const WeCaptcha());
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
