import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

const nodes = [
  WeTreeNode(
    'food',
    '食品',
    children: [WeTreeNode('snack', '零食'), WeTreeNode('drink', '饮料')],
  ),
  WeTreeNode('digital', '数码', children: [WeTreeNode('phone', '手机')]),
];

class _Single extends StatefulWidget {
  const _Single({this.strict = false, this.filterable = false});

  final bool strict;
  final bool filterable;

  @override
  State<_Single> createState() => _SingleState();
}

class _SingleState extends State<_Single> {
  String? value;

  @override
  Widget build(BuildContext context) => WeTreeSelect<String>(
    nodes: nodes,
    value: value,
    checkStrictly: widget.strict,
    filterable: widget.filterable,
    onChanged: (v) => setState(() => value = v),
  );
}

class _Multi extends StatefulWidget {
  const _Multi({this.collapse = false});

  final bool collapse;

  @override
  State<_Multi> createState() => _MultiState();
}

class _MultiState extends State<_Multi> {
  Set<String> values = {};

  @override
  Widget build(BuildContext context) => WeTreeSelect<String>.multiple(
    nodes: nodes,
    values: values,
    defaultExpandAll: true,
    collapseTags: widget.collapse,
    width: 320,
    onValuesChanged: (s) => setState(() => values = s),
  );
}

void main() {
  testWidgets('单选：点父节点只展开，点叶子选中并关闭', (tester) async {
    await tester.pumpWidget(_app(const _Single()));
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('食品'));
    await tester.pumpAndSettle();
    final state = tester.state<_SingleState>(find.byType(_Single));
    expect(state.value, isNull);
    expect(find.text('零食'), findsOneWidget);

    await tester.tap(find.text('零食'));
    await tester.pumpAndSettle();
    expect(state.value, 'snack');
    expect(find.text('饮料'), findsNothing, reason: '面板已关闭');
    expect(find.text('零食'), findsOneWidget, reason: '字段显示选中项');
  });

  testWidgets('单选 checkStrictly：可以选父节点', (tester) async {
    await tester.pumpWidget(_app(const _Single(strict: true)));
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('数码'));
    await tester.pumpAndSettle();
    expect(tester.state<_SingleState>(find.byType(_Single)).value, 'digital');
  });

  testWidgets('重新打开时展开到当前值', (tester) async {
    await tester.pumpWidget(_app(const _Single()));
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('数码'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('手机'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('手机'));
    await tester.pumpAndSettle();
    expect(find.text('手机'), findsNWidgets(2), reason: '字段和树里各一个');
  });

  testWidgets('多选：勾父节点只显示一个父标签，点 × 连子节点一起去掉', (tester) async {
    await tester.pumpWidget(_app(const _Multi()));
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('食品'));
    await tester.pumpAndSettle();
    final state = tester.state<_MultiState>(find.byType(_Multi));
    expect(state.values, {'food', 'snack', 'drink'});
    expect(find.text('零食'), findsOneWidget, reason: '只在树里，不做标签');

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(state.values, isEmpty);
  });

  testWidgets('多选 collapseTags：超出折叠成 +N', (tester) async {
    await tester.pumpWidget(_app(const _Multi(collapse: true)));
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('零食'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('手机'));
    await tester.pumpAndSettle();
    expect(find.text('+ 1'), findsOneWidget);
  });

  testWidgets('桌面端 filterable：输入过滤后点结果能选中', (tester) async {
    await tester.pumpWidget(_app(const _Single(filterable: true)));
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '手');
    await tester.pumpAndSettle();
    expect(find.text('食品'), findsNothing);
    await tester.tap(find.text('手机', findRichText: true));
    await tester.pumpAndSettle();
    expect(tester.state<_SingleState>(find.byType(_Single)).value, 'phone');
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));
}
