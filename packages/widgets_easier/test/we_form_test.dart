import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

class _Page extends StatefulWidget {
  const _Page({required this.form, this.nameValidator, this.disabled = false});

  final WeFormController form;
  final WeValidator? nameValidator;
  final bool disabled;

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  String name = '';
  String? category;
  Set<String> tags = {};
  final TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) => WeForm(
    controller: widget.form,
    labelWidth: 90,
    disabled: widget.disabled,
    children: [
      WeFormItem(
        name: 'name',
        label: '名称',
        value: name,
        rules: [
          const WeRule(required: true),
          const WeRule(min: 2, max: 8, trigger: WeRuleTrigger.blur),
          if (widget.nameValidator != null)
            WeRule(
              validator: widget.nameValidator,
              trigger: WeRuleTrigger.submit,
            ),
        ],
        onReset: () => setState(() => name = ''),
        child: WeInput(
          key: const Key('name'),
          onChanged: (v) => setState(() => name = v),
        ),
      ),
      WeFormItem(
        name: 'category',
        label: '分类',
        value: category,
        rules: const [WeRule(required: true, message: '请选择分类')],
        child: WeSelect<String>(
          value: category,
          options: const [WeSelectOption('a', '服装'), WeSelectOption('b', '数码')],
          onChanged: (v) => setState(() => category = v),
        ),
      ),
      WeFormItem(
        name: 'tags',
        label: '标签',
        value: tags,
        rules: const [WeRule(max: 2)],
        child: WeSelect<String>.multiple(
          values: tags,
          options: const [
            WeSelectOption('x', '新品'),
            WeSelectOption('y', '热卖'),
            WeSelectOption('z', '包邮'),
          ],
          onChanged: (v) => setState(() => tags = v),
        ),
      ),
      WeFormItem(
        name: 'price',
        label: '价格',
        valueGetter: () => price.text,
        rules: [
          WeRule(pattern: RegExp(r'^\d+(\.\d{1,2})?$'), message: '价格格式不对'),
        ],
        child: WeInput(key: const Key('price'), controller: price),
      ),
    ],
  );
}

void main() {
  testWidgets('WeRule.check：必填、长度、数值、数量、正则、自定义', (tester) async {
    expect(await const WeRule(required: true).check('', label: '名称'), '请填写名称');
    expect(await const WeRule(min: 2).check('a'), '长度不能少于 2 个字符');
    expect(await const WeRule(max: 3).check('abcd'), '长度不能超过 3 个字符');
    expect(await const WeRule(min: 10).check(5), '不能小于 10');
    expect(await const WeRule(max: 1).check({1, 2}), '最多选择 1 项');
    expect(await WeRule(pattern: RegExp(r'^\d+$')).check('x1'), '格式不正确');
    expect(await const WeRule(min: 2).check(''), isNull, reason: '非必填的空值跳过');
    expect(
      await WeRule(
        validator: (v) async => v == 'taken' ? '已被占用' : null,
      ).check('taken'),
      '已被占用',
    );
  });

  testWidgets('validate() 显示所有错误并返回 false；改正后返回 true', (tester) async {
    final form = WeFormController();
    await tester.pumpWidget(_app(_Page(form: form)));

    expect(await form.validate(), isFalse);
    await tester.pumpAndSettle();
    expect(find.text('请填写名称'), findsOneWidget);
    expect(find.text('请选择分类'), findsOneWidget);
    expect(find.text('*'), findsNWidgets(2));

    await tester.enterText(find.byKey(const Key('name')), '夏季T恤');
    await tester.pumpAndSettle();
    expect(find.text('请填写名称'), findsNothing, reason: 'change 规则随输入重新校验');

    await tester.tap(find.byType(WeSelect<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('数码'));
    await tester.pumpAndSettle();
    expect(find.text('请选择分类'), findsNothing);

    expect(await form.validate(), isTrue);
  });

  testWidgets('blur 规则在失焦时才校验', (tester) async {
    final form = WeFormController();
    await tester.pumpWidget(_app(_Page(form: form)));

    await tester.enterText(find.byKey(const Key('name')), 'a');
    await tester.pumpAndSettle();
    expect(find.text('长度不能少于 2 个字符'), findsNothing);

    await tester.tap(find.byKey(const Key('price')));
    await tester.pumpAndSettle();
    expect(find.text('长度不能少于 2 个字符'), findsOneWidget);
  });

  testWidgets('valueGetter：控制器驱动的输入也能随输入校验', (tester) async {
    final form = WeFormController();
    await tester.pumpWidget(_app(_Page(form: form)));
    await tester.enterText(find.byKey(const Key('price')), '12.345');
    await tester.pumpAndSettle();
    expect(find.text('价格格式不对'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('price')), '12.34');
    await tester.pumpAndSettle();
    expect(find.text('价格格式不对'), findsNothing);
  });

  testWidgets('多选数量上限走 max 规则', (tester) async {
    final form = WeFormController();
    await tester.pumpWidget(_app(_Page(form: form)));
    await tester.tap(find.byType(WeSelect<String>).last);
    await tester.pumpAndSettle();
    for (final label in ['新品', '热卖', '包邮']) {
      await tester.tap(find.text(label).last);
      await tester.pumpAndSettle();
    }
    expect(find.text('最多选择 2 项'), findsOneWidget);
  });

  testWidgets('异步 validator：validate 等待结果', (tester) async {
    final form = WeFormController();
    final gate = Completer<String?>();
    await tester.pumpWidget(
      _app(_Page(form: form, nameValidator: (_) => gate.future)),
    );
    await tester.enterText(find.byKey(const Key('name')), '重名商品');
    await tester.pumpAndSettle();

    bool? ok;
    unawaited(form.validateField('name').then((v) => ok = v));
    await tester.pump();
    expect(ok, isNull);

    gate.complete('名称已存在');
    await tester.pumpAndSettle();
    expect(ok, isFalse);
    expect(find.text('名称已存在'), findsOneWidget);
  });

  testWidgets('resetFields 恢复初始值且不立刻报错；clearValidate 只清错误', (tester) async {
    final form = WeFormController();
    await tester.pumpWidget(_app(_Page(form: form)));
    await tester.enterText(find.byKey(const Key('name')), '临时');
    await tester.pumpAndSettle();

    await form.validate();
    await tester.pumpAndSettle();
    expect(find.text('请选择分类'), findsOneWidget);

    form.clearValidate(['category']);
    await tester.pumpAndSettle();
    expect(find.text('请选择分类'), findsNothing);

    form.resetFields();
    await tester.pumpAndSettle();
    expect(find.text('请填写名称'), findsNothing, reason: '重置后的值变化不触发校验');
    expect(
      tester.state<WeFormItemState>(find.byType(WeFormItem).first).error,
      isNull,
    );
  });

  testWidgets('错误态染红 WeInput 边框；disabled 透传给字段', (tester) async {
    final form = WeFormController();
    await tester.pumpWidget(_app(_Page(form: form, disabled: true)));
    await tester.tap(find.byType(WeSelect<String>).first);
    await tester.pumpAndSettle();
    expect(find.text('服装'), findsNothing, reason: '表单禁用时下拉打不开');

    await tester.pumpWidget(_app(_Page(form: form)));
    await form.validate();
    await tester.pumpAndSettle();
    final colors = tester.element(find.byType(WeForm)).weColors;
    final box = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byKey(const Key('name')),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final border = (box.decoration! as BoxDecoration).border! as Border;
    expect(border.top.color, colors.danger);
  });
}
