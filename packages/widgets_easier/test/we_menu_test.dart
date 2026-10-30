import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

const _entries = <WeMenuEntry>[
  WeMenuItem('home', 'Home', icon: Icons.home_outlined),
  WeMenuGroup(
    'Trade',
    children: [
      WeSubMenu(
        'goods',
        'Goods',
        icon: Icons.inventory_2_outlined,
        children: [
          WeMenuItem('list', 'All goods'),
          WeMenuItem('stock', 'Low stock', badge: 12),
        ],
      ),
      WeSubMenu(
        'orders',
        'Orders',
        icon: Icons.receipt_long_outlined,
        children: [
          WeMenuItem('all', 'All orders'),
          WeMenuItem('refund', 'Refunds', disabled: true),
        ],
      ),
    ],
  ),
];

Widget _host(Widget child, {double width = 240}) => MaterialApp(
  theme: ThemeData.light().copyWith(extensions: const [WeTheme.light()]),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, height: 600, child: child),
    ),
  ),
);

void main() {
  testWidgets('tapping an item reports its id', (tester) async {
    final picked = <String>[];
    await tester.pumpWidget(
      _host(WeMenu(entries: _entries, onSelect: picked.add)),
    );
    await tester.tap(find.text('Home'));
    expect(picked, ['home']);
  });

  testWidgets('sub-menus are closed until tapped, then reveal children', (
    tester,
  ) async {
    await tester.pumpWidget(_host(WeMenu(entries: _entries, onSelect: (_) {})));
    expect(find.text('All goods'), findsNothing);

    await tester.tap(find.text('Goods'));
    await tester.pumpAndSettle();
    expect(find.text('All goods'), findsOneWidget);

    await tester.tap(find.text('Goods'));
    await tester.pumpAndSettle();
    expect(find.text('All goods'), findsNothing);
  });

  testWidgets('the branch holding the selection opens by itself', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(WeMenu(entries: _entries, selectedId: 'stock', onSelect: (_) {})),
    );
    await tester.pumpAndSettle();
    expect(find.text('Low stock'), findsOneWidget);
    expect(find.text('All orders'), findsNothing);

    // A selection pushed from outside opens its branch too.
    await tester.pumpWidget(
      _host(WeMenu(entries: _entries, selectedId: 'all', onSelect: (_) {})),
    );
    await tester.pumpAndSettle();
    expect(find.text('All orders'), findsOneWidget);
  });

  testWidgets('uniqueOpened keeps a single top-level branch open', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        WeMenu(
          entries: _entries,
          uniqueOpened: true,
          defaultOpenIds: const {'goods'},
          onSelect: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('All goods'), findsOneWidget);

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(find.text('All orders'), findsOneWidget);
    expect(find.text('All goods'), findsNothing);
  });

  testWidgets('controlled open state is reported, not applied', (tester) async {
    Set<String>? reported;
    await tester.pumpWidget(
      _host(
        WeMenu(
          entries: _entries,
          openIds: const {},
          onOpenChanged: (ids) => reported = ids,
          onSelect: (_) {},
        ),
      ),
    );
    await tester.tap(find.text('Goods'));
    await tester.pumpAndSettle();
    expect(reported, {'goods'});
    expect(find.text('All goods'), findsNothing);
  });

  testWidgets('a disabled item does not fire onSelect', (tester) async {
    final picked = <String>[];
    await tester.pumpWidget(
      _host(
        WeMenu(
          entries: _entries,
          defaultOpenIds: const {'orders'},
          onSelect: picked.add,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Refunds'));
    expect(picked, isEmpty);
  });

  testWidgets('collapsed mode shows icons only', (tester) async {
    await tester.pumpWidget(
      _host(
        WeMenu(entries: _entries, collapsed: true, onSelect: (_) {}),
        width: 64,
      ),
    );
    expect(find.text('Home'), findsNothing);
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(find.byType(Tooltip), findsWidgets);
  });

  testWidgets('a squeezed menu drops labels instead of overflowing', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(WeMenu(entries: _entries, onSelect: (_) {}), width: 80),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('Enter on a focused item selects it', (tester) async {
    final picked = <String>[];
    await tester.pumpWidget(
      _host(WeMenu(entries: _entries, onSelect: picked.add)),
    );
    await tester.pump();
    // The first tile is the first focusable in the scope.
    FocusManager.instance.primaryFocus?.nextFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(picked, ['home']);
  });
}
