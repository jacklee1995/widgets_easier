import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

void main() {
  group('WeColorScheme', () {
    test('semantic() covers every SemanticEnum value', () {
      const scheme = WeColorScheme.light();
      for (final type in SemanticEnum.values) {
        expect(scheme.semantic(type), isA<Color>());
      }
    });

    test('light and dark palettes differ in text colours', () {
      const light = WeColorScheme.light();
      const dark = WeColorScheme.dark();
      expect(light.primaryText, isNot(dark.primaryText));
      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
    });

    test('lerp at 0 and 1 returns the end points', () {
      const a = WeColorScheme.light();
      const b = WeColorScheme.dark();
      expect(WeColorScheme.lerp(a, b, 0).primaryText, a.primaryText);
      expect(WeColorScheme.lerp(a, b, 1).primaryText, b.primaryText);
    });
  });

  group('WeTheme.of', () {
    testWidgets('falls back to a palette matching ThemeData.brightness', (
      tester,
    ) async {
      late WeTheme captured;
      await tester.pumpWidget(
        Theme(
          data: ThemeData.dark(),
          child: Builder(
            builder: (context) {
              captured = WeTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(captured.colors.brightness, Brightness.dark);
    });

    testWidgets('returns the installed extension', (tester) async {
      const custom = WeTheme.light(
        colors: WeColorScheme.light(primary: Color(0xFF123456)),
      );
      late WeTheme captured;
      await tester.pumpWidget(
        Theme(
          data: ThemeData.light().copyWith(extensions: const [custom]),
          child: Builder(
            builder: (context) {
              captured = WeTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(captured.colors.primary, const Color(0xFF123456));
      expect(
        captured.colors.semantic(SemanticEnum.primary),
        const Color(0xFF123456),
      );
    });
  });

  test('WeSizeScheme maps SizeEnum to control and compact sizes', () {
    const sizes = WeSizeScheme.standard();
    expect(sizes.control(SizeEnum.large).height, 40);
    expect(sizes.control(SizeEnum.defaultSize).height, 32);
    expect(sizes.control(SizeEnum.small).height, 24);
    expect(sizes.compact(SizeEnum.small).height, 20);
  });
}
