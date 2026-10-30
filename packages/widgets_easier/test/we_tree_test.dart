import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

const nodes = [
  WeTreeNode(
    'food',
    '食品',
    children: [
      WeTreeNode('snack', '零食'),
      WeTreeNode('tea', '茶饮', disabled: true),
    ],
  ),
  WeTreeNode(
    'digital',
    '数码',
    children: [WeTreeNode('phone', '手机'), WeTreeNode('audio', '耳机音响')],
  ),
  WeTreeNode('home', '家居'),
];

/// A tree whose checked set lives in the host, like real usage.
class _Checked extends StatefulWidget {
  const _Checked({this.strict = false});

  final bool strict;

  @override
  State<_Checked> createState() => _CheckedState();
}

class _CheckedState extends State<_Checked> {
  Set<String> checked = {};

  @override
  Widget build(BuildContext context) => WeTree<String>(
    nodes: nodes,
    defaultExpandAll: true,
    showCheckbox: true,
    checkStrictly: widget.strict,
    checked: checked,
    onCheck: (s) => setState(() => checked = s),
  );
}

Set<String> _checked(WidgetTester tester) =>
    tester.state<_CheckedState>(find.byType(_Checked)).checked;

Finder _boxOf(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Row)).first,
  matching: find.byType(WeCheckbox),
);

void main() {
  testWidgets('点箭头展开，点行选中', (tester) async {
    String? selected;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => WeTree<String>(
            nodes: nodes,
            selected: selected,
            expandOnClickNode: false,
            onSelect: (v) => setState(() => selected = v),
          ),
        ),
      ),
    );
    expect(find.text('零食'), findsNothing);
    await tester.tap(find.byIcon(Icons.arrow_right_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('零食'), findsOneWidget);
    await tester.tap(find.text('零食'));
    await tester.pumpAndSettle();
    expect(selected, 'snack');
  });

  testWidgets('点父行既选中又展开 / 收起', (tester) async {
    await tester.pumpWidget(_app(const WeTree<String>(nodes: nodes)));
    await tester.tap(find.text('数码'));
    await tester.pumpAndSettle();
    expect(find.text('手机'), findsOneWidget);
    await tester.tap(find.text('数码'));
    await tester.pumpAndSettle();
    expect(find.text('手机'), findsNothing);
  });

  testWidgets('勾父节点连带子节点；全勾后父节点也在结果里', (tester) async {
    await tester.pumpWidget(_app(const _Checked()));
    await tester.tap(_boxOf('数码'));
    await tester.pump();
    expect(_checked(tester), {'digital', 'phone', 'audio'});

    await tester.tap(_boxOf('手机'));
    await tester.pump();
    expect(_checked(tester), {'audio'}, reason: '缺一个子节点，父节点退出');
  });

  testWidgets('禁用子节点不跟着勾；父节点半选，再点一次能取消', (tester) async {
    await tester.pumpWidget(_app(const _Checked()));
    await tester.tap(_boxOf('食品'));
    await tester.pump();
    expect(_checked(tester), {'snack'}, reason: '茶饮禁用，食品只能半选');

    await tester.tap(_boxOf('食品'));
    await tester.pump();
    expect(_checked(tester), isEmpty);
  });

  testWidgets('checkStrictly：父子互不影响', (tester) async {
    await tester.pumpWidget(_app(const _Checked(strict: true)));
    await tester.tap(_boxOf('数码'));
    await tester.pump();
    expect(_checked(tester), {'digital'});
  });

  testWidgets('toggleChecked 与组件内的联动一致', (tester) async {
    expect(WeTree.toggleChecked(nodes, <String>{}, 'digital', true), {
      'digital',
      'phone',
      'audio',
    });
    expect(
      WeTree.toggleChecked(
        nodes,
        {'digital', 'phone', 'audio'},
        'audio',
        false,
      ),
      {'phone'},
    );
    expect(WeTree.find(nodes, 'audio')?.label, '耳机音响');
  });

  testWidgets('filter 只留命中节点及其祖先，并高亮命中', (tester) async {
    await tester.pumpWidget(
      _app(const WeTree<String>(nodes: nodes, filter: '耳机')),
    );
    expect(find.text('数码'), findsOneWidget);
    expect(find.text('食品'), findsNothing);
    expect(find.text('家居'), findsNothing);
    expect(find.text('耳机音响', findRichText: true), findsOneWidget);
    expect(find.text('手机'), findsNothing);
  });

  testWidgets('filter 无结果时显示空提示', (tester) async {
    await tester.pumpWidget(
      _app(const WeTree<String>(nodes: nodes, filter: '不存在')),
    );
    expect(find.text('暂无数据'), findsOneWidget);
  });

  testWidgets('lazyLoad：展开时加载子节点，加载中显示转圈', (tester) async {
    final Completer<List<WeTreeNode<String>>> pending = Completer();
    final List<String> asked = [];
    await tester.pumpWidget(
      _app(
        WeTree<String>(
          nodes: const [
            WeTreeNode('region', '华东'),
            WeTreeNode('x', '末级', isLeaf: true),
          ],
          lazyLoad: (n) {
            asked.add(n.value);
            return pending.future;
          },
        ),
      ),
    );
    expect(
      find.byIcon(Icons.arrow_right_rounded),
      findsOneWidget,
      reason: 'isLeaf: true 的节点没有箭头',
    );
    await tester.tap(find.text('华东'));
    await tester.pump();
    expect(asked, ['region']);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    pending.complete(const [WeTreeNode('sh', '上海')]);
    await tester.pumpAndSettle();
    expect(find.text('上海'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('accordion：展开一个会收起同级', (tester) async {
    await tester.pumpWidget(
      _app(const WeTree<String>(nodes: nodes, accordion: true)),
    );
    await tester.tap(find.text('食品'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('数码'));
    await tester.pumpAndSettle();
    expect(find.text('手机'), findsOneWidget);
    expect(find.text('零食'), findsNothing);
  });

  testWidgets('键盘：↓ 移动、→ 展开并进入、← 回父级、Enter 选中、空格勾选', (tester) async {
    String? selected;
    Set<String> checked = {};
    final FocusNode focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => WeTree<String>(
            nodes: nodes,
            focusNode: focus,
            selected: selected,
            onSelect: (v) => setState(() => selected = v),
            showCheckbox: true,
            checked: checked,
            onCheck: (s) => setState(() => checked = s),
          ),
        ),
      ),
    );
    focus.requestFocus();
    await tester.pump();

    // 光标在 食品 → ↓ 数码 → → 展开 → → 进入 手机 → ↓ 耳机音响
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('手机'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(selected, 'audio');

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(checked, {'audio'});

    // ← 回到 数码，再 ← 收起
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(find.text('手机'), findsNothing);
  });
}
