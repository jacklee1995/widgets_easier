import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child, {WeTheme we = const WeTheme.light()}) => MaterialApp(
  theme: ThemeData(extensions: [we]),
  home: Scaffold(body: Center(child: child)),
);

final TargetPlatformVariant _desktop = TargetPlatformVariant.only(
  TargetPlatform.windows,
);

void main() {
  group('WePlatform.isTouch', () {
    test('Android, iOS and Fuchsia are touch; desktops are not', () {
      for (final p in TargetPlatform.values) {
        final bool expected =
            p == TargetPlatform.android ||
            p == TargetPlatform.iOS ||
            p == TargetPlatform.fuchsia;
        expect(WePlatform.isTouchPlatform(p), expected, reason: '$p');
      }
    });

    test('a forced interaction wins over the platform', () {
      expect(
        WePlatform.resolveTouch(WeInteraction.pointer, TargetPlatform.android),
        isFalse,
      );
      expect(
        WePlatform.resolveTouch(WeInteraction.touch, TargetPlatform.windows),
        isTrue,
      );
      expect(
        WePlatform.resolveTouch(WeInteraction.auto, TargetPlatform.iOS),
        isTrue,
      );
    });

    testWidgets('reads the local Theme platform', (tester) async {
      late bool outer;
      late bool inner;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) {
              outer = WePlatform.isTouch(context);
              return Theme(
                data: Theme.of(
                  context,
                ).copyWith(platform: TargetPlatform.android),
                child: Builder(
                  builder: (context) {
                    inner = WePlatform.isTouch(context);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
      expect(outer, isFalse);
      expect(inner, isTrue);
    }, variant: _desktop);
  });

  group('touch sizes', () {
    testWidgets('WeTheme.of switches to touch sizes on Android', (
      tester,
    ) async {
      late WeTheme we;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) {
              we = WeTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(we.sizes, same(const WeSizeScheme.touch()));
    });

    testWidgets('custom sizes and pointer mode are left alone', (tester) async {
      const custom = WeSizeScheme.touch();
      late WeTheme pointer;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) {
              pointer = WeTheme.of(context);
              return const SizedBox();
            },
          ),
          we: const WeTheme.light(interaction: WeInteraction.pointer),
        ),
      );
      expect(pointer.sizes, same(const WeSizeScheme.standard()));

      late WeTheme mine;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) {
              mine = WeTheme.of(context);
              return const SizedBox();
            },
          ),
          we: const WeTheme.light().copyWith(
            sizes: const WeSizeScheme.standard().copyWith(medium: custom.small),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(mine.sizes.medium.height, custom.small.height);
    });

    testWidgets('WeButton is 44 tall on Android', (tester) async {
      await tester.pumpWidget(_app(WeButton(text: '提交', onPressed: () {})));
      expect(tester.getSize(find.byType(WeButton)).height, 44);
    });

    testWidgets('WeButton is 32 tall on Windows', (tester) async {
      await tester.pumpWidget(_app(WeButton(text: '提交', onPressed: () {})));
      expect(tester.getSize(find.byType(WeButton)).height, 32);
    }, variant: _desktop);
  });

  group('touch triggers', () {
    testWidgets('a hover WePopper opens on tap on Android', (tester) async {
      await tester.pumpWidget(
        _app(
          WePopper(
            trigger: WePopperTrigger.hover,
            popupBuilder: (_) => const Text('浮层内容'),
            child: const Text('触发'),
          ),
        ),
      );
      await tester.tap(find.text('触发'));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsOneWidget);
    });

    testWidgets('a hover WePopper still opens on hover on Windows', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          WePopper(
            trigger: WePopperTrigger.hover,
            popupBuilder: (_) => const Text('浮层内容'),
            child: const Text('触发'),
          ),
        ),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.text('触发')));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsOneWidget);
    }, variant: _desktop);

    testWidgets('WeTooltip opens on long press and hides by itself', (
      tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        _app(
          WeTooltip(
            content: '编辑这一行',
            child: WeButton(text: '编辑', onPressed: () => taps++),
          ),
        ),
      );

      await tester.tap(find.text('编辑'));
      await tester.pumpAndSettle();
      expect(taps, 1);
      expect(find.text('编辑这一行'), findsNothing);

      await tester.longPress(find.text('编辑'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('编辑这一行'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pumpAndSettle();
      expect(find.text('编辑这一行'), findsNothing);
    });
  });

  group('widths stay within the screen', () {
    Future<BuildContext> phone(WidgetTester tester, double width) async {
      tester.view.physicalSize = Size(width, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      late BuildContext ctx;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox.expand();
            },
          ),
        ),
      );
      return ctx;
    }

    testWidgets('WeNotification on a 320 wide phone', (tester) async {
      final ctx = await phone(tester, 320);
      WeNotification.show(
        ctx,
        title: '导出完成',
        message: '文件已保存到下载目录',
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      final Rect card = tester.getRect(
        find
            .ancestor(of: find.text('导出完成'), matching: find.byType(Material))
            .first,
      );
      expect(card.left, greaterThanOrEqualTo(0));
      expect(card.right, lessThanOrEqualTo(320));
      expect(tester.takeException(), isNull);
      WeNotification.closeAll();
      await tester.pumpAndSettle();
    });

    testWidgets('WeDialog on a 360 wide phone', (tester) async {
      await phone(tester, 360);
      await tester.pumpWidget(
        _app(const WeDialog(title: '标题', child: Text('正文'))),
      );
      final Rect box = tester.getRect(find.byType(WeDialog));
      expect(box.width, lessThanOrEqualTo(360));
      expect(tester.takeException(), isNull);
    });
  });

  group('debug hints', () {
    setUp(WePlatform.debugResetHints);

    tearDown(() {
      WePlatform.debugHints = true;
      WePlatform.debugResetHints();
    });

    // flutter_test checks that debugPrint is restored before tearDown runs,
    // so the capture is undone inside the test body.
    Future<List<String>> capture(Future<void> Function() body) async {
      final List<String> printed = [];
      final DebugPrintCallback original = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null && message.contains('WePagination')) {
          printed.add(message);
        }
      };
      try {
        await body();
      } finally {
        debugPrint = original;
      }
      return printed;
    }

    Widget pagination() =>
        WePagination(total: 100, page: 1, pageSize: 10, onPageChanged: (_) {});

    testWidgets('a desktop widget on touch prints once', (tester) async {
      final hints = await capture(() async {
        await tester.pumpWidget(_app(Column(children: [pagination()])));
        await tester.pumpWidget(
          _app(Column(children: [pagination(), pagination()])),
        );
      });
      expect(hints, hasLength(1));
      expect(hints.single, contains('PaginationView'));
      expect(hints.single, contains('WePlatform.debugHints = false'));
    });

    testWidgets('debugHints = false keeps it quiet', (tester) async {
      WePlatform.debugHints = false;
      final hints = await capture(() => tester.pumpWidget(_app(pagination())));
      expect(hints, isEmpty);
    });

    testWidgets('nothing is printed on desktop', (tester) async {
      final hints = await capture(() => tester.pumpWidget(_app(pagination())));
      expect(hints, isEmpty);
    }, variant: _desktop);
  });
}
