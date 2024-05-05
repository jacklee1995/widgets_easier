import 'package:flutter/material.dart';

import '../enums/semantic_enum.dart';
import 'semantic_color.dart';

Color findStatusColor(SemanticEnum dialogType) {
  switch (dialogType) {
    case SemanticEnum.primary:
      return SemanticColors.primary;
    case SemanticEnum.secondary:
      return SemanticColors.secondary;
    case SemanticEnum.success:
      return SemanticColors.success;
    case SemanticEnum.warning:
      return SemanticColors.warning;
    case SemanticEnum.info:
      return SemanticColors.info;
    case SemanticEnum.danger:
      return SemanticColors.danger;
    case SemanticEnum.fatal:
      return SemanticColors.fatal;
    default:
      return SemanticColors.primary;
  }
}
