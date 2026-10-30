import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

const List<WeTabbarItem> _items = [
  WeTabbarItem('首页', Icons.home_outlined, activeIcon: Icons.home),
  WeTabbarItem('分类', Icons.grid_view_outlined),
  WeTabbarItem('消息', Icons.chat_bubble_outline, badge: 120),
  WeTabbarItem('我的', Icons.person_outline, dot: true),
];

Widget _app(Widget bar, {double bottom = 0}) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(padding: EdgeInsets.only(bottom: bottom)),
      child: Scaffold(body: const SizedBox.expand(), bottomNavigationBar: bar),
    ),
  ),
);

class _Host extends StatefulWidget {
  const _Host({this.safeArea = true});

  final bool safeArea;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  int index = 0;
  int reselected = 0;

  @override
  Widget build(BuildContext context) => WeTabbar(
    items: _items,
    index: index,
    safeArea: widget.safeArea,
    onChanged: (i) => setState(() => index = i),
    onReselect: (_) => reselected++,
  );
}

void main() {
  testWidgets('tapping an item selects it; tapping it again reselects', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const _Host()));
    final _HostState host = tester.state(find.byType(_Host));
    expect(find.byIcon(Icons.home), findsOneWidget, reason: 'active icon');

    await tester.tap(find.text('分类'));
    await tester.pumpAndSettle();
    expect(host.index, 1);
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(host.reselected, 0);

    await tester.tap(find.text('分类'));
    await tester.pump();
    expect(host.index, 1);
    expect(host.reselected, 1);
  });

  testWidgets('counts and dots show in the corner', (tester) async {
    await tester.pumpWidget(_app(const _Host()));
    expect(find.text('99+'), findsOneWidget);
    final Finder mine = find.ancestor(
      of: find.byIcon(Icons.person_outline),
      matching: find.byType(WeBadge),
    );
    expect(tester.widget<WeBadge>(mine).dot, isTrue);
  });

  testWidgets('items share the width and are at least 48 tall', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app(const _Host()));
    final Size bar = tester.getSize(find.byType(WeTabbar));
    expect(bar.width, 390);
    for (final label in ['首页', '分类', '消息', '我的']) {
      final Rect cell = tester.getRect(
        find.ancestor(of: find.text(label), matching: find.byType(InkWell)),
      );
      expect(cell.width, closeTo(390 / 4, 0.5), reason: label);
      expect(cell.height, greaterThanOrEqualTo(48), reason: label);
    }
  });

  testWidgets('the bottom safe area is added below the items', (tester) async {
    await tester.pumpWidget(_app(const _Host(), bottom: 34));
    final double padded = tester.getSize(find.byType(WeTabbar)).height;
    await tester.pumpWidget(_app(const _Host(safeArea: false), bottom: 34));
    final double bare = tester.getSize(find.byType(WeTabbar)).height;
    expect(padded - bare, 34);
  });

  testWidgets('screen readers hear a selected tab and its position', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app(const _Host()));
    expect(
      tester.getSemantics(find.text('首页')),
      matchesSemantics(
        label: '首页',
        hint: '1 / 4',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });
}
