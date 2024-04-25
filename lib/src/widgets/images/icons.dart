import 'package:flutter/widgets.dart';

import '../../../widgets_easier.dart';

Widget _loadIcon({
  required String assetName,
  required SemanticEnum semanticType,
  double size = 82,
}) {
  return Image.asset(
    'assets/icons/$assetName.png',
    package: 'get_dialogs',
    width: size,
    height: size,
    color: findStatusColor(semanticType),
  );
}

class Iocns {
  static Widget info(SemanticEnum semanticType, {double size = 82}) =>
      _loadIcon(assetName: "info", semanticType: semanticType, size: size);
  static Widget warning(SemanticEnum semanticType, {double size = 82}) =>
      _loadIcon(assetName: "warning", semanticType: semanticType, size: size);
  static Widget success(SemanticEnum semanticType, {double size = 82}) =>
      _loadIcon(assetName: "success", semanticType: semanticType, size: size);
  static Widget error(SemanticEnum semanticType, {double size = 82}) =>
      _loadIcon(assetName: "error", semanticType: semanticType, size: size);
  static Widget right(SemanticEnum semanticType, {double size = 82}) =>
      _loadIcon(assetName: "right", semanticType: semanticType, size: size);
  static Widget confirm(SemanticEnum semanticType, {double size = 82}) =>
      _loadIcon(assetName: "confirm", semanticType: semanticType, size: size);
  static Widget search(SemanticEnum semanticType, {double size = 82}) =>
      _loadIcon(assetName: "search", semanticType: semanticType, size: size);
  static Widget close(SemanticEnum semanticType, {double size = 82}) =>
      _loadIcon(assetName: "close", semanticType: semanticType, size: size);
  static Widget prohibit(SemanticEnum semanticType, {double size = 82}) =>
      _loadIcon(assetName: "prohibit", semanticType: semanticType, size: size);
}
