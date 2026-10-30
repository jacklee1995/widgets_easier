import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _host(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme,
  home: Scaffold(body: Center(child: child)),
);

TextField _field(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField));

TextEditingController _text(WidgetTester tester) => _field(tester).controller!;

/// Types [text] with the caret left at [caret], the way a keyboard would.
Future<void> _type(
  WidgetTester tester,
  String text, {
  required int caret,
}) async {
  tester.testTextInput.updateEditingValue(
    TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: caret),
    ),
  );
  await tester.pump();
}

void main() {
  group('lifecycle', () {
    testWidgets('long-pressing a disabled counter does not throw', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const CounterInput(enabled: false)));
      await tester.longPress(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the repeat timer stops when the widget is disposed mid-press',
      (tester) async {
        await tester.pumpWidget(_host(const CounterInput(maxValue: 1e9)));
        await tester.startGesture(tester.getCenter(find.byIcon(Icons.add)));
        await tester.pump(const Duration(milliseconds: 800));
        await tester.pump(const Duration(milliseconds: 300));

        // Navigate away without ever lifting the finger.
        await tester.pumpWidget(_host(const SizedBox()));
        await tester.pump(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('an externally owned controller survives the widget', (
      tester,
    ) async {
      final controller = CounterInputController(initialValue: 4);
      addTearDown(controller.dispose);

      await tester.pumpWidget(_host(CounterInput(controller: controller)));
      await tester.pumpWidget(_host(const SizedBox()));

      expect(() => controller.setValue(9), returnsNormally);
      expect(controller.textController.text, '9');
    });

    test('the controller disposes its text controller', () {
      final controller = CounterInputController()..dispose();
      expect(
        () => controller.textController.text = '1',
        throwsA(isA<FlutterError>()),
      );
    });
  });

  group('stepping', () {
    testWidgets('fractional steps do not drift', (tester) async {
      final values = <double>[];
      await tester.pumpWidget(
        _host(
          CounterInput(
            step: 0.1,
            maxValue: 1,
            onValueChanged: (_, value) => values.add(value),
          ),
        ),
      );

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }
      expect(values, <double>[0.1, 0.2, 0.3]);
      expect(_text(tester).text, '0.3');
    });

    testWidgets('onMax fires once on a fractional bound, then overflows', (
      tester,
    ) async {
      var maxHits = 0;
      var overflowHits = 0;
      await tester.pumpWidget(
        _host(
          CounterInput(
            step: 0.1,
            maxValue: 0.3,
            onMax: () => maxHits++,
            onMaxOverflow: () => overflowHits++,
          ),
        ),
      );

      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }
      expect(maxHits, 1);
      expect(overflowHits, 1);
    });

    testWidgets('holding a button repeats and stops at the bound', (
      tester,
    ) async {
      var overflowHits = 0;
      await tester.pumpWidget(
        _host(CounterInput(maxValue: 3, onMaxOverflow: () => overflowHits++)),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byIcon(Icons.add)),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(seconds: 2));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(_text(tester).text, '3');
      // The bound is announced once, not on every tick of the held button.
      expect(overflowHits, 1);
    });

    testWidgets('arrow keys step the value', (tester) async {
      await tester.pumpWidget(_host(const CounterInput(minValue: -5)));
      await tester.tap(find.byType(TextField));
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(_text(tester).text, '1');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(_text(tester).text, '-1');
    });
  });

  group('typing', () {
    testWidgets('the caret stays where the user put it', (tester) async {
      await tester.pumpWidget(_host(const CounterInput(maxValue: 9999)));
      await tester.tap(find.byType(TextField));
      await tester.pump();

      await _type(tester, '123', caret: 3);
      await _type(tester, '1923', caret: 2);

      expect(_text(tester).text, '1923');
      expect(_text(tester).selection.baseOffset, 2);
    });

    testWidgets('out-of-range input is only clamped on submit', (tester) async {
      await tester.pumpWidget(
        _host(const CounterInput(minValue: 10, maxValue: 20)),
      );
      await tester.tap(find.byType(TextField));
      await tester.pump();

      // "1" is below the minimum but has to survive so that "15" is reachable.
      await _type(tester, '1', caret: 1);
      expect(_text(tester).text, '1');
      await _type(tester, '15', caret: 2);
      expect(_text(tester).text, '15');

      await _type(tester, '150', caret: 3);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(_text(tester).text, '20');
    });

    testWidgets('clearing the field does not snap to the minimum', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const CounterInput(minValue: 3, maxValue: 30)),
      );
      await tester.tap(find.byType(TextField));
      await tester.pump();

      await _type(tester, '', caret: 0);
      expect(_text(tester).text, '');

      await _type(tester, '2', caret: 1);
      await _type(tester, '25', caret: 2);
      expect(_text(tester).text, '25');
    });

    testWidgets('a negative minimum makes negative input possible', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const CounterInput(minValue: -10)));
      await tester.enterText(find.byType(TextField), '-5');
      await tester.pump();
      expect(_text(tester).text, '-5');
    });

    testWidgets('a non-negative range rejects the minus sign', (tester) async {
      await tester.pumpWidget(_host(const CounterInput()));
      await tester.enterText(find.byType(TextField), '-5');
      await tester.pump();
      expect(_text(tester).text, isNot(startsWith('-')));
    });

    testWidgets('malformed input is rejected rather than patched up', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const CounterInput(step: 0.01, maxValue: 50)),
      );
      await tester.tap(find.byType(TextField));
      await tester.pump();

      await _type(tester, '1.2', caret: 3);
      await _type(tester, '1.2.3', caret: 5);
      expect(_text(tester).text, '1.2');
    });

    testWidgets('blurring normalises the displayed value', (tester) async {
      await tester.pumpWidget(_host(const CounterInput(maxValue: 999)));
      await tester.tap(find.byType(TextField));
      await tester.pump();

      await _type(tester, '007', caret: 3);
      expect(_text(tester).text, '007');

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(_text(tester).text, '6');
    });
  });

  group('theming', () {
    testWidgets('colours come from WeTheme', (tester) async {
      await tester.pumpWidget(
        _host(
          const CounterInput(type: SemanticEnum.success),
          theme: ThemeData.dark().copyWith(
            extensions: const <ThemeExtension<dynamic>>[WeTheme.dark()],
          ),
        ),
      );

      const colors = WeColorScheme.dark();
      expect(_field(tester).style?.color, colors.primaryText);

      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();
      final add = icons.firstWhere((icon) => icon.icon == Icons.add);
      expect(add.color, colors.onSemantic);

      // At the lower bound the minus glyph is dimmed instead of vanishing.
      final remove = icons.firstWhere((icon) => icon.icon == Icons.remove);
      expect(remove.color!.a, lessThan(1.0));
    });

    testWidgets('size tokens drive the height', (tester) async {
      // flutter_test runs as Android, so the touch sizes apply.
      await tester.pumpWidget(_host(const CounterInput(size: SizeEnum.large)));
      const sizes = WeSizeScheme.touch();
      expect(
        tester.getSize(find.byType(CounterInput)).height,
        sizes.large.height,
      );
    });
  });

  group('reconfiguration', () {
    testWidgets('shrinking the range re-clamps the value', (tester) async {
      final controller = CounterInputController(initialValue: 80);
      addTearDown(controller.dispose);

      await tester.pumpWidget(_host(CounterInput(controller: controller)));
      expect(controller.value, 80);

      await tester.pumpWidget(
        _host(CounterInput(controller: controller, maxValue: 10)),
      );
      expect(controller.value, 10);
      expect(controller.textController.text, '10');
    });

    testWidgets('an explicit precision pads the display', (tester) async {
      await tester.pumpWidget(
        _host(const CounterInput(decimals: 2, step: 0.25, maxValue: 5)),
      );
      expect(_text(tester).text, '0.00');

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(_text(tester).text, '0.25');
    });
  });
}
