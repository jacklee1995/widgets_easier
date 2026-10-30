import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('loading 为 true 时出现文字并挡住点击', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(
        WeLoading(
          loading: true,
          text: '保存中',
          child: TextButton(onPressed: () => taps++, child: const Text('点我')),
        ),
      ),
    );
    expect(find.text('保存中'), findsOneWidget);
    await tester.tap(find.text('点我'), warnIfMissed: false);
    expect(taps, 0);
  });

  testWidgets('loading 为 false 时不挡点击', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(
        WeLoading(
          loading: false,
          text: '保存中',
          child: TextButton(onPressed: () => taps++, child: const Text('点我')),
        ),
      ),
    );
    await tester.tap(find.text('点我'));
    expect(taps, 1);
  });

  testWidgets('service 全屏遮罩，close 后消失', (tester) async {
    late WeLoadingHandle handle;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => handle = WeLoading.service(context, text: '同步渠道'),
            child: const Text('开'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('开'));
    await tester.pump();
    expect(find.text('同步渠道'), findsOneWidget);
    handle.close();
    await tester.pump();
    expect(find.text('同步渠道'), findsNothing);
    handle.close();
    expect(handle.isClosed, isTrue, reason: '重复 close 不抛异常');
  });

  testWidgets('空闲时没有转圈动画，pumpAndSettle 能结束', (tester) async {
    await tester.pumpWidget(_app(const WeLoading(child: Text('表格'))));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('loading 切回 false 后遮罩淡出并移除', (tester) async {
    var busy = true;
    late StateSetter set;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return WeLoading(loading: busy, child: const Text('表格'));
          },
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    set(() => busy = false);
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('WeTable：无数据时骨架屏，有数据时保留行并盖遮罩', (tester) async {
    Widget table(List<String> rows) => _app(
      WeTable<String>(
        rows: rows,
        loading: true,
        loadingText: '刷新中',
        columns: [WeColumn.text('名称', (r) => r)],
      ),
    );
    await tester.pumpWidget(table(const []));
    expect(find.byType(WeSkeleton), findsWidgets);
    expect(find.text('刷新中'), findsNothing);

    await tester.pumpWidget(table(const ['苹果']));
    expect(find.byType(WeSkeleton), findsNothing);
    expect(find.text('苹果'), findsOneWidget);
    expect(find.text('刷新中'), findsOneWidget);
  });

  testWidgets('lock: false 时遮罩下仍可点击', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(
        WeLoading(
          loading: true,
          lock: false,
          child: TextButton(onPressed: () => taps++, child: const Text('点我')),
        ),
      ),
    );
    await tester.tap(find.text('点我'));
    expect(taps, 1);
  });
}
