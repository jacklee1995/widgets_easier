import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

const Color _brand = Color(0xFF13CE66);
const WeColorScheme _light = WeColorScheme.light();

Widget _host(Widget child, {Brightness brightness = Brightness.light}) {
  final we = brightness == Brightness.dark
      ? const WeTheme.dark(interaction: WeInteraction.pointer)
      : const WeTheme.light(interaction: WeInteraction.pointer);
  return MaterialApp(
    theme:
        (brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light())
            .copyWith(
              extensions: [
                we.copyWith(colors: we.colors.copyWith(primary: _brand)),
              ],
            ),
    home: Scaffold(body: Center(child: child)),
  );
}

BoxDecoration _decoration(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(of: find.byType(CheckTag), matching: find.byType(Container))
        .first,
  );
  return container.decoration! as BoxDecoration;
}

Color? _textColor(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style?.color;

void main() {
  group('CheckTag appearance', () {
    testWidgets('unchecked is a grey fill with grey text and no outline', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const CheckTag('tag')));
      final decoration = _decoration(tester);
      expect(decoration.color, _light.lightFill);
      expect((decoration.border! as Border).top.color, Colors.transparent);
      expect(_textColor(tester, 'tag'), _light.secondaryText);
    });

    testWidgets('checked looks like a light Tag of its type', (tester) async {
      await tester.pumpWidget(
        _host(const CheckTag('tag', initialChecked: true)),
      );
      final decoration = _decoration(tester);
      expect(decoration.color, _brand.withValues(alpha: 0.1));
      expect(_textColor(tester, 'tag'), _brand);
    });

    testWidgets('checked honours the plain and dark themes', (tester) async {
      await tester.pumpWidget(
        _host(
          const CheckTag(
            'tag',
            initialChecked: true,
            theme: TagThemeEnum.plain,
            type: SemanticEnum.danger,
          ),
        ),
      );
      var decoration = _decoration(tester);
      expect(decoration.color, Colors.transparent);
      expect((decoration.border! as Border).top.color, _light.danger);
      expect(_textColor(tester, 'tag'), _light.danger);

      await tester.pumpWidget(
        _host(
          const CheckTag(
            'tag',
            initialChecked: true,
            theme: TagThemeEnum.dark,
            type: SemanticEnum.danger,
          ),
        ),
      );
      await tester.pumpAndSettle();
      decoration = _decoration(tester);
      expect(decoration.color, _light.danger);
      expect(_textColor(tester, 'tag'), _light.onSemantic);
    });

    testWidgets('a custom color wins over type', (tester) async {
      await tester.pumpWidget(
        _host(
          const CheckTag('tag', initialChecked: true, color: Color(0xFF112233)),
        ),
      );
      expect(_textColor(tester, 'tag'), const Color(0xFF112233));
    });

    testWidgets('unchecked follows the dark palette', (tester) async {
      await tester.pumpWidget(
        _host(const CheckTag('tag'), brightness: Brightness.dark),
      );
      const dark = WeColorScheme.dark();
      expect(_decoration(tester).color, dark.lightFill);
      expect(_textColor(tester, 'tag'), dark.secondaryText);
    });

    testWidgets('sizes come from the compact tokens', (tester) async {
      const sizes = WeSizeScheme.standard();
      for (final size in SizeEnum.values) {
        await tester.pumpWidget(_host(CheckTag('tag', size: size)));
        await tester.pumpAndSettle();
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(CheckTag),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(
          container.constraints?.maxHeight,
          sizes.compact(size).height,
          reason: 'height of $size',
        );
      }
    });

    testWidgets('the check icon only shows while checked', (tester) async {
      await tester.pumpWidget(
        _host(const CheckTag('tag', showCheckIcon: true)),
      );
      expect(find.byIcon(Icons.check), findsNothing);

      await tester.tap(find.byType(CheckTag));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });

  group('CheckTag uncontrolled', () {
    testWidgets('a tap toggles the state and fires every callback', (
      tester,
    ) async {
      final changes = <bool>[];
      var checked = 0;
      var unchecked = 0;
      await tester.pumpWidget(
        _host(
          CheckTag(
            'tag',
            onChanged: changes.add,
            onChecked: () => checked++,
            onUnchecked: () => unchecked++,
          ),
        ),
      );

      await tester.tap(find.byType(CheckTag));
      await tester.pumpAndSettle();
      expect(changes, [true]);
      expect(checked, 1);
      expect(unchecked, 0);
      expect(_textColor(tester, 'tag'), _brand);

      await tester.tap(find.byType(CheckTag));
      await tester.pumpAndSettle();
      expect(changes, [true, false]);
      expect(checked, 1);
      expect(unchecked, 1);
      expect(_textColor(tester, 'tag'), _light.secondaryText);
    });

    testWidgets('starts from initialChecked', (tester) async {
      final changes = <bool>[];
      await tester.pumpWidget(
        _host(CheckTag('tag', initialChecked: true, onChanged: changes.add)),
      );
      await tester.tap(find.byType(CheckTag));
      await tester.pumpAndSettle();
      expect(changes, [false]);
    });
  });

  group('CheckTag controlled', () {
    testWidgets('renders the given value and does not flip on its own', (
      tester,
    ) async {
      final changes = <bool>[];
      await tester.pumpWidget(
        _host(CheckTag('tag', checked: false, onChanged: changes.add)),
      );

      await tester.tap(find.byType(CheckTag));
      await tester.pumpAndSettle();
      expect(changes, [true]);
      expect(_textColor(tester, 'tag'), _light.secondaryText);

      await tester.pumpWidget(
        _host(CheckTag('tag', checked: true, onChanged: changes.add)),
      );
      await tester.pumpAndSettle();
      expect(_textColor(tester, 'tag'), _brand);
    });

    testWidgets('a value pushed by the parent is picked up', (tester) async {
      var value = false;
      late StateSetter rebuild;
      await tester.pumpWidget(
        _host(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return CheckTag(
                'tag',
                checked: value,
                onChanged: (next) => setState(() => value = next),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(CheckTag));
      await tester.pumpAndSettle();
      expect(value, isTrue);
      expect(_textColor(tester, 'tag'), _brand);

      rebuild(() => value = false);
      await tester.pumpAndSettle();
      expect(_textColor(tester, 'tag'), _light.secondaryText);
    });
  });

  group('CheckTag disabled', () {
    testWidgets('ignores taps and dims the label', (tester) async {
      final changes = <bool>[];
      await tester.pumpWidget(
        _host(CheckTag('tag', disabled: true, onChanged: changes.add)),
      );
      expect(_textColor(tester, 'tag'), _light.disabledText);
      // Dimming must not turn the invisible outline into a grey one.
      expect(
        (_decoration(tester).border! as Border).top.color,
        Colors.transparent,
      );

      await tester.tap(find.byType(CheckTag));
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
    });

    testWidgets('a checked disabled tag keeps its accent at half strength', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const CheckTag('tag', disabled: true, initialChecked: true)),
      );
      expect(_textColor(tester, 'tag'), _brand.withValues(alpha: 0.5));
    });
  });

  group('CheckTag keyboard', () {
    testWidgets('space toggles a focused tag', (tester) async {
      final changes = <bool>[];
      await tester.pumpWidget(
        _host(CheckTag('tag', autofocus: true, onChanged: changes.add)),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(changes, [true]);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(changes, [true, false]);
    });

    testWidgets('a disabled tag cannot be focused', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _host(CheckTag('tag', disabled: true, focusNode: node)),
      );
      node.requestFocus();
      await tester.pumpAndSettle();
      expect(node.hasFocus, isFalse);
    });
  });

  group('CheckTag semantics', () {
    testWidgets('exposes the checked state', (tester) async {
      await tester.pumpWidget(_host(const CheckTag('tag')));
      expect(
        tester.getSemantics(find.text('tag')),
        matchesSemantics(
          label: 'tag',
          isButton: true,
          hasCheckedState: true,
          isChecked: false,
          isEnabled: true,
          hasEnabledState: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
    });
  });
}
