import 'dart:ui';

import '../enums/semantic_enum.dart';
import '../theme/we_color_scheme.dart';

/// Returns the colour of [type] in the default **light** palette.
///
/// Legacy helper: it has no access to the ambient theme, so it cannot follow
/// dark mode or a custom palette. Prefer `type.resolve(context)` or
/// `WeTheme.of(context).colors.semantic(type)`.
// TODO(refactor): annotate @Deprecated once every component reads the colour
// from WeTheme; the annotation cannot be added earlier because
// `deprecated_member_use_from_same_package` would fail the build.
Color findStatusColor(SemanticEnum type) =>
    const WeColorScheme.light().semantic(type);
