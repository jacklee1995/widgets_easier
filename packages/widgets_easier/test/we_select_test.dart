import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

const _fruits = [
  WeSelectOption('apple', '苹果'),
  WeSelectOption('banana', '香蕉'),
  WeSelectOption('cherry', '樱桃', disabled: true),
  WeSelectOption('durian', '榴莲'),
];

/// Hosts a single select with its own state, like a real page would.
class _Single extends StatefulWidget {
  const _Single({this.filterable = false, this.groups = const []});

  final bool filterable;
  final List<WeSelectGroup<String>> groups;

  @override
  State<_Single> createState() => _SingleState();
}

class _SingleState extends State<_Single> {
  String? value;

  @override
  Widget build(BuildContext context) => WeSelect<String>(
    width: 240,
    value: value,
    hint: '请选择',
    clearable: true,
    filterable: widget.filterable,
    options: widget.groups.isEmpty ? _fruits : const [],
    groups: widget.groups,
    onChanged: (v) => setState(() => value = v),
  );
}

class _Multi extends StatefulWidget {
  const _Multi({this.limit = 0, this.collapse = false});

  final int limit;
  final bool collapse;

  @override
  State<_Multi> createState() => _MultiState();
}

class _MultiState extends State<_Multi> {
  Set<String> values = {};

  @override
  Widget build(BuildContext context) => WeSelect<String>.multiple(
    width: 280,
    values: values,
    hint: '多选',
    multipleLimit: widget.limit,
    collapseTags: widget.collapse,
    filterable: true,
    options: _fruits,
    onChanged: (v) => setState(() => values = v),
  );
}

