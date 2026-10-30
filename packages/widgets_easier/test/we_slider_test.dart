import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void main() {
  testWidgets('拖动滑块改变 value', (tester) async {
    double v = 20;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => WeSlider(
            value: v,
            min: 0,
            max: 100,
            onChanged: (n) => setState(() => v = n),
          ),
        ),
      ),
    );
    final slider = tester.widget<Slider>(find.byType(Slider));
    slider.onChanged!(80);
    await tester.pump();
    expect(v, 80);
  });

  testWidgets('step 产生 discrete divisions', (tester) async {
    await tester.pumpWidget(
      _app(WeSlider(value: 4, min: 0, max: 10, step: 2, onChanged: (_) {})),
    );
    expect(tester.widget<Slider>(find.byType(Slider)).divisions, 5);
  });

  testWidgets('range 两个滑块', (tester) async {
    var range = (20.0, 80.0);
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => WeSlider.range(
            values: range,
            onRangeChanged: (r) => setState(() => range = r),
          ),
        ),
      ),
    );
    tester.widget<RangeSlider>(find.byType(RangeSlider)).onChanged!(
      const RangeValues(10, 90),
    );
    await tester.pump();
    expect(range, (10.0, 90.0));
  });

  testWidgets('禁用后拖不动', (tester) async {
    double v = 50;
    await tester.pumpWidget(
      _app(WeSlider(value: v, disabled: true, onChanged: (n) => v = n)),
    );
    expect(tester.widget<Slider>(find.byType(Slider)).onChanged, isNull);
  });

  testWidgets('在 WeFormItem 里变化会触发校验', (tester) async {
    final form = WeFormController();
    double v = 0;
    await tester.pumpWidget(
      _app(
        WeForm(
          controller: form,
          children: [
            WeFormItem(
              name: 'n',
              label: '折扣',
              valueGetter: () => v,
              rules: [
                WeRule(validator: (x) => (x as double) < 1 ? '至少 1' : null),
              ],
              child: StatefulBuilder(
                builder: (context, setState) => WeSlider(
                  value: v,
                  min: 0,
                  max: 10,
                  onChanged: (n) => setState(() => v = n),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    expect(await form.validate(), isFalse);
    tester.widget<Slider>(find.byType(Slider)).onChanged!(3);
    await tester.pump();
    await tester.pump();
    expect(await form.validate(), isTrue);
  });
}
