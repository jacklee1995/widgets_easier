import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier_privacy_guard_example/main.dart';

void main() {
  testWidgets('the example shows its controls', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pump();
    expect(find.text('4111 1111 1111 1111'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsWidgets);
  });
}
