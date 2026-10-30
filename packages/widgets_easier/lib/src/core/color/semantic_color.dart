import 'dart:ui';

import '../theme/we_color_scheme.dart';

const WeColorScheme _light = WeColorScheme.light();

/// Static access to the default light palette.
///
/// Prefer `WeTheme.of(context).colors` so that dark mode and custom palettes
/// are honoured. This class only mirrors [WeColorScheme.light].
// TODO(refactor): annotate @Deprecated once every component reads its colours
// from WeTheme; the annotation cannot be added earlier because
// `deprecated_member_use_from_same_package` would fail the build.
abstract final class SemanticColors {
  // Status Colors
  static const Color primary = Color(0xFF409EFF);
  static const Color secondary = Color(0xFF909399);
  static const Color success = Color(0xFF67C23A);
  static const Color warning = Color(0xFFE6A23C);
  static const Color info = Color(0xFF0DCAF0);
  static const Color danger = Color(0xFFDC3545);
  static const Color fatal = Color(0xFFC910F2);

  // Text Colors
  static const Color primaryText = Color(0xFF303133);
  static const Color regularText = Color(0xFF606266);
  static const Color secondaryText = Color(0xFF909399);
  static const Color placeholderText = Color(0xFFA8ABB2);
  static const Color disabledText = Color(0xFFC0C4CC);

  // Border Colors
  static const Color darkerBorder = Color(0xFFCDD0D6);
  static const Color darkBorder = Color(0xFFD4D7DE);
  static const Color baseBorder = Color(0xFFDCDFE6);
  static const Color lightBorder = Color(0xFFE4E7ED);
  static const Color lighterBorder = Color(0xFFEBEEF5);
  static const Color extraLightBorder = Color(0xFFF2F6FC);

  // Fill Colors
  static const Color darkerFill = Color(0xFFE6E8EB);
  static const Color darkFill = Color(0xFFEBEDF0);
  static const Color baseFill = Color(0xFFF0F2F5);
  static const Color lightFill = Color(0xFFF5F7FA);
  static const Color lighterFill = Color(0xFFFAFAFA);
  static const Color extraLightFill = Color(0xFFFAFCFF);
  static const Color blankFill = Color(0xFFFFFFFF);

  // Basic Colors
  static const Color basicBlack = Color(0xFF000000);
  static const Color basicWhite = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  // Background Colors
  static Color get pageBackground => _light.pageBackground;
  static Color get baseBackground => _light.baseBackground;
  static Color get overlayBackground => _light.overlayBackground;
}
