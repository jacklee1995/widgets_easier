import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

const _regions = [
  WeCascaderOption(
    'zj',
    '浙江',
    children: [
      WeCascaderOption(
        'hz',
        '杭州',
        children: [
          WeCascaderOption('xh', '西湖区'),
          WeCascaderOption('bj', '滨江区'),
        ],
      ),
      WeCascaderOption('nb', '宁波', children: [WeCascaderOption('yz', '鄞州区')]),
    ],
  ),
  WeCascaderOption(
    'js',
    '江苏',
    children: [
      WeCascaderOption('nj', '南京', children: [WeCascaderOption('gl', '鼓楼区')]),
    ],
  ),
  WeCascaderOption('xz', '西藏', disabled: true),
];

class _Host extends StatefulWidget {
  const _Host({
    this.initial,
    this.checkStrictly = false,
    this.filterable = false,
  });

  final List<String>? initial;
  final bool checkStrictly;
  final bool filterable;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late List<String>? value = widget.initial;
  final List<List<String>?> changes = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(extensions: const [WeTheme.light()]),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topLeft,
            child: WeCascader<String>(
              options: _regions,
              value: value,
              checkStrictly: widget.checkStrictly,
              filterable: widget.filterable,
              clearable: true,
              onChanged: (v) => setState(() {
                value = v;
                changes.add(v);
              }),
            ),
          ),
        ),
      ),
    );
  }
}

_HostState _state(WidgetTester tester) =>
    tester.state<_HostState>(find.byType(_Host));

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(WeCascader<String>));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('点开逐级展开，点叶子选中整条路径并关闭', (tester) async {
    await tester.pumpWidget(const _Host());
    await _open(tester);
    expect(find.text('浙江'), findsOneWidget);
    expect(find.text('杭州'), findsNothing);

    await tester.tap(find.text('浙江'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('杭州'));
    await tester.pumpAndSettle();
    expect(_state(tester).changes, isEmpty, reason: '非叶子只展开');

    await tester.tap(find.text('滨江区'));
    await tester.pumpAndSettle();
    expect(_state(tester).value, ['zj', 'hz', 'bj']);
    expect(find.text('西湖区'), findsNothing, reason: '面板已关闭');
    expect(find.text('浙江 / 杭州 / 滨江区'), findsOneWidget);
  });

  testWidgets('禁用项点不动，重开时展开到当前值', (tester) async {
    await tester.pumpWidget(const _Host(initial: ['js', 'nj', 'gl']));
    await _open(tester);
    expect(find.text('南京'), findsOneWidget);
    expect(find.text('鼓楼区'), findsOneWidget);

    await tester.tap(find.text('西藏'));
    await tester.pumpAndSettle();
    expect(_state(tester).changes, isEmpty);
    expect(find.text('南京'), findsOneWidget);
  });

  testWidgets('checkStrictly：点单选框可选中非叶子', (tester) async {
    await tester.pumpWidget(const _Host(checkStrictly: true));
    await _open(tester);
    await tester.tap(find.text('浙江'));
    await tester.pumpAndSettle();

    final Finder hangzhouRow = find
        .ancestor(of: find.text('杭州'), matching: find.byType(Row))
        .first;
    final Offset left = tester.getTopLeft(hangzhouRow);
    await tester.tapAt(left + const Offset(7, 17));
    await tester.pumpAndSettle();
    expect(_state(tester).value, ['zj', 'hz']);
    expect(find.text('西湖区'), findsOneWidget, reason: '选非叶子不关闭面板');
  });

  testWidgets('键盘：下/右/回车走到叶子', (tester) async {
    await tester.pumpWidget(const _Host());
    await tester.tap(find.byType(WeCascader<String>));
    await tester.pumpAndSettle();

    // 打开时高亮第一项 浙江；右 → 杭州；右 → 西湖区；下 → 滨江区。
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(_state(tester).value, ['zj', 'hz', 'bj']);
  });

  testWidgets('键盘：左退回上一列，下跳过禁用项循环', (tester) async {
    await tester.pumpWidget(const _Host());
    await _open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    // 浙江 → 江苏 → (西藏禁用) → 浙江
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(find.text('南京'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(find.text('杭州'), findsOneWidget);
  });

  testWidgets('filterable：搜索显示完整路径，点击选中', (tester) async {
    await tester.pumpWidget(const _Host(filterable: true));
    await _open(tester);
    await tester.enterText(find.byType(TextField), '鼓楼');
    await tester.pumpAndSettle();
    expect(find.text('江苏 / 南京 / 鼓楼区'), findsOneWidget);
    expect(find.text('浙江'), findsNothing);

    await tester.tap(find.text('江苏 / 南京 / 鼓楼区'));
    await tester.pumpAndSettle();
    expect(_state(tester).value, ['js', 'nj', 'gl']);
  });

  testWidgets('桌面端：可搜索时点面板不会因搜索框失焦而关闭', (tester) async {
    await tester.pumpWidget(const _Host(filterable: true));
    await _open(tester);
    await tester.tap(find.text('浙江'));
    await tester.pumpAndSettle();
    expect(find.text('杭州'), findsOneWidget);
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  testWidgets('filterable：无结果时提示', (tester) async {
    await tester.pumpWidget(const _Host(filterable: true));
    await _open(tester);
    await tester.enterText(find.byType(TextField), '不存在');
    await tester.pumpAndSettle();
    expect(find.text('无匹配数据'), findsOneWidget);
  });
}