void main() {
  testWidgets('单选：打开、选择、关闭并显示标签', (tester) async {
    await tester.pumpWidget(_app(const _Single()));
    expect(find.text('请选择'), findsOneWidget);

    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(find.text('香蕉'), findsOneWidget);

    await tester.tap(find.text('香蕉'));
    await tester.pumpAndSettle();
    expect(find.text('香蕉'), findsOneWidget);
    expect(find.text('苹果'), findsNothing);
  });

  testWidgets('禁用选项点了没反应', (tester) async {
    await tester.pumpWidget(_app(const _Single()));
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('樱桃'));
    await tester.pumpAndSettle();
    expect(find.text('苹果'), findsOneWidget, reason: '面板仍然打开');
  });

  testWidgets('nullable T：值为 null 的"全部"选项也显示标签', (tester) async {
    await tester.pumpWidget(
      _app(
        WeSelect<int?>(
          width: 200,
          value: null,
          options: const [WeSelectOption(null, '全部'), WeSelectOption(1, '一')],
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.text('全部'), findsOneWidget);
  });

  testWidgets('键盘：↓ 打开，↓ 跳过禁用项，Enter 选中', (tester) async {
    await tester.pumpWidget(_app(const _Single()));
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(find.text('苹果'), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(find.text('苹果'), findsOneWidget);

    // 高亮从苹果开始：↓ 香蕉，↓ 跳过樱桃到榴莲。
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('榴莲'), findsOneWidget);
    expect(find.text('苹果'), findsNothing);
  });

  testWidgets('可搜索：输入后只剩匹配项，无匹配时提示', (tester) async {
    await tester.pumpWidget(_app(const _Single(filterable: true)));
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '香');
    await tester.pumpAndSettle();
    expect(find.text('香蕉'), findsOneWidget);
    expect(find.text('苹果'), findsNothing);

    await tester.enterText(find.byType(TextField), '西瓜');
    await tester.pumpAndSettle();
    expect(find.text('无匹配数据'), findsOneWidget);
  });

  testWidgets('桌面端：多选点选项后面板不因搜索框失焦而关闭', (tester) async {
    await tester.pumpWidget(_app(const _Multi()));
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('香蕉'));
    await tester.pumpAndSettle();
    expect(find.text('苹果'), findsOneWidget, reason: '面板仍然打开');
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  testWidgets('分组：显示组标题，搜索时空组被隐藏', (tester) async {
    await tester.pumpWidget(
      _app(
        const _Single(
          filterable: true,
          groups: [
            WeSelectGroup('水果', [WeSelectOption('apple', '苹果')]),
            WeSelectGroup('蔬菜', [WeSelectOption('leek', '韭菜')]),
          ],
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(find.text('水果'), findsOneWidget);
    expect(find.text('蔬菜'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '韭');
    await tester.pumpAndSettle();
    expect(find.text('水果'), findsNothing);
    expect(find.text('韭菜'), findsOneWidget);
  });

  testWidgets('多选：选中后面板不关，出现标签，点 × 移除', (tester) async {
    await tester.pumpWidget(_app(const _Multi()));
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    await tester.tap(find.text('苹果'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('香蕉').last);
    await tester.pumpAndSettle();
    // 字段里的标签 + 面板里的选项。
    expect(find.text('苹果'), findsNWidgets(2));
    expect(find.text('香蕉'), findsNWidgets(2));

    await tester.tapAt(const Offset(700, 500));
    await tester.pumpAndSettle();
    expect(find.text('苹果'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('苹果'), findsNothing);
    expect(find.text('香蕉'), findsOneWidget);
  });

  testWidgets('多选：multipleLimit 到上限后其余选项不可选', (tester) async {
    await tester.pumpWidget(_app(const _Multi(limit: 1)));
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('苹果'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('香蕉'));
    await tester.pumpAndSettle();
    expect(find.text('香蕉'), findsOneWidget, reason: '只在面板里，没有成为标签');
  });

  testWidgets('多选：collapseTags 显示 +N', (tester) async {
    await tester.pumpWidget(_app(const _Multi(collapse: true)));
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('苹果'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('香蕉').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('榴莲').last);
    await tester.pumpAndSettle();
    expect(find.text('+ 2'), findsOneWidget);
  });

  testWidgets('远程搜索：加载中 → 结果，选中后标签保留', (tester) async {
    String? value;
    final List<String> queries = [];
    Completer<List<WeSelectOption<String>>>? pending;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => WeSelect<String>(
            width: 240,
            value: value,
            hint: '搜索用户',
            remoteMethod: (q) {
              queries.add(q);
              pending = Completer();
              return pending!.future;
            },
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    );
    await tester.tap(find.text('搜索用户'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('加载中'), findsOneWidget);
    expect(queries, ['']);
    pending!.complete(const []);
    await tester.pumpAndSettle();
    expect(find.text('无数据'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '张');
    await tester.pump(const Duration(milliseconds: 350));
    expect(queries.last, '张');
    pending!.complete(const [WeSelectOption('u1', '张三')]);
    await tester.pumpAndSettle();

    await tester.tap(find.text('张三'));
    await tester.pumpAndSettle();
    expect(value, 'u1');
    expect(find.text('张三'), findsOneWidget);
  });

  testWidgets('WeDropdown：点击打开，选中回调并关闭', (tester) async {
    String? picked;
    await tester.pumpWidget(
      _app(
        WeDropdown<String>(
          items: const [
            WeDropdownItem('edit', '编辑'),
            WeDropdownItem(
              'del',
              '删除',
              divided: true,
              type: SemanticEnum.danger,
            ),
          ],
          onSelected: (v) => picked = v,
          child: const Text('更多'),
        ),
      ),
    );
    await tester.tap(find.text('更多'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();
    expect(picked, 'del');
    expect(find.text('编辑'), findsNothing);
  });

  testWidgets('WeDropdown.builder：按钮 onPressed 打开', (tester) async {
    await tester.pumpWidget(
      _app(
        WeDropdown<String>.builder(
          items: const [WeDropdownItem('a', '选项 A')],
          builder: (context, open) => WeButton(text: '操作', onPressed: open),
        ),
      ),
    );
    await tester.tap(find.text('操作'));
    await tester.pumpAndSettle();
    expect(find.text('选项 A'), findsOneWidget);
  });
}
