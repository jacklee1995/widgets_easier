import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('点击标题展开和收起', (tester) async {
    var open = <String>{};
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => WeCollapse(
            expanded: open,
            onChanged: (s) => setState(() => open = s),
            items: const [
              WeCollapseItem(name: 'a', title: '基础设置', child: Text('内容 A')),
              WeCollapseItem(name: 'b', title: '安全', child: Text('内容 B')),
            ],
          ),
        ),
      ),
    );
    expect(find.text('内容 A'), findsOneWidget);
    expect(
      tester
          .widget<AnimatedAlign>(find.byType(AnimatedAlign).first)
          .heightFactor,
      0,
    );
    await tester.tap(find.text('基础设置'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<AnimatedAlign>(find.byType(AnimatedAlign).first)
          .heightFactor,
      1,
    );
  });

  testWidgets('accordion 同时只开一项；disabled 点不动', (tester) async {
    var open = {'a'};
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => WeCollapse(
            accordion: true,
            expanded: open,
            onChanged: (s) => setState(() => open = s),
            items: const [
              WeCollapseItem(name: 'a', title: 'A', child: Text('内容 A')),
              WeCollapseItem(name: 'b', title: 'B', child: Text('内容 B')),
              WeCollapseItem(
                name: 'c',
                title: 'C',
                child: Text('内容 C'),
                disabled: true,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(open, {'b'});
    await tester.tap(find.text('C'));
    await tester.pump();
    expect(open, {'b'});
  });

  testWidgets('extra 显示在标题右侧，点它也能切换', (tester) async {
    var open = <String>{};
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => WeCollapse(
            expanded: open,
            onChanged: (s) => setState(() => open = s),
            items: const [
              WeCollapseItem(
                name: 'a',
                title: '通知',
                extra: Text('3 条未读'),
                child: Text('内容'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('3 条未读'));
    await tester.pump();
    expect(open, {'a'});
  });

  testWidgets('键盘：Tab 聚焦标题，Enter / 空格切换；收起的面板里的输入框不进 Tab 顺序', (tester) async {
    var open = <String>{};
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => WeCollapse(
            expanded: open,
            onChanged: (s) => setState(() => open = s),
            items: const [
              WeCollapseItem(name: 'a', title: 'A', child: TextField()),
              WeCollapseItem(name: 'b', title: 'B', child: Text('内容 B')),
            ],
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(open, {'b'}, reason: '第二次 Tab 越过 A 里隐藏的输入框，落在 B 标题上');

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(open, isEmpty);
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));
}
