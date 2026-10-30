import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../enums/semantic_enum.dart';

/// The colour design tokens of Widgets Easier.
///
/// The naming follows the Element Plus palette: seven *semantic* colours,
/// five text colours, six border colours, seven fill colours and three
/// background colours. Two built-in palettes are provided through
/// [WeColorScheme.light] and [WeColorScheme.dark]; use [copyWith] to derive a
/// brand-specific palette.
@immutable
class WeColorScheme {
  const WeColorScheme({
    required this.brightness,
    required this.primary,
    required this.secondary,
    required this.success,
    required this.warning,
    required this.info,
    required this.danger,
    required this.fatal,
    required this.primaryText,
    required this.regularText,
    required this.secondaryText,
    required this.placeholderText,
    required this.disabledText,
    required this.darkerBorder,
    required this.darkBorder,
    required this.baseBorder,
    required this.lightBorder,
    required this.lighterBorder,
    required this.extraLightBorder,
    required this.darkerFill,
    required this.darkFill,
    required this.baseFill,
    required this.lightFill,
    required this.lighterFill,
    required this.extraLightFill,
    required this.blankFill,
    required this.pageBackground,
    required this.baseBackground,
    required this.overlayBackground,
    required this.mask,
  });

  /// The default light palette.
  const WeColorScheme.light({
    this.primary = const Color(0xFF409EFF),
    this.secondary = const Color(0xFF909399),
    this.success = const Color(0xFF67C23A),
    this.warning = const Color(0xFFE6A23C),
    this.info = const Color(0xFF0DCAF0),
    this.danger = const Color(0xFFDC3545),
    this.fatal = const Color(0xFFC910F2),
  }) : brightness = Brightness.light,
       primaryText = const Color(0xFF303133),
       regularText = const Color(0xFF606266),
       secondaryText = const Color(0xFF909399),
       placeholderText = const Color(0xFFA8ABB2),
       disabledText = const Color(0xFFC0C4CC),
       darkerBorder = const Color(0xFFCDD0D6),
       darkBorder = const Color(0xFFD4D7DE),
       baseBorder = const Color(0xFFDCDFE6),
       lightBorder = const Color(0xFFE4E7ED),
       lighterBorder = const Color(0xFFEBEEF5),
       extraLightBorder = const Color(0xFFF2F6FC),
       darkerFill = const Color(0xFFE6E8EB),
       darkFill = const Color(0xFFEBEDF0),
       baseFill = const Color(0xFFF0F2F5),
       lightFill = const Color(0xFFF5F7FA),
       lighterFill = const Color(0xFFFAFAFA),
       extraLightFill = const Color(0xFFFAFCFF),
       blankFill = const Color(0xFFFFFFFF),
       pageBackground = const Color(0xFFF2F3F5),
       baseBackground = const Color(0xFFFFFFFF),
       overlayBackground = const Color(0xFFFFFFFF),
       mask = const Color(0x80000000);

  /// The default dark palette (values follow Element Plus' dark theme).
  const WeColorScheme.dark({
    this.primary = const Color(0xFF409EFF),
    this.secondary = const Color(0xFF909399),
    this.success = const Color(0xFF67C23A),
    this.warning = const Color(0xFFE6A23C),
    this.info = const Color(0xFF0DCAF0),
    this.danger = const Color(0xFFF56C6C),
    this.fatal = const Color(0xFFD65CF5),
  }) : brightness = Brightness.dark,
       primaryText = const Color(0xFFE5EAF3),
       regularText = const Color(0xFFCFD3DC),
       secondaryText = const Color(0xFFA3A6AD),
       placeholderText = const Color(0xFF8D9095),
       disabledText = const Color(0xFF6C6E72),
       darkerBorder = const Color(0xFF636466),
       darkBorder = const Color(0xFF58585B),
       baseBorder = const Color(0xFF4C4D4F),
       lightBorder = const Color(0xFF414243),
       lighterBorder = const Color(0xFF363637),
       extraLightBorder = const Color(0xFF2B2B2C),
       darkerFill = const Color(0xFF424243),
       darkFill = const Color(0xFF39393A),
       baseFill = const Color(0xFF303030),
       lightFill = const Color(0xFF262727),
       lighterFill = const Color(0xFF1D1D1D),
       extraLightFill = const Color(0xFF191919),
       blankFill = const Color(0x00000000),
       pageBackground = const Color(0xFF0A0A0A),
       baseBackground = const Color(0xFF141414),
       overlayBackground = const Color(0xFF1D1E1F),
       mask = const Color(0xB3000000);

  /// Whether this palette is meant for a light or a dark surface.
  final Brightness brightness;

  // ── Semantic colours ───────────────────────────────────────────────────

  final Color primary;
  final Color secondary;
  final Color success;
  final Color warning;
  final Color info;
  final Color danger;
  final Color fatal;

  // ── Text colours ───────────────────────────────────────────────────────

  final Color primaryText;
  final Color regularText;
  final Color secondaryText;
  final Color placeholderText;
  final Color disabledText;

  // ── Border colours ─────────────────────────────────────────────────────

  final Color darkerBorder;
  final Color darkBorder;
  final Color baseBorder;
  final Color lightBorder;
  final Color lighterBorder;
  final Color extraLightBorder;

