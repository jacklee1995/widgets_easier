import 'package:flutter/widgets.dart';

import '../enums/semantic_enum.dart';
import '../theme/we_semantic.dart';

/// The bundled status icons, tinted with a semantic colour.
///
/// Every getter returns an [Image] whose colour follows the ambient
/// [WeTheme] palette for the given [SemanticEnum].
abstract final class WeIcons {
  static Widget info(SemanticEnum type, {double size = 82}) =>
      _WeIcon(name: 'info', type: type, size: size);
  static Widget warning(SemanticEnum type, {double size = 82}) =>
      _WeIcon(name: 'warning', type: type, size: size);
  static Widget success(SemanticEnum type, {double size = 82}) =>
      _WeIcon(name: 'success', type: type, size: size);
  static Widget error(SemanticEnum type, {double size = 82}) =>
      _WeIcon(name: 'error', type: type, size: size);
  static Widget right(SemanticEnum type, {double size = 82}) =>
      _WeIcon(name: 'right', type: type, size: size);
  static Widget confirm(SemanticEnum type, {double size = 82}) =>
      _WeIcon(name: 'confirm', type: type, size: size);
  static Widget search(SemanticEnum type, {double size = 82}) =>
      _WeIcon(name: 'search', type: type, size: size);
  static Widget close(SemanticEnum type, {double size = 82}) =>
      _WeIcon(name: 'close', type: type, size: size);
  static Widget prohibit(SemanticEnum type, {double size = 82}) =>
      _WeIcon(name: 'prohibit', type: type, size: size);
}

/// Legacy misspelled name of [WeIcons], kept for source compatibility.
// TODO(refactor): annotate @Deprecated once the internal call sites use
// WeIcons; `deprecated_member_use_from_same_package` would fail the build.
typedef Iocns = WeIcons;

class _WeIcon extends StatelessWidget {
  const _WeIcon({required this.name, required this.type, required this.size});

  final String name;
  final SemanticEnum type;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/$name.png',
      package: 'widgets_easier',
      width: size,
      height: size,
      color: type.resolve(context),
    );
  }
}
