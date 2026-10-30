import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../enums/size_enum.dart';

/// Dimensions of a single control size step (large / default / small).
@immutable
class WeControlSize {
  const WeControlSize({
    required this.height,
    required this.fontSize,
    required this.horizontalPadding,
    required this.spacing,
    required this.iconSize,
  });

  /// Total height of the control.
  final double height;

  /// Font size of the control's label.
  final double fontSize;

  /// Horizontal padding between the border and the content.
  final double horizontalPadding;

  /// Gap between an icon and the label.
  final double spacing;

  /// Size of leading / trailing icons.
  final double iconSize;

  WeControlSize copyWith({
    double? height,
    double? fontSize,
    double? horizontalPadding,
    double? spacing,
    double? iconSize,
  }) {
    return WeControlSize(
      height: height ?? this.height,
      fontSize: fontSize ?? this.fontSize,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      spacing: spacing ?? this.spacing,
      iconSize: iconSize ?? this.iconSize,
    );
  }

  static WeControlSize lerp(WeControlSize a, WeControlSize b, double t) {
    return WeControlSize(
      height: lerpDouble(a.height, b.height, t)!,
      fontSize: lerpDouble(a.fontSize, b.fontSize, t)!,
      horizontalPadding: lerpDouble(
        a.horizontalPadding,
        b.horizontalPadding,
        t,
      )!,
      spacing: lerpDouble(a.spacing, b.spacing, t)!,
      iconSize: lerpDouble(a.iconSize, b.iconSize, t)!,
    );
  }
}

/// Size design tokens: one [WeControlSize] per [SizeEnum] step, for regular
/// controls (buttons, inputs, selects) and for compact ones (tags, badges).
@immutable
class WeSizeScheme {
  const WeSizeScheme({
    required this.large,
    required this.medium,
    required this.small,
    required this.compactLarge,
    required this.compactMedium,
    required this.compactSmall,
  });

  /// Element Plus-like defaults: 40 / 32 / 24 for controls, 32 / 24 / 20 for
  /// compact components.
  const WeSizeScheme.standard()
    : large = const WeControlSize(
        height: 40,
        fontSize: 16,
        horizontalPadding: 20,
        spacing: 8,
        iconSize: 20,
      ),
      medium = const WeControlSize(
        height: 32,
        fontSize: 14,
        horizontalPadding: 16,
        spacing: 6,
        iconSize: 16,
      ),
      small = const WeControlSize(
        height: 24,
        fontSize: 12,
        horizontalPadding: 12,
        spacing: 4,
        iconSize: 14,
      ),
      compactLarge = const WeControlSize(
        height: 32,
        fontSize: 16,
        horizontalPadding: 12,
        spacing: 8,
        iconSize: 16,
      ),
      compactMedium = const WeControlSize(
        height: 24,
        fontSize: 14,
        horizontalPadding: 10,
        spacing: 6,
        iconSize: 14,
      ),
      compactSmall = const WeControlSize(
        height: 20,
        fontSize: 12,
        horizontalPadding: 8,
        spacing: 4,
        iconSize: 12,
      );

  /// Finger-sized controls: 48 / 44 / 36 for controls, 32 / 28 / 24 for
  /// compact components, so the default size meets the 44 px touch target.
  /// [WeTheme.of] switches to it on touch while the theme still uses
  /// [WeSizeScheme.standard].
  const WeSizeScheme.touch()
    : large = const WeControlSize(
        height: 48,
        fontSize: 17,
        horizontalPadding: 22,
        spacing: 8,
        iconSize: 22,
      ),
      medium = const WeControlSize(
        height: 44,
        fontSize: 16,
        horizontalPadding: 18,
        spacing: 8,
        iconSize: 20,
      ),
      small = const WeControlSize(
        height: 36,
        fontSize: 14,
        horizontalPadding: 14,
        spacing: 6,
        iconSize: 18,
      ),
      compactLarge = const WeControlSize(
        height: 32,
        fontSize: 16,
        horizontalPadding: 12,
        spacing: 8,
        iconSize: 16,
      ),
      compactMedium = const WeControlSize(
        height: 28,
        fontSize: 14,
        horizontalPadding: 10,
        spacing: 6,
        iconSize: 14,
      ),
      compactSmall = const WeControlSize(
        height: 24,
        fontSize: 13,
        horizontalPadding: 8,
        spacing: 4,
        iconSize: 13,
      );

  final WeControlSize large;
  final WeControlSize medium;
  final WeControlSize small;
  final WeControlSize compactLarge;
  final WeControlSize compactMedium;
  final WeControlSize compactSmall;

  /// Dimensions for a regular control of the given [size].
  WeControlSize control(SizeEnum size) => switch (size) {
    SizeEnum.large => large,
    SizeEnum.defaultSize => medium,
    SizeEnum.small => small,
  };

  /// Dimensions for a compact component (tag, badge) of the given [size].
  WeControlSize compact(SizeEnum size) => switch (size) {
    SizeEnum.large => compactLarge,
    SizeEnum.defaultSize => compactMedium,
    SizeEnum.small => compactSmall,
  };

  WeSizeScheme copyWith({
    WeControlSize? large,
    WeControlSize? medium,
    WeControlSize? small,
    WeControlSize? compactLarge,
    WeControlSize? compactMedium,
    WeControlSize? compactSmall,
  }) {
    return WeSizeScheme(
      large: large ?? this.large,
      medium: medium ?? this.medium,
      small: small ?? this.small,
      compactLarge: compactLarge ?? this.compactLarge,
      compactMedium: compactMedium ?? this.compactMedium,
      compactSmall: compactSmall ?? this.compactSmall,
    );
  }

  static WeSizeScheme lerp(WeSizeScheme a, WeSizeScheme b, double t) {
    // Keeps the const presets identical through theme animations, which
    // WeTheme.of relies on to tell the standard preset from a custom one.
    if (identical(a, b)) return a;
    return WeSizeScheme(
      large: WeControlSize.lerp(a.large, b.large, t),
      medium: WeControlSize.lerp(a.medium, b.medium, t),
      small: WeControlSize.lerp(a.small, b.small, t),
      compactLarge: WeControlSize.lerp(a.compactLarge, b.compactLarge, t),
      compactMedium: WeControlSize.lerp(a.compactMedium, b.compactMedium, t),
      compactSmall: WeControlSize.lerp(a.compactSmall, b.compactSmall, t),
    );
  }
}
