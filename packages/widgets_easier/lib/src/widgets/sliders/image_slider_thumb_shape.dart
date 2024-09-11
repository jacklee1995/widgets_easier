import 'package:flutter/material.dart';

class ImageSliderThumbShape extends SliderComponentShape {
  final Widget image;
  final double width;
  final double height;

  ImageSliderThumbShape({
    required this.image,
    required this.width,
    required this.height,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Image imageWidget = image as Image;
    final ImageStream imageStream =
        imageWidget.image.resolve(ImageConfiguration.empty);
    final ImageStreamListener listener =
        ImageStreamListener((ImageInfo info, bool _) {
      paintImage(
        canvas: context.canvas,
        rect: Rect.fromCenter(center: center, width: width, height: height),
        image: info.image,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    });

    imageStream.addListener(listener);
    imageStream.removeListener(listener);
  }
}
