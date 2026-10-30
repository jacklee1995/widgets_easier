import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

void main() {
  testWidgets('SemanticButton renders its text and reacts to taps', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SemanticButton(text: 'Click me', onTap: () => taps++),
          ),
        ),
      ),
    );

    expect(find.text('Click me'), findsOneWidget);
    await tester.tap(find.text('Click me'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('Tag renders its text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Tag('hello'))),
    );
    expect(find.text('hello'), findsOneWidget);
  });

  test('findStatusColor maps every SemanticEnum value', () {
    for (final type in SemanticEnum.values) {
      expect(findStatusColor(type), isA<Color>());
    }
  });
}
