import 'package:flutter/material.dart';

import '../platform/we_platform.dart';
import 'we_color_scheme.dart';
import 'we_shape_scheme.dart';
import 'we_size_scheme.dart';

/// The design tokens used by every Widgets Easier component.
///
/// Install it as a [ThemeExtension] on your [ThemeData]:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData.light().copyWith(extensions: [WeTheme.light()]),
///   darkTheme: ThemeData.dark().copyWith(extensions: [WeTheme.dark()]),
/// )
/// ```
///
/// Components read it with [WeTheme.of]. When no extension is installed a
/// default palette matching the ambient [ThemeData.brightness] is used, so
/// the widgets keep working in apps that never configure a theme.
///
/// On touch (see [interaction]) [WeTheme.of] swaps the standard sizes for
/// [WeSizeScheme.touch]; custom [sizes] are left alone.
@immutable
class WeTheme extends ThemeExtension<WeTheme> {
  const WeTheme({
    required this.colors,
    this.sizes = const WeSizeScheme.standard(),
    this.radius = const WeRadiusScheme.standard(),
    this.spacing = const WeSpacingScheme.standard(),
    this.shadows = const WeShadowScheme.standard(),
    this.interaction = WeInteraction.auto,
  });

  /// Light theme with the default palette.
  const WeTheme.light({
    this.colors = const WeColorScheme.light(),
    this.sizes = const WeSizeScheme.standard(),
    this.radius = const WeRadiusScheme.standard(),
    this.spacing = const WeSpacingScheme.standard(),
    this.shadows = const WeShadowScheme.standard(),
    this.interaction = WeInteraction.auto,
  });

  /// Dark theme with the default palette.
  const WeTheme.dark({
    this.colors = const WeColorScheme.dark(),
    this.sizes = const WeSizeScheme.standard(),
    this.radius = const WeRadiusScheme.standard(),
    this.spacing = const WeSpacingScheme.standard(),
    this.shadows = const WeShadowScheme.standard(),
    this.interaction = WeInteraction.auto,
  });

  final WeColorScheme colors;
  final WeSizeScheme sizes;
  final WeRadiusScheme radius;
  final WeSpacingScheme spacing;
  final WeShadowScheme shadows;

  /// Pointer or touch; [WeInteraction.auto] decides by platform. Use
  /// [WeInteraction.pointer] to keep desktop sizes and hover on a phone.
  final WeInteraction interaction;

  /// The [WeTheme] installed on the closest [Theme], or a default one that
  /// matches the theme's brightness, with touch sizes applied on touch.
  static WeTheme of(BuildContext context) {
    final theme = Theme.of(context);
    final WeTheme we =
        theme.extension<WeTheme>() ??
        (theme.brightness == Brightness.dark
            ? const WeTheme.dark()
            : const WeTheme.light());
    if (identical(we.sizes, const WeSizeScheme.standard()) &&
        WePlatform.resolveTouch(we.interaction, theme.platform)) {
      return we.copyWith(sizes: const WeSizeScheme.touch());
    }
    return we;
  }

  /// The [WeTheme] installed on the closest [Theme], or `null`. Unlike [of]
  /// it returns the extension as installed, without touch sizes.
  static WeTheme? maybeOf(BuildContext context) =>
      Theme.of(context).extension<WeTheme>();

  @override
  WeTheme copyWith({
    WeColorScheme? colors,
    WeSizeScheme? sizes,
    WeRadiusScheme? radius,
    WeSpacingScheme? spacing,
    WeShadowScheme? shadows,
    WeInteraction? interaction,
  }) {
    return WeTheme(
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      radius: radius ?? this.radius,
      spacing: spacing ?? this.spacing,
      shadows: shadows ?? this.shadows,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  WeTheme lerp(ThemeExtension<WeTheme>? other, double t) {
    if (other is! WeTheme) return this;
    if (t <= 0) return this;
    if (t >= 1) return other;
    return WeTheme(
      colors: WeColorScheme.lerp(colors, other.colors, t),
      sizes: WeSizeScheme.lerp(sizes, other.sizes, t),
      radius: WeRadiusScheme.lerp(radius, other.radius, t),
      spacing: WeSpacingScheme.lerp(spacing, other.spacing, t),
      shadows: WeShadowScheme.lerp(shadows, other.shadows, t),
      interaction: t < 0.5 ? interaction : other.interaction,
    );
  }
}

/// Convenience accessors on [BuildContext].
extension WeThemeContext on BuildContext {
  /// Shorthand for `WeTheme.of(this)`.
  WeTheme get weTheme => WeTheme.of(this);

  /// Shorthand for `WeTheme.of(this).colors`.
  WeColorScheme get weColors => WeTheme.of(this).colors;
}
