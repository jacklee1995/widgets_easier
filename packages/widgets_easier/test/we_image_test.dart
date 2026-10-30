import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(
    extensions: const [WeTheme.light(interaction: WeInteraction.pointer)],
  ),
  home: Scaffold(body: Center(child: child)),
);

const _gallery = [
  WeImageSource.network(''),
  WeImageSource.network(''),
  WeImageSource.network(''),
];

double _scale(WidgetTester tester) => tester
    .widgetList<InteractiveViewer>(find.byType(InteractiveViewer))
    .firstWhere((v) => v.transformationController != null)
    .transformationController!
    .value
    .getMaxScaleOnAxis();

Future<void> _open(WidgetTester tester, {int initialIndex = 0}) async {
  await tester.pumpWidget(
    _app(
      WeImage(
        src: '',
        width: 40,
        height: 40,
        preview: true,
        previewList: _gallery,
        initialIndex: initialIndex,
      ),
    ),
  );
  await tester.tap(find.byType(WeImage));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('src 为空时显示错误占位', (tester) async {
    await tester.pumpWidget(
      _app(const WeImage(src: '', width: 80, height: 80)),
    );
    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
  });

  testWidgets('不开 preview 时点击不弹查看器', (tester) async {
    await tester.pumpWidget(
      _app(const WeImage(src: '', width: 80, height: 80)),
    );
    await tester.tap(find.byType(WeImage));
    await tester.pumpAndSettle();
    expect(find.byTooltip('关闭（Esc）'), findsNothing);
  });

  testWidgets('打开时定位到 initialIndex，Esc 关闭', (tester) async {
    await _open(tester, initialIndex: 2);
    expect(find.text('3 / 3'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('3 / 3'), findsNothing);
  });

  testWidgets('左右箭头按钮与键盘切图，首尾按钮禁用', (tester) async {
    await _open(tester);
    expect(find.text('1 / 3'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.chevron_left_rounded),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.byTooltip('下一张（→）'));
    await tester.pumpAndSettle();
    expect(find.text('2 / 3'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('3 / 3'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.chevron_right_rounded),
          )
          .onPressed,
      isNull,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(find.text('2 / 3'), findsOneWidget);
  });

  testWidgets('工具栏与 + / - / 0 缩放，换图后复位', (tester) async {
    await _open(tester);
    await tester.tap(find.byTooltip('放大（+）'));
    await tester.pump();
    expect(_scale(tester), closeTo(1.25, 0.001));

    await tester.sendKeyEvent(LogicalKeyboardKey.equal);
    await tester.pump();
    expect(_scale(tester), closeTo(1.5625, 0.001));

    await tester.sendKeyEvent(LogicalKeyboardKey.minus);
    await tester.pump();
    expect(_scale(tester), closeTo(1.25, 0.001));

    await tester.sendKeyEvent(LogicalKeyboardKey.digit0);
    await tester.pump();
    expect(_scale(tester), closeTo(1, 0.001));

    await tester.tap(find.byTooltip('放大（+）'));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(_scale(tester), closeTo(1, 0.001));
  });

  testWidgets('缩小有下限', (tester) async {
    await _open(tester);
    for (int i = 0; i < 20; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.minus);
    }
    await tester.pump();
    expect(_scale(tester), closeTo(WeImageViewer.minScale, 0.001));
  });

  testWidgets('旋转按钮每次转 90°', (tester) async {
    await _open(tester);
    await tester.tap(find.byTooltip('向右旋转'));
    await tester.pumpAndSettle();
    final AnimatedRotation r = tester
        .widgetList<AnimatedRotation>(find.byType(AnimatedRotation))
        .firstWhere((w) => w.turns != 0);
    expect(r.turns, 0.25);
  });
}
