import 'package:flutter/material.dart';

import 'we_captcha.dart';

/// 滑动拼图验证码。
///
/// 这是 [WeCaptcha] 的旧接口，只保留了 URL 底图和成功 / 失败两个回调。新代码请直接用
/// [WeCaptcha]：它支持任意 [ImageProvider]、离线生成图案、失败重试、次数限制、
/// 键盘操作与服务端校验。
///
/// ```dart
/// // 旧写法
/// SlidingCaptcha(imageUrl: url, onSuccess: ok, onFail: bad)
///
/// // 新写法
/// WeCaptcha.network(url, onSuccess: ok, onFail: bad)
/// ```
@Deprecated('改用 WeCaptcha，1.0.0 会移除。')
class SlidingCaptcha extends StatelessWidget {
  /// 用作验证图像的 URL。
  final String imageUrl;

  /// 验证成功时触发。
  final VoidCallback onSuccess;

  /// 验证失败时触发。
  final VoidCallback onFail;

  /// 允许的误差范围（像素）。全局生效，这也是它被废弃的原因之一，
  /// [WeCaptcha.tolerance] 是按实例配置的。
  static double deviation = 8;

  const SlidingCaptcha({
    super.key,
    required this.imageUrl,
    required this.onSuccess,
    required this.onFail,
  });

  @override
  Widget build(BuildContext context) {
    return WeCaptcha.network(
      imageUrl,
      height: 200,
      tolerance: deviation,
      onSuccess: onSuccess,
      onFail: onFail,
    );
  }
}
