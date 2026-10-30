import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('标题、说明和返回', (tester) async {
    var back = 0;
    await tester.pumpWidget(
      _app(
        WePageHeader(
          title: '经营概览',
          description: '延迟 5 分钟',
          onBack: () => back++,
        ),
      ),
    );
    expect(find.text('经营概览'), findsOneWidget);
    expect(find.text('延迟 5 分钟'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    expect(back, 1);
  });
}
