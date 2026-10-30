import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Corner radius tokens.
@immutable
class WeRadiusScheme {
  const WeRadiusScheme({
    required this.small,
    required this.base,
    required this.round,
    required this.circle,
  });

  const WeRadiusScheme.standard()
    : small = 2,
      base = 4,
      round = 20,
      circle = 9999;

  final double small;
  final double base;
  final double round;
  final double circle;

  WeRadiusScheme copyWith({
    double? small,
    double? base,
    double? round,
    double? circle,
  }) {
    return WeRadiusScheme(
      small: small ?? this.small,
      base: base ?? this.base,
      round: round ?? this.round,
      circle: circle ?? this.circle,
    );
  }

  static WeRadiusScheme lerp(WeRadiusScheme a, WeRadiusScheme b, double t) {
    return WeRadiusScheme(
      small: lerpDouble(a.small, b.small, t)!,
      base: lerpDouble(a.base, b.base, t)!,
      round: lerpDouble(a.round, b.round, t)!,
      circle: lerpDouble(a.circle, b.circle, t)!,
    );
  }
}

/// Spacing scale tokens.
@immutable
class WeSpacingScheme {
  const WeSpacingScheme({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  const WeSpacingScheme.standard() : xs = 4, sm = 8, md = 12, lg = 16, xl = 24;

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  WeSpacingScheme copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return WeSpacingScheme(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  static WeSpacingScheme lerp(WeSpacingScheme a, WeSpacingScheme b, double t) {
    return WeSpacingScheme(
      xs: lerpDouble(a.xs, b.xs, t)!,
      sm: lerpDouble(a.sm, b.sm, t)!,
      md: lerpDouble(a.md, b.md, t)!,
      lg: lerpDouble(a.lg, b.lg, t)!,
      xl: lerpDouble(a.xl, b.xl, t)!,
    );
  }
}

/// Elevation tokens, mirroring Element Plus' `--el-box-shadow*` variables.
@immutable
class WeShadowScheme {
  const WeShadowScheme({
    required this.base,
    required this.light,
    required this.lighter,
    required this.dark,
  });

  const WeShadowScheme.standard()
    : base = const [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
      light = const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
      lighter = const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
      dark = const [
        BoxShadow(
          color: Color(0x66000000),
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      ];

  final List<BoxShadow> base;
  final List<BoxShadow> light;
  final List<BoxShadow> lighter;
  final List<BoxShadow> dark;

  WeShadowScheme copyWith({
    List<BoxShadow>? base,
    List<BoxShadow>? light,
    List<BoxShadow>? lighter,
    List<BoxShadow>? dark,
  }) {
    return WeShadowScheme(
      base: base ?? this.base,
      light: light ?? this.light,
      lighter: lighter ?? this.lighter,
      dark: dark ?? this.dark,
    );
  }

  static WeShadowScheme lerp(WeShadowScheme a, WeShadowScheme b, double t) {
    return WeShadowScheme(
      base: BoxShadow.lerpList(a.base, b.base, t) ?? b.base,
      light: BoxShadow.lerpList(a.light, b.light, t) ?? b.light,
      lighter: BoxShadow.lerpList(a.lighter, b.lighter, t) ?? b.lighter,
      dark: BoxShadow.lerpList(a.dark, b.dark, t) ?? b.dark,
    );
  }
}