  // ── Fill colours ───────────────────────────────────────────────────────

  final Color darkerFill;
  final Color darkFill;
  final Color baseFill;
  final Color lightFill;
  final Color lighterFill;
  final Color extraLightFill;
  final Color blankFill;

  // ── Background colours ─────────────────────────────────────────────────

  final Color pageBackground;
  final Color baseBackground;
  final Color overlayBackground;

  /// Colour of modal barriers behind dialogs and sheets.
  final Color mask;

  /// Returns the colour that represents [type].
  Color semantic(SemanticEnum type) => switch (type) {
    SemanticEnum.primary => primary,
    SemanticEnum.secondary => secondary,
    SemanticEnum.success => success,
    SemanticEnum.warning => warning,
    SemanticEnum.info => info,
    SemanticEnum.danger => danger,
    SemanticEnum.fatal => fatal,
  };

  /// The text colour that contrasts with a filled semantic surface.
  Color get onSemantic => const Color(0xFFFFFFFF);

  WeColorScheme copyWith({
    Brightness? brightness,
    Color? primary,
    Color? secondary,
    Color? success,
    Color? warning,
    Color? info,
    Color? danger,
    Color? fatal,
    Color? primaryText,
    Color? regularText,
    Color? secondaryText,
    Color? placeholderText,
    Color? disabledText,
    Color? darkerBorder,
    Color? darkBorder,
    Color? baseBorder,
    Color? lightBorder,
    Color? lighterBorder,
    Color? extraLightBorder,
    Color? darkerFill,
    Color? darkFill,
    Color? baseFill,
    Color? lightFill,
    Color? lighterFill,
    Color? extraLightFill,
    Color? blankFill,
    Color? pageBackground,
    Color? baseBackground,
    Color? overlayBackground,
    Color? mask,
  }) {
    return WeColorScheme(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      danger: danger ?? this.danger,
      fatal: fatal ?? this.fatal,
      primaryText: primaryText ?? this.primaryText,
      regularText: regularText ?? this.regularText,
      secondaryText: secondaryText ?? this.secondaryText,
      placeholderText: placeholderText ?? this.placeholderText,
      disabledText: disabledText ?? this.disabledText,
      darkerBorder: darkerBorder ?? this.darkerBorder,
      darkBorder: darkBorder ?? this.darkBorder,
      baseBorder: baseBorder ?? this.baseBorder,
      lightBorder: lightBorder ?? this.lightBorder,
      lighterBorder: lighterBorder ?? this.lighterBorder,
      extraLightBorder: extraLightBorder ?? this.extraLightBorder,
      darkerFill: darkerFill ?? this.darkerFill,
      darkFill: darkFill ?? this.darkFill,
      baseFill: baseFill ?? this.baseFill,
      lightFill: lightFill ?? this.lightFill,
      lighterFill: lighterFill ?? this.lighterFill,
      extraLightFill: extraLightFill ?? this.extraLightFill,
      blankFill: blankFill ?? this.blankFill,
      pageBackground: pageBackground ?? this.pageBackground,
      baseBackground: baseBackground ?? this.baseBackground,
      overlayBackground: overlayBackground ?? this.overlayBackground,
      mask: mask ?? this.mask,
    );
  }

  /// Linearly interpolates between two palettes.
  static WeColorScheme lerp(WeColorScheme a, WeColorScheme b, double t) {
    Color c(Color x, Color y) => Color.lerp(x, y, t)!;
    return WeColorScheme(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      primary: c(a.primary, b.primary),
      secondary: c(a.secondary, b.secondary),
      success: c(a.success, b.success),
      warning: c(a.warning, b.warning),
      info: c(a.info, b.info),
      danger: c(a.danger, b.danger),
      fatal: c(a.fatal, b.fatal),
      primaryText: c(a.primaryText, b.primaryText),
      regularText: c(a.regularText, b.regularText),
      secondaryText: c(a.secondaryText, b.secondaryText),
      placeholderText: c(a.placeholderText, b.placeholderText),
      disabledText: c(a.disabledText, b.disabledText),
      darkerBorder: c(a.darkerBorder, b.darkerBorder),
      darkBorder: c(a.darkBorder, b.darkBorder),
      baseBorder: c(a.baseBorder, b.baseBorder),
      lightBorder: c(a.lightBorder, b.lightBorder),
      lighterBorder: c(a.lighterBorder, b.lighterBorder),
      extraLightBorder: c(a.extraLightBorder, b.extraLightBorder),
      darkerFill: c(a.darkerFill, b.darkerFill),
      darkFill: c(a.darkFill, b.darkFill),
      baseFill: c(a.baseFill, b.baseFill),
      lightFill: c(a.lightFill, b.lightFill),
      lighterFill: c(a.lighterFill, b.lighterFill),
      extraLightFill: c(a.extraLightFill, b.extraLightFill),
      blankFill: c(a.blankFill, b.blankFill),
      pageBackground: c(a.pageBackground, b.pageBackground),
      baseBackground: c(a.baseBackground, b.baseBackground),
      overlayBackground: c(a.overlayBackground, b.overlayBackground),
      mask: c(a.mask, b.mask),
    );
  }
}
