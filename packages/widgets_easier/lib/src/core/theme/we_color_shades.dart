import 'dart:ui';

import '../enums/semantic_enum.dart';
import 'we_color_scheme.dart';

/// Element Plus derives nine tints of every semantic colour
/// (`--el-color-primary-light-3` … `light-9`) plus one shade
/// (`--el-color-primary-dark-2`) and uses them for hover states, plain
/// buttons, light tags and alert backgrounds.
///
/// This extension provides the same ramp for [WeColorScheme]. Tints are mixed
/// towards [WeColorScheme.baseBackground] so that they stay legible on dark
/// surfaces, where Element Plus mixes towards its dark background as well.
extension WeColorShades on WeColorScheme {
  /// Mixes [type]'s colour with the base background by [level] tenths.
  ///
  /// `light(type, 9)` is the faintest tint and is used for alert and light-tag
  /// backgrounds; `light(type, 3)` is the hover colour of a filled button.
  Color light(SemanticEnum type, int level) => lighten(semantic(type), level);

  /// Mixes [type]'s colour with black by `0.2`, the pressed colour of a filled
  /// button.
  Color dark(SemanticEnum type) => darken(semantic(type));

  /// Same as [light], for an arbitrary [color].
  Color lighten(Color color, int level) {
    assert(level >= 1 && level <= 9, 'level must be between 1 and 9');
    return Color.lerp(color, baseBackground, level / 10)!;
  }

  /// Same as [dark], for an arbitrary [color].
  Color darken(Color color, [double amount = 0.2]) =>
      Color.lerp(color, const Color(0xFF000000), amount)!;

  /// The Element Plus ramp for [type] as a list indexed by level.
  ///
  /// Index 0 is the colour itself; indices 1–9 are `light(type, i)`.
  List<Color> ramp(SemanticEnum type) => [
    semantic(type),
    for (int i = 1; i <= 9; i++) light(type, i),
  ];
}
