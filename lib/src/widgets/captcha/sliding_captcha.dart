import 'dart:math';

import 'package:flutter/material.dart';

/// 验证码组件
///
/// 这个组件用于显示一个验证码图像，用户需要滑动滑块以解锁验证。当验证成功或失败时，
/// 分别触发 [onSuccess] 或 [onFail] 回调函数。你可以设置允许的误差范围 [deviation]
/// 以调整验证的精确性。
///
/// 使用示例：
///
/// ```dart
/// SlidingCaptcha(
///   imageUrl: 'https://example.com/captcha-image.png',
///   onSuccess: () {
///     // 验证成功时的处理逻辑
///   },
///   onFail: () {
///     // 验证失败时的处理逻辑
///   },
/// )
/// ```
class SlidingCaptcha extends StatefulWidget {
  /// 用作验证图像的URL
  final String imageUrl;

  /// 当验证成功时触发的回调函数。
  final Function() onSuccess;

  /// 当验证失败时触发的回调函数。
  final Function() onFail;

  /// 允许的误差范围，用于调整验证的精确性。
  static double deviation = 5;

  /// 创建一个 [SlidingCaptcha] 小部件，需要指定 [imageUrl]、[onSuccess] 和 [onFail] 回调函数。
  const SlidingCaptcha({
    super.key,
    required this.imageUrl,
    required this.onSuccess,
    required this.onFail,
  });

  @override
  State<SlidingCaptcha> createState() => _SlidingCaptchaState();
}

class _SlidingCaptchaState extends State<SlidingCaptcha> {
  /// 滑块的当前位置。
  double _sliderValue = 0.0;

  late double _offsetRate;

  /// 用于定位的偏移值。
  late double _offsetValue;

  /// 小部件的总宽度。
  late double width;

  /// 用于确保验证仅仅一次有效
  bool _verified = false;

  double _generateRandomNumber() {
    // 创建一个Random对象
    var random = Random();

    // 生成一个介于0.1和0.9之间的随机小数
    double randomValue = 0.1 + random.nextDouble() * 0.7;

    return randomValue;
  }

  @override
  void initState() {
    _offsetRate = _generateRandomNumber();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    _offsetValue = _offsetRate * width;
    return Column(
      children: [
        // 堆叠三层，背景图、裁剪的拼图、拼图的轮廓绘图
        Stack(
          alignment: Alignment.center,
          children: [
            // 背景图层
            Image.network(
              widget.imageUrl,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            // 背景标记层
            CustomPaint(
              size: Size(width, 200.0),
              painter: CaptchaBorderPainter(_offsetValue),
            ),
            // 拼图层
            Positioned(
              left: _sliderValue * width - _offsetValue,
              child: ClipPath(
                clipper: CaptchaClipper(_sliderValue, _offsetValue),
                child: Image.network(
                  widget.imageUrl,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 拼图的轮廓层
            Positioned(
              left: _sliderValue * width - _offsetValue,
              child: CustomPaint(
                size: Size(width, 200.0),
                painter: CaptchaBorderPainter(_offsetValue),
              ),
            ),
          ],
        ),
        //
        SliderTheme(
          data: SliderThemeData(
            thumbColor: Colors.white, // 滑块颜色为白色
            activeTrackColor: Colors.green[900], // 激活轨道颜色为深绿色
            inactiveTrackColor: Colors.green[900], // 非激活轨道颜色为深绿色
            trackHeight: 10.0, // 轨道高度
            thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10.0), // 滑块形状为圆形
          ),
          child: Slider(
            value: _sliderValue,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
            onChangeEnd: (value) {
              if (_verified == false) {
                if (_sliderValue.abs() * width >
                        _offsetValue - SlidingCaptcha.deviation &&
                    _sliderValue.abs() * width <
                        _offsetValue + SlidingCaptcha.deviation) {
                  widget.onSuccess();
                  _verified = true;
                } else {
                  widget.onFail();
                  _verified = true;
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

/// 用于创建中滑动拼图的自定义剪切器。
class CaptchaClipper extends CustomClipper<Path> {
  final double sliderValue;
  final double offsetValue;

  /// 创建一个 [CaptchaClipper]，需要指定 [sliderValue] 和 [offsetValue]。
  CaptchaClipper(this.sliderValue, this.offsetValue);

  @override
  Path getClip(Size size) {
    final path = Path();

    final rect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(offsetValue + size.width * sliderValue, 60),
        Offset(
          offsetValue + size.width * sliderValue + 80,
          size.height - 40,
        ),
      ),
      const Radius.circular(10.0),
    );

    path.addRRect(rect);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CaptchaBorderPainter extends CustomPainter {
  final double offsetValue;

  CaptchaBorderPainter(this.offsetValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rect = Rect.fromPoints(
      Offset(offsetValue, 60),
      Offset(
        offsetValue + 80,
        size.height - 40,
      ),
    );

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10.0)));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
