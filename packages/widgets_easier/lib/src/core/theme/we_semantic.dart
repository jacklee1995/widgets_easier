import 'package:flutter/widgets.dart';

import '../enums/semantic_enum.dart';
import 'we_color_scheme.dart';
import 'we_theme.dart';

/// Colour helpers on [SemanticEnum].
extension SemanticEnumColors on SemanticEnum {
  /// The colour representing this semantic type in [scheme].
  Color colorOf(WeColorScheme scheme) => scheme.semantic(this);

  /// The colour representing this semantic type in the ambient [WeTheme].
  Color resolve(BuildContext context) =>
      WeTheme.of(context).colors.semantic(this);
}
