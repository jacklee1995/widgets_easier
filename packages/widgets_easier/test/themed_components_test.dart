import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

/// Guards against components drifting back to hard-coded colours and sizes.
///
/// Every component listed here must read its paint from [WeTheme]; if one
/// starts ignoring the extension again, these tests go red instead of the
/// regression only showing up when somebody eyeballs dark mode.

const Color _brand = Color(0xFF13CE66);

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

/// The colour of the [Material] the button paints itself with.
Color? _buttonFill(WidgetTester tester) {
  final material = tester.widget<Material>(
    find.descendant(
      of: find.byType(SemanticButton),
      matching: find.byType(Material),
    ),
  );
  return material.color;
}

BoxDecoration _tagDecoration(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(of: find.byType(Tag), matching: find.byType(Container))
        .first,
  );
  return container.decoration! as BoxDecoration;
}

void main() {
  group('SemanticButton follows WeTheme', () {
    testWidgets('fills with the theme primary, not the built-in blue', (
      tester,
    ) async {
      await tester.pumpWidget(_host(SemanticButton(text: 'ok', onTap: () {})));
      expect(_buttonFill(tester), _brand);
      expect(_buttonFill(tester), isNot(const WeColorScheme.light().primary));
    });

    testWidgets('an explicit color still wins over the theme', (tester) async {
      await tester.pumpWidget(
        _host(
          SemanticButton(
            text: 'ok',
            color: const Color(0xFF112233),
            onTap: () {},
          ),
        ),
      );
      expect(_buttonFill(tester), const Color(0xFF112233));
    });

    testWidgets('height and font size come from the size tokens', (
      tester,
    ) async {
      const sizes = WeSizeScheme.standard();
      for (final size in SizeEnum.values) {
        await tester.pumpWidget(
          _host(SemanticButton(text: 'ok', size: size, onTap: () {})),
        );
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(SemanticButton),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(
          container.constraints?.maxHeight,
          sizes.control(size).height,
          reason: 'height of $size',
        );
        expect(
          tester.widget<Text>(find.text('ok')).style?.fontSize,
          sizes.control(size).fontSize,
          reason: 'font size of $size',
        );
      }
    });

    testWidgets('an explicit fontSize overrides the token', (tester) async {
      await tester.pumpWidget(
        _host(SemanticButton(text: 'ok', fontSize: 27, onTap: () {})),
      );
      expect(tester.widget<Text>(find.text('ok')).style?.fontSize, 27);
    });
  });

  group('Tag follows WeTheme', () {
    testWidgets('borders and fills with the theme primary', (tester) async {
      await tester.pumpWidget(
        _host(const Tag('tag', type: SemanticEnum.primary)),
      );
      final border = _tagDecoration(tester).border! as Border;
      expect(border.top.color, _brand);
    });

    testWidgets('an untyped plain tag uses the token border, not black', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const Tag('tag')));
      final border = _tagDecoration(tester).border! as Border;
      expect(border.top.color, const WeColorScheme.light().baseBorder);
      expect(border.top.color, isNot(const Color(0xFF000000)));
    });

    testWidgets('text uses the light palette on a light theme', (tester) async {
      await tester.pumpWidget(_host(const Tag('tag')));
      expect(
        tester.widget<Text>(find.text('tag')).style?.color,
        const WeColorScheme.light().primaryText,
      );
    });

    testWidgets('text uses the dark palette on a dark theme', (tester) async {
      await tester.pumpWidget(
        _host(const Tag('tag'), brightness: Brightness.dark),
      );
      expect(
        tester.widget<Text>(find.text('tag')).style?.color,
        const WeColorScheme.dark().primaryText,
      );
    });

    testWidgets('sizes come from the compact tokens', (tester) async {
      const sizes = WeSizeScheme.standard();
      for (final size in SizeEnum.values) {
        await tester.pumpWidget(_host(Tag('tag', size: size)));
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(Tag),
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
  });
}
