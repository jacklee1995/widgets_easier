import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _host(void Function(BuildContext context) onTap) {
  return MaterialApp(
    theme: ThemeData(extensions: const [WeTheme.light()]),
    home: Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () => onTap(context),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

/// 拖标题栏。标题栏走的是原始指针事件，没有 touch slop，给多少走多少。
Future<void> _dragBy(WidgetTester tester, String title, Offset delta) async {
  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text(title)),
  );
  await gesture.moveBy(delta);
  await gesture.up();
  await tester.pumpAndSettle();
}

/// 弹窗面板的左上角，用来判断有没有被拖动。
Offset _panelTopLeft(WidgetTester tester, String title) {
  final Finder panel = find.ancestor(
    of: find.text(title),
    matching: find.byType(Material),
  );
  return tester.getTopLeft(panel.last);
}

void main() {
  group('WeDialog', () {
    testWidgets('渲染标题、正文和按钮，并把结果 pop 回去', (tester) async {
      String? result;

      await tester.pumpWidget(
        _host((context) async {
          result = await WeDialog.show<String>(
            context,
            title: '发布商品',
            child: const Text('弹窗正文'),
            actions: (context) => [
              WeButton(
                text: '提交',
                onPressed: () => Navigator.of(context).pop('done'),
              ),
            ],
          );
        }),
      );
      await _open(tester);

      expect(find.text('发布商品'), findsOneWidget);
      expect(find.text('弹窗正文'), findsOneWidget);

      await tester.tap(find.text('提交'));
      await tester.pumpAndSettle();

      expect(result, 'done');
      expect(find.text('弹窗正文'), findsNothing);
    });

    testWidgets('关闭按钮和 Esc 都能收起弹窗', (tester) async {
      await tester.pumpWidget(
        _host(
          (context) => WeDialog.show<void>(
            context,
            title: '标题',
            child: const Text('内容'),
          ),
        ),
      );

      await _open(tester);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(find.text('内容'), findsNothing);

      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('内容'), findsNothing);
    });

    testWidgets('closeOnClickModal 决定点遮罩关不关', (tester) async {
      await tester.pumpWidget(
        _host(
          (context) => WeDialog.show<void>(
            context,
            title: '标题',
            closeOnClickModal: false,
            child: const Text('内容'),
          ),
        ),
      );
      await _open(tester);

      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();
      expect(find.text('内容'), findsOneWidget);
    });

    testWidgets('拖动标题栏可以移动弹窗，双击复位', (tester) async {
      await tester.pumpWidget(
        _host(
          (context) => WeDialog.show<void>(
            context,
            title: '可拖动',
            child: const Text('内容'),
          ),
        ),
      );
      await _open(tester);

      final Offset before = _panelTopLeft(tester, '可拖动');
      await _dragBy(tester, '可拖动', const Offset(80, 40));

      final Offset after = _panelTopLeft(tester, '可拖动');
      expect(after - before, const Offset(80, 40));

      // 双击标题栏回到初始位置。
      await tester.tap(find.text('可拖动'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('可拖动'));
      await tester.pumpAndSettle();
      expect(_panelTopLeft(tester, '可拖动'), before);
    });

    testWidgets('拖到屏幕外时留出一截，不会彻底跑丢', (tester) async {
      await tester.pumpWidget(
        _host(
          (context) => WeDialog.show<void>(
            context,
            title: '可拖动',
            child: const Text('内容'),
          ),
        ),
      );
      await _open(tester);

      await _dragBy(tester, '可拖动', const Offset(4000, 4000));

      final Size screen =
          tester.view.physicalSize / tester.view.devicePixelRatio;
      final Offset topLeft = _panelTopLeft(tester, '可拖动');
      expect(topLeft.dx, lessThan(screen.width));
      expect(topLeft.dy, lessThan(screen.height));
      expect(find.text('可拖动'), findsOneWidget);
    });

    testWidgets('draggable: false 时标题栏不再响应拖动', (tester) async {
      await tester.pumpWidget(
        _host(
          (context) => WeDialog.show<void>(
            context,
            title: '固定',
            draggable: false,
            child: const Text('内容'),
          ),
        ),
      );
      await _open(tester);

      final Offset before = _panelTopLeft(tester, '固定');
      await _dragBy(tester, '固定', const Offset(80, 40));

      expect(_panelTopLeft(tester, '固定'), before);
    });
  });

  group('WeMessageBox', () {
    testWidgets('confirm 确认返回 true，取消返回 false', (tester) async {
      bool? answer;

      await tester.pumpWidget(
        _host((context) async {
          answer = await WeMessageBox.confirm(context, '确认删除？');
        }),
      );

      await _open(tester);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(answer, isFalse);

      await _open(tester);
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(answer, isTrue);
    });

    testWidgets('alert 被遮罩之外的方式关掉时返回 false', (tester) async {
      bool? answer;

      await tester.pumpWidget(
        _host((context) async {
          answer = await WeMessageBox.alert(context, '导出完成');
        }),
      );
      await _open(tester);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(find.text('导出完成'), findsNothing);
      expect(answer, isFalse);
    });

    testWidgets('prompt 校验不过时按钮禁用，通过后返回输入', (tester) async {
      String? name;

      await tester.pumpWidget(
        _host((context) async {
          name = await WeMessageBox.prompt(
            context,
            '起个名字',
            validator: (v) => v.trim().isEmpty ? '不能为空' : null,
          );
        }),
      );
      await _open(tester);

      // 空值时确定不可点，弹窗还在。
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(find.text('起个名字'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '双十一券包');
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();

      expect(name, '双十一券包');
    });
  });

  group('WinStyleDialog', () {
    testWidgets('标题栏可拖动，关闭按钮收起弹窗', (tester) async {
      await tester.pumpWidget(
        _host(
          (context) =>
              WinDialogs.show<void>(context, title: '导出订单', text: '导出为 CSV。'),
        ),
      );
      await _open(tester);

      final Offset before = _panelTopLeft(tester, '导出订单');
      await _dragBy(tester, '导出订单', const Offset(-60, 30));
      expect(_panelTopLeft(tester, '导出订单') - before, const Offset(-60, 30));

      await tester.tap(find.byType(WinCloseButton));
      await tester.pumpAndSettle();
      expect(find.text('导出订单'), findsNothing);
    });
  });
}
