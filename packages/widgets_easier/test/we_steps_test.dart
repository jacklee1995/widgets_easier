import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

const _steps = [
  WeStep(title: '下单'),
  WeStep(title: '付款', description: '微信支付'),
  WeStep(title: '发货'),
  WeStep(title: '签收'),
];

void main() {
  testWidgets('active 之前打勾、当前与之后显示序号', (tester) async {
    await tester.pumpWidget(_app(const WeSteps(active: 2, steps: _steps)));

    expect(find.byIcon(Icons.check), findsNWidgets(2));
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('微信支付'), findsOneWidget);
  });

  testWidgets('状态颜色：完成用 primary，等待用占位色，error 覆盖', (tester) async {
    const theme = WeTheme.light();
    await tester.pumpWidget(
      _app(
        const WeSteps(
          active: 1,
          steps: [
            WeStep(title: 'A'),
            WeStep(title: 'B', status: WeStepStatus.error),
            WeStep(title: 'C'),
          ],
        ),
      ),
    );

    Color colorOf(String t) => tester.widget<Text>(find.text(t)).style!.color!;
    expect(colorOf('A'), theme.colors.primary);
    expect(colorOf('B'), theme.colors.danger);
    expect(colorOf('C'), theme.colors.placeholderText);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('finishStatus: success 与 active = 长度时全部完成', (tester) async {
    const theme = WeTheme.light();
    await tester.pumpWidget(
      _app(
        const WeSteps(
          active: 4,
          finishStatus: WeStepStatus.success,
          steps: _steps,
        ),
      ),
    );

    expect(find.byIcon(Icons.check), findsNWidgets(4));
    expect(
      tester.widget<Text>(find.text('签收')).style!.color,
      theme.colors.success,
    );
  });

  testWidgets('onTap 回传步骤下标', (tester) async {
    int? tapped;
    await tester.pumpWidget(
      _app(WeSteps(active: 1, steps: _steps, onTap: (i) => tapped = i)),
    );

    await tester.tap(find.text('发货'));
    expect(tapped, 2);
  });

  testWidgets('纵向、居中、simple 三种布局都能渲染且不溢出', (tester) async {
    for (final w in const [
      WeSteps(active: 1, direction: Axis.vertical, steps: _steps),
      WeSteps(active: 1, alignCenter: true, steps: _steps),
      WeSteps(active: 1, simple: true, steps: _steps),
      WeSteps(
        active: 1,
        steps: [
          WeStep(title: '自定义', icon: Icons.local_shipping_outlined),
          WeStep(title: '结束'),
        ],
      ),
    ]) {
      await tester.pumpWidget(_app(w));
      expect(tester.takeException(), isNull);
      expect(find.text(w.steps.last.title), findsOneWidget);
    }
    expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
  });
}
