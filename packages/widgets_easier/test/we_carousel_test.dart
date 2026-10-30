import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('箭头切换、onChanged 回调', (tester) async {
    var index = 0;
    await tester.pumpWidget(
      _app(
        WeCarousel(
          autoplay: false,
          arrow: WeCarouselArrow.always,
          onChanged: (i) => index = i,
          children: const [
            ColoredBox(color: Colors.red, child: Text('一')),
            ColoredBox(color: Colors.blue, child: Text('二')),
            ColoredBox(color: Colors.green, child: Text('三')),
          ],
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(index, 1);
    expect(find.text('二'), findsOneWidget);
  });
}
