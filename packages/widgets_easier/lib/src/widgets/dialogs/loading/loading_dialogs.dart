import 'package:flutter/material.dart';

import '../../feedback/we_loading.dart';

/// Fullscreen loading overlay. Use [WeLoading.service] instead.
@Deprecated('改用 WeLoading / WeLoading.service，1.0.0 移除')
class LoadingDialogs {
  static WeLoadingHandle? _current;

  static WeLoadingHandle show(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    _current?.close();
    return _current = WeLoading.service(context, text: message);
  }

  static void hide() {
    _current?.close();
    _current = null;
  }
}
